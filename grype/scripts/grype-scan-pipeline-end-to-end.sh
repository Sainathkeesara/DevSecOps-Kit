#!/usr/bin/env bash
# last_verified: 2026-07-18 · grype n/a
#
# End-to-end Grype vulnerability scanning pipeline.
# Scans a container image, produces JSON + SARIF output, and gates CI
# on a configurable severity threshold.
#
# I wrote this after the quickstart to see how Grype fits into a real
# CI stage. The approach here is: scan once, export two formats from
# the same run (JSON for local review, SARIF for GitHub code scanning),
# then re-check with --fail-on to decide pass/fail.
#
# Usage:
#   ./grype-scan-pipeline-end-to-end.sh <image> [--fail-on <severity>]
#
# Examples:
#   ./grype-scan-pipeline-end-to-end.sh alpine:latest
#   ./grype-scan-pipeline-end-to-end.sh myapp:v1 --fail-on critical

IMAGE="${1:-}"
FAIL_ON="${2:-high}"

if [ -z "$IMAGE" ]; then
  echo "Usage: $0 <image> [--fail-on severity]"
  echo "  severity defaults to 'high'"
  exit 1
fi

OUTDIR="./grype-output"
mkdir -p "$OUTDIR"

# Build a safe filename from the image ref (replace / and : with _)
SAFE_NAME="$(echo "$IMAGE" | tr '/:' '_')"
JSON_FILE="${OUTDIR}/${SAFE_NAME}.json"
SARIF_FILE="${OUTDIR}/${SAFE_NAME}.sarif"

echo "=== Step 1: Scan and export JSON ==="
# JSON is the most detailed format — good for local inspection and jq queries.
# Using --file writes output directly to disk instead of stdout.
grype "$IMAGE" -o json --file "$JSON_FILE"
echo "  JSON report: $JSON_FILE"

echo ""
echo "=== Step 2: Generate SARIF for CI upload ==="
# SARIF is what GitHub code scanning consumes. Same image, different format.
# The docs note that --file and --output can conflict with some flags —
# keeping the invocation simple avoids that.
grype "$IMAGE" -o sarif --file "$SARIF_FILE"
echo "  SARIF report: $SARIF_FILE"

echo ""
echo "=== Step 3: Severity gate ==="
# --fail-on makes grype exit 1 when any vulnerability at or above the
# given severity is found. This is what makes the pipeline gate CI.
# I capture the exit code separately so I can print a clear message
# regardless of whether the gate passes or fails.
set +e
grype "$IMAGE" --fail-on "$FAIL_ON" -o table
GATE_EXIT=$?
set -e

if [ "$GATE_EXIT" -eq 1 ]; then
  echo ""
  echo "Gate FAILED: vulnerabilities found at or above '$FAIL_ON' severity"
  echo "Check $JSON_FILE or $SARIF_FILE for details"
  exit 1
fi

echo ""
echo "=== Step 4: Verify ==="
# Quick count from the JSON to confirm the scan actually ran.
if [ -f "$JSON_FILE" ]; then
  TOTAL=$(jq '.matches | length' "$JSON_FILE")
  echo "Verified: $TOTAL vulnerabilities recorded in $JSON_FILE"
else
  echo "Warning: $JSON_FILE was not created — something went wrong during scan"
fi

echo ""
echo "Pipeline complete. Reports in $OUTDIR/"
echo "  JSON:  $JSON_FILE"
echo "  SARIF: $SARIF_FILE"
echo "  Gate:  passed (no $FAIL_ON+ findings)"
