#!/usr/bin/env bash
# scan-ci.sh — CI-mode TruffleHog scan with artifact generation
#
# Usage:
#   ./scan-ci.sh [--github|--gitlab] [--full-history]
#
# Generates SARIF output for GitHub Code Scanning or GitLab SAST.
# Exits: 0 = clean, 1 = findings, 2 = error
#
# Environment variables:
#   CI_PLATFORM     — "github" or "gitlab" (auto-detected if not set)
#   TRUFFLEHOG_TOKEN — token for authenticated git scanning
#   SCAN_DEPTH      — git history depth (default: 50, 0 = full history)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${PROJECT_DIR}/trufflehog-config.yaml"
REPORT_DIR="${PROJECT_DIR}/reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

PLATFORM="${CI_PLATFORM:-}"
FULL_HISTORY=false
SCAN_DEPTH="${SCAN_DEPTH:-50}"

while [[ $# -gt 0 ]]; do
  case $1 in
    --github)
      PLATFORM="github"
      shift
      ;;
    --gitlab)
      PLATFORM="gitlab"
      shift
      ;;
    --full-history)
      FULL_HISTORY=true
      SCAN_DEPTH=0
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--github|--gitlab] [--full-history]"
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

# Auto-detect CI platform
if [[ -z "$PLATFORM" ]]; then
  if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
    PLATFORM="github"
  elif [[ -n "${GITLAB_CI:-}" ]]; then
    PLATFORM="gitlab"
  else
    PLATFORM="github"  # default
  fi
fi

echo "[ci-scan] Platform: $PLATFORM"
echo "[ci-scan] Config: $CONFIG_FILE"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "[error] Config file not found: $CONFIG_FILE" >&2
  exit 2
fi

mkdir -p "$REPORT_DIR"

HAS_FINDINGS=0
SARIF_FILES=()
JUNIT_FILE=""

run_scan() {
  local name="$1"
  local cmd="$2"
  local outfile="${REPORT_DIR}/${name}-${TIMESTAMP}.sarif"

  echo "[scan] $name..."
  if eval "$cmd" \
      --config="$CONFIG_FILE" \
      --sarif \
      --no-verification > "$outfile" 2>&1; then
    echo "  → clean"
    return 0
  fi

  if [[ -s "$outfile" ]]; then
    local count
    count=$(jq '.runs[0].results | length' "$outfile" 2>/dev/null || echo "0")
    echo "  → $count potential secret(s)"
    SARIF_FILES+=("$outfile")
    return 1
  fi

  echo "  → clean (exit code non-zero but no SARIF output)"
  return 0
}

# Filesystem scan
if ! run_scan "filesystem" "trufflehog filesystem \"$PROJECT_DIR\""; then
  HAS_FINDINGS=1
fi

# Git history scan
if [[ "$FULL_HISTORY" == true ]]; then
  if ! run_scan "git-full" "trufflehog git file://\"$PROJECT_DIR\""; then
    HAS_FINDINGS=1
  fi
else
  if ! run_scan "git" "trufflehog git file://\"$PROJECT_DIR\" --since-commit HEAD~${SCAN_DEPTH}"; then
    HAS_FINDINGS=1
  fi
fi

# Combine SARIF files if multiple
if [[ ${#SARIF_FILES[@]} -gt 1 ]]; then
  COMBINED="${REPORT_DIR}/trufflehog-combined.sarif"
  echo "[ci-scan] Combining ${#SARIF_FILES[@]} SARIF files..."
  jq -s '{
    version: "2.1.0",
    runs: (map(.runs[0]) | add | {results: (map(.results) | add), tool: .tool, artifacts: .artifacts})
  }' "${SARIF_FILES[@]}" > "$COMBINED"
  SARIF_FILES=("$COMBINED")
elif [[ ${#SARIF_FILES[@]} -eq 1 ]]; then
  # Copy to stable name
  cp "${SARIF_FILES[0]}" "${REPORT_DIR}/trufflehog-combined.sarif"
  SARIF_FILES=("${REPORT_DIR}/trufflehog-combined.sarif")
fi

# Generate JUnit for GitLab
if [[ "$PLATFORM" == "gitlab" && ${#SARIF_FILES[@]} -gt 0 ]]; then
  JUNIT_FILE="${REPORT_DIR}/trufflehog-junit-${TIMESTAMP}.xml"
  echo "[ci-scan] Generating JUnit report..."
  python3 - <<'PYEOF'
import json, sys, xml.etree.ElementTree as ET
from datetime import datetime

with open(sys.argv[1]) as f:
    sarif = json.load(f)

testsuite = ET.Element("testsuite", name="TruffleHog Secret Detection", timestamp=datetime.utcnow().isoformat())
results = sarif.get("runs", [{}])[0].get("results", [])

for r in results:
    rule_id = r.get("ruleId", "unknown")
    msg = r.get("message", {}).get("text", "")
    locs = r.get("locations", [])
    file_path = locs[0].get("physicalLocation", {}).get("artifactLocation", {}).get("uri", "unknown") if locs else "unknown"
    line = locs[0].get("physicalLocation", {}).get("region", {}).get("startLine", 0) if locs else 0

    testcase = ET.SubElement(testsuite, "testcase", name=f"{rule_id}:{file_path}:{line}", classname="secret-detection")
    failure = ET.SubElement(testcase, "failure", message=msg, type="SecretFound")
    failure.text = f"Detector: {rule_id}\nFile: {file_path}:{line}\nDetails: {msg}"

if len(results) == 0:
    ET.SubElement(testsuite, "testcase", name="no-secrets-found", classname="secret-detection")

tree = ET.ElementTree(testsuite)
tree.write(sys.argv[2], encoding="utf-8", xml_declaration=True)
PYEOF
  "${SARIF_FILES[0]}" "$JUNIT_FILE"
fi

# GitHub: SARIF upload is handled by the workflow
# GitLab: artifacts are declared in .gitlab-ci.yml

if [[ $HAS_FINDINGS -eq 1 ]]; then
  echo ""
  echo "[ci-scan] Secrets detected — failing build"
  exit 1
fi

echo ""
echo "[ci-scan] No secrets detected"
exit 0