# last_verified: 2026-10-20 · trufflehog n/a

FROM python:3.12-alpine

# TruffleHog pipeline scanner container.
# Designed for CI/CD pipelines: scans a bind-mounted repository or filesystem path
# and emits JSON for downstream processing or SARIF upload.

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache git && \
    pip install --no-cache-dir trufflehog

COPY --chmod=755 <<"SCRIPT" /usr/local/bin/scan-pipeline.sh
#!/bin/sh
set -e

SCAN_TARGET="${1:-/repo}"
SCAN_MODE="${2:-filesystem}"
OUTPUT_FORMAT="${3:-json}"

cd "$SCAN_TARGET"

case "$SCAN_MODE" in
    git)
        trufflehog git file://"$SCAN_TARGET" --no-verification --"$OUTPUT_FORMAT"
        ;;
    filesystem)
        trufflehog filesystem . --no-verification --"$OUTPUT_FORMAT"
        ;;
    github)
        if [ -z "$TRUFFLEHOG_TOKEN" ]; then
            echo "TRUFFLEHOG_TOKEN required for github mode" >&2
            exit 1
        fi
        trufflehog github --repo="$SCAN_TARGET" --token="$TRUFFLEHOG_TOKEN" --no-verification --"$OUTPUT_FORMAT"
        ;;
    *)
        echo "Unknown scan mode: $SCAN_MODE (git|filesystem|github)" >&2
        exit 1
        ;;
esac
SCRIPT

WORKDIR /repo
ENTRYPOINT ["/usr/local/bin/scan-pipeline.sh"]