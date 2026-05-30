#!/usr/bin/env bash
# Generate SBOMs in every format Syft supports for a container image
# Usage: ./gen-multi-format-sboms.sh [image]

IMAGE="${1:-alpine:latest}"
# Replacing slashes and colons so the filename doesn't break on disk
SAFE=$(echo "$IMAGE" | tr '/:' '__')
OUTDIR="./sboms"

mkdir -p "$OUTDIR"

# syft-json — Syft's own format, has the most metadata (includes relationships)
syft "$IMAGE" -o syft-json > "$OUTDIR/${SAFE}_syft.json"
echo "  syft-json    -> $OUTDIR/${SAFE}_syft.json"

# cyclonedx-json — CycloneDX standard, what most tools expect these days
syft "$IMAGE" -o cyclonedx-json > "$OUTDIR/${SAFE}_cyclonedx.json"
echo "  cyclonedx-json -> $OUTDIR/${SAFE}_cyclonedx.json"

# cyclonedx-xml — same schema, XML edition
syft "$IMAGE" -o cyclonedx-xml > "$OUTDIR/${SAFE}_cyclonedx.xml"
echo "  cyclonedx-xml  -> $OUTDIR/${SAFE}_cyclonedx.xml"

# spdx-json — SPDX standard, popular in open-source compliance workflows
syft "$IMAGE" -o spdx-json > "$OUTDIR/${SAFE}_spdx.json"
echo "  spdx-json     -> $OUTDIR/${SAFE}_spdx.json"

# spdx-tag-value — tag-value format from SPDX spec, more human-readable than JSON
syft "$IMAGE" -o spdx-tag-value > "$OUTDIR/${SAFE}_spdx.spdx"
echo "  spdx-tag-value -> $OUTDIR/${SAFE}_spdx.spdx"

# github-json — GitHub dependency graph format, can upload to GH Dependabot
syft "$IMAGE" -o github-json > "$OUTDIR/${SAFE}_github.json"
echo "  github-json   -> $OUTDIR/${SAFE}_github.json"

# table — terminal-friendly summary, useful for a quick look
syft "$IMAGE" -o table > "$OUTDIR/${SAFE}_table.txt"
echo "  table         -> $OUTDIR/${SAFE}_table.txt"

echo ""
echo "Done — 7 SBOM files for $IMAGE in $OUTDIR/"
