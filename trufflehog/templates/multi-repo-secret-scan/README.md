# TruffleHog Multi-Repository Configuration

A project scaffold for running TruffleHog secret scans across multiple repositories
with centralized allowlisting, custom detector rules, and CI integration.

## Purpose

Organizations managing dozens or hundreds of repositories need a centralized approach
to secret scanning. Running TruffleHog per-repo independently leads to inconsistent
configuration, duplicated allowlist entries, and difficulty tracking exceptions.

This scaffold provides:
- Centralized detector configuration (custom regex patterns, entropy tuning)
- Organization-wide allowlist management
- Multi-repository scanning script
- GitHub Actions workflow for scheduled organization scans

## Structure

```
multi-repo-secret-scan/
├── README.md
├── Makefile
├── repos.txt                  # Target repository URLs
├── .trufflehogignore           # Global exclusion patterns
├── .trufflehog/
│   ├── config.yaml            # Custom detectors and entropy settings
│   └── allowlist.yaml         # Centralized verified secret allowlist
├── .github/workflows/
│   └── org-secret-scan.yml    # Scheduled GitHub Actions workflow
└── scripts/
    ├── scan-multi-repo.sh     # Multi-repository scan runner
    └── generate-report.py     # Aggregate results and produce summary
```

## Prerequisites

- TruffleHog CLI v3.0+ (`pip install trufflehog` or `brew install trufflehog`)
- Git CLI with SSH keys or personal access token configured
- A GitHub repository (for CI integration)
- GitHub token with `repo` scope for organization scanning

## Steps

### 1. Configure target repositories

Edit `repos.txt` to list repositories to scan (one per line):

```
https://github.com/org/repo1
https://github.com/org/repo2
https://github.com/org/legacy-app
```

### 2. Configure custom detectors

Edit `.trufflehog/config.yaml` to add organization-specific secret patterns:

```yaml
custom_detectors:
  - name: "Internal API key"
    regex:
      pattern: "sk-internal-[0-9a-f]{32}"
    keywords:
      - "sk-internal"
```

### 3. Configure allowlist

Add verified false positives to `.trufflehog/allowlist.yaml`:

```yaml
allowlist:
  - detector: AWS
    path: "docs/examples/aws-config.example"
    line: 15
    commit: "abc123"
    reason: "Example credential in documentation"
```

### 4. Run a local scan

```bash
make scan
```

The script clones each repository, runs TruffleHog, and aggregates results.

## Verify

- Run `make scan` against a test organization — should produce a report with zero findings on clean repos
- Add a repository with known secrets — the report should list them with file and line numbers
- Check `.github/workflows/org-secret-scan.yml` runs on schedule (weekly) and produces artifacts
- Verify allowlisted secrets are excluded from results