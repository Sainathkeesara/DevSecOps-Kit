#!/usr/bin/env bash
# last_verified: 2026-09-22 · git n/a

# A small Git automation script that wraps common workflow steps.
# This is one way to do it; the docs also suggest using git aliases or
# a dedicated tool like git-flow for more complex workflows.
#
# Usage: ./git-automation.sh <branch-name> <commit-type> <commit-message>
# Example: ./git-automation.sh add-login feat "add user login endpoint"

branch_name="${1:-}"
commit_type="${2:-}"
commit_message="${3:-}"

if [[ -z "$branch_name" || -z "$commit_type" || -z "$commit_message" ]]; then
    echo "Usage: $0 <branch-name> <commit-type> <commit-message>"
    echo "Commit types: feat, fix, docs, refactor, test, chore"
    exit 1
fi

# Validate commit type
valid_types="feat|fix|docs|refactor|test|chore"
if [[ ! "$commit_type" =~ ^($valid_types)$ ]]; then
    echo "Invalid commit type: $commit_type"
    echo "Valid types: feat, fix, docs, refactor, test, chore"
    exit 1
fi

# Ensure we're in a git repo
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not a git repository"
    exit 1
fi

# Fetch latest main
echo "==> Fetching latest main"
git fetch origin main --quiet

# Create and switch to feature branch
echo "==> Creating branch: $branch_name"
git checkout -b "$branch_name" origin/main

# Stage all changes
echo "==> Staging changes"
git add -A

# Commit with conventional message
full_message="${commit_type}: ${commit_message}"
echo "==> Committing: $full_message"
git commit -m "$full_message"

# Push branch
echo "==> Pushing branch to origin"
git push -u origin "$branch_name"

# Open PR if gh is available
if command -v gh >/dev/null 2>&1; then
    echo "==> Creating pull request"
    gh pr create --title "$full_message" --body "Automated PR from git-automation.sh" --base main --head "$branch_name"
else
    echo "gh CLI not found — pushed branch but did not create PR"
    echo "Run: gh pr create --title \"$full_message\" --base main --head \"$branch_name\""
fi

# Verify: check that the branch exists on remote
git ls-remote --exit-code --heads origin "$branch_name" >/dev/null && echo "==> Verified: branch exists on remote" || echo "==> Warning: branch not found on remote"

echo "==> Done"