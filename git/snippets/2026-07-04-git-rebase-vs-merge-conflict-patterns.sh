#!/usr/bin/env bash
# last_verified: 2026-07-04 · git n/a

# Compare merge and rebase when both branches change the same file.
# Run inside an empty directory — this script creates its own repo.

rm -rf rebase-demo
git init rebase-demo
cd rebase-demo || exit

# Base commit on master
echo "initial content" > notes.txt
git add notes.txt
git commit -m "initial commit on master"

# Feature branch diverges
git checkout -b feature
echo "feature change" >> notes.txt
git add notes.txt
git commit -m "feature change on feature branch"

# Master diverges with a conflicting edit
git checkout master
echo "master change" >> notes.txt
git add notes.txt
git commit -m "master change on master branch"

echo "--- merge: git merge feature ---"
git merge feature
echo "Conflict in notes.txt. Resolve, then: git add notes.txt && git commit"

# Clean up the merge commit so the graph stays clean for the rebase demo
git checkout master
git reset --hard ORIG_HEAD

echo "--- rebase: git rebase master feature ---"
git rebase master feature
echo "Conflict in notes.txt again. Resolve, then: git add notes.txt && git rebase --continue"
