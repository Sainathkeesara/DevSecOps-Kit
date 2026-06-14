#!/usr/bin/env bash
IMAGE="${1:-alpine:latest}"
export COSIGN_PASSWORD="${COSIGN_PASSWORD:-password}"
cosign generate-key-pair
cosign sign --key cosign.key --yes "$IMAGE"
cosign verify --key cosign.pub "$IMAGE"
