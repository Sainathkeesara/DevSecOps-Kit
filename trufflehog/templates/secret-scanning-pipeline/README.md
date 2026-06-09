# TruffleHog Secret Scanning Pipeline

A project scaffold for running TruffleHog secret scans across git repositories
and filesystem paths, with CI integration for GitHub Actions.

## Purpose

Teams that manage multiple repositories or monorepos need a consistent way to
catch leaked secrets before they reach production. Running `trufflehog git`
ad-hoc across repos is error-prone and misses the CI gate. This scaffold
centralises scan targets, configuration, and CI integration so every scan
uses the same rules.

## Structure

```
secret-scanning-pipeline/
├── README.md
├── Makefile
├── trufflehog-config.yaml        # Shared config: detectors, entropy, exclusions
├── .gitignore
├── .github/workflows/
│   └── secret-scan.yml           # GitHub Actions — runs on PR and push
└── scripts/
    └── scan-all.sh               # Multi-target scan entry point
```

## Prerequisites

- TruffleHog CLI v3.0+ (install via `pip install trufflehog` or `brew install trufflehog`)
- Git CLI
- A GitHub repository (for CI integration)

## Steps

### 1. Copy the scaffold

```bash
cp -r secret-scanning-pipeline /your/repo/scaffolds/trufflehog-scan
```

### 2. Configure targets

Edit `trufflehog-config.yaml` to set the repositories, filesystem paths, and
exclusion rules that match your project layout.

### 3. Run a local scan

```bash
make scan
```

The script scans all configured targets and exits non-zero if any secrets are
found.

### 4. Enable CI

Push the scaffold to your repo and enable GitHub Actions. The workflow at
`.github/workflows/secret-scan.yml` runs on pull requests and pushes to the
default branch, uploading SARIF results for GitHub code scanning.

## Verify

- Run `make scan` — the script should report zero findings in a clean project.
- Add a file containing a test secret (e.g. `AKIAIOSFODNN7EXAMPLE`) and re-run.
  The exit code should be 1 and the output should list the detected secret.
- Remove the test secret and confirm a clean exit.
- Open a PR that introduces a test secret and check that the GitHub Action
  blocks the merge.
