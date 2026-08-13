#!/usr/bin/env bash
# last_verified: 2026-08-13 · syft n/a · trivy n/a
# Generate a Syft SBOM and run a Trivy scan for every image in images.txt.
#
# Usage:
#   ./scripts/scan-workload-images.sh [images-file]
#
# Writes reports to reports/ with one SBOM and one Trivy report per image.
# Exits non-zero if any image fails the Trivy severity gate.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
IMAGES_FILE="${1:-${PROJECT_DIR}/images.txt}"
REPORT_DIR="${PROJECT_DIR}/reports"

mkdir -p "$REPORT_DIR"

if [[ ! -f "$IMAGES_FILE" ]]; then
  echo "error: images file not found: $IMAGES_FILE" >&2
  exit 1
fi

GATE_FAILED=0

while IFS= read -r line; do
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  IMAGE="$line"
  SAFE_NAME=$(echo "$IMAGE" | tr '/:@' '---')

  echo "[syft] Generating SBOM for ${IMAGE}"
  syft scan "$IMAGE" -o cyclonedx-json > "${REPORT_DIR}/${SAFE_NAME}.cdx.json"

  echo "[trivy] Scanning ${IMAGE}"
  if ! trivy image "$IMAGE" --config "${PROJECT_DIR}/trivy.yaml" > "${REPORT_DIR}/${SAFE_NAME}.trivy.txt"; then
    echo "  -> ${IMAGE} failed the severity gate (see ${SAFE_NAME}.trivy.txt)"
    GATE_FAILED=1
  fi
done < "$IMAGES_FILE"

echo ""
echo "Reports written to ${REPORT_DIR}/"
if [[ $GATE_FAILED -ne 0 ]]; then
  echo "One or more images failed the Trivy severity gate."
  exit 1
fi
echo "All images passed the severity gate."