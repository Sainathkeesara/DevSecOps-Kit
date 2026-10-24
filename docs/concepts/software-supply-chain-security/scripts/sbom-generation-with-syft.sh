#!/usr/bin/env bash
# last_verified: 2026-10-24 · syft n/a
# Practice: generate an SBOM with syft and inspect the result.
set -euo pipefail

IMAGE="${1:-alpine:latest}"
OUT_DIR="${2:-./sbom-out}"
FORMAT="${3:-cyclonedx-json}"

mkdir -p "$OUT_DIR"

echo "Generating SBOM for $IMAGE ..."
syft "$IMAGE" -o "$FORMAT=$OUT_DIR/sbom.$FORMAT" || {
  echo "syft failed; is it installed and on PATH?" >&2
  exit 1
}

echo "SBOM written to $OUT_DIR/sbom.$FORMAT"
ls -lh "$OUT_DIR"
