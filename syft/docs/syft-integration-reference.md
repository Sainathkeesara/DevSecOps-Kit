---
last_verified: 2026-10-10
tool_version: "1.6.0"
---

# Syft integration reference for SBOM generation

## Purpose

This reference documents the integration patterns for embedding Syft SBOM generation into CI/CD pipelines, supply-chain tooling, and automated workflows. It covers platform-specific configurations, authentication strategies, output format selection for downstream consumers, artifact storage, and attestation workflows.

## When to use

- Building SBOM generation into CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins, Azure Pipelines)
- Generating SBOMs for multi-language repositories and container images
- Integrating Syft output with vulnerability scanners (Grype, Trivy), policy engines, or compliance tools
- Attesting SBOMs with cosign for supply-chain integrity
- Scanning Kubernetes workload images at scale
- Operating in environments with private registries requiring authentication

## Prerequisites

- Syft CLI v1.6.0+ installed and available on `PATH` (or via container image `anchore/syft:latest`)
- Access to target artifacts: source repositories, container images, or filesystem directories
- For registry-backed images: credentials with pull access to the target registry
- For CI integration: a pipeline execution environment with network access to registries and artifact storage
- For attestation: cosign CLI v2.2.0+ and keyless signing setup (OIDC) or key pair

## Steps

### 1. CI/CD platform integration patterns

#### GitHub Actions

Use the official `anchore/syft-action` for the simplest integration. The action installs Syft, handles caching, and supports multiple output formats.

```yaml
name: SBOM Generation
on:
  push:
    branches: [main]
    tags: ['v*']
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  packages: write
  id-token: write
  security-events: write

jobs:
  sbom:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Cache Syft metadata
        uses: actions/cache@v4
        with:
          path: ~/.cache/syft
          key: syft-${{ runner.os }}-${{ hashFiles('**/Dockerfile', '**/docker-compose*.yml') }}
          restore-keys: syft-${{ runner.os }}-

      - name: Generate SBOM (container image)
        uses: anchore/syft-action@v1
        with:
          image: ghcr.io/${{ github.repository }}:${{ github.sha }}
          output: cyclonedx-json=sbom.cdx.json

      - name: Generate SBOM (repository source)
        uses: anchore/syft-action@v1
        with:
          image: dir:.
          output: spdx-json=sbom.spdx.json

      - name: Upload SBOM artifacts
        uses: actions/upload-artifact@v4
        with:
          name: sbom-artifacts
          path: sbom.*.json
          retention-days: 90

      - name: Upload SARIF to code scanning
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: sbom.cdx.json
          category: sbom
```

Key action inputs:
- `image` — target (image reference, `dir:path`, `docker:tarball`, `registry:ref`)
- `output` — format and file mapping, e.g., `cyclonedx-json=sbom.cdx.json spdx-json=sbom.spdx.json`
- `config` — path to `.syft.yaml` for cataloger/output customization
- `version` — Syft version to install (default: latest)

#### GitLab CI

```yaml
stages:
  - sbom

variables:
  SYFT_CACHE_DIR: "$CI_PROJECT_DIR/.cache/syft"

sbom:generate:
  stage: sbom
  image: anchore/syft:latest
  cache:
    key: syft-${CI_COMMIT_REF_SLUG}
    paths:
      - .cache/syft/
  script:
    - syft dir:. -o spdx-json=sbom.spdx.json cyclonedx-json=sbom.cdx.json
    - syft docker:${CI_REGISTRY_IMAGE}:${CI_COMMIT_SHA} -o cyclonedx-json=sbom-container.cdx.json
  artifacts:
    reports:
      sast: sbom.cdx.json
    paths:
      - sbom.*.json
    expire_in: 90d
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_COMMIT_TAG
```

#### Jenkins (Declarative Pipeline)

