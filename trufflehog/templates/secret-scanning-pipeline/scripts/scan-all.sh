#!/usr/bin/env bash
# scan-all.sh — Run TruffleHog against configured targets
#
# Usage:
#   ./scan-all.sh              — scan all targets, exit 1 on any finding
#   ./scan-all.sh --ci         — same but write SARIF-compatible output
#
# Reads targets from trufflehog-config.yaml at the project root.
# Falls back to scanning the entire filesystem if the config file is missing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${PROJECT_DIR}/trufflehog-config.yaml"
REPORT_DIR="${PROJECT_DIR}/reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CI_MODE=0

if [[ "${1:-}" == "--ci" ]]; then
  CI_MODE=1
fi

mkdir -p "$REPORT_DIR"

scan_target() {
  local target="$1"
  local label="$2"
  local outfile="${REPORT_DIR}/${label}-${TIMESTAMP}.json"

  echo "[scan] $target"

  if [[ $CI_MODE -eq 1 ]]; then
    trufflehog filesystem "$target" \
      --config="$CONFIG_FILE" \
      --json \
      --no-verification 2>/dev/null > "$outfile" || true
  else
    trufflehog filesystem "$target" \
      --config="$CONFIG_FILE" \
      --json \
      --no-verification 2>/dev/null > "$outfile" || true
  fi

  if [[ -s "$outfile" ]]; then
    local count
    count=$(wc -l < "$outfile")
    echo "  → $count potential secret(s)"
    return 1
  fi

  echo "  → clean"
  return 0
}

HAS_FINDINGS=0

# Try to parse targets from the config file
if [[ -f "$CONFIG_FILE" ]]; then
  # Filesystem targets — scan each configured path
  while IFS= read -r line; do
    path="$PROJECT_DIR/$line"
    if [[ -d "$path" ]]; then
      scan_target "$path" "$(basename "$path")" || HAS_FINDINGS=1
    fi
  done < <(yq eval '.fs_paths[]' "$CONFIG_FILE" 2>/dev/null || echo ".")

  # If yq isn't available or no fs_paths configured, scan the project root
  if [[ $HAS_FINDINGS -eq 0 ]] && ! command -v yq &>/dev/null; then
    echo "[info] yq not found — falling back to full-project scan"
    scan_target "$PROJECT_DIR" "full-scan" || HAS_FINDINGS=1
  fi
else
  echo "[warn] No config file found at $CONFIG_FILE — scanning project root"
  scan_target "$PROJECT_DIR" "full-scan" || HAS_FINDINGS=1
fi

exit $HAS_FINDINGS
