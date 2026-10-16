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
