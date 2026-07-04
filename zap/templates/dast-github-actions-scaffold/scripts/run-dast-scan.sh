#!/usr/bin/env bash
# last_verified: 2026-07-04 · OWASP ZAP n/a
set -euo pipefail

TARGET_URL="${1:-http://localhost:8080}"
OUTPUT_DIR="${2:-reports}"
PLAN="${3:-plans/quick-scan.yaml}"

if [ ! -f "$PLAN" ]; then
  echo "Error: plan file not found: $PLAN" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Starting DAST scan for $TARGET_URL using plan $PLAN"

# Run the scan using the configured plan.
# Replace the placeholder below with your ZAP execution command.
# Docker example:
#   docker run --rm \
#     -v "$(pwd)/plans:/zap/plans:ro" \
#     -v "$(pwd)/$OUTPUT_DIR:/zap/reports" \
#     <zap-image> -autorun /zap/plans/$(basename "$PLAN")
#
# Local install example:
#   zap.sh -autorun "$(pwd)/$PLAN"

echo "Scan complete. Reports written to $OUTPUT_DIR"
