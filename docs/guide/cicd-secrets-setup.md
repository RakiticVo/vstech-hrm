# CI/CD Setup & Release Guide (vstech-hrm)

Project-specific companion to [agent-cicd-universal-blueprint.md](agent-cicd-universal-blueprint.md). It lists how to create every credential file, which GitHub Secrets / Variables to set, and how to cut a release.

---

## 1. What the pipeline does

| Tag | Allowed on | Android | iOS | Artifacts |
| --- | --- | --- | --- | --- |
| `vX.Y.Z-uat` | `origin/develop` | Release-signed **APK** → Firebase App Distribution | App Store-signed **IPA** → TestFlight | APK + IPA |
| `vX.Y.Z` | `origin/main` | Release-signed **AAB** → Google Play `production` track | App Store-signed **IPA** → TestFlight (submit for review manually) | AAB + IPA |

- **Version name** comes from the tag (`v1.2.3-uat` → `1.2.3`). **Build number** = workflow run number + `BUILD_NUMBER_OFFSET`, so it always increases. `pubspec.yaml` does not need a manual bump.
- Release notes = the annotated tag message.
- Every run posts its result to Telegram (success or failure). Issues and issue comments are posted too.
- Artifacts are kept for 30 days under the run's **Summary → Artifacts**, downloadable by members with access to the private `V-STECH/hrm-mobile` repo.
- The repo is private, so macOS runner minutes (iOS jobs) count against the organization's Actions quota at a higher rate than Linux minutes.

Files: `.github/workflows/{release,issue-telegram,ios-setup-certificates}.yml`, `.github/scripts/telegram_*.sh`, `android/{Gemfile,fastlane/}`, `ios/{Gemfile,fastlane/}`, `android/app/build.gradle.kts` (signing).

---

## 2. App configuration (`DOTENV_UAT` / `DOTENV_PROD`)

The app reads its configuration from a `.env` file that is **bundled inside the APK/IPA** (`flutter_dotenv`, declared as an asset in `pubspec.yaml`). `.env` is git-ignored, so CI must write it before building. Each secret holds the **whole content** of the `.env` file for that channel:

```dotenv
ENVIRONMENT=dev            # prod for DOTENV_PROD
API_BASE_URL=https://<uat-or-prod-backend>
USE_MOCK_DATA=false
FACE_API_BASE_URL=https://<face-api>
FACE_APP_CODE=HRM
```

Only put values that are safe to ship inside the app — anyone can unzip an APK and read `.env`.

---

## 3. Creating the credential files

### 3.1 Android upload keystore (`ANDROID_KEYSTORE_*`, `ANDROID_KEY_*`)

Create it once and **back it up** (losing it means you cannot update the Play app without a key reset):

```bash
keytool -genkeypair -v -keystore upload_keystore.jks -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
base64 < upload_keystore.jks | tr -d '\n' | pbcopy   # → ANDROID_KEYSTORE_BASE64
```

- `ANDROID_KEYSTORE_PASSWORD` = store password, `ANDROID_KEY_ALIAS` = `upload`, `ANDROID_KEY_PASSWORD` = key password.
- With **Play App Signing** (default for new apps) this is the *upload key*; Google holds the app signing key.
- Local release builds: copy the file to `android/app/upload_keystore.jks` and create `android/key.properties` (both git-ignored):

  ```properties
  storePassword=...
  keyPassword=...
  keyAlias=upload
  storeFile=upload_keystore.jks
  ```

  Without a keystore, local release builds fall back to debug signing.

### 3.2 Google Play service account (`PLAY_STORE_JSON_KEY`)

1. Google Cloud Console → pick or create a project → **IAM & Admin → Service Accounts → Create**. No project role needed.
2. Open the account → **Keys → Add key → JSON** → download it. The whole JSON text is the secret.
3. Enable **Google Play Android Developer API** for that Cloud project.
4. Play Console → **Users and permissions → Invite new user** → the service account email → app access to `com.vstech.vstech_hrm` with *Release to production…* and *Release apps to testing tracks* permissions.
5. The Play API cannot create an app or upload its very first build: upload the first AAB manually (any track) and complete the store listing, content rating, data safety and pricing sections.
6. While the app has never been published, Play only accepts **draft** releases: set the variable `PLAY_STORE_RELEASE_STATUS=draft` until the first public release is approved, then remove it.

### 3.3 Firebase App Distribution (`FIREBASE_*`)

1. Firebase Console → project → **Add app → Android**, package `com.vstech.vstech_hrm` (no `google-services.json` is needed in the app).
2. **Project settings → General → Your apps** → copy the **App ID** (`1:…:android:…`) → `FIREBASE_ANDROID_APP_ID`.
3. **App Distribution → Testers & Groups** → create the group `internal-testers` (alias must match `FIREBASE_TESTER_GROUPS`, default `internal-testers`) and add testers.
4. Google Cloud Console (same project) → **Service Accounts → Create** with role **Firebase App Distribution Admin** → **Keys → JSON** → whole JSON text = `FIREBASE_APP_DISTRIBUTION_CREDENTIALS`.

### 3.4 App Store Connect API key (`APP_STORE_CONNECT_*`, `APPLE_*`)

