#!/usr/bin/env bash
# last_verified: 2026-07-10 · grype n/a
#
# grype-end-to-end-scan-pipeline.sh
#
# End-to-end container vulnerability scanning pipeline built around Grype.
# It scans one or more container images, emits both machine-readable JSON
# (for triage/audit) and SARIF (for upload to GitHub code scanning), and
# exits non-zero when vulnerabilities at or above a chosen severity are found
# so it can gate a CI job.
#
# Intended to be dropped into a CI runner as-is: point IMAGE (or pass an
# image ref as the first argument) and run. Results land in ./scan-results.

set -euo pipefail

# ----- configuration -------------------------------------------------------
IMAGE="${1:-${IMAGE:-}}"
OUTPUT_DIR="${OUTPUT_DIR:-scan-results}"
FAIL_ON="${FAIL_ON:-high}"          # grype severity gate: negligible|low|medium|high|critical
# Optional: only_fail_on tells grype to ignore certain fix states. Leave empty
# to use the default behaviour (all findings count).
ONLY_FAIL_ON="${ONLY_FAIL_ON:-}"

if [[ -z "$IMAGE" ]]; then
  echo "usage: $0 <image-ref>   (or set IMAGE)" >&2
  exit 2
fi

# ----- helpers -------------------------------------------------------------
log() { printf '[grype-pipeline] %s\n' "$*"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: required command '$1' not found on PATH" >&2
    exit 3
  }
}

# ----- pre-flight ----------------------------------------------------------
require_cmd grype

mkdir -p "$OUTPUT_DIR"
SAFE_NAME="$(echo "$IMAGE" | tr '/:' '__')"
JSON_OUT="${OUTPUT_DIR}/${SAFE_NAME}.json"
SARIF_OUT="${OUTPUT_DIR}/${SAFE_NAME}.sarif"

# ----- scan ----------------------------------------------------------------
# One Grype invocation per image. We capture JSON locally and generate SARIF
# from the same scan so the two artifacts describe exactly the same findings.
log "scanning ${IMAGE} (fail-on=${FAIL_ON})"
if ! grype "$IMAGE" -o json --file "$JSON_OUT"; then
  echo "error: grype failed to scan ${IMAGE}" >&2
  exit 4
fi

# SARIF is produced as a separate render of the same image scan. In CI you
# typically upload this file to the GitHub code-scanning API.
grype "$IMAGE" -o sarif --file "$SARIF_OUT"
log "wrote ${JSON_OUT} and ${SARIF_OUT}"

# ----- gate ----------------------------------------------------------------
# Re-run grype in table mode purely to apply the severity gate and set the
# exit code. --fail-on makes grype exit 1 when a matching finding exists.
GATE_ARGS=( "$IMAGE" --fail-on "$FAIL_ON" )
[[ -n "$ONLY_FAIL_ON" ]] && GATE_ARGS+=( --only-fail-on "$ONLY_FAIL_ON" )

set +e
grype "${GATE_ARGS[@]}" -o table
GATE_RC=$?
set -e

if [[ $GATE_RC -eq 1 ]]; then
  log "gate FAILED: ${IMAGE} has vulnerabilities at or above '${FAIL_ON}'"
  exit 1
elif [[ $GATE_RC -ne 0 ]]; then
  echo "error: grype gate returned unexpected code ${GATE_RC}" >&2
  exit 4
fi

log "gate PASSED: no ${FAIL_ON}+ vulnerabilities in ${IMAGE}"
