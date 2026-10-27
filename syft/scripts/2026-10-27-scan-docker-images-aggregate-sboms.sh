#!/usr/bin/env bash
# last_verified: 2026-10-27 · syft n/a

# I wanted one script that walks a folder of saved image tars and makes an SBOM per image.
IMAGES_DIR="${1:-./images}"
OUT_DIR="${2:-./sboms}"
mkdir -p "$OUT_DIR"

for tar in "$IMAGES_DIR"/*.tar; do
  [ -e "$tar" ] || continue
  name=$(basename "$tar" .tar)
  echo "scanning $name"
  syft "docker-archive:$tar" -o cyclonedx-json > "$OUT_DIR/$name.cdx.json"
done

echo "done — SBOMs in $OUT_DIR"
