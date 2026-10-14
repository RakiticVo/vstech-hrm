#!/bin/bash
# Capture the booted iPhone 17 Pro Max simulator into ../screenshots/<name>.png
# usage: shot.sh <name> [delay-seconds]
DIR="$(cd "$(dirname "$0")/.." && pwd)/screenshots"
sleep "${2:-1.5}"
xcrun simctl io 336E8AC6-0457-43CD-B285-6FACE70295BC screenshot "$DIR/$1.png" >/dev/null 2>&1 && echo "saved $1"
