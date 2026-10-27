#!/usr/bin/env bash
# last_verified: 2026-10-27 · syft n/a

# My first try at getting Syft to emit SBOMs in the three formats I keep seeing.
TARGET="${1:-alpine:latest}"

# SPDX
syft "$TARGET" -o spdx-json > sbom.spdx.json

# CycloneDX
syft "$TARGET" -o cyclonedx-json > sbom.cdx.json

# Syft's own JSON
syft "$TARGET" -o syft-json > sbom.syft.json

echo "wrote sbom.spdx.json, sbom.cdx.json, sbom.syft.json"
