# last_verified: 2026-07-22 · Snyk n/a
# Purpose: Custom Snyk CLI container for air-gapped vulnerability scanning.
#          The Snyk binary is pre-bundled at build time so runtime requires
#          no outbound network access.
# Usage:
#   docker build -t custom-snyk:latest -f custom-snyk-cli-air-gapped.Dockerfile .
#   docker run --rm -v "$PWD":/workspace -w /workspace -e SNYK_TOKEN=<token> custom-snyk:latest snyk test

FROM node:20-slim AS base

LABEL org.opencontainers.image.title="Custom Snyk CLI"
LABEL org.opencontainers.image.description="Air-gapped Snyk vulnerability scanner with pre-installed CLI"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      openssh-client && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g snyk && \
    snyk --version

WORKDIR /workspace

ENTRYPOINT ["snyk"]
