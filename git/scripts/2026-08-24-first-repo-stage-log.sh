#!/usr/bin/env bash
# last_verified: 2026-08-24 · git n/a

# Create a fresh repo, stage a file, and run git log — my first Git workflow.
# I kept reading about Git but never actually ran the commands, so here's the
# smallest thing that works.

repo_dir="${1:-my-first-repo}"
rm -rf "$repo_dir"
git init -q "$repo_dir"
cd "$repo_dir" || exit 1

git config user.email "learner@example.com"
git config user.name "Learner"

echo "Hello, Git!" > hello.txt
git add hello.txt
git commit -q -m "first commit"

echo "=== git log output ==="
git log --oneline
