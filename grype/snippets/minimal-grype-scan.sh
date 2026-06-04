#!/usr/bin/env bash

# Minimal Grype scan for local container images
# Usage: ./minimal-grype-scan.sh <image_name> [output_dir]

IMAGE="${1:-alpine:latest}"
OUTDIR="${2:-.}"

# Run vulnerability scan with severity filtering
grype "$IMAGE" --only-fixed --output json > "$OUTDIR/grype-results.json"

# Count findings by severity
CRITICAL=$(jq '.matches | map(select(.vulnerability.severity == "Critical")) | length' "$OUTDIR/grype-results.json" 2>/dev/null || echo "0")
echo "Critical vulnerabilities: $CRITICAL"

# Fail if critical issues found (CI gating)
if [ "$CRITICAL" -gt 0 ]; then
    echo "Critical vulnerabilities found - blocking"
    exit 1
fi