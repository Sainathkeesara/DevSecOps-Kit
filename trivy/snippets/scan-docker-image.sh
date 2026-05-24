#!/bin/sh
# Scan a Docker image with Trivy and print the vulnerability report
# Usage: ./scan-docker-image.sh <image-name>

IMAGE="${1:-alpine:latest}"
trivy image --severity CRITICAL,HIGH "$IMAGE" \
  --format table \
  --exit-code 1 \
  --ignore-unfixed
# TODO: add --skip-db-update for offline use
