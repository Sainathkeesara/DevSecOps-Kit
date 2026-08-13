---
last_verified: 2026-08-13
tool_version: n/a
---

# Syft + Trivy K8s Workload Scan Scaffold

A project scaffold for scanning the container images a Kubernetes workload
actually runs. Syft generates a CycloneDX SBOM for each image; Trivy scans that
image for vulnerabilities and the generated SBOM. Wired into a GitHub Actions
workflow so every change to the image inventory triggers a scan.

## Purpose

Scanning every image in a cluster by hand does not scale, and scanning on
demand misses images nobody remembered to check. This scaffold centralises the
image list for a set of Kubernetes workloads in one file (`images.txt`),
generates an SBOM per image with Syft, and runs a Trivy vulnerability scan
with a severity gate in CI. The result: each workload image gets a repeatable
SBOM plus a vulnerability report on every push.

## When to use

- You deploy container images to Kubernetes and want a standing SBOM +
  vulnerability check for what actually runs.
- You want one place to declare "these are the images my workloads use" instead
  of scattering image refs across Deployment manifests.
- You need CI to block on critical/high findings without tuning per-image.

## Prerequisites

- Syft CLI installed and on `PATH`
- Trivy CLI installed and on `PATH`
- Docker available (only needed if the workflow runs the scans in CI)
- A Git repository with GitHub Actions enabled (for the CI path)

## Structure

```
syft-trivy-k8s-scan-scaffold/
├── README.md
├── Makefile
├── syft.yaml                   # Syft cataloger + output config
├── trivy.yaml                  # Trivy severity gate + scan config
├── .gitignore
├── images.txt                  # one image ref per line (workload inventory)
├── scripts/
│   └── scan-workload-images.sh # local entry point: SBOM then scan
└── .github/workflows/
    └── k8s-workload-scan.yml   # CI — same pipeline in GitHub Actions
```

## Steps

### 1. Copy the scaffold

```bash
cp -r syft-trivy-k8s-scan-scaffold /your/repo/security/workload-scan
```

### 2. Declare the workload images

Edit `images.txt`. One image reference per line; `#` starts a comment:

```text
nginx
redis
postgres
```

These are the images your Kubernetes workloads run. Add every image reference
your Deployments, StatefulSets, and DaemonSets use.

### 3. Generate SBOMs and scan locally

```bash
make scan
```

The script runs `syft scan <image> -o cyclonedx-json` for each entry to produce
`reports/<image>.cdx.json`, then runs `trivy image <image> --config trivy.yaml`
to produce `reports/<image>.trivy.json`. If any scan fails the configured
severity gate, the script exits non-zero — that is what CI uses to block.

### 4. Enable CI

Push the scaffold and enable GitHub Actions. The workflow at
`.github/workflows/k8s-workload-scan.yml` runs on every pull request and push to
the default branch. It runs the same generate-then-scan sequence inside
container jobs and uploads both the SBOMs and the Trivy reports as artifacts.

## Verify

- Run `make scan` on a clean checkout. Every image in `images.txt` should have
  two files under `reports/` — a `.cdx.json` SBOM and a `.trivy.json` report.
- Add an image with a known-vulnerable tag to `images.txt` and confirm the run
  exits non-zero once Trivy flags it above the severity gate.
- Remove the image again, push, and confirm the CI workflow produces SBOM and
  report artifacts in the run summary.

## Common errors

- **`syft: command not found` / `trivy: command not found`** — the CLIs are not
  on `PATH`. Install them and re-run `make scan`.
- **`error: images.txt not found`** — the script reads it relative to the
  project root; run from the scaffold directory or pass the path explicitly
  (`./scripts/scan-workload-images.sh /path/to/images.txt`).
- **CI job fails to reach the registry** — the workflow pulls each image before
  scanning; if an image is private, add registry authentication to the job
  before the generate step.