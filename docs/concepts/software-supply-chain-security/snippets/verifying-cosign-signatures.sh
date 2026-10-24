#!/usr/bin/env bash
# last_verified: 2026-10-24 · cosign n/a
# Verify a cosign signature on an image or blob.
set -euo pipefail

TARGET="${1:?usage: $0 <image-or-blob> [key-or-cert]}"
KEY="${2:-}"

if [ -n "$KEY" ]; then
  cosign verify --key "$KEY" "$TARGET"
else
  cosign verify "$TARGET"
fi

echo "Signature verification completed for $TARGET"
