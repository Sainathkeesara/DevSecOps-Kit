#!/usr/bin/env bash
# last_verified: 2026-10-22 · grype n/a

# My first grype scan from scratch. One way to do it; the docs also mention
# scanning an SBOM instead of an image, which I have not tried yet.

set -u

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
    echo "usage: grype-scan-from-scratch.sh <image-or-archive>" >&2
    exit 2
fi

echo "scanning: $IMAGE"
if ! grype "$IMAGE"; then
    echo "grype scan failed" >&2
    exit 1
fi

echo "done"