#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
PORT="${1:-8123}"

echo "FRAME · 证件照工坊"
echo "http://127.0.0.1:${PORT}/"
echo "按 Ctrl+C 停止"

python3 -m http.server "$PORT" --bind 127.0.0.1
