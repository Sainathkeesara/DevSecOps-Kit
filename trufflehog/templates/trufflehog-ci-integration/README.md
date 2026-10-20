# TruffleHog CI Integration Scaffold

A production-ready project scaffold for integrating TruffleHog secret scanning into CI/CD pipelines with GitHub Actions and GitLab CI support.

## Purpose

This template provides a complete, runnable CI integration for TruffleHog that teams can copy into any repository. It includes workflow files for both GitHub Actions and GitLab CI, a shared configuration layer, and scan scripts that work locally and in CI without modification.

## When to use

- You need TruffleHog to run on every pull request and push to protected branches
- You want a single configuration file that works locally and in multiple CI systems
- You need SARIF output for GitHub code scanning and JUnit output for GitLab
- You want centralized allowlist management across repositories
- You are standardizing secret scanning across an organization

## Prerequisites

- TruffleHog CLI v3.0+ (`pip install trufflehog` or `brew install trufflehog`)
- Git CLI
- A GitHub or GitLab repository with Actions/CI enabled
- For GitHub: repository with code scanning enabled (for SARIF upload)
- For GitLab: runner with Docker executor or shell executor with TruffleHog installed

## Structure

```text
trufflehog-ci-integration/
├── README.md
├── Makefile
├── .gitignore
├── trufflehog-config.yaml           # Shared scan configuration
├── .trufflehog/
│   ├── config.yaml                  # Custom detectors and entropy settings
│   └── allowlist.yaml               # Verified false-positive allowlist
├── .github/workflows/
│   └── trufflehog-scan.yml          # GitHub Actions — PR, push, schedule
├── .gitlab/
│   └── ci/
│       └── trufflehog-scan.yml      # GitLab CI — merge request, pipeline, schedule
└── scripts/
    ├── scan.sh                      # Local and CI scan entry point
    └── scan-ci.sh                   # CI-specific wrapper with artifact upload
```

## Configuration

### trufflehog-config.yaml

The root configuration file controls scan targets, output formats, and detector selection. Edit this file to match your repository layout.

```yaml
# Scan targets — paths or git references to scan
fs_paths:
  - "."
  - "!vendor/**"
  - "!.git/**"

# Git scanning options
git:
  since_commit: "HEAD~50"
  branch: "main"

# Output formats — sarif for GitHub, json for local, junit for GitLab
output_format: "json"

# Detector configuration
detectors:
  enable_all: true
  exclude:
    - "generic-api-key"  # Too noisy for our codebase
  custom_detectors_dir: ".trufflehog"

# Verification — verify secrets against live APIs (slower, fewer false positives)
verification:
  enabled: false  # Set true in CI for production scans
  concurrency: 5

# Allowlist — paths to allowlist files
allowlist:
  - ".trufflehog/allowlist.yaml"
```

### .trufflehog/config.yaml

Custom detectors and entropy tuning live here. This directory is referenced by `custom_detectors_dir` in the root config.

```yaml
custom_detectors:
  - name: "Internal API Key"
    regex:
      pattern: "sk-internal-[0-9a-f]{32}"
    keywords:
      - "sk-internal"

  - name: "Company Database Password"
    regex:
      pattern: "db-[a-z]+-[0-9a-f]{16}"
    keywords:
      - "db-"
```

### .trufflehog/allowlist.yaml

Verified false positives that should not fail the scan. Each entry must include detector, path, line, commit, and reason.

```yaml
allowlist:
  - detector: "AWS"
    path: "docs/examples/aws-config.example"
    line: 15
    commit: "abc123def456"
    reason: "Example credential in documentation"
```

## Steps

### 1. Copy the scaffold

Copy this directory into your repository root:

```bash
cp -r trufflehog-ci-integration /your/repo/.github/trufflehog
```

Or copy individual files to your preferred locations.

### 2. Configure targets

Edit `trufflehog-config.yaml` to set the filesystem paths, git references, and exclusion rules that match your project.

### 3. Run a local scan

```bash
make scan
```

The script scans all configured targets and exits non-zero if any unverified secrets are found.

### 4. Enable GitHub Actions

Copy `.github/workflows/trufflehog-scan.yml` to your repository's `.github/workflows/` directory. The workflow runs on:
- Pull requests (uploads SARIF to code scanning)
- Pushes to default branch (uploads SARIF)
- Weekly schedule (full history scan)

### 5. Enable GitLab CI

Copy `.gitlab/ci/trufflehog-scan.yml` to your repository's `.gitlab/ci/` directory or include it in your `.gitlab-ci.yml`. The pipeline runs on:
- Merge requests (reports findings in MR widget)
- Pipeline runs on default branch
- Weekly schedule (full history scan)

## Verify

- Run `make scan` in a clean repository — should exit 0 with no findings
- Add a test secret (`AKIAIOSFODNN7EXAMPLE`) to a file and re-run — should exit 1
- Remove the test secret and confirm clean exit
- Open a PR with a test secret on GitHub — workflow should upload SARIF and block merge
- Run pipeline on GitLab — MR widget should show findings

## Common errors

- `trufflehog: command not found` — the workflows install TruffleHog via pip; local runs need the CLI on PATH
- SARIF upload fails — ensure code scanning is enabled in repository settings (GitHub) or that the runner has network access to the GitLab API
- Allowlist not working — check that commit hash in allowlist matches the commit where the secret appears (use `git log --oneline -1 <file>`)
- Too many findings in PR comment — the GitHub workflow limits to first 20 findings; full results in artifact
- GitLab JUnit report not appearing — ensure `reports:junit` path matches the output file in the script

## References

- TruffleHog CLI reference: `trufflehog --help`
- GitHub code scanning SARIF format: https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/uploading-a-sarif-file-to-github
- GitLab SAST integration: https://docs.gitlab.com/ee/user/application_security/sast/
- TruffleHog configuration: https://github.com/trufflesecurity/trufflehog/blob/main/docs/content/docs/getting-started/configuration.md
- Kit secret scanning patterns: `trufflehog/templates/secret-scanning-pipeline/`, `trufflehog/templates/github-secret-scanning-integration/`, `trufflehog/templates/multi-repo-secret-scan/`