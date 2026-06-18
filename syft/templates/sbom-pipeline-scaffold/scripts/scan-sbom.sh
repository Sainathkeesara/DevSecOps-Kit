#!/usr/bin/env bash
# scan-sbom.sh — Build image, generate SBOM, scan for vulnerabilities
#
# Usage:
#   ./scripts/scan-sbom.sh
#
# Reads syft.yaml and grype.yaml from the project root.
# Writes reports to reports/ with a timestamp.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="${PROJECT_DIR}/reports"

mkdir -p "$REPORT_DIR"

IMAGE_TAG="app:scan-${TIMESTAMP}"

echo "[build] Building Docker image: ${IMAGE_TAG}"
docker build -t "${IMAGE_TAG}" -f "${PROJECT_DIR}/Dockerfile" "${PROJECT_DIR}"

echo "[syft] Generating SBOM..."
syft scan "${IMAGE_TAG}" \
  --config "${PROJECT_DIR}/syft.yaml" \
  --output cyclonedx-json \
  > "${REPORT_DIR}/sbom.cdx.json"

echo "[grype] Scanning SBOM for vulnerabilities..."
grype "sbom:${REPORT_DIR}/sbom.cdx.json" \
  --config "${PROJECT_DIR}/grype.yaml" \
  --output json \
  > "${REPORT_DIR}/grype-results.json" || true

echo ""
echo "=== Vulnerability Summary ==="
if command -v jq &>/dev/null && [[ -f "${REPORT_DIR}/grype-results.json" ]]; then
  python3 -c "
import json
with open('${REPORT_DIR}/grype-results.json') as f:
    data = json.load(f)
matches = data.get('matches', [])
if not matches:
    print('No vulnerabilities found.')
    exit(0)
sev_count = {}
for m in matches:
    sev = m.get('vulnerability', {}).get('severity', 'unknown')
    sev_count[sev] = sev_count.get(sev, 0) + 1
for s in ['critical', 'high', 'medium', 'low', 'unknown']:
    if s in sev_count:
        print(f'  {s}: {sev_count[s]}')
print(f'  Total: {len(matches)}')
print(f'  Report: ${REPORT_DIR}/grype-results.json')
"
fi

echo ""
echo "[done] Reports written to ${REPORT_DIR}/"
echo "  SBOM:     ${REPORT_DIR}/sbom.cdx.json"
echo "  Grype:    ${REPORT_DIR}/grype-results.json"
