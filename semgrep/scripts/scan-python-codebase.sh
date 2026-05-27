#!/bin/bash
# Scan a Python codebase with Semgrep and filter by severity
# Usage: ./scan-python-codebase.sh [target-dir] [severity]

TARGET="${1:-.}"
SEVERITY="${2:-WARNING}"

echo "Scanning $TARGET with Semgrep (severity >= $SEVERITY)..."

semgrep --config=auto --severity="$SEVERITY" "$TARGET"
