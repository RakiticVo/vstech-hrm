#!/usr/bin/env bash
# Posts the outcome of a release pipeline run to Telegram, in the same plain-text style as the
# issue notifications:
#
#   🚀 Release v1.0.0-uat (RakiticVo/vstech-hrm)
#   UAT · version 1.0.0 (build 12)
#   by RakiticVo
#   🤖 Android: ✅ Firebase App Distribution
#   🍎 iOS: ✅ TestFlight
#   📦 Artifacts: <run url>
#
# Env (all from the workflow, never interpolated into the script):
#   TAG, REPO, ACTOR, RUN_URL, BUILD_NAME, BUILD_NUMBER (empty when tag validation failed),
#   TEST_RESULT, ANDROID_RESULT, IOS_RESULT — success | failure | cancelled | skipped
# Telegram settings and DRY_RUN: see telegram_send.sh.
set -euo pipefail

if [[ "${TAG}" == *-uat* ]]; then
  channel="UAT"
  android_target="Firebase App Distribution"
else
  channel="Production"
  android_target="Google Play"
fi
ios_target="TestFlight"

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
  header="❌ Release ${TAG} failed"
elif printf '%s\n' "${results[@]}" | grep -qx cancelled; then
  header="⏹ Release ${TAG} cancelled"
else
  header="🚀 Release ${TAG}"
fi

lines=("${header} (${REPO})" "${channel} · version ${BUILD_NAME:-?} (build ${BUILD_NUMBER:-?})" "by ${ACTOR}")
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
