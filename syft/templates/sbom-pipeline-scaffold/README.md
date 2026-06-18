# SBOM Pipeline Scaffold — Syft + Grype CI Integration

A project scaffold for generating SBOMs with Syft and scanning them for
vulnerabilities with Grype in CI. Designed as a starting point — adjust the
catalogers, severity thresholds, and output formats to match your team's
supply-chain security requirements.

## Purpose

Teams that build container images need a repeatable way to produce SBOMs and
check them for known vulnerabilities before deployment. Running Syft and Grype
ad-hoc works for one-off images, but without a CI gate vulnerabilities slip
through. This scaffold wires both tools into a GitHub Actions workflow so every
image push produces an SBOM AND a vulnerability report.

## Structure

```
sbom-pipeline-scaffold/
├── README.md
├── Makefile
├── syft.yaml                   # Syft cataloger and output config
├── grype.yaml                  # Grype severity thresholds and matching
├── .gitignore
├── .github/workflows/
│   └── sbom-scan.yml           # GitHub Actions — build, SBOM, scan
└── scripts/
    └── scan-sbom.sh            # Local scan: generate SBOM then check vulns
```

## Prerequisites

- Docker (for building the target image)
- Syft CLI v0.90+ — install via `curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin`
- Grype CLI v0.70+ — install via `curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin`
- A GitHub repository (for CI integration)

## Steps

### 1. Copy the scaffold

```bash
cp -r sbom-pipeline-scaffold /your/repo/security/sbom-pipeline
```

### 2. Configure Syft

Edit `syft.yaml` to enable or disable catalogers based on your project's
language ecosystem. By default only common ecosystems are enabled to keep scan
times reasonable.

### 3. Configure Grype

Edit `grype.yaml` to set the vulnerability severity threshold. The default
fails on `high` and `critical` — adjust to `medium` if your team has a
stricter policy.

### 4. Run a local scan

```bash
make scan
```

This builds a Docker image from the project root, generates an SBOM with Syft,
and runs Grype against the SBOM. Both report files land in `reports/`.

### 5. Enable CI

Push the scaffold to your repo and enable GitHub Actions. The workflow at
`.github/workflows/sbom-scan.yml` runs on every pull request and push to the
default branch, producing an SBOM artifact and a Grype SARIF report for GitHub
code scanning.

## Verify

- Run `make scan` locally on a clean image — Grype should report vulnerabilities
  (almost every base image has some), but the Makefile target only warns by
  default, it does not fail.
- Introduce a deliberately vulnerable dependency (e.g. an old `lodash` version
  in a `package.json`) and verify Grype flags it in the report.
- Push a PR that introduces a known-vulnerable dependency and confirm the CI
  workflow catches it.
