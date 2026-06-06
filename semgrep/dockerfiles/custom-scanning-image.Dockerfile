# Purpose: Custom Semgrep scanning image with pre-loaded community rules and a CI entrypoint script.
#          Designed for use in GitHub Actions, Jenkins, or any CI runner that pulls a Docker image.
# Steps:
#   1. Build: docker build -t semgrep-scanning .
#   2. Run:   docker run --rm -v $(pwd):/src semgrep-scanning --config=auto --output=semgrep-results.sarif
#   3. Verify: docker run --rm semgrep-scanning semgrep --version
# When to use: Offline or air-gapped CI runners where rules should not be fetched at scan time.
#              Also useful when you want deterministic rule versions across teams.

FROM python:3.12-slim

RUN pip install --no-cache-dir semgrep==1.106.0

# Pre-download community rule registry so scans work offline
RUN semgrep --config=auto /tmp/init-scan 2>/dev/null || true

# Copy the CI entrypoint
COPY ci-entrypoint.sh /usr/local/bin/ci-entrypoint
RUN chmod +x /usr/local/bin/ci-entrypoint

RUN addgroup --system semgrep && adduser --system --ingroup semgrep semgrep

WORKDIR /src
USER semgrep

ENTRYPOINT ["ci-entrypoint"]
