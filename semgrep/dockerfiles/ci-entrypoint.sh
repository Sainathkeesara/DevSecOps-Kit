#!/usr/bin/env bash
# CI entrypoint for the custom Semgrep scanning image.
# Wraps semgrep with baseline-commit support for diff-aware scanning.
# Falls back to full scan if no baseline is provided.

set -e

BASELINE="${BASELIME_COMMIT:-}"

if [ -n "$BASELINE" ]; then
  exec semgrep --baseline-commit "$BASELINE" "$@"
else
  exec semgrep "$@"
fi
