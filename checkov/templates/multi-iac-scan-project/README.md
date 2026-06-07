# Checkov Multi-IaC Scan Project

A project scaffold for scanning multiple Infrastructure-as-Code formats with
Checkov — Terraform, Kubernetes, CloudFormation, ARM, Docker, and Helm charts.
Intended as a starting point for teams that need consistent policy enforcement
across different IaC tooling in the same repository.

## Purpose

Run Checkov against a monorepo or multi-project workspace where IaC files live
in separate directories. The scaffold provides a shared config, a wrapper
script for local runs, and a CI pipeline so scans behave the same way
everywhere.

## Prerequisites

- Python 3.9+
- `checkov` installed (`pip install checkov` or via the official Docker image)
- Access to the IaC files you want to scan

## Steps

### 1. Clone or copy the scaffold

```bash
cp -r multi-iac-scan-project /your/repo/scaffolds/checkov-scan
```

### 2. Review the config

Edit `checkov-config.yaml` to set severity thresholds, skip checks, or add
custom policy directories. The included config enables scanning for Terraform,
Kubernetes, CloudFormation, and Dockerfile checks.

```yaml
# Key sections to review:
#   --compact        — reduces output noise
#   --framework      — lists which IaC frameworks to check
#   --skip-check     — checks you want to suppress repo-wide
```

### 3. Run the scan

```bash
chmod +x scan.sh
./scan.sh
```

The script scans all directories listed in `TARGET_DIRS` and exits non-zero if
any medium-or-higher severity finding is detected.

### 4. CI integration

Push the scaffold to your repo and enable GitHub Actions. The workflow at
`.github/workflows/checkov-scan.yml` runs on pull requests and pushes to main.

## Verify

- Run `./scan.sh` against a known-bad Terraform file (e.g. an S3 bucket with
  `acl = "public-read"`). The exit code should be 1 and the output should list
  the failed check.
- Re-run after fixing the issue; the exit code should be 0.
- Open a PR with a IaC policy violation and confirm the GitHub Action marks it
  as failed.

## File structure

```
multi-iac-scan-project/
├── README.md
├── Makefile
├── checkov-config.yaml
├── scan.sh
└── .github/
    └── workflows/
        └── checkov-scan.yml
```
