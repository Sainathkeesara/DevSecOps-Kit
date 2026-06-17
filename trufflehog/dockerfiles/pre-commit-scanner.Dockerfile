FROM python:3.12-alpine

# Installs TruffleHog and wraps it for use as a pre-commit scanning container.
# Designed to run against a bind-mounted repo: the entrypoint reads staged
# files from a Git worktree at /repo and blocks on secrets.

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache git && \
    pip install --no-cache-dir trufflehog==3.88.2

COPY --chmod=755 <<"SCRIPT" /usr/local/bin/scan-pre-commit.sh
#!/bin/sh
set -e
REPO_DIR="${1:-/repo}"
cd "$REPO_DIR"

STAGED=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
if [ -z "$STAGED" ]; then
    echo "No staged files to scan."
    exit 0
fi

# Run TruffleHog filesystem scan on staged files, fail if any secret is found
trufflehog filesystem $STAGED --no-verification --json 2>/dev/null | grep -q . && \
    { echo "Secret detected — commit blocked."; exit 1; }
echo "No secrets found."
SCRIPT

WORKDIR /repo
ENTRYPOINT ["/usr/local/bin/scan-pre-commit.sh"]
