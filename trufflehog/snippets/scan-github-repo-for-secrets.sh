#!/bin/bash
# Scan a GitHub repository for leaked secrets using TruffleHog
# Usage: ./scan-github-repo-for-secrets.sh <repo-url> [github-token]

REPO="${1:-https://github.com/trufflesecurity/test_keys}"
TOKEN="${2:-}"

CMD="trufflehog git $REPO --results=verified,unverified,unknown --json"

if [ -n "$TOKEN" ]; then
  CMD="$CMD --token=$TOKEN"
fi

echo "Scanning $REPO for secrets..."
eval "$CMD" | jq '{
  detector: .DetectorName,
  verified: .Verified,
  file: .SourceMetadata.Data.Git.file,
  commit: .SourceMetadata.Data.Git.commit,
  line: .SourceMetadata.Data.Git.line
}' 2>/dev/null || eval "$CMD"
