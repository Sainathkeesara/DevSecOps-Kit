#!/usr/bin/env bash
# last_verified: 2026-07-21 · grype n/a
#
# Grype CI scanning pipeline — scan a container image, export JSON +
# SARIF, and gate on severity. Designed to be dropped into a GitHub
# Actions or similar CI step as-is.

set -euo pipefail

IMAGE="${1:-${IMAGE:-}}"
OUTPUT_DIR="${OUTPUT_DIR:-grype-reports}"
SEVERITY_GATE="${SEVERITY_GATE:-high}"

usage() {
  echo "Usage: $0 <image>"
  echo "  IMAGE        Container image to scan (or set IMAGE env)"
  echo "  OUTPUT_DIR   Report output directory (default: grype-reports)"
  echo "  SEVERITY_GATE  Fail severity threshold (default: high)"
  exit 2
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Required command '$1' not found on PATH" >&2
    exit 3
  }
}

[[ -n "$IMAGE" ]] || usage
require_cmd grype

mkdir -p "$OUTPUT_DIR"
safe_name=$(echo "$IMAGE" | tr '/:' '__')
json_out="${OUTPUT_DIR}/${safe_name}.json"
sarif_out="${OUTPUT_DIR}/${safe_name}.sarif"

# Scan once, export two formats. JSON for detailed review and SARIF for
# GitHub code-scanning upload. Grype's SARIF output has the same findings
# as JSON — no extra scan needed.
echo "Scanning ${IMAGE} ..."
grype "$IMAGE" -o json --file "$json_out"
grype "$IMAGE" -o sarif --file "$sarif_out"
echo "Reports: ${json_out} ${sarif_out}"

# Severity gate: re-run with --fail-on so the exit code reflects the
# configured threshold. This is what makes the pipeline fail in CI when
# a high/critical finding is present.
echo "Checking severity gate (>= ${SEVERITY_GATE}) ..."
set +e
grype "$IMAGE" --fail-on "$SEVERITY_GATE" -o table >/dev/null 2>&1
gate_rc=$?
set -e

case $gate_rc in
  0)
    echo "Gate passed: no ${SEVERITY_GATE}+ vulnerabilities"
    ;;
  1)
    echo "Gate FAILED: vulnerabilities at or above ${SEVERITY_GATE}"
    exit 1
    ;;
  *)
    echo "WARNING: grype --fail-on returned unexpected exit code ${gate_rc}"
    ;;
esac