```groovy
pipeline {
  agent { docker { image 'anchore/syft:latest' } }
  options {
    timeout(time: 30, unit: 'MINUTES')
  }
  environment {
    SYFT_CACHE_DIR = "${WORKSPACE}/.cache/syft"
  }
  stages {
    stage('SBOM: Repository') {
      steps {
        sh 'syft dir:. -o spdx-json=sbom.spdx.json cyclonedx-json=sbom.cdx.json'
      }
    }
    stage('SBOM: Container Image') {
      steps {
        sh '''
          docker pull ${REGISTRY}/${APP}:${BUILD_NUMBER}
          syft docker:${REGISTRY}/${APP}:${BUILD_NUMBER} -o cyclonedx-json=sbom-container.cdx.json
        '''
      }
    }
    stage('Archive Artifacts') {
      steps {
        archiveArtifacts artifacts: 'sbom.*.json', fingerprint: true
      }
    }
  }
}
```

#### Azure Pipelines

```yaml
trigger:
  - main
  - tags/v*

pool:
  vmImage: 'ubuntu-latest'

variables:
  SYFT_CACHE_DIR: $(Pipeline.Workspace)/.cache/syft

steps:
  - task: Cache@2
    inputs:
      key: 'syft | $(Agent.OS) | **/Dockerfile'
      path: $(SYFT_CACHE_DIR)

  - script: |
      # Install Syft from official release
      curl -sSfL <SYFT_RELEASE_URL> | tar -xz -C $(Agent.ToolsDirectory)/syft
      echo "$(Agent.ToolsDirectory)/syft" >> $GITHUB_PATH
    displayName: 'Install Syft'

  - script: |
      syft dir:. -o spdx-json=sbom.spdx.json cyclonedx-json=sbom.cdx.json
    displayName: 'Generate SBOM (source)'

  - script: |
      docker pull $(CONTAINER_REGISTRY)/$(APP):$(Build.BuildNumber)
      syft docker:$(CONTAINER_REGISTRY)/$(APP):$(Build.BuildNumber) -o cyclonedx-json=sbom-container.cdx.json
    displayName: 'Generate SBOM (container)'

  - publish: $(Build.SourcesDirectory)/sbom.*.json
    artifact: sbom-artifacts
```

### 2. Multi-language repository SBOM generation

Syft detects package managers from manifest files. For repositories with multiple ecosystems, generate per-ecosystem SBOMs and a combined SBOM.

```bash
# Generate per-ecosystem SBOMs
syft dir:. --scope packages -o cyclonedx-json=sbom.cdx.json

# Generate per-language SBOMs using cataloger selection
syft dir:. --cataloger python -o cyclonedx-json=sbom-python.cdx.json
syft dir:. --cataloger npm -o cyclonedx-json=sbom-npm.cdx.json
syft dir:. --cataloger go -o cyclonedx-json=sbom-go.cdx.json
```

Use a configuration file (`.syft.yaml`) to control catalogers globally:

```yaml
# .syft.yaml
catalogers:
  disabled:
    - gem
    - python
    - npm
    - go-mod
    - java
    - rust
    - dart
    - dotnet
    - php-composer
    - elixir-mix
    - swift-package-manager
    - apk
    - dpkg
    - rpm
    - dnf
    - conda
    - conan
    - nix
    - portage
  enabled:
    - python
    - go-mod
    - java
```

### 3. Container image SBOM generation patterns

#### Scanning local Docker images

```bash
# Using Docker daemon (requires dockerd)
syft docker:myapp:v1.0.0 -o cyclonedx-json=sbom.cdx.json

# Using containerd
syft containerd:myapp:v1.0.0 -o cyclonedx-json=sbom.cdx.json

# Using podman
syft podman:myapp:v1.0.0 -o cyclonedx-json=sbom.cdx.json
```

#### Scanning registry images without local pull

```bash
# Direct registry scan (requires auth)
syft registry:myregistry.io/myapp:v1.0.0 -o cyclonedx-json=sbom.cdx.json

# With explicit credentials
SYFT_REGISTRY_AUTH_USERNAME=user SYFT_REGISTRY_AUTH_PASSWORD=pass \
  syft registry:myregistry.io/myapp:v1.0.0 -o cyclonedx-json=sbom.cdx.json
```

#### Scanning OCI layout directories

```bash
# For images saved with `docker save` or `skopeo copy`
syft oci:./oci-layout -o cyclonedx-json=sbom.cdx.json

# For single-image OCI tar
syft oci-archive:./image.tar -o cyclonedx-json=sbom.cdx.json
```

#### Multi-architecture images

```bash
# Syft scans the platform matching the host by default
syft docker:myapp:v1.0.0 --platform linux/amd64 -o cyclonedx-json=sbom-amd64.cdx.json
syft docker:myapp:v1.0.0 --platform linux/arm64 -o cyclonedx-json=sbom-arm64.cdx.json

# Or scan all platforms and merge (requires manual merge of artifacts arrays)
```

### 4. Registry authentication patterns

See `enterprise-registry-auth-caching.md` for detailed patterns. Summary:

| Method | Use case | Configuration |
|--------|----------|---------------|
| Docker credentials | Local development, single registry | `docker login` then Syft reads `~/.docker/config.json` |
| Environment variables | CI pipelines, ephemeral runners | `SYFT_REGISTRY_AUTH_USERNAME`, `SYFT_REGISTRY_AUTH_PASSWORD`, `SYFT_REGISTRY_AUTH_TOKEN` |
| Config file (`.syft.yaml`) | Multiple registries, persistent config | `registry.auth` array with `authority`, `username`, `password`, `token` |
| OIDC / IRSA | EKS/GKE/AKS workloads | `SYFT_REGISTRY_AUTH_AUTHORITY` + `SYFT_REGISTRY_AUTH_TOKEN` from token exchange |

For CI, generate `.syft.yaml` at runtime:

```yaml
# GitHub Actions example
- name: Generate Syft config
  run: |
    cat > .syft.yaml <<EOF
    registry:
      auth:
        - authority: ${{ vars.REGISTRY_HOST }}
          username: ${{ secrets.REGISTRY_USER }}
          password: ${{ secrets.REGISTRY_PASS }}
    EOF
```

### 5. Output format selection for downstream consumers

| Downstream tool / use case | Recommended format | Reason |
|---------------------------|-------------------|--------|
| Grype vulnerability scanning | `cyclonedx-json` | Native `vulnerabilities[]` injection, `bom-ref` stability |
| Trivy vulnerability scanning | `cyclonedx-json` or `spdx-json` | Both supported; CycloneDX has richer tool metadata |
| License compliance (FOSSA, ClearlyDefined) | `spdx-json` | ISO standard, `licenseConcluded`, `relationships` |
| Internal tooling, custom parsers | `syft-json` | Flat structure, smallest size, no schema ceremony |
| SBOM storage/registry (OCI artifacts) | `cyclonedx-json` + `spdx-json` | Dual format maximizes consumer compatibility |
| GitHub Dependency Graph / Dependabot | `cyclonedx-json` | Native ingestion via `github/codeql-action/upload-sarif` |

Generate multiple formats in one pass:

```bash
syft docker:myapp:v1.0.0 \
  -o cyclonedx-json=sbom.cdx.json \
  -o spdx-json=sbom.spdx.json \
  -o syft-json=sbom.syft.json
```

### 6. SBOM artifact storage and distribution

#### OCI registry as SBOM store

Package SBOMs into an OCI image and push alongside the application image:

```bash
# Generate SBOMs
syft docker:myregistry.io/app:v1.0.0 -o cyclonedx-json=sbom.cdx.json -o spdx-json=sbom.spdx.json

# Create OCI artifact
mkdir -p sbom-artifact/sboms
cp sbom.*.json sbom-artifact/sboms/
cat > sbom-artifact/Dockerfile.sbom <<'EOF'
FROM scratch
COPY sboms/ /sboms/
LABEL org.opencontainers.image.title="SBOMs for app:v1.0.0"
LABEL org.opencontainers.image.description="CycloneDX and SPDX SBOMs"
EOF

docker build -t myregistry.io/sboms/app:v1.0.0 -f sbom-artifact/Dockerfile.sbom sbom-artifact
docker push myregistry.io/sboms/app:v1.0.0
```

#### GitHub Packages / Container Registry

```yaml
- name: Push SBOM to GHCR
  run: |
    SBOM_IMAGE=ghcr.io/${{ github.repository }}/sboms:${{ github.sha }}
    mkdir -p sbom-out
    syft docker:ghcr.io/${{ github.repository }}:${{ github.sha }} -o cyclonedx-json > sbom-out/sbom.cdx.json
    syft docker:ghcr.io/${{ github.repository }}:${{ github.sha }} -o spdx-json > sbom-out/sbom.spdx.json
    cat > Dockerfile.sbom <<'EOF'
    FROM scratch
    COPY sbom-out/ /sboms/
    EOF
    docker build -t $SBOM_IMAGE -f Dockerfile.sbom .
    docker push $SBOM_IMAGE
  env:
    REGISTRY_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Attestation with cosign

```bash
# Keyless signing (OIDC)
cosign sign --yes myregistry.io/sboms/app:v1.0.0

# With key pair
cosign sign --key cosign.key myregistry.io/sboms/app:v1.0.0

# Verify attestation
cosign verify --certificate-oidc-issuer <OIDC_ISSUER_URL> \
  --certificate-identity-regexp ".*" \
  myregistry.io/sboms/app:v1.0.0
```

### 7. Vulnerability scanner integration

#### Grype (tight CycloneDX integration)

```bash
# Generate CycloneDX SBOM, then scan
syft docker:myapp:v1.0.0 -o cyclonedx-json=sbom.cdx.json
grype sbom:sbom.cdx.json --fail-on high --output json=grype-results.json

# Or pipe directly (Grype invokes Syft internally)
grype docker:myapp:v1.0.0 --fail-on high --output json=grype-results.json
```

Grype injects findings into the CycloneDX `vulnerabilities[]` array, preserving `bom-ref` links to components.

#### Trivy

```bash
# Scan SBOM file
trivy sbom sbom.cdx.json --exit-code 1 --severity HIGH,CRITICAL --format json=trivy-results.json

# Scan image directly (Trivy generates SBOM internally)
trivy image myapp:v1.0.0 --exit-code 1 --severity HIGH,CRITICAL --format json=trivy-results.json
```

#### CI gate pattern

```bash
#!/usr/bin/env bash
# sbom-gate.sh — fail build on vulnerability regression
set -euo pipefail

SBOM_FILE="${1:-sbom.cdx.json}"
BASELINE_FILE="${2:-baseline.cdx.json}"
THRESHOLD="${THRESHOLD:-high}"

# Current scan
grype "sbom:${SBOM_FILE}" --fail-on "${THRESHOLD}" --output json > current.json

# Compare against baseline if exists
if [[ -f "${BASELINE_FILE}" ]]; then
  python3 - <<'PY' "${BASELINE_FILE}" current.json
import json, sys
baseline = json.load(open(sys.argv[1]))
current = json.load(open(sys.argv[2]))

base_vulns = {m["vulnerability"]["id"] for m in baseline.get("matches", [])}
curr_vulns = {m["vulnerability"]["id"] for m in current.get("matches", [])}

new = curr_vulns - base_vulns
fixed = base_vulns - curr_vulns

if new:
    print(f"REGRESSION: {len(new)} new vulnerabilities introduced")
    for v in sorted(new):
        print(f"  + {v}")
    sys.exit(1)

if fixed:
    print(f"FIXED: {len(fixed)} vulnerabilities resolved")
    for v in sorted(fixed):
        print(f"  - {v}")

print("PASS: No vulnerability regression")
PY
fi
```

### 8. Kubernetes workload scanning

For scanning images actually deployed in a cluster:

```bash
# Extract image references from workloads
kubectl get pods -A -o jsonpath='{range .items[*]}{.spec.containers[*].image}{"\n"}{.spec.initContainers[*].image}{"\n"}{end}' | sort -u > images.txt

# Scan each image
while read -r img; do
  [[ -z "$img" ]] && continue
  safe=$(echo "$img" | tr '/:@' '---')
  syft "registry:$img" -o cyclonedx-json="reports/${safe}.cdx.json"
  trivy image "$img" --config trivy.yaml --format json="reports/${safe}.trivy.json"
done < images.txt
```

See `syft-trivy-k8s-scan-scaffold` template for a complete project structure.

### 9. Syft configuration for CI

Recommended `.syft.yaml` for CI environments:

```yaml
# .syft.yaml (project root)
catalogers:
  # Enable only needed ecosystems to reduce scan time
  enabled:
    - python
    - go-mod
    - java
    - npm
    - rust
    - dotnet
  disabled: []  # or list catalogers to explicitly disable

# Output settings
output:
  file: sbom.cdx.json
  format: cyclonedx-json

# Registry settings (auth provided via env vars in CI)
registry:
  insecure-skip-tls-verify: false
  insecure-use-http: false
```

### 10. Performance optimization

- **Cache directory**: Set `SYFT_CACHE_DIR` to a persistent location in CI (`actions/cache`, GitLab CI cache, Jenkins workspace)
- **Cataloger selection**: Disable unused catalogers via `.syft.yaml` to reduce scan time
- **Scope limitation**: Use `--scope packages` (default) instead of `--scope all-layers` unless file-level data is needed
- **Parallel scans**: For multi-image pipelines, run Syft in parallel jobs per image
- **Base image reuse**: Cache is keyed by image layers; pin base image tags to maximize cache hits

## Verify

1. **Format validation**: Run `syft alpine:latest -o cyclonedx-json | jq '.bomFormat'` → outputs `"CycloneDX"`
2. **Schema validation**: Validate CycloneDX output against schema: `cyclonedx-validate sbom.cdx.json` (if `cyclonedx-python` installed)
3. **Artifact completeness**: Confirm SBOM contains expected package count: `jq '.components | length' sbom.cdx.json`
4. **Attestation verification**: `cosign verify --certificate-oidc-issuer <OIDC_ISSUER_URL> <sbom-oci-ref>`
5. **Vulnerability gate**: Run Grype against generated SBOM with `--fail-on high` and confirm exit code reflects policy
6. **Registry auth**: Scan a private image with CI credentials and confirm no 401 errors
7. **Cache effectiveness**: Second scan of same image in same CI run completes faster with no registry pull logs at debug level

## Common errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `unable to determine registry auth` | Image registry URL doesn't match `authority` in config | Ensure `authority` matches registry host:port exactly; check for path prefixes |
| `authentication required` on every scan | `DOCKER_CONFIG` points to empty/invalid config | Verify config file exists and contains registry credentials; check file permissions |
| `failed to fetch image: 401 Unauthorized` | Token expired or insufficient scope | Refresh token; ensure token has `registry:read` or equivalent scope |
| `config file ignored` | Multiple config files present | Syft uses first file found in resolution order; remove or consolidate configs |
| `cache directory permission denied` | CI runner user cannot write to cache path | Set `SYFT_CACHE_DIR` to writable path (e.g., `$HOME/.cache/syft`) |
| `no packages found` | Catalogers disabled or wrong scope | Enable relevant catalogers in `.syft.yaml`; verify `--scope` setting |
| `Grype: no matches found` | SBOM format mismatch or empty SBOM | Ensure CycloneDX format used; verify SBOM has `components[]` |
| `cosign: OIDC token not available` | Running outside GitHub Actions/OIDC environment | Use keyless signing only in supported CI; use key pair for local signing |

## References

- Syft CLI documentation (anchore/syft repository)
- Syft GitHub Action (anchore/syft-action repository)
- Syft configuration reference (anchore/syft docs)
- CycloneDX specification
- SPDX specification
- Grype SBOM scanning documentation
- Trivy SBOM scanning documentation
- cosign keyless signing documentation
- OCI artifacts specification
- SLSA SBOM requirements