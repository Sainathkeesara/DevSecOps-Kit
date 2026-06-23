#!/usr/bin/env bash
# Minimal Terrascan CI script: scan Terraform and fail on high severity violations
# Following the quickstart — figured this out after the --exit-code gotcha

TARGET="${1:-.}"

echo "=== Terrascan CI scan: $TARGET ==="

# Without --exit-code terrascan returns 0 even when it finds violations,
# which defeats the purpose of a CI gate — that was the first thing I tripped on
terrascan scan -d "$TARGET" --severity high --exit-code 1 -o human

# The --exit-code flag makes the exit code propagate automatically,
# so no extra checking needed here