1. App Store Connect → **Users and Access → Integrations → App Store Connect API → Team Keys → +**, access **App Manager** (or Admin).
2. Download `AuthKey_<KEYID>.p8` (only downloadable **once**). Its full content, including the `BEGIN/END PRIVATE KEY` lines = `APP_STORE_CONNECT_API_KEY_P8`.
3. `APP_STORE_CONNECT_KEY_ID` = the Key ID; `APP_STORE_CONNECT_ISSUER_ID` = the Issuer ID shown above the key list.
4. `APPLE_ID` = Apple Developer account email; `APPLE_TEAM_ID` = `W563R99PM4`.
5. The bundle ID `com.vstech.vstechHrm` must exist under **Certificates, Identifiers & Profiles → Identifiers**, and the app record must exist in App Store Connect.
6. TestFlight: in the app's **TestFlight → Internal Testing** group, enable automatic distribution so UAT testers get each build.

### 3.5 Fastlane Match repo (`MATCH_*`)

1. Create an **empty private** GitHub repo, e.g. `V-STECH/hrm-mobile-certificates`.
2. Create a deploy key pair:

   ```bash
   ssh-keygen -t ed25519 -C "vstech-hrm-match" -f match_deploy_key -N ""
   ```

   - Repo → **Settings → Deploy keys → Add** the content of `match_deploy_key.pub`, tick **Allow write access**.
   - `MATCH_SSH_KEY` = content of `match_deploy_key` (private key).
3. `MATCH_GIT_URL` = `git@github.com:V-STECH/hrm-mobile-certificates.git`.
4. `MATCH_PASSWORD` = a strong random passphrase (`openssl rand -base64 24`). Store it in a password manager; it decrypts the certificates.
5. Run **Actions → iOS Setup Certificates (one-time) → Run workflow** once. The Match repo then contains `certs/distribution/*` and `profiles/appstore/*`. Afterwards you may untick write access on the deploy key.

The Apple account allows only a few distribution certificates — if the run fails with a certificate limit, revoke an unused one in the Developer portal.

### 3.6 Telegram (`TELEGRAM_*`)

1. Create a bot with [@BotFather](https://t.me/BotFather) → `/newbot` → token = `TELEGRAM_BOT_TOKEN`.
2. Add the bot to the team group (allow it to post in the topic if the group uses topics).
3. Send any message in the group/topic, then open `https://api.telegram.org/bot<TOKEN>/getUpdates`:
   - `message.chat.id` (negative, `-100…`) = `TELEGRAM_CHAT_ID`.
   - `message.message_thread_id` = `TELEGRAM_MESSAGE_THREAD_ID` (leave unset for groups without topics).
4. `issue-telegram.yml` only fires once it is on the default branch (`main`).

---

## 4. GitHub Secrets & Variables

Repo → **Settings → Secrets and variables → Actions**.

**Secrets**

| Name | Section |
| --- | --- |
| `DOTENV_UAT`, `DOTENV_PROD` | §2 |
| `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | §3.1 |
| `PLAY_STORE_JSON_KEY` | §3.2 |
| `FIREBASE_ANDROID_APP_ID`, `FIREBASE_APP_DISTRIBUTION_CREDENTIALS` | §3.3 |
| `APPLE_ID`, `APPLE_TEAM_ID`, `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY_P8` | §3.4 |
| `MATCH_GIT_URL`, `MATCH_PASSWORD`, `MATCH_SSH_KEY` | §3.5 |
| `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`, `TELEGRAM_MESSAGE_THREAD_ID` (optional) | §3.6 |

Setting them from files with the GitHub CLI keeps multi-line values intact:

```bash
gh secret set DOTENV_UAT < .env.uat
gh secret set ANDROID_KEYSTORE_BASE64 --body "$(base64 < upload_keystore.jks | tr -d '\n')"
gh secret set PLAY_STORE_JSON_KEY < play-service-account.json
gh secret set APP_STORE_CONNECT_API_KEY_P8 < AuthKey_XXXXXXXXXX.p8
gh secret set MATCH_SSH_KEY < match_deploy_key
```

**Variables** (optional, defaults in brackets)

| Name | Purpose |
| --- | --- |
| `PLAY_STORE_TRACK` [`production`] | Play track for `vX.Y.Z` tags (`internal`, `alpha`, `beta`, `production`) |
| `PLAY_STORE_RELEASE_STATUS` [`completed`] | `draft` until the app's first public release (§3.2) |
| `FIREBASE_TESTER_GROUPS` [`internal-testers`] | Comma-separated Firebase tester group aliases |
| `BUILD_NUMBER_OFFSET` [`0`] | Added to the run number — raise it above any build number already uploaded by hand |

---

## 5. Cutting a release

```bash
# UAT — the commit must already be on origin/develop
git checkout develop && git pull
git tag -a v0.0.1-uat -m "UAT: what testers should check"
git push origin v0.0.1-uat

# Production — the commit must already be on origin/main (merged from release/*)
git checkout main && git pull
git tag -a v0.0.1 -m "Release notes"
git push origin v0.0.1
```

After a production run: Google Play rolls the build out on the configured track; for iOS, open App Store Connect, attach the TestFlight build to the new version and **Submit for Review**.

TestFlight asks about export compliance for each build unless `ITSAppUsesNonExemptEncryption` is declared in `ios/Runner/Info.plist`.

## 6. Pre-flight checklist

- [ ] All secrets in §4 set; Telegram bot in the group.
- [ ] `iOS Setup Certificates` ran once successfully.
- [ ] First AAB uploaded manually to Play; `PLAY_STORE_RELEASE_STATUS=draft` while the app is unpublished.
- [ ] Workflows merged to `develop` (UAT) and `main` (production + issue notifications).
- [ ] First UAT tag pushed on `develop`; build visible in Firebase, TestFlight and Telegram.
