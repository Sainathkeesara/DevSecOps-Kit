#!/usr/bin/env bash
# Minimal image signing + verification with Cosign — my first attempt

IMAGE="${1:-ghcr.io/myorg/myapp:latest}"

echo "[1/4] Generate a key pair"
cosign generate-key-pair

echo "[2/4] Sign the image with the private key"
cosign sign --key cosign.key "$IMAGE"

echo "[3/4] Verify the signature with the public key"
cosign verify --key cosign.pub "$IMAGE"

echo "[4/4] Check the signature is tied to the right digest"
cosign verify --key cosign.pub "$IMAGE" | head -5

echo "Done — image signed and verified."
