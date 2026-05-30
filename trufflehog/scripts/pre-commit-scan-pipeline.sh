#!/usr/bin/env bash
# Minimal pre-commit hook: scans staged files for secrets with TruffleHog
# Drop this into .git/hooks/pre-commit and make it executable

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
    exit 0
fi

# TruffleHog filesystem scan on staged files
trufflehog filesystem "$STAGED_FILES" --no-verification --json 2>/dev/null | while read -r result; do
    detector=$(echo "$result" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['DetectorName'])")
    file=$(echo "$result" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['SourceMetadata']['Data']['Filesystem']['file'])")
    echo "Secret detected: $detector in $file"
done

# check if trufflehog found anything
if trufflehog filesystem "$STAGED_FILES" --no-verification --json 2>/dev/null | grep -q .; then
    echo "✋ Commit blocked: secrets found in staged files."
    echo "   Use 'git rm --cached <file>' or remove the secret and re-stage."
    exit 1
fi

exit 0
