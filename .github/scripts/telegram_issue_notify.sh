#!/usr/bin/env bash
# Sends a GitHub issue / issue-comment event to a Telegram chat (optionally a forum topic) as plain
# text:
#
#   ✅ Issue #100 closed (RakiticVo/vstech-hrm)
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
  text="💬 New comment on #${ISSUE_NUMBER} (${REPO})
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
