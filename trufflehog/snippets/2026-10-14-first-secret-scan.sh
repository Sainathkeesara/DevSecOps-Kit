#!/bin/bash
# last_verified: 2026-10-14 · trufflehog n/a
# My first trufflehog scan — checking my local checkout for leaked secrets.
# I am scanning the current directory because the docs example used a
# remote repo and that failed for me (no token handy), so local felt simpler.

TARGET="${1:-.}"

echo "Scanning $TARGET for secrets..."
trufflehog filesystem "$TARGET" --json | jq '{detector: .DetectorName, verified: .Verified, file: .SourceMetadata.Data.Filesystem.file}'
# TODO: the jq filter guesses the JSON shape from one test run — not sure it holds for git scans yet
