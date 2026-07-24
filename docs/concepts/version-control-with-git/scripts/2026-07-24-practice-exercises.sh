#!/usr/bin/env bash
# last_verified: 2026-07-24 · Git n/a
#
# Practice: Version Control with Git exercises
# I wrote this script to practice branching, committing, and merging
# inside a throwaway repo so I can repeat the workflow without
# touching a real project.

SCRATCH=$(mktemp -d)
cd "$SCRATCH" || exit 1

# Initialize a repo with a fake identity for practice
git init
git config user.email "learner@example.com"
git config user.name "Learner"

# Add an initial policy file and commit it
cat > policy.conf <<'EOF'
alert_threshold: high
max_retries: 3
EOF

git add policy.conf
git commit -m "add initial security policy"

# Create a feature branch and bump the alert threshold
git checkout -b feature/tune-alerts
cat > policy.conf <<'EOF'
alert_threshold: critical
max_retries: 1
EOF
git add policy.conf
git commit -m "raise alert threshold in feature branch"

# Merge back and show what changed
git checkout -
git merge feature/tune-alerts
git diff HEAD~1 HEAD -- policy.conf

echo "Scratch repo: $SCRATCH"
