#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: sbom-vuln-pipeline.sh <image-or-source>

Environment:
  OUTPUT_DIR     Report directory (default: ./syft-grype-output)
  FAIL_ON        Grype fail threshold: negligible, low, medium, high, critical (default: high)
  GRYPE_FORMAT   Grype output format: json, sarif, cyclonedx-json, table (default: json)

Examples:
  ./sbom-vuln-pipeline.sh alpine:latest
  OUTPUT_DIR=reports FAIL_ON=critical ./sbom-vuln-pipeline.sh docker:nginx:1.25
USAGE
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

safe_name() {
  printf '%s' "$1" | tr '/:@' '---' | sed 's/[^A-Za-z0-9._-]/_/g'
}

extension_for_format() {
  case "$1" in
    json|cyclonedx-json) printf 'json' ;;
    sarif) printf 'sarif' ;;
    table) printf 'txt' ;;
    *) fail "unsupported Grype output format: $1" ;;
  esac
}

summarize_json() {
  local report=$1
  python3 - "$report" <<'PY'
import json
import sys
from collections import Counter

path = sys.argv[1]
try:
    with open(path, encoding="utf-8") as handle:
        data = json.load(handle)
except json.JSONDecodeError as exc:
    print(f"warning: could not parse {path}: {exc}")
    sys.exit(0)

matches = data.get("matches", [])
if not matches:
    print("No vulnerabilities matched the configured threshold.")
    sys.exit(0)

counts = Counter(match.get("vulnerability", {}).get("severity", "unknown") for match in matches)
print("Vulnerability summary:")
for severity in ["critical", "high", "medium", "low", "negligible", "unknown"]:
    if counts.get(severity):
        print(f"  {severity}: {counts[severity]}")
print(f"  total: {len(matches)}")
PY
}

[[ ${1:-} == "-h" || ${1:-} == "--help" ]] && { usage; exit 0; }
TARGET="${1:-}"
[[ -n "$TARGET" ]] || { usage; exit 1; }

OUTPUT_DIR="${OUTPUT_DIR:-./syft-grype-output}"
FAIL_ON="${FAIL_ON:-high}"
GRYPE_FORMAT="${GRYPE_FORMAT:-json}"

case "$FAIL_ON" in
  negligible|low|medium|high|critical) ;;
  *) fail "FAIL_ON must be one of: negligible, low, medium, high, critical" ;;
esac

require_command syft
require_command grype
require_command python3

GRYPE_EXT=$(extension_for_format "$GRYPE_FORMAT")
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="${OUTPUT_DIR%/}/$(safe_name "$TARGET")-${TIMESTAMP}"
SBOM_FILE="${REPORT_DIR}/sbom.cyclonedx.json"
GRYPE_FILE="${REPORT_DIR}/grype-results.${GRYPE_EXT}"

mkdir -p "$REPORT_DIR"

printf '[syft] Generating CycloneDX SBOM for %s\n' "$TARGET"
syft scan "$TARGET" -o cyclonedx-json > "$SBOM_FILE"

printf '[grype] Scanning SBOM with fail-on=%s format=%s\n' "$FAIL_ON" "$GRYPE_FORMAT"
GRYPE_EXIT=0
if ! grype "sbom:${SBOM_FILE}" --fail-on "$FAIL_ON" --output "$GRYPE_FORMAT" > "$GRYPE_FILE"; then
  GRYPE_EXIT=$?
fi

if [[ "$GRYPE_FORMAT" == "json" ]]; then
  summarize_json "$GRYPE_FILE"
fi

printf '[done] Reports written to %s\n' "$REPORT_DIR"
printf '  SBOM:   %s\n' "$SBOM_FILE"
printf '  Grype:  %s\n' "$GRYPE_FILE"

if [[ $GRYPE_EXIT -ne 0 ]]; then
  printf '[fail] Grype exited with code %s for threshold %s\n' "$GRYPE_EXIT" "$FAIL_ON"
  exit "$GRYPE_EXIT"
fi

printf '[pass] No vulnerabilities met the %s threshold\n' "$FAIL_ON"
