#!/usr/bin/env bash
# scan.sh — Local TruffleHog scan entry point
#
# Usage:
#   ./scan.sh              — scan filesystem and git history, exit 1 on findings
#   ./scan.sh --filesystem — scan filesystem only
#   ./scan.sh --git        — scan git history only
#   ./scan.sh --verify     — verify secrets against live APIs (slower)
#
# Reads configuration from trufflehog-config.yaml at project root.
# Exits: 0 = clean, 1 = findings, 2 = error

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${PROJECT_DIR}/trufflehog-config.yaml"
REPORT_DIR="${PROJECT_DIR}/reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

MODE="all"
VERIFY=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --filesystem)
      MODE="filesystem"
      shift
      ;;
    --git)
      MODE="git"
      shift
      ;;
    --verify)
      VERIFY=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--filesystem|--git] [--verify]"
      echo "  --filesystem  Scan filesystem only"
      echo "  --git         Scan git history only"
      echo "  --verify      Verify secrets against live APIs"
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "[error] Config file not found: $CONFIG_FILE" >&2
  exit 2
fi

mkdir -p "$REPORT_DIR"

VERIFY_FLAG=""
if [[ "$VERIFY" == true ]]; then
  VERIFY_FLAG="--verification"
  echo "[info] Secret verification enabled"
else
  VERIFY_FLAG="--no-verification"
fi

HAS_FINDINGS=0

scan_filesystem() {
  local outfile="${REPORT_DIR}/filesystem-${TIMESTAMP}.json"
  echo "[scan] Filesystem scan..."

  if trufflehog filesystem "$PROJECT_DIR" \
      --config="$CONFIG_FILE" \
      --json \
      $VERIFY_FLAG 2>/dev/null > "$outfile"; then
    echo "  → clean"
    return 0
  fi

  if [[ -s "$outfile" ]]; then
    local count
    count=$(wc -l < "$outfile")
    echo "  → $count potential secret(s)"
    head -20 "$outfile"
    return 1
  fi

  echo "  → clean (exit code non-zero but no output)"
  return 0
}

scan_git() {
  local outfile="${REPORT_DIR}/git-${TIMESTAMP}.json"
  echo "[scan] Git history scan (last 50 commits)..."

  if trufflehog git file://"$PROJECT_DIR" \
      --since-commit HEAD~50 \
      --config="$CONFIG_FILE" \
      --json \
      $VERIFY_FLAG 2>/dev/null > "$outfile"; then
    echo "  → clean"
    return 0
  fi

  if [[ -s "$outfile" ]]; then
    local count
    count=$(wc -l < "$outfile")
    echo "  → $count potential secret(s)"
    head -20 "$outfile"
    return 1
  fi

  echo "  → clean (exit code non-zero but no output)"
  return 0
}

case $MODE in
  filesystem)
    scan_filesystem || HAS_FINDINGS=1
    ;;
  git)
    scan_git || HAS_FINDINGS=1
    ;;
  all)
    scan_filesystem || HAS_FINDINGS=1
    scan_git || HAS_FINDINGS=1
    ;;
esac

if [[ $HAS_FINDINGS -eq 1 ]]; then
  echo ""
  echo "[result] Secrets detected — review findings above"
  exit 1
fi

echo ""
echo "[result] No secrets detected"
exit 0