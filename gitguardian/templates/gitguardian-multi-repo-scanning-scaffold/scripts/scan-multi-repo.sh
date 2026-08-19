#!/usr/bin/env bash
# last_verified: 2026-08-19 · GitGuardian ggshield
#
# Clone each repository listed in repos.txt, run ggshield against the
# working tree, and write a timestamped JSON report per repo.
#
# Usage: ./scan-multi-repo.sh <repos-file> <output-dir>
#
# Environment variables:
#   GG_TOKEN      - GitGuardian API token (optional, enables dashboard push)
#   GG_CONFIG     - Path to ggshield.yaml (default: ../ggshield.yaml)

set -euo pipefail

REPOS_FILE="${1:-repos.txt}"
OUT_DIR="${2:-reports}"
GG_CONFIG="${GG_CONFIG:-$(dirname "$0")/../ggshield.yaml}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
WORK_ROOT=$(mktemp -d /tmp/gg-scan-XXXXXX)

mkdir -p "$OUT_DIR"

if [[ ! -f "$REPOS_FILE" ]]; then
  echo "ERROR: repos file not found: $REPOS_FILE" >&2
  exit 1
fi

if ! command -v ggshield &>/dev/null; then
  echo "ERROR: ggshield is not installed" >&2
  exit 2
fi

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required" >&2
  exit 2
fi

total=0
failures=0

while IFS= read -r repo_url || [[ -n "$repo_url" ]]; do
  [[ -z "$repo_url" ]] && continue
  [[ "$repo_url" =~ ^# ]] && continue

  total=$((total + 1))
  repo_name=$(basename "$repo_url" .git)
  clone_dir="$WORK_ROOT/$repo_name"

  echo "[$total] Scanning $repo_name ..."

  if ! git clone --depth 1 "$repo_url" "$clone_dir" >/dev/null 2>&1; then
    echo "  WARNING: failed to clone $repo_url — skipping" >&2
    failures=$((failures + 1))
    continue
  fi

  if [[ -n "${GG_TOKEN:-}" ]]; then
    GITGUARDIAN_API_KEY="$GG_TOKEN" ggshield secret scan path "$clone_dir" \
      --recursive --json --config-path "$GG_CONFIG" \
      > "$OUT_DIR/${repo_name}-${TIMESTAMP}.json" 2>/dev/null || true
  else
    ggshield secret scan path "$clone_dir" \
      --recursive --json --config-path "$GG_CONFIG" \
      > "$OUT_DIR/${repo_name}-${TIMESTAMP}.json" 2>/dev/null || true
  fi

  echo "  Report: $OUT_DIR/${repo_name}-${TIMESTAMP}.json"
done < "$REPOS_FILE"

echo ""
echo "Scanned $total repos ($failures failures). Reports in $OUT_DIR/"
