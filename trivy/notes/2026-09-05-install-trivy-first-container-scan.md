---
last_verified: 2026-09-05
tool_version: n/a
sources: []
---

# Install Trivy and scan my first container image

I needed a quick way to check container images for known CVEs before pushing them to a registry. Trivy kept coming up as the go-to tool.

## Installation

I went with the standalone binary approach since I didn't want to pull a full Docker image just to scan:

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

Straightforward — downloaded the binary and dropped it in PATH.

## First scan

Pointed it at a local image I'd built:

```bash
trivy image myapp:latest
```

The first thing that happened was a database download. Took about 30 seconds the first time. Then it printed a table of vulnerabilities.

## What tripped me up

**Database caching.** The vuln database is ~30MB and gets cached after the first pull. If you scan again within a day, it's instant. But if you wait, it re-downloads. No obvious progress indicator during the download — just a pause.

**Image not found locally.** I tried scanning an image that only existed in a remote registry. Trivy couldn't find it. Had to `docker pull` it first, or use `trivy image registry.example.com/myapp:latest` to have Trivy pull it directly.

**Severity levels.** Default output shows everything including LOW and UNKNOWN. For a quick triage I needed `--severity HIGH,CRITICAL` to cut the noise.

**Exit codes.** Trivy exits non-zero when vulnerabilities match the severity filter. This broke my CI script until I added `|| true` or used `--exit-code 0` for informational runs.

## What I'd try next

Try `trivy fs .` to scan a local directory for IaC misconfigurations, and `trivy sbom` to generate an SBOM from an image.
