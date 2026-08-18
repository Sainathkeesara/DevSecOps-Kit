---
last_verified: 2026-08-18
tool_version: n/a
---

# Dependabot security update workflow — auto-merge strategy for patch versions

## Purpose

This guide describes how to set up an auto-merge workflow for Dependabot security updates that limits automatic merging to patch-version changes. The intent is to reduce the window of exposure for known vulnerabilities while reserving manual review for minor and major version bumps that carry higher risk.

## When to use

Use this workflow when you maintain repositories with frequent patch releases and want to keep dependency exposure low without requiring manual review for every low-risk update. It is well-suited to projects where the CI pipeline can validate a patch bump quickly and where branch protection rules are configured to allow automated merges after checks pass.

## Prerequisites

- Dependabot security updates enabled in the repository
- A CI workflow that runs on pull requests and validates dependency changes
- Branch protection rules that permit merging based on status checks rather than requiring manual approval for every PR

## Steps

1. **Restrict auto-merge candidates to patch versions.** Configure a version filter so that only patch bumps are evaluated for automatic merging. Minor and major version changes remain open for manual review.

2. **Create a lightweight validation workflow for Dependabot PRs.** The workflow should run the project's test suite and any dependency-specific checks. Keeping validation fast ensures the merge window stays short.

3. **Implement the auto-merge action.** After validation passes, the action checks that the pull request is still a patch-only change. If the version range has shifted to a minor or major bump, the PR is left open for manual review.

4. **Verify the end-to-end flow.** Trigger or wait for a security update. Confirm that the PR opens, validation runs, and the PR merges automatically.

## Verify

After configuration, confirm:
- A Dependabot security update PR opens for a vulnerable dependency
- The CI validation passes
- The pull request merges automatically
- The dependency manifest reflects the patched version
