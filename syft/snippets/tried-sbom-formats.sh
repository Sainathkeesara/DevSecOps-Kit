#!/usr/bin/env bash
# Generate SBOMs in SPDX and CycloneDX formats from a given image
# Usage: ./generate-sbom-spdx-cyclonedx.sh <image>

IMAGE="${1:-alpine:latest}"

syft "$IMAGE" -o spdx-json > "${IMAGE//\//_}_spdx.json"
syft "$IMAGE" -o cyclonedx-json > "${IMAGE//\//_}_cyclonedx.json"

echo "SBOMs written for $IMAGE"
