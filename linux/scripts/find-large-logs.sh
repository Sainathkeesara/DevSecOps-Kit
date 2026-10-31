#!/bin/bash
# last_verified: 2026-10-31 · linux n/a
set -e

LOG_DIR="${1:-.}"

cd "$LOG_DIR" || exit

find . -name '*.log' -type f -size +1M
