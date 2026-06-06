#!/usr/bin/env bash
# scan.sh — Run Checkov against multiple IaC directories
#
# Usage:
#   ./scan.sh            — scan configured targets, exit 1 on medium+ findings
#   ./scan.sh --sarif    — same scan but output SARIF to stdout
#
# TARGET_DIRS: space-separated list of directories to scan.
# Adjust these to match your repository layout.

set -euo pipefail

TARGET_DIRS=(
  "terraform/"
  "kubernetes/"
  "cloudformation/"
  "arm-templates/"
  "docker/"
  "helm-charts/"
)

HAS_ERROR=0
SARIF_FLAG=0

if [[ "${1:-}" == "--sarif" ]]; then
  SARIF_FLAG=1
fi

for dir in "${TARGET_DIRS[@]}"; do
  if [[ ! -d "$dir" ]]; then
    echo "[skip] $dir — does not exist"
    continue
  fi

  echo "[scan] $dir"

  if [[ $SARIF_FLAG -eq 1 ]]; then
    checkov \
      --config-file checkov-config.yaml \
      --directory "$dir" \
      --output sarif \
      --compact || HAS_ERROR=1
  else
    checkov \
      --config-file checkov-config.yaml \
      --directory "$dir" \
      --compact || HAS_ERROR=1
  fi
done

exit $HAS_ERROR
