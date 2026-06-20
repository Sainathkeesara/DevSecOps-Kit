# Trivy SBOM Scanning Reference Guide

## Purpose

Trivy can generate Software Bill of Materials (SBOM) artifacts for container images, filesystem directories, and remote repositories. SBOMs enumerate every dependency with its version, license, and known vulnerability status, providing a machine-readable inventory for compliance audits, software supply-chain security, and incident response.

This reference covers SBOM generation workflows, output format selection, and integration patterns for CI pipelines.

## Prerequisites

- Trivy v0.40+ (SBOM output introduced in earlier versions; CycloneDX support added in v0.37+)
- Docker installed for container-image scanning
- Internet access for vulnerability database updates (first run downloads ~200 MB)

## Supported Targets and Modes

Trivy supports three scan targets for SBOM generation:

| Target | Command | Use Case |
|--------|---------|----------|
| Container image | `trivy image` | Scan a built or pulled container image |
| Filesystem | `trivy fs` | Scan a local directory or project tree |
| Remote repository | `trivy repo` | Scan a remote Git repository |

### Container image scanning

SBOM generation on a container image captures every layer and package installed in the image:

```bash
trivy image --format spdx-json \
  --output sbom.spdx.json \
  alpine:latest
```

The image must be available locally. For images in a registry, pull first:

```bash
trivy image --format cyclonedx-json \
  --output sbom.cyclonedx.json \
  nginx:1.25
```

### Filesystem scanning

Filesystem mode scans a local directory tree for package manifests:

```bash
trivy fs --format spdx-json \
  --output project-sbom.spdx.json \
  /path/to/project
```

This detects dependencies from `package.json`, `Gemfile.lock`, `requirements.txt`, `go.mod`, and other manifest files.

### Remote repository scanning

Trivy can clone and scan a remote Git repository without local checkout:

```bash
trivy repo --format cyclonedx-json \
  --output repo-sbom.cyclonedx.json \
  https://github.com/example/project.git#main
```

## Output Format Selection

Trivy supports three SBOM formats via the `--format` flag:

| Format | Flag | Notable Use |
|--------|------|-------------|
| SPDX JSON | `spdx-json` | Linux Foundation standard; broad tooling support |
| CycloneDX JSON | `cyclonedx-json` | OASIS standard; preferred for vulnerability correlation |
| CycloneDX XML | `cyclonedx-xml` | Legacy integrations; some SCA tools require XML |

SPDX and CycloneDX overlap in most fields but differ in metadata structure. Choose based on the downstream consumer:
- **SPDX** for license compliance workflows and organizational SBOM archives
- **CycloneDX** for dependency-track, Anchore Grype, and vulnerability-focused tooling

### Generating multiple formats from a single scan

Trivy does not natively emit multiple formats per invocation, but Bash process substitution or a short loop can reconcile this:

```bash
trivy image --format spdx-json alpine:latest > sbom.spdx.json
trivy image --format cyclonedx-json alpine:latest > sbom.cyclonedx.json
```

Cache the vulnerability database between runs to avoid re-downloading:

```bash
TRIVY_CACHE_DIR=/tmp/.trivy-cache trivy image ...
```

## Severity Filtering and Policy Integration

SBOM generation includes all detected packages regardless of severity. To produce a curated SBOM containing only packages with known vulnerabilities:

```bash
trivy image --format spdx-json \
  --severity CRITICAL,HIGH,MEDIUM \
  --ignore-unfixed \
  --output sbom-filtered.spdx.json \
  alpine:latest
```

`--ignore-unfixed` omits packages with no available patch — useful for producing a risk-focused SBOM rather than a complete inventory.

Use `.trivyignore` to exclude specific packages from SBOM output without altering scan results:

```
CVE-2023-0001  # false positive, tracked internally
```

## CI Pipeline Integration

### GitHub Actions — SBOM artifact upload

```yaml
name: Generate SBOM
on:
  push:
    branches: [main]

jobs:
  sbom:
    runs-on: ubuntu-latest
    env:
      TRIVY_CACHE_DIR: /tmp/.trivy-cache
    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build -t app:${{ github.sha }} .

      - name: Cache Trivy DB
        uses: actions/cache@v4
        with:
          path: ${{ env.TRIVY_CACHE_DIR }}
          key: trivy-db-${{ runner.os }}

      - name: Generate SBOM (SPDX)
        run: |
          trivy image --format spdx-json \
            --output sbom.spdx.json \
            app:${{ github.sha }}

      - name: Upload SBOM
        uses: actions/upload-artifact@v4
        with:
          name: sbom
          path: sbom.spdx.json
```

### GitLab CI — multi-format SBOM stage

```yaml
sbom-generate:
  stage: security
  image: docker:latest
  services:
    - docker:dind
  variables:
    TRIVY_CACHE_DIR: /tmp/.trivy-cache
  script:
    - apk add --no-cache curl
    - curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
    - docker build -t app:$CI_COMMIT_SHA .
    - trivy image --format spdx-json --output sbom.spdx.json app:$CI_COMMIT_SHA
    - trivy image --format cyclonedx-json --output sbom.cyclonedx.json app:$CI_COMMIT_SHA
  artifacts:
    paths:
      - sbom.spdx.json
      - sbom.cyclonedx.json
    expire_in: 1 week
```

## Common Issues

| Issue | Cause | Resolution |
|-------|-------|------------|
| Trivy exits 1 on no vulnerabilities | `--exit-code` set without `--ignore-unfixed` | Remove `--exit-code` or add `--ignore-unfixed` |
| SBOM missing transitive dependencies | Scanning wrong target | Verify `trivy fs` or `trivy image` covers the scanned scope |
| CycloneDX output empty | Trivy version older than v0.37 | Upgrade Trivy — CycloneDX added in v0.37.0 |
| DB download slow on CI | Trivy cache not restored between runs | Ensure the cache action restores `TRIVY_CACHE_DIR` before Trivy runs |

## References

- Trivy SBOM documentation: https://aquasecurity.github.io/trivy/latest/docs/output/sbom/
- SPDX specification: https://spdx.github.io/spdx-spec/
- CycloneDX specification: https://cyclonedx.org/
