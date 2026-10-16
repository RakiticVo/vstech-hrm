# Universal Flutter CI/CD & Store Publishing Blueprint for AI Agents

> **Source of Truth & Agent Protocol**: This document serves as the canonical, cross-project blueprint for AI Agents and DevOps engineers to implement, adapt, and run automated CI/CD deployment pipelines for Flutter mobile applications (Android & iOS) targeting **Firebase App Distribution**, **Google Play Store**, and **Apple App Store Connect / TestFlight**.
>
> Grounded in real-world production runs, this guide documents all mandatory directory layouts, code signing mechanisms, build configurations, and battle-tested edge-case resolutions.

---

## 📑 Table of Contents

1. [Architecture & Deployment Flow](#1-architecture--deployment-flow)
2. [Configuration Classification Matrix](#2-configuration-classification-matrix)
3. [Mandatory File & Directory Layout](#3-mandatory-file--directory-layout)
4. [Step-by-Step Agent Implementation Playbook](#4-step-by-step-agent-implementation-playbook)
5. [Complete Universal Code Templates](#5-complete-universal-code-templates)
   - [5.1 GitHub Actions Workflow (`.github/workflows/release.yml`)](#51-github-actions-workflow)
   - [5.2 Android Fastlane & Bundler Setup](#52-android-fastlane--bundler-setup)
   - [5.3 iOS Fastlane & Match Code Signing Setup](#53-ios-fastlane--match-code-signing-setup)
   - [5.4 Android Gradle Signing Configuration (`build.gradle.kts`)](#54-android-gradle-signing-configuration)
   - [5.5 Telegram Notifications (Issues & Releases)](#55-telegram-notifications-issues--releases)
   - [5.6 One-Time iOS Certificate Bootstrap Workflow](#56-one-time-ios-certificate-bootstrap-workflow)
6. [Critical Agent Invariants & Battle-Tested Gotchas](#6-critical-agent-invariants--battle-tested-gotchas)
7. [Pre-Flight Verification Checklist](#7-pre-flight-verification-checklist)

---

## 1. Architecture & Deployment Flow

The pipeline follows a **tag-driven, decoupled branching strategy**:

```text
                     ┌─────────────────────────────────────────────────────────┐
                     │          Developer pushes Git Tag (v*)                  │
                     └────────────────────────────┬────────────────────────────┘
                                                  │
                                   ┌──────────────┴──────────────┐
                                   ▼                             ▼
                      Branch check: dev or prod?      Tag format validation
                                   │                             │
                     ┌─────────────┴─────────────┐               │
                     ▼                           ▼               ▼
           Tag: `vX.Y.Z-uat`               Tag: `vX.Y.Z` (Clean)
         (Target: UAT Testers)           (Target: Production Stores)
                     │                           │
          ┌──────────┴──────────┐     ┌──────────┴──────────┐
          ▼                     ▼     ▼                     ▼
     Android UAT             iOS UAT Android Prod        iOS Prod
     (APK to Firebase   (IPA to TestFlight (AAB to Google (IPA to App Store
      Distribution)       Internal)    Play Console)      Connect / TestFlight)
          │                     │     │                     │
          └──────────┬──────────┘     └──────────┬──────────┘
                     ▼                           ▼
          Report Version to Backend     Report Version to Backend
                     │                           │
                     └─────────────┬─────────────┘
                                   ▼
             Telegram release message (always — success or failure)

   Independently: GitHub issue events ──► Telegram issue message (same chat / topic)
```

### Key Architectural Invariants

1. **Security Guardrail (Branch Isolation)**:
   - Release tags (`v*`) are **only permitted** on commits belonging to `origin/dev` (for UAT) or `origin/prod` (for Production).
   - Any tag pushed on an unmerged feature branch is immediately rejected by CI to prevent unverified code from reaching testers or users.
2. **UAT Environment (`vX.Y.Z-uat`)**:
   - Target Android: APK uploaded to Firebase App Distribution with release notes extracted from the tag message.
   - Target iOS: IPA uploaded to TestFlight (Internal Testers group).
   - API Configuration: Injects `--dart-define=API_BASE_URL=$API_BASE_URL_UAT`.
3. **Production Environment (`vX.Y.Z`)**:
   - Target Android: App Bundle (`.aab`) deployed to Google Play Store (Internal, Closed Alpha, or Production track).
   - Target iOS: IPA deployed to App Store Connect / TestFlight Production.
   - API Configuration: Injects `--dart-define=API_BASE_URL=$API_BASE_URL_PROD`.
4. **Backend Webhook Sync**:
   - Upon successful binary upload, CI calls the backend endpoint `POST /app-version` with header `x-ci-token` to synchronize the active mobile app version.
5. **Team Notifications (Telegram)**:
   - **Release**: a final `notify-telegram` job (`if: always()`) posts the tag, channel (UAT / Production), `pubspec.yaml` version + build, actor, per-platform result and the run link (artifacts) — on success **and** on failure.
   - **Issues**: a separate `issue-telegram.yml` workflow posts issue opened / reopened / closed / assigned and new issue comments (PR comments are ignored).
   - Both post plain text to the same chat and forum topic, sharing one sender script.

---

## 2. Configuration Classification Matrix

When onboarding a new project, AI Agents must strictly distinguish between **Auto-Extracted Parameters** (read directly from code) and **User-Provided Secrets** (must be configured in GitHub Secrets). Never ask the user for values that already exist in code.

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           CONFIG CLASSIFICATION MATRIX                          │
├───────────────────────────────┬───────────────────────────────┬─────────────────┤
│  🙋‍♂️ TYPE 1: USER SECRETS      │  🔍 TYPE 2: AUTO-EXTRACTED    │ ⚙️ TYPE 3:      │
│  (Configured in GitHub)       │  (Inspected from Repository)  │ SYSTEM CONSTANTS│
└───────────────────────────────┴───────────────────────────────┴─────────────────┘
```

### 🙋‍♂️ Type 1: User-Provided Secrets (GitHub Repository Secrets)

| Secret Name | Purpose & Source | Target Platform |
|---|---|---|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded string of the release keystore `.jks` file | Android |
| `ANDROID_KEYSTORE_PASSWORD` | Password of the Android release keystore | Android |
| `ANDROID_KEY_ALIAS` | Key alias inside the keystore (e.g., `app_alias`) | Android |
| `ANDROID_KEY_PASSWORD` | Password for the key alias | Android |
| `PLAY_STORE_JSON_KEY` | Google Play Console GCP Service Account JSON key text | Android Prod |
| `FIREBASE_APP_DISTRIBUTION_CREDENTIALS` | Firebase GCP Service Account JSON key text | Android UAT |
| `FIREBASE_ANDROID_APP_ID` | Mobile app ID in Firebase Console (e.g., `1:123456:android:...`) | Android UAT |
| `APPLE_ID` | Apple Developer Account email address | iOS |
| `APPLE_TEAM_ID` | 10-character Apple Developer Team ID | iOS |
| `APP_STORE_CONNECT_KEY_ID` | App Store Connect API Key ID (e.g., `SACK5N6YM4`) | iOS |
| `APP_STORE_CONNECT_ISSUER_ID` | App Store Connect Issuer UUID | iOS |
| `APP_STORE_CONNECT_API_KEY_P8` | Complete content of Apple private key `.p8` file | iOS |
| `MATCH_GIT_URL` | SSH Git URL of the private code-signing repository | iOS |
| `MATCH_PASSWORD` | Passphrase used to encrypt/decrypt certificates in Match repo | iOS |
| `MATCH_SSH_KEY` | Private SSH Key with write access to `MATCH_GIT_URL` | iOS |
| `API_BASE_URL_UAT` | Backend API root URL for UAT builds | Android & iOS |
| `API_BASE_URL_PROD` | Backend API root URL for Production builds | Android & iOS |
| `APP_VERSION_CI_TOKEN` | Token for authenticating version update webhook with backend | Both (Optional) |
| `TELEGRAM_BOT_TOKEN` | Bot token from [@BotFather](https://t.me/BotFather); the bot must be a member of the target group | Notifications |
| `TELEGRAM_CHAT_ID` | Target chat ID (groups are negative, e.g. `-100…`) | Notifications |
| `TELEGRAM_MESSAGE_THREAD_ID` | Forum topic ID inside the group (leave empty / unset for groups without topics) | Notifications (Optional) |

---

### 🔍 Type 2: Auto-Extracted Parameters (Inspect Target Repo)

AI Agents **MUST inspect these files** in the target workspace and substitute them into the templates:

| Configuration Item | Location in Target Project | Regex / Search Pattern |
|---|---|---|
| **App Name** | `pubspec.yaml` | `^name:\s*(.+)` |
| **Flutter SDK Version** | `pubspec.yaml` | `sdk:\s*">=([0-9.]+)"` |
| **Android Package Name** | `android/app/build.gradle.kts` (or `.gradle`) | `applicationId = "([^"]+)"` or `namespace = "([^"]+)"` |
| **Android Keystore Filename** | `android/app/build.gradle.kts` (or `.gradle`) | `storeFile = file\("([^"]+)"\)` |
| **iOS Bundle Identifier** | `ios/Runner.xcodeproj/project.pbxproj` | `PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);` |
| **iOS Development Team** | `ios/Runner.xcodeproj/project.pbxproj` | `DEVELOPMENT_TEAM = ([^;]+);` |
| **Xcode Scheme / Workspace**| `ios/` directory | Defaults to `Runner` / `Runner.xcworkspace` |

---

### ⚙️ Type 3: Fixed System Constants & Invariants

| Constant / Path | Standard Value | Rationale |
|---|---|---|
| **Standardized Apple API Key Path** | `ios/fastlane/api_key.p8` | Fixed destination for decoded `.p8` key in CI |
| **Play Store Key Path** | `android/fastlane/fastlane-play-store.json` | Standardized destination for Google Play JSON key |
| **Firebase Credentials Path** | `android/fastlane/firebase-distribution.json` | Standardized destination for Firebase JSON key |
| **Ruby Version** | `3.3` | fastlane dropped Ruby 3.1 (2.240+ requires ≥ 3.2; 3.1 pins you to fastlane 2.234 with deprecation warnings) |
| **Java Version** | `17` (Zulu distribution) | Compatible with Gradle 7.x & 8.x and Android SDK 34+ |
| **CI Runner OS** | Ubuntu (`ubuntu-latest`) for Android; macOS (`macos-latest`) for iOS | Cost-effective and matches platform build requirements |
| **Telegram Scripts Path** | `.github/scripts/telegram_*.sh` | Shared by the issue and release notifiers; workflows sparse-checkout only this folder |

---

## 3. Mandatory File & Directory Layout

Agents must adhere to the exact directory layout below. Placing `Gemfile` inside `fastlane/` instead of `android/` or `ios/` is a **critical mistake** that breaks Bundler and caching on GitHub Actions:

```text
TARGET_FLUTTER_PROJECT/
├── .github/
│   ├── workflows/
│   │   ├── release.yml                             <-- Unified CI/CD Pipeline (+ notify-telegram job)
│   │   ├── issue-telegram.yml                      <-- Issue → Telegram notifications
│   │   └── ios-setup-certificates.yml              <-- One-time Match certificate bootstrap (manual)
│   └── scripts/
│       ├── telegram_send.sh                        <-- Shared Telegram sender (plain text, topic, DRY_RUN)
│       ├── telegram_issue_notify.sh                <-- Issue / comment message format
│       └── telegram_release_notify.sh              <-- Release outcome message format
├── android/
│   ├── Gemfile                                     <-- MUST BE AT android/Gemfile
│   ├── Gemfile.lock                                <-- Checked into Git
│   ├── app/
│   │   ├── build.gradle.kts (or build.gradle)      <-- Contains signingConfigs & applicationId
│   │   └── <app_keystore>.jks                      <-- Created dynamically on CI runner (Git-ignored)
│   └── fastlane/
│       ├── Appfile                                 <-- Fastlane Android app metadata
│       ├── Fastfile                                <-- Fastlane Android deployment lanes
│       ├── Pluginfile                              <-- Declares fastlane-plugin-firebase_app_distribution
│       ├── firebase-distribution.json               <-- Created dynamically on CI runner (Git-ignored)
│       └── fastlane-play-store.json                <-- Created dynamically on CI runner (Git-ignored)
├── ios/
│   ├── Gemfile                                     <-- MUST BE AT ios/Gemfile
│   ├── Gemfile.lock                                <-- Checked into Git
│   ├── Runner.xcworkspace                          <-- Standard Flutter iOS workspace
│   └── fastlane/
│       ├── Appfile                                 <-- Fastlane iOS app metadata
│       ├── Fastfile                                <-- Fastlane iOS deployment lanes
│       ├── Matchfile                               <-- Fastlane Match git-storage config
│       └── api_key.p8                              <-- Created dynamically on CI runner (Git-ignored)
└── pubspec.yaml                                    <-- Contains version: X.Y.Z+build
```

---

## 4. Step-by-Step Agent Implementation Playbook

When tasked with setting up or repairing CI/CD in any Flutter repository, follow this execution sequence:

### Phase 1: Codebase Inspection
1. Open `pubspec.yaml`: note `name` and Flutter SDK version.
2. Open `android/app/build.gradle.kts`:
   - Identify `applicationId`.
   - Verify `signingConfigs { create("release") { ... } }` exists and note the target keystore filename (e.g. `upload_keystore.jks`).
3. Open `ios/Runner.xcodeproj/project.pbxproj`:
   - Search for `PRODUCT_BUNDLE_IDENTIFIER` (e.g., `com.company.app`).
   - Search for `DEVELOPMENT_TEAM`.

### Phase 2: Configuration Scaffolding
1. Create `android/Gemfile` and `android/fastlane/Pluginfile`.
2. Create `android/fastlane/Appfile` and `android/fastlane/Fastfile`.
3. Create `ios/Gemfile`.
4. Create `ios/fastlane/Appfile`, `ios/fastlane/Matchfile`, and `ios/fastlane/Fastfile`.
5. Create `.github/workflows/release.yml`.
6. Update `.gitignore` to ensure generated credentials (`*.jks`, `*.p8`, `*.json`) are never committed.
7. Create the Telegram notifier scripts in `.github/scripts/` (`chmod +x`), `.github/workflows/issue-telegram.yml`, and the `notify-telegram` job at the end of `release.yml` ([Section 5.5](#55-telegram-notifications-issues--releases)). Dry-run each script locally with `DRY_RUN=1`.
8. Create `.github/workflows/ios-setup-certificates.yml` + the `setup_certificates` lane ([Section 5.6](#56-one-time-ios-certificate-bootstrap-workflow)) so nobody needs fastlane on a local Mac.

### Phase 3: Bundler Lockfile Generation
- On a Mac or Linux environment, run `bundle install` inside both `android/` and `ios/` to generate `Gemfile.lock`.
- If on Windows, note that Windows developers do not need Ruby locally; GitHub Actions with `bundler-cache: true` will resolve gems automatically on the runner.

### Phase 4: Secrets Audit
- Generate an audit list for the user outlining all required GitHub Secrets based on [Section 2](#2-configuration-classification-matrix).
- Provide step-by-step instructions for obtaining any missing credentials.
- Telegram: confirm the bot was added to the group (and may post in the topic) before the first run; otherwise `sendMessage` returns `chat not found` / `message thread not found`.

---

## 5. Complete Universal Code Templates

### 5.1 GitHub Actions Workflow

Path: `.github/workflows/release.yml`

```yaml
name: CI/CD Release Pipeline

on:
  push:
    tags:
      - 'v*'

env:
  ACTIONS_ALLOW_USE_UNSECURE_NODE_VERSION: 'true'
  FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: 'true'

jobs:
  # -------------------------------------------------------------
  # STAGE 1: Code Verification & Static Analysis
  # -------------------------------------------------------------
  test:
    name: Flutter Tests & Analysis
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Validate Tag Branch Integrity
        run: |
          git fetch --all
          TAG_COMMIT=$(git rev-parse HEAD)
          CONTAINED_BRANCHES=$(git branch -r --contains $TAG_COMMIT)
          echo "Branches containing commit $TAG_COMMIT:"
          echo "$CONTAINED_BRANCHES"
          if ! echo "$CONTAINED_BRANCHES" | grep -qE 'origin/(prod|dev)'; then
            echo "::error::Release tags are only allowed on 'origin/prod' or 'origin/dev' branches!"
            exit 1
          fi

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install Dependencies
        run: flutter pub get

      - name: Run Static Analyzer
        run: flutter analyze --no-fatal-infos --no-fatal-warnings

      - name: Run Automated Tests
        run: flutter test

  # -------------------------------------------------------------
  # STAGE 2A: Android UAT (Firebase App Distribution)
  # -------------------------------------------------------------
  android-uat:
    name: Android UAT Deployment
    needs: test
    if: contains(github.ref, '-uat')
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Extract Release Notes from Tag Message
        run: |
          TAG_MSG=$(git tag -l --format='%(contents)' ${{ github.ref_name }})
          if [ -z "$TAG_MSG" ]; then
            TAG_MSG=$(git log -1 --pretty=%B)
          fi
          # Flatten multi-line notes for GitHub Actions env safely
          TAG_MSG=$(echo "$TAG_MSG" | tr '\n' ' ')
          echo "RELEASE_NOTES=$TAG_MSG" >> $GITHUB_ENV

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Setup Ruby 3.3
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: android

      - name: Decode Android Keystore & Firebase Credentials
        run: |
          # Replace 'upload_keystore.jks' with the filename defined in build.gradle.kts
          echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | grep -v "CERTIFICATE" | base64 --decode > app/upload_keystore.jks
          printf "%s" "$FIREBASE_APP_DISTRIBUTION_CREDENTIALS" > firebase-distribution.json
          printf "%s" "$FIREBASE_APP_DISTRIBUTION_CREDENTIALS" > fastlane/firebase-distribution.json
        working-directory: android
        env:
          ANDROID_KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
          FIREBASE_APP_DISTRIBUTION_CREDENTIALS: ${{ secrets.FIREBASE_APP_DISTRIBUTION_CREDENTIALS }}

      - name: Build APK & Deploy to Firebase App Distribution
        run: bundle exec fastlane distribute_firebase
        working-directory: android
        env:
          FIREBASE_ANDROID_APP_ID: ${{ secrets.FIREBASE_ANDROID_APP_ID }}
          ANDROID_KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
          ANDROID_KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
          ANDROID_KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
          API_BASE_URL: ${{ secrets.API_BASE_URL_UAT }}
          RELEASE_NOTES: ${{ env.RELEASE_NOTES }}

  # -------------------------------------------------------------
  # STAGE 2B: Android Production (Google Play Store)
  # -------------------------------------------------------------
  android-prod:
    name: Android Production Deployment
    needs: test
    if: "!contains(github.ref, '-uat') && !contains(github.ref, '-beta')"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Extract Release Notes
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          TAG_MSG=$(git tag -l --format='%(contents)' ${{ github.ref_name }})
          if [ -z "$TAG_MSG" ] && [ "${{ github.ref_name }}" = "prod" ]; then
            PR_BODY=$(gh pr list --base prod --state merged --json body,mergeCommit --jq ".[] | select(.mergeCommit.oid == \"$GITHUB_SHA\") | .body")
            if [ -n "$PR_BODY" ]; then
              TAG_MSG="$PR_BODY"
            fi
          fi
          if [ -z "$TAG_MSG" ]; then
            TAG_MSG=$(git log -1 --pretty=%B)
          fi
          CLEANED_NOTES=$(echo "$TAG_MSG" | tr '\n' ' ')
          echo "RELEASE_NOTES=$CLEANED_NOTES" >> $GITHUB_ENV

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Setup Ruby 3.3
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: android

      - name: Decode Keystore & Play Store Service Account
        run: |
          echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | grep -v "CERTIFICATE" | base64 --decode > app/upload_keystore.jks
          printf "%s" "$PLAY_STORE_JSON_KEY" > fastlane-play-store.json
          printf "%s" "$PLAY_STORE_JSON_KEY" > fastlane/fastlane-play-store.json
        working-directory: android
        env:
          ANDROID_KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
          PLAY_STORE_JSON_KEY: ${{ secrets.PLAY_STORE_JSON_KEY }}

      - name: Build AAB & Deploy to Google Play Console
        run: bundle exec fastlane deploy_play_store
        working-directory: android
        env:
          ANDROID_KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
          ANDROID_KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
          ANDROID_KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
          API_BASE_URL: ${{ secrets.API_BASE_URL_PROD }}
          PLAY_STORE_TRACK: ${{ secrets.PLAY_STORE_TRACK || 'internal' }}
          RELEASE_NOTES: ${{ env.RELEASE_NOTES }}

  # -------------------------------------------------------------
  # STAGE 3A: iOS UAT (TestFlight Internal)
  # -------------------------------------------------------------
  ios-uat:
    name: iOS UAT Deployment (TestFlight)
    needs: test
    if: contains(github.ref, '-uat')
    runs-on: macos-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Extract Release Notes from Tag Message
        run: |
          TAG_MSG=$(git tag -l --format='%(contents)' ${{ github.ref_name }})
          if [ -z "$TAG_MSG" ]; then
            TAG_MSG=$(git log -1 --pretty=%B)
          fi
          TAG_MSG=$(echo "$TAG_MSG" | tr '\n' ' ')
          echo "RELEASE_NOTES=$TAG_MSG" >> $GITHUB_ENV

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Setup SSH Key for Fastlane Match
        uses: webfactory/ssh-agent@v0.9.0
        with:
          ssh-private-key: ${{ secrets.MATCH_SSH_KEY }}

      - name: Setup Ruby 3.3
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: ios

      - name: Install Flutter Dependencies
        run: flutter pub get

      - name: Generate Flutter iOS Configurations
        run: flutter build ios --config-only --no-codesign

      - name: Setup App Store Connect API Key
        run: |
          printf "%s" "$APP_STORE_CONNECT_API_KEY_P8" > ios/fastlane/api_key.p8
        env:
          APP_STORE_CONNECT_API_KEY_P8: ${{ secrets.APP_STORE_CONNECT_API_KEY_P8 }}

      - name: Build IPA & Deploy to TestFlight
        run: bundle exec fastlane deploy_app_store
        working-directory: ios
        env:
          APPLE_ID: ${{ secrets.APPLE_ID }}
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
          MATCH_GIT_URL: ${{ secrets.MATCH_GIT_URL }}
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
          APP_STORE_CONNECT_KEY_ID: ${{ secrets.APP_STORE_CONNECT_KEY_ID }}
          APP_STORE_CONNECT_ISSUER_ID: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
          API_BASE_URL: ${{ secrets.API_BASE_URL_UAT }}
          RELEASE_NOTES: ${{ env.RELEASE_NOTES }}

  # -------------------------------------------------------------
  # STAGE 3B: iOS Production (App Store Connect / TestFlight)
  # -------------------------------------------------------------
  ios-prod:
    name: iOS Production Deployment
    needs: test
    if: "!contains(github.ref, '-uat') && !contains(github.ref, '-beta')"
    runs-on: macos-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Extract Release Notes
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          TAG_MSG=$(git tag -l --format='%(contents)' ${{ github.ref_name }})
          if [ -z "$TAG_MSG" ] && [ "${{ github.ref_name }}" = "prod" ]; then
            PR_BODY=$(gh pr list --base prod --state merged --json body,mergeCommit --jq ".[] | select(.mergeCommit.oid == \"$GITHUB_SHA\") | .body")
            if [ -n "$PR_BODY" ]; then
              TAG_MSG="$PR_BODY"
            fi
          fi
          if [ -z "$TAG_MSG" ]; then
            TAG_MSG=$(git log -1 --pretty=%B)
          fi
          CLEANED_NOTES=$(echo "$TAG_MSG" | tr '\n' ' ')
          echo "RELEASE_NOTES=$CLEANED_NOTES" >> $GITHUB_ENV

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Setup SSH Key for Fastlane Match
        uses: webfactory/ssh-agent@v0.9.0
        with:
          ssh-private-key: ${{ secrets.MATCH_SSH_KEY }}

      - name: Setup Ruby 3.3
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: ios

      - name: Install Flutter Dependencies
        run: flutter pub get

      - name: Generate Flutter iOS Configurations
        run: flutter build ios --config-only --no-codesign

      - name: Setup App Store Connect API Key
        run: |
          printf "%s" "$APP_STORE_CONNECT_API_KEY_P8" > ios/fastlane/api_key.p8
        env:
          APP_STORE_CONNECT_API_KEY_P8: ${{ secrets.APP_STORE_CONNECT_API_KEY_P8 }}

      - name: Build IPA & Deploy to App Store Connect
        run: bundle exec fastlane deploy_app_store
        working-directory: ios
        env:
          APPLE_ID: ${{ secrets.APPLE_ID }}
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
          MATCH_GIT_URL: ${{ secrets.MATCH_GIT_URL }}
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
          APP_STORE_CONNECT_KEY_ID: ${{ secrets.APP_STORE_CONNECT_KEY_ID }}
          APP_STORE_CONNECT_ISSUER_ID: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
          API_BASE_URL: ${{ secrets.API_BASE_URL_PROD }}
          RELEASE_NOTES: ${{ env.RELEASE_NOTES }}

  # -------------------------------------------------------------
  # STAGE 4: Backend Version Synchronization Webhook
  # -------------------------------------------------------------
  notify-backend-uat:
    name: Notify Backend (UAT)
    needs: [android-uat, ios-uat]
    if: contains(github.ref, '-uat')
    runs-on: ubuntu-latest
    steps:
      - name: Report Active UAT Version to Backend
        env:
          API_BASE_URL: ${{ secrets.API_BASE_URL_UAT }}
          APP_VERSION_CI_TOKEN: ${{ secrets.APP_VERSION_CI_TOKEN }}
        run: |
          if [ -z "$APP_VERSION_CI_TOKEN" ]; then
            echo "APP_VERSION_CI_TOKEN is not configured. Skipping webhook."
            exit 0
          fi
          RAW_TAG="${{ github.ref_name }}"
          CLEAN_VERSION=$(echo "$RAW_TAG" | sed -E 's/^v//; s/-.*//')
          echo "Reporting UAT release version $CLEAN_VERSION to $API_BASE_URL/app-version..."
          curl -s -X POST "$API_BASE_URL/app-version" \
            -H "Content-Type: application/json" \
            -H "x-ci-token: $APP_VERSION_CI_TOKEN" \
            -d "{\"version\": \"$CLEAN_VERSION\"}"

  notify-backend-prod:
    name: Notify Backend (Production)
    needs: [android-prod, ios-prod]
    if: "!contains(github.ref, '-uat') && !contains(github.ref, '-beta')"
    runs-on: ubuntu-latest
    steps:
      - name: Report Active Production Version to Backend
        env:
          API_BASE_URL: ${{ secrets.API_BASE_URL_PROD }}
          APP_VERSION_CI_TOKEN: ${{ secrets.APP_VERSION_CI_TOKEN }}
        run: |
          if [ -z "$APP_VERSION_CI_TOKEN" ]; then
            echo "APP_VERSION_CI_TOKEN is not configured. Skipping webhook."
            exit 0
          fi
          RAW_TAG="${{ github.ref_name }}"
          CLEAN_VERSION=$(echo "$RAW_TAG" | sed -E 's/^v//; s/-.*//')
          echo "Reporting Production release version $CLEAN_VERSION to $API_BASE_URL/app-version..."
          curl -s -X POST "$API_BASE_URL/app-version" \
            -H "Content-Type: application/json" \
            -H "x-ci-token: $APP_VERSION_CI_TOKEN" \
            -d "{\"version\": \"$CLEAN_VERSION\"}"

  # -------------------------------------------------------------
  # STAGE 5: Telegram release notification (success or failure)
  # -------------------------------------------------------------
  notify-telegram:
    name: Notify Telegram
    needs: [test, android-uat, android-prod, ios-uat, ios-prod]
    if: always()
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - name: Checkout notifier script and pubspec
        uses: actions/checkout@v4
        with:
          sparse-checkout: |
            .github/scripts
            pubspec.yaml
          sparse-checkout-cone-mode: false

      - name: Read app version
        id: version
        run: echo "value=$(grep -m1 '^version:' pubspec.yaml | awk '{print $2}')" >> "$GITHUB_OUTPUT"

      - name: Send release status
        run: bash .github/scripts/telegram_release_notify.sh
        env:
          TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          TELEGRAM_CHAT_ID: ${{ secrets.TELEGRAM_CHAT_ID }}
          TELEGRAM_MESSAGE_THREAD_ID: ${{ secrets.TELEGRAM_MESSAGE_THREAD_ID }}
          TAG: ${{ github.ref_name }}
          REPO: ${{ github.repository }}
          ACTOR: ${{ github.actor }}
          RUN_URL: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}
          APP_VERSION: ${{ steps.version.outputs.value }}
          TEST_RESULT: ${{ needs.test.result }}
          ANDROID_RESULT: ${{ contains(github.ref, '-uat') && needs.android-uat.result || needs.android-prod.result }}
          IOS_RESULT: ${{ contains(github.ref, '-uat') && needs.ios-uat.result || needs.ios-prod.result }}
```

---

### 5.2 Android Fastlane & Bundler Setup

#### Path: `android/Gemfile`
> ⚠️ **Must be located directly at `android/Gemfile` (never inside `android/fastlane/`)**.

```ruby
source "https://rubygems.org"

gem "fastlane"
gem "rubyzip", "~> 2.3.0"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
```

#### Path: `android/fastlane/Pluginfile`
```ruby
# Autogenerated by fastlane
# Do not delete this file if you use fastlane plugins

gem 'fastlane-plugin-firebase_app_distribution'
```

#### Path: `android/fastlane/Appfile`
```ruby
# Path is relative to the android/fastlane directory
json_key_file("fastlane-play-store.json")
package_name("{{PACKAGE_NAME}}") # e.g. com.example.app
```

#### Path: `android/fastlane/Fastfile`
```ruby
default_platform(:android)

platform :android do
  desc "Submit a new Internal Build to Firebase App Distribution"
  lane :distribute_firebase do
    api_base_url = ENV["API_BASE_URL"].to_s.strip
    sh("flutter build apk --release --dart-define=API_BASE_URL=#{api_base_url}")
    
    firebase_app_distribution(
      app: ENV["FIREBASE_ANDROID_APP_ID"],
      service_credentials_file: "firebase-distribution.json",
      groups: "internal-testers",
      release_notes: ENV["RELEASE_NOTES"] || "Build triggered via GitHub Actions tag push.",
      apk_path: "../build/app/outputs/flutter-apk/app-release.apk"
    )
  end

  desc "Deploy a new version to the Google Play Store"
  lane :deploy_play_store do
    api_base_url = ENV["API_BASE_URL"].to_s.strip
    sh("flutter build appbundle --release --dart-define=API_BASE_URL=#{api_base_url}")
    
    release_notes_text = ENV["RELEASE_NOTES"] || "Release update."
    changelog_dir = "metadata/android/vi-VN/changelogs"
    FileUtils.mkdir_p(changelog_dir)
    File.write("#{changelog_dir}/default.txt", release_notes_text)

    track = ENV["PLAY_STORE_TRACK"].to_s.strip
    track = "internal" if track.empty?

    upload_to_play_store(
      track: track,
      aab: "../build/app/outputs/bundle/release/app-release.aab",
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true,
      skip_upload_changelogs: true
    )
  end
end
```

---

### 5.3 iOS Fastlane & Match Code Signing Setup

#### Path: `ios/Gemfile`
> ⚠️ **Must be located directly at `ios/Gemfile` (never inside `ios/fastlane/`)**.

```ruby
source "https://rubygems.org"

gem "fastlane"
gem "rubyzip", "~> 2.3.0"
```

#### Path: `ios/fastlane/Appfile`
```ruby
# app_identifier accepts a single String
app_identifier("{{IOS_BUNDLE_IDENTIFIER}}") # e.g. com.example.app
apple_id(ENV["APPLE_ID"])
team_id(ENV["APPLE_TEAM_ID"])
```

#### Path: `ios/fastlane/Matchfile`
> ⚠️ **Critical Rule**: Never put dummy fallback URLs (like `git@github.com:YourOrg/...`) inside `Matchfile`. Always read cleanly from `ENV["MATCH_GIT_URL"]`.
> Notice that `app_identifier` in `Matchfile` accepts an **Array of strings `[...]`**.

```ruby
git_url(ENV["MATCH_GIT_URL"])
storage_mode("git")
type("appstore")
app_identifier(["{{IOS_BUNDLE_IDENTIFIER}}"]) # Array of strings!
username(ENV["APPLE_ID"])
clone_branch_directly(true)
```

#### Path: `ios/fastlane/Fastfile`
```ruby
require 'base64'

default_platform(:ios)

platform :ios do
  desc "Push a new build to App Store Connect / TestFlight"
  lane :deploy_app_store do
    setup_ci if ENV["CI"]
    
    # Authenticate via App Store Connect API Key
    api_key = app_store_connect_api_key(
      key_id: ENV["APP_STORE_CONNECT_KEY_ID"],
      issuer_id: ENV["APP_STORE_CONNECT_ISSUER_ID"],
      key_filepath: "fastlane/api_key.p8",
      in_house: false
    )
    
    # Synchronize certificates and profiles in read-only mode on CI
    match(
      type: "appstore",
      readonly: true,
      api_key: api_key,
      team_id: ENV["APPLE_TEAM_ID"]
    )
    
    api_base_url = ENV["API_BASE_URL"].to_s.strip
    
    # Flutter reads DART_DEFINES as a comma-separated list where EACH define is base64-encoded on
    # its own. Never encode the joined string — the app would get one malformed define.
    encoded_defines = [
      "API_BASE_URL=#{api_base_url}"
      # , "APP_ENV=#{ENV['APP_ENV']}", "DEBUG_CONSOLE=#{ENV['DEBUG_CONSOLE']}"  # more defines here
    ].map { |define| Base64.strict_encode64(define) }.join(",")

    # Resolve Swift Package Manager deployment target incompatibilities
    package_swift_path = "Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift"
    if File.exist?(package_swift_path)
      UI.message("Adjusting iOS deployment target in #{package_swift_path} to 15.0...")
      content = File.read(package_swift_path)
      content = content.gsub('.iOS("13.0")', '.iOS("15.0")')
      File.write(package_swift_path, content)
    end

    app_id = "{{IOS_BUNDLE_IDENTIFIER}}"
    profile_name = ENV["sigh_#{app_id}_appstore"] || "match AppStore #{app_id}"

    # Manual signing for the Runner target only — a profile passed through xcargs is also applied
    # to the CocoaPods targets, which fail with "does not support provisioning profiles".
    update_code_signing_settings(
      use_automatic_signing: false,
      path: "Runner.xcodeproj",
      targets: ["Runner"],
      build_configurations: ["Release"],
      team_id: ENV["APPLE_TEAM_ID"],
      code_sign_identity: "Apple Distribution",
      profile_name: profile_name
    )

    # Build the signed iOS IPA archive using gym
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      configuration: "Release",
      output_directory: "../build/ios/ipa",
      output_name: "{{APP_NAME}}.ipa",
      export_method: "app-store",
      export_options: {
        provisioningProfiles: { app_id => profile_name }
      },
      xcargs: "DART_DEFINES=#{encoded_defines}"
    )
    
    # Locate upload-symbols binary dynamically from SPM checkouts if Crashlytics is used
    spm_binary_path = Dir["/Users/runner/Library/Developer/Xcode/DerivedData/Runner-*/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols"].first
    binary_option = {}
    if spm_binary_path && File.exist?(spm_binary_path)
      UI.message("Found SPM Crashlytics upload-symbols at: #{spm_binary_path}")
      binary_option[:binary_path] = spm_binary_path
    end

    # Upload dSYM files if Crashlytics GoogleService-Info.plist exists
    if File.exist?("Runner/GoogleService-Info.plist") && File.exist?("../build/ios/ipa/{{APP_NAME}}.app.dSYM.zip")
      upload_symbols_to_crashlytics(
        dsym_path: "../build/ios/ipa/{{APP_NAME}}.app.dSYM.zip",
        gsp_path: "Runner/GoogleService-Info.plist",
        **binary_option
      )
    end

    # Upload IPA to TestFlight
    upload_to_testflight(
      ipa: "../build/ios/ipa/{{APP_NAME}}.ipa",
      skip_waiting_for_build_processing: true,
      api_key: api_key,
      changelog: ENV["RELEASE_NOTES"] || "New release build."
    )
  end
end
```

---

### 5.4 Android Gradle Signing Configuration

In `android/app/build.gradle.kts` (or `build.gradle`), ensure the release signing configuration reads from environment variables on CI, with fallback to local `key.properties`:

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        create("release") {
            // Priority: Environment variables (GitHub Actions) -> local key.properties
            val envKeystorePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
            val envKeyAlias = System.getenv("ANDROID_KEY_ALIAS")
            val envKeyPassword = System.getenv("ANDROID_KEY_PASSWORD")

            storeFile = file("upload_keystore.jks")
            storePassword = envKeystorePassword ?: keystoreProperties.getProperty("storePassword")
            keyAlias = envKeyAlias ?: keystoreProperties.getProperty("keyAlias")
            keyPassword = envKeyPassword ?: keystoreProperties.getProperty("keyPassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}
```

---

### 5.5 Telegram Notifications (Issues & Releases)

Two notifiers share one sender. Messages are **plain text** (no `parse_mode`), so nothing needs escaping, and every GitHub-controlled value reaches the scripts **only through `env:`** — never through `${{ ... }}` inside a `run:` block — so issue titles / comments cannot inject shell commands.

Message formats:

```text
🆕 Issue #100 opened (org/repo)          🚀 Release v1.0.0-uat (org/repo)
<issue title>                             UAT · version 1.0.0 (build 1)
by <actor>                                by <actor>
https://github.com/org/repo/issues/100    🤖 Android: ✅ Firebase App Distribution
                                          🍎 iOS: ✅ TestFlight
                                          📦 Artifacts: <run url>
```

Issue icons: 🆕 opened · 🔄 reopened · ✅ closed · 👤 assigned · 💬 comment (first 300 chars). Release header: 🚀 all passed · ❌ any job failed (the failed platform shows ❌; failed tests show `🧪 Test: ❌`) · ⏹ cancelled. Tags without `-uat` read `Production` / Google Play / App Store Connect.

#### Path: `.github/scripts/telegram_send.sh`
```bash
#!/usr/bin/env bash
# Sends plain text to a Telegram chat (optionally a forum topic). Shared by the issue and release
# notifiers.
#
# Usage: telegram_send.sh "<text>"
# Env:   TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID, TELEGRAM_MESSAGE_THREAD_ID (optional topic)
#        DRY_RUN=1 prints the payload instead of sending it.
set -euo pipefail

text="${1:?usage: telegram_send.sh <text>}"

payload="$(
  jq -n \
    --arg chat_id "${TELEGRAM_CHAT_ID}" \
    --arg thread_id "${TELEGRAM_MESSAGE_THREAD_ID-}" \
    --arg text "${text}" \
    '{chat_id: $chat_id, text: $text, link_preview_options: {is_disabled: true}}
    + (if $thread_id == "" then {} else {message_thread_id: ($thread_id | tonumber)} end)'
)"

if [ "${DRY_RUN-}" = "1" ]; then
  printf '%s\n' "${payload}"
  exit 0
fi

: "${TELEGRAM_BOT_TOKEN:?TELEGRAM_BOT_TOKEN is not set}"
response="$(
  curl -sS -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -H 'Content-Type: application/json' \
    --data "${payload}"
)"
if [ "$(printf '%s' "${response}" | jq -r '.ok')" != "true" ]; then
  echo "::error::Telegram sendMessage failed: $(printf '%s' "${response}" | jq -r '.description // "unknown error"')"
  exit 1
fi
echo "Sent to Telegram (message_id $(printf '%s' "${response}" | jq -r '.result.message_id'))"
```

#### Path: `.github/scripts/telegram_issue_notify.sh`
```bash
#!/usr/bin/env bash
# Sends a GitHub issue / issue-comment event to a Telegram chat (optionally a forum topic) as plain
# text, in the team's format:
#
#   ✅ Issue #100 closed (V-STECH/home_services_mobile)
#   <issue title>
#   by <actor>
#   <issue url>
#
# All event data arrives through environment variables set by the workflow — never interpolated
# into this script — so issue titles / comments cannot inject shell commands.
#
# Required: TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID, EVENT_NAME, ACTION, REPO, ISSUE_NUMBER,
#           ISSUE_TITLE, ISSUE_URL, ACTOR
# Optional: TELEGRAM_MESSAGE_THREAD_ID (forum topic), COMMENT_BODY
# DRY_RUN=1 prints the Telegram payload instead of sending it (see telegram_send.sh).
set -euo pipefail

MAX_COMMENT_CHARS="${MAX_COMMENT_CHARS:-300}"

if [ "${EVENT_NAME}" = "issue_comment" ]; then
  comment="${COMMENT_BODY-}"
  if [ "${#comment}" -gt "${MAX_COMMENT_CHARS}" ]; then
    comment="${comment:0:${MAX_COMMENT_CHARS}}…"
  fi
  text="💬 Comment mới trên #${ISSUE_NUMBER} (${REPO})
${ISSUE_TITLE}
by ${ACTOR}:
${comment}
${ISSUE_URL}"
else
  # One icon per action so the chat is scannable at a glance.
  case "${ACTION}" in
    opened) icon="🆕" ;;
    reopened) icon="🔄" ;;
    closed) icon="✅" ;;
    assigned) icon="👤" ;;
    *) icon="📌" ;;
  esac
  text="${icon} Issue #${ISSUE_NUMBER} ${ACTION} (${REPO})
${ISSUE_TITLE}
by ${ACTOR}
${ISSUE_URL}"
fi

bash "$(dirname "$0")/telegram_send.sh" "${text}"
```

#### Path: `.github/scripts/telegram_release_notify.sh`
```bash
#!/usr/bin/env bash
# Posts the outcome of a release pipeline run to Telegram, in the same plain-text style as the
# issue notifications:
#
#   🚀 Release v1.0.0-uat (V-STECH/home_services_mobile)
#   UAT · version 1.0.0 (build 1)
#   by RakiticVo
#   🤖 Android: ✅ Firebase App Distribution
#   🍎 iOS: ✅ TestFlight
#   📦 Artifacts: <run url>
#
# Env (all from the workflow, never interpolated into the script):
#   TAG, REPO, ACTOR, RUN_URL, APP_VERSION (pubspec "1.0.0+1"),
#   TEST_RESULT, ANDROID_RESULT, IOS_RESULT — success | failure | cancelled | skipped
# Telegram settings and DRY_RUN: see telegram_send.sh.
set -euo pipefail

if [[ "${TAG}" == *-uat* ]]; then
  channel="UAT"
  android_target="Firebase App Distribution"
  ios_target="TestFlight"
else
  channel="Production"
  android_target="Google Play"
  ios_target="App Store Connect"
fi

version_name="${APP_VERSION%%+*}"
build_number="${APP_VERSION#*+}"
[ "${build_number}" = "${APP_VERSION}" ] && build_number="?"

status_icon() {
  case "$1" in
    success) echo "✅" ;;
    failure) echo "❌" ;;
    cancelled) echo "⏹" ;;
    *) echo "⏭" ;;
  esac
}

results=("${TEST_RESULT}" "${ANDROID_RESULT}" "${IOS_RESULT}")
if printf '%s\n' "${results[@]}" | grep -qx failure; then
  header="❌ Release ${TAG} lỗi"
elif printf '%s\n' "${results[@]}" | grep -qx cancelled; then
  header="⏹ Release ${TAG} đã huỷ"
else
  header="🚀 Release ${TAG}"
fi

lines=("${header} (${REPO})" "${channel} · version ${version_name} (build ${build_number})" "by ${ACTOR}")
# Tests only get a line when they did not pass (then the builds never ran).
if [ "${TEST_RESULT}" != "success" ]; then
  lines+=("🧪 Test: $(status_icon "${TEST_RESULT}")")
fi
if [ "${ANDROID_RESULT}" != "skipped" ]; then
  lines+=("🤖 Android: $(status_icon "${ANDROID_RESULT}") ${android_target}")
fi
if [ "${IOS_RESULT}" != "skipped" ]; then
  lines+=("🍎 iOS: $(status_icon "${IOS_RESULT}") ${ios_target}")
fi
lines+=("📦 Artifacts: ${RUN_URL}")

text="$(printf '%s\n' "${lines[@]}")"
bash "$(dirname "$0")/telegram_send.sh" "${text}"
```

#### Path: `.github/workflows/issue-telegram.yml`
```yaml
name: Telegram Issue Notifications

# Posts issue activity to the team's Telegram chat / topic.
# Secrets: TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID, TELEGRAM_MESSAGE_THREAD_ID (forum topic, optional).
# Note: issue events run the workflow file from the default branch.
on:
  issues:
    types: [opened, reopened, closed, assigned]
  issue_comment:
    types: [created]

permissions:
  contents: read

jobs:
  notify:
    name: Send to Telegram
    # Comments on pull requests also fire issue_comment — only forward real issues.
    if: ${{ !github.event.issue.pull_request }}
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - name: Checkout notifier script
        uses: actions/checkout@v4
        with:
          sparse-checkout: .github/scripts
          sparse-checkout-cone-mode: false

      - name: Notify Telegram
        run: bash .github/scripts/telegram_issue_notify.sh
        env:
          TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          TELEGRAM_CHAT_ID: ${{ secrets.TELEGRAM_CHAT_ID }}
          TELEGRAM_MESSAGE_THREAD_ID: ${{ secrets.TELEGRAM_MESSAGE_THREAD_ID }}
          EVENT_NAME: ${{ github.event_name }}
          ACTION: ${{ github.event.action }}
          REPO: ${{ github.repository }}
          ACTOR: ${{ github.actor }}
          ISSUE_NUMBER: ${{ github.event.issue.number }}
          ISSUE_TITLE: ${{ github.event.issue.title }}
          ISSUE_URL: ${{ github.event.issue.html_url }}
          COMMENT_BODY: ${{ github.event.comment.body }}
```

The release side is the `notify-telegram` job at the end of the [5.1 template](#51-github-actions-workflow).

Local dry-runs (no message is sent):

```bash
DRY_RUN=1 TELEGRAM_CHAT_ID=-100123 EVENT_NAME=issues ACTION=opened REPO=org/repo ACTOR=me \
  ISSUE_NUMBER=1 ISSUE_TITLE=Test ISSUE_URL=https://github.com/org/repo/issues/1 \
  bash .github/scripts/telegram_issue_notify.sh

DRY_RUN=1 TELEGRAM_CHAT_ID=-100123 TAG=v1.0.0-uat REPO=org/repo ACTOR=me RUN_URL=https://example.com \
  APP_VERSION=1.0.0+1 TEST_RESULT=success ANDROID_RESULT=success IOS_RESULT=failure \
  bash .github/scripts/telegram_release_notify.sh
```

---

### 5.6 One-Time iOS Certificate Bootstrap Workflow

CI release jobs run Match **read-only**, so the distribution certificate + App Store profile must be created once. Do it on GitHub Actions with the App Store Connect API key — no local fastlane, no Apple ID login / 2FA. The Match deploy key (`MATCH_SSH_KEY`) needs **write access** for this run.

#### Lane in `ios/fastlane/Fastfile`
```ruby
  desc "One-time: create the App Store certificate + profile and store them in the Match repo"
  lane :setup_certificates do
    setup_ci if ENV["CI"]

    api_key = app_store_connect_api_key(
      key_id: ENV["APP_STORE_CONNECT_KEY_ID"],
      issuer_id: ENV["APP_STORE_CONNECT_ISSUER_ID"],
      key_filepath: "fastlane/api_key.p8",
      in_house: false
    )

    # clone_branch_directly(true) in the Matchfile fails on an empty repo — let match create the branch.
    match(
      type: "appstore",
      readonly: false,
      api_key: api_key,
      team_id: ENV["APPLE_TEAM_ID"],
      clone_branch_directly: false
    )
  end
```

#### Path: `.github/workflows/ios-setup-certificates.yml`
Triggered manually (`workflow_dispatch`) on `macos-latest`: checkout → `webfactory/ssh-agent` with `MATCH_SSH_KEY` → Ruby 3.3 + `bundler-cache` in `ios/` → write `ios/fastlane/api_key.p8` → `bundle exec fastlane setup_certificates` with `APPLE_ID`, `APPLE_TEAM_ID`, `MATCH_GIT_URL`, `MATCH_PASSWORD`, `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`. Afterwards the Match repo contains `certs/distribution/*` and `profiles/appstore/*`; write access on the deploy key can be removed again.

---

## 6. Critical Agent Invariants & Battle-Tested Gotchas

Based on real-world debugging cycles across multiple projects, agents must review these specific operational traps:

| Trap Area | What Goes Wrong (Failure Mode) | The Mandatory Fix |
|---|---|---|
| **Ruby Version** | fastlane ≥ 2.240 dropped Ruby 3.1: on 3.1 Bundler resolves an old fastlane (2.234) and prints "Support for your Ruby version is going away". | Use `ruby-version: '3.3'` in every `ruby/setup-ruby@v1` step. If an old plugin hits `CFPropertyList` / `psych` errors, update the plugin rather than downgrading Ruby. |
| **Misplaced `Gemfile`** | Placing `Gemfile` in `android/fastlane/` or `ios/fastlane/` causes Bundler cache to miss, running without fastlane plugins. | `Gemfile` **must always** be at root of `android/` and `ios/`. Fastlane plugins are imported via `eval_gemfile('fastlane/Pluginfile')`. |
| **Fastlane Match Git Clone Failure** | Leaving dummy default URLs like `git@github.com:YourOrg/...` in `Matchfile` causes `fastlane match` to clone a nonexistent repo when the secret is unset. | Use clean `git_url(ENV["MATCH_GIT_URL"])` without fallback literals. |
| **Matchfile vs Appfile Array Syntax** | `Matchfile` errors out with `app_identifier should be an Array` if passed a raw string. | In `Matchfile`: `app_identifier(["..."])` (array). In `Appfile`: `app_identifier("...")` (string). |
| **Dynamic Provisioning Profile Name** | Fastlane `build_app` fails signing with `Provisioning profile specifier not found`. | Always dynamically read the generated profile name from `ENV["sigh_#{bundle_id}_appstore"] || "match AppStore #{bundle_id}"`. |
| **Dart Defines in Xcode xcargs** | Raw `DART_DEFINES` with URLs break the Xcode CLI; encoding the **joined** string (`"A=1,B=2"`) as one base64 value makes Flutter see a single define whose value swallows the others. | Base64-encode **each** define separately and join with commas (`defines.map { ... Base64.strict_encode64(d) }.join(",")`), then pass `DART_DEFINES=#{encoded_defines}`. |
| **SPM Deployment Target Mismatch** | `FlutterGeneratedPluginSwiftPackage` errors with `target requires iOS 15.0 but Package.swift declares 13.0`. | Automatically patch `Package.swift` in the Fastlane lane before running `build_app`: replace `.iOS("13.0")` with `.iOS("15.0")`. |
| **Missing SPM dSYM upload-symbols** | Crashlytics fails to upload symbols because CocoaPods binary path does not exist under Swift Package Manager. | Dynamically scan `DerivedData` for `checkouts/firebase-ios-sdk/Crashlytics/upload-symbols` as demonstrated in `ios/fastlane/Fastfile`. |
| **Signing via xcargs hits CocoaPods targets** | Passing `CODE_SIGN_STYLE=Manual PROVISIONING_PROFILE_SPECIFIER=…` in `xcargs` applies to every target, so Pods targets fail with "does not support provisioning profiles". | Use `update_code_signing_settings(targets: ["Runner"], …)` before `build_app`, plus `export_options: { provisioningProfiles: { bundle_id => profile } }`; keep only `DART_DEFINES` in `xcargs`. |
| **First Match run on an empty repo** | `fatal: Remote branch master not found` — the Matchfile's `clone_branch_directly(true)` needs an existing branch. | Run the one-time bootstrap with `clone_branch_directly: false` ([5.6](#56-one-time-ios-certificate-bootstrap-workflow)); release lanes keep the Matchfile default. |
| **Issue workflow never fires** | `issues` / `issue_comment` events always run the workflow file from the **default branch**; a workflow only on `dev` or a feature branch is ignored. | Merge `issue-telegram.yml` into the default branch (e.g. `main`). |
| **Script injection via issue text** | Interpolating `${{ github.event.issue.title }}` / comment body inside `run:` lets anyone who can open an issue run shell commands on the runner. | Pass every event field through `env:` and reference it as `"$VAR"` in the script (see 5.5). |
| **PR comments in the issue topic** | `issue_comment` also fires for pull-request comments. | Guard the job with `if: ${{ !github.event.issue.pull_request }}`. |
| **Failed release goes unannounced** | A notify job with plain `needs:` is skipped when any needed job fails or is skipped. | Use `if: always()` on `notify-telegram` and read `needs.<job>.result` (`success` / `failure` / `cancelled` / `skipped`). |
| **Telegram `chat not found` / `message thread not found`** | Bot not in the group, wrong chat ID, or wrong topic ID. | Add the bot to the group, use the `-100…` chat ID, verify the topic ID; leave `TELEGRAM_MESSAGE_THREAD_ID` empty for groups without topics. |
| **Multi-line Release Notes Break GitHub Env** | Multi-line tag messages cause `GITHUB_ENV` variable truncation or syntax errors. | Cleanse newlines in shell before exporting: `TAG_MSG=$(echo "$TAG_MSG" | tr '\n' ' ')`. |

---

## 7. Pre-Flight Verification Checklist

Before pushing any release tag or handing off a new CI/CD setup, execute this checklist:

```markdown
- [ ] 1. Verified `android/Gemfile` and `ios/Gemfile` are committed to Git.
- [ ] 2. Verified `android/fastlane/Pluginfile` declares `fastlane-plugin-firebase_app_distribution`.
- [ ] 3. Verified `android/app/build.gradle.kts` release signingConfig matches the Keystore filename in CI.
- [ ] 4. Verified `ios/fastlane/Matchfile` has array syntax for `app_identifier`.
- [ ] 5. Verified `pubspec.yaml` version has been bumped (`X.Y.Z+build`).
- [ ] 6. Verified current working branch is fully merged into `dev` (or `prod`).
- [ ] 7. Checked that all 15+ GitHub Secrets from Section 2 are populated in repository settings.
- [ ] 8. Telegram: `TELEGRAM_BOT_TOKEN` / `TELEGRAM_CHAT_ID` (/ `TELEGRAM_MESSAGE_THREAD_ID`) set, bot added to the group, `issue-telegram.yml` on the default branch, scripts dry-run with `DRY_RUN=1`.
- [ ] 9. iOS: Match repo already holds `certs/` + `profiles/` (ran `ios-setup-certificates.yml` once).
- [ ] 10. Pushed tag matching pattern:
       - UAT: `git tag -a vX.Y.Z-uat -m "UAT Release Notes" && git push origin vX.Y.Z-uat`
       - Prod: `git tag -a vX.Y.Z -m "Production Release Notes" && git push origin vX.Y.Z`
```

---

## 8. Summary for AI Agents

When instructed to configure CI/CD on a new project:
1. **Never copy-paste hardcoded project IDs** (`gocsuaapp`, `AuthKey_SACK5N6YM4.p8`, etc.) from old projects.
2. **Scan the new project** for `applicationId`, `PRODUCT_BUNDLE_IDENTIFIER`, and Flutter SDK version.
3. **Scaffold the exact templates** from Section 5 with the extracted identifiers.
4. **Instruct the user** which GitHub Secrets need to be filled in according to the Type 1 table.
5. **Wire Telegram notifications** (Section 5.5): shared sender, issue workflow on the default branch, `notify-telegram` job with `if: always()`.
6. **Bootstrap iOS certificates once** with the manual workflow (Section 5.6).
7. **Verify with a dry-run tag** (`v1.0.0-uat`) on the `dev` branch — expect builds on Firebase / TestFlight and a 🚀 message in Telegram.
