#!/usr/bin/env bash
# last_verified: 2026-07-16 · git · ansible

# rollback.sh — restore previous state and redeploy
# Usage: ./scripts/pipeline/rollback.sh <environment>

ENV="${1:-production}"
echo "[*] Rolling back $ENV"
git revert --no-commit HEAD
git commit -m "rollback: revert last deploy"
git push
