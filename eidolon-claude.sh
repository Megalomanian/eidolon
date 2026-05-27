#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

mkdir -p artifacts

exec docker run -it --rm \
  --env-file .env \
  -e ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-https://api.deepseek.com/anthropic}" \
  -e CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  -v "$(pwd):/work" \
  -v "$(pwd)/artifacts:/shared" \
  eidolon-claude:dev "$@"
