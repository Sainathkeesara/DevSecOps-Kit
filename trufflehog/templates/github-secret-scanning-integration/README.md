# TruffleHog GitHub Secret Scanning Integration

A GitHub Actions scaffold for running TruffleHog against a repository and turning findings into a PR comment plus a fail-fast CI gate.

## Purpose

This template gives a GitHub repository a repeatable secret-scanning workflow. It runs TruffleHog against Git history, writes JSON results to an Actions artifact, summarizes the first findings in a pull request comment, and fails the workflow when potential secrets are present.

## When to use

- You want TruffleHog to run on every pull request and push.
- You need a JSON artifact for later triage.
- You want PR comments that point reviewers to detector names, files, commits, and line numbers.
- You are starting with repository history scanning before adding org-wide GitHub API scans.

## Prerequisites

- GitHub Actions enabled in the target repository.
- TruffleHog CLI available in the workflow.
- Optional `TRUFFLEHOG_TOKEN` secret for authenticated GitHub repository scans.

## Structure

```text
github-secret-scanning-integration/
├── README.md
├── Makefile
├── .gitignore
├── .github/workflows/
│   └── github-secret-scan.yml
└── scripts/
    └── scan-github.sh
```

## Steps

### 1. Copy the scaffold

Copy this directory into the target repository root or into a shared `.github/actions` style path.

### 2. Run locally

```bash
make scan
```

The local command scans the current Git repository history and exits non-zero if TruffleHog returns findings.

### 3. Scan a remote GitHub repository

```bash
TRUFFLEHOG_TARGET_REPO=https://github.com/example-org/example-repo.git make scan-github
```

Set `TRUFFLEHOG_TOKEN` when the repository is private or when GitHub API rate limits are a concern.

### 4. Enable GitHub Actions

Push `.github/workflows/github-secret-scan.yml` with the scaffold. The workflow runs on pull requests, pushes, and a weekly schedule.

## Verify

- Run `make scan` in a clean repository; it should print `No TruffleHog findings.`
- Add a fake secret to a temporary branch, run the scan, and confirm the workflow uploads `trufflehog-results.json`.
- Open a pull request with the fake secret and confirm the workflow comments on the PR before failing.

## Common errors

- `trufflehog: command not found`: the workflow installs TruffleHog with `pip`; local runs need the CLI on `PATH`.
- Empty results with a non-zero scan status: inspect `trufflehog-scan.log` for TruffleHog usage errors.
- Too many PR comment lines: the workflow intentionally summarizes the first 10 findings and keeps the full JSON in the artifact.
