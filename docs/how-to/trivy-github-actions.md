# Trivy GitHub Actions Integration

---
SQUIRREL:
  title: "Trivy GitHub Actions Workflow Integration"
  category: "trivy"
  tags: ["trivy", "github-actions", "ci-cd", "security-scanning", "sarif"]
  last_verified: "2026-05-09"
  version: "trivy-action v3+"
---

## Purpose

This guide provides steps to integrate Aqua Security Trivy vulnerability scanning into GitHub Actions workflows as automated security checks. Enables continuous vulnerability assessment of container images, filesystem dependencies, infrastructure-as-code configurations, and exposed secrets on every push, pull request, and scheduled interval, with SARIF output to GitHub Code Scanning alerts.

## When to use

- GitHub-hosted CI/CD with GitHub Actions runners
- Implementing Shift-Left security in GitHub-based repositories
- Requiring vulnerability scans before merge (PR gating)
- Continuous monitoring of container images (Docker, OCI)
- Scanning IaC templates (Terraform, Kubernetes, Helm, CloudFormation)
- Detecting hardcoded secrets in code
- Compliance: SOC2, PCI-DSS, CIS benchmarks

## Prerequisites

- GitHub repository with Actions enabled
- Ubuntu-latest or ubuntu-22.04+ runners (self-hosted also supported)
- Workflow file permission to write to `security-events` (SARIF upload)
- Token with `security_events: write` scope (GITHUB_TOKEN has this by default)
- For image scanning: Docker daemon access on runner (or use Trivy Docker action variant)

## Installation

### Step 1: Add Workflow File

Create `.github/workflows/trivy-scan.yml` in your repository:

```yaml
name: Security Scan - Trivy

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  schedule:
    - cron: '0 2 * * *'  # Daily at 02:00 UTC
  workflow_dispatch:     # Manual trigger

permissions:
  contents: read
  security-events: write  # Required for Code Scanning

jobs:
  trivy-fs:
    name: Filesystem Scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy FS scanner
        uses: aquasecurity/trivy-action@v3
        with:
          scan-type: 'fs'
          format: 'sarif'
          output: 'trivy-fs-results.sarif'
          severity: 'HIGH,CRITICAL'
          exit-code: '1'

      - name: Upload Trivy FS scan results
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: 'trivy-fs-results.sarif'
          category: 'fs'

  trivy-image:
    name: Container Image Scan
    runs-on: ubuntu-latest
    if: github.event_name != 'pull_request'  # Skip on PR if no image
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build image
        run: |
          docker build -t myapp:${{ github.sha }} .

      - name: Run Trivy image scanner
        uses: aquasecurity/trivy-action@v3
        with:
          scan-type: 'image'
          format: 'sarif'
          output: 'trivy-image-results.sarif'
          severity: 'HIGH,CRITICAL'
          exit-code: '1'
          image-ref: 'myapp:${{ github.sha }}'

      - name: Upload Trivy image scan results
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: 'trivy-image-results.sarif'
          category: 'image'
```

### Step 2: Generate Workflow Automatically

Use the integration script to generate best-practice workflows:

```bash
# Generate standard multi-scan workflow
./scripts/bash/ci_cd_toolkit/github/trivy-github-actions.sh --generate

# Generate image-only scan
./scripts/bash/ci_cd_toolkit/github/trivy-github-actions.sh \
  --generate \
  --scan-type image \
  --workflow .github/workflows/trivy-image.yml

# Generate with custom severity
./scripts/bash/ci_cd_toolkit/github/trivy-github-actions.sh \
  --generate \
  --severity CRITICAL \
  --exit-code 0  # Warn but don't fail
```

### Step 3: Commit and Push

```bash
git add .github/workflows/trivy-scan.yml
git commit -m "ci: add Trivy security scanning workflow"
git push origin main
```

Workflow will trigger automatically on next push. View results in **Security** tab → **Code scanning alerts**.

## Scan Types

### Filesystem (fs)

Scans project dependencies and files for vulnerabilities:

```yaml
- uses: aquasecurity/trivy-action@v3
  with:
    scan-type: 'fs'
    format: 'sarif'
    output: 'trivy-fs.sarif'
    severity: 'HIGH,CRITICAL'
    # Optional: limit scan scope
    # scan-ref: './src'  # Only scan specific directory
    # trivy-ignores: '.trivyignore'
```

### Container Image

Scans built or pulled container images:

```yaml
- name: Build image
  run: docker build -t myapp:$GITHUB_SHA .

- uses: aquasecurity/trivy-action@v3
  with:
    scan-type: 'image'
    image-ref: 'myapp:${{ github.sha }}'
    format: 'sarif'
    output: 'trivy-image.sarif'
    severity: 'HIGH,CRITICAL'
    # For private registry:
    # username: ${{ secrets.REGISTRY_USER }}
    # password: ${{ secrets.REGISTRY_PASS }}
```

### Configuration (config)

Scans IaC templates for misconfigurations:

```yaml
- uses: aquasecurity/trivy-action@v3
  with:
    scan-type: 'config'
    format: 'sarif'
    output: 'trivy-config.sarif'
    severity: 'HIGH,CRITICAL'
    scan-ref: './k8s/'
    # Include specific frameworks
    # include-configs: 'tf,helm,k8s,dockerfile'
```

### Secret Scanning

Detects exposed secrets:

```yaml
- uses: aquasecurity/trivy-action@v3
  with:
    scan-type: 'secret'
    format: 'sarif'
    output: 'trivy-secret.sarif'
    severity: 'HIGH,CRITICAL'
```

## Configuration

### Severity Thresholds

```yaml
severity: 'CRITICAL'           # Only critical issues
severity: 'HIGH,CRITICAL'      # High and critical (recommended)
severity: 'LOW,MEDIUM,HIGH,CRITICAL'  # All issues
```

Exit codes (set `exit-code` input):
- `0`: Never fail (useful for monitoring only)
- `1`: Fail on HIGH or CRITICAL (default)
- `2`: Fail on MEDIUM or higher

### Output Formats

| Format | Use case |
|--------|----------|
| `sarif` | GitHub Code Scanning (recommended) |
| `json`  | Custom tooling, API integration |
| `table` | Human-readable in logs |
| `cyclonedx` | SBOM generation |
| `html`  | Human-readable report artifact |

### Caching (Speed up repeated scans)

```yaml
- uses: aquasecurity/trivy-action@v3
  with:
    cache-backend: github  # Uses GitHub Actions cache
    # Or local Redis: cache-backend: redis
```

### Ignore Patterns

Create `.trivyignore` in repository root:
```text
# Ignore specific vulnerability
CVE-2023-1234

# Ignore for specific package
pkg: npm/axios@0.21.1

# Ignore in specific file
./vendor/**

# Ignore by severity
CVE-2023- LOW
```

Then reference:
```yaml
with:
  trivy-ignores: '.trivyignore'
```

## Advanced Patterns

### Matrix Scanning (Multiple Configurations)

```yaml
jobs:
  trivy:
    strategy:
      matrix:
        scan-type: ['fs', 'config', 'secret']
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aquasecurity/trivy-action@v3
        with:
          scan-type: ${{ matrix.scan-type }}
          format: sarif
          output: trivy-${{ matrix.scan-type }}-results.sarif
      - uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: trivy-${{ matrix.scan-type }}-results.sarif
          category: ${{ matrix.scan-type }}
```

### Conditional Scanning (PR vs Push)

```yaml
jobs:
  trivy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: aquasecurity/trivy-action@v3
        with:
          scan-type: ${{ github.event_name == 'pull_request' && 'fs' || 'fs,image' }}
          # Only scan image on push (when image is built)
          # Only scan fs on PR (fast)
```

### Docker-in-Docker (for image scanning on self-hosted)

```yaml
jobs:
  trivy-image:
    runs-on: self-hosted  # Ensure Docker daemon available
    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build -t myapp:$GITHUB_SHA .

      - name: Run Trivy in Docker (alternative)
        run: |
          docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $PWD:/work \
            -w /work \
            aquasec/trivy:latest image \
              --format sarif \
              --output trivy-results.sarif \
              myapp:$GITHUB_SHA
```

## Verify

### Check Workflow Execution

1. Navigate to repository **Actions** tab
2. Select "Security Scan - Trivy" workflow
3. Verify job completed (green check or red X)
4. Click job → expand "Run Trivy FS scanner" step
5. Review Trivy output in logs

### Check Code Scanning Alerts

1. Navigate to repository **Security** tab
2. Select **Code scanning alerts**
3. Filter by tool: "Trivy"
4. Review alerts by severity, state, assignee

### CLI Verification

```bash
# List workflow runs
gh run list --workflow="trivy-scan.yml"

# Download SARIF artifact
gh run download <run-id> --name 'trivy-fs-results.sarif'

# Parse SARIF with jq
jq '.runs[0].results | length' trivy-fs-results.sarif
```

## Rollback

### Disable Workflow Temporarily

```yaml
on:
  # push:  # Comment out triggers
  # pull_request:
  workflow_dispatch: {}  # Only manual
```

Or rename file:
```bash
mv .github/workflows/trivy-scan.yml .github/workflows/trivy-scan.yml.disabled
git commit -m "ci: disable Trivy scan temporarily"
```

### Adjust Severity Threshold

Reduce severity or disable exit-code failure:

```yaml
- uses: aquasecurity/trivy-action@v3
  with:
    severity: 'CRITICAL'      # Only critical fails build
    exit-code: '0'            # Never fail build (monitoring only)
```

### Remove Trivy Action

```bash
git rm .github/workflows/trivy-scan.yml
git commit -m "ci: remove Trivy scan workflow"
```

## Common errors

**"Permission security-events: write is required"**
- Add permissions block at top of workflow:
  ```yaml
  permissions:
    security-events: write
  ```
- Repository settings → Actions → General → Workflow permissions → "Read and write permissions"

**"Failed to upload SARIF: 422 Unprocessable Entity"**
- SARIF file may be malformed
- Ensure `category` field differs between upload steps
- Validate SARIF with `ajv validate -s https://json.schemastore.org/sarif-2.1.0.json -d trivy-results.sarif`

**"No such image" or "image not found"**
- Image must exist in registry or local Docker daemon
- For local Docker: Use Docker-in-Docker (self-hosted runner) or docker/build-push-action first
- For remote registry: Provide credentials via `username`/`password` or registry token

**"Cannot connect to Docker daemon"**
- GitHub-hosted runners don't have Docker daemon
- Use `docker/build-push-action` to build and scan with `image-ref` pointing to built image
- Or use `trivy-action` with `scan-type: fs` instead (no Docker needed)

**Trivy database download fails**
- GitHub runners have rate limits
- Enable cache: `cache-backend: github`
- Or use `skip-db-update: true` and pre-cache DB

**Workflow takes too long (>10 min)**
- Limit scan scope: `scan-ref: './src'` instead of full repo
- Exclude directories: `--skip-dirs vendor,node_modules`
- Use `--parallelism` (not directly configurable in action)
- Consider separate workflows for fs vs image (parallelize)

**SARIF upload fails with "category must be unique"**
- Each `upload-sarif` step needs unique `category` input
- Use different categories per scan: `fs`, `image`, `config`, `secret`

**"Cannot resolve action" aquasecurity/trivy-action@v3**
- Ensure `v3` version exists (check https://github.com/aquasecurity/trivy-action/releases)
- Use full ref: `@v3.0.0` for specific version
- Or use commit SHA for immutability

**Exit code 1 despite no critical vulnerabilities**
- Check severity threshold: maybe MEDIUM included
- Adjust `severity:` input to only CRITICAL
- Or set `exit-code: 0` to never fail (monitoring mode)

## Performance optimization

```yaml
- uses: aquasecurity/trivy-action@v3
  with:
    # Speed: cache DB between runs
    cache-backend: github

    # Parallelism (default 1)
    # Not directly exposed in action; set TRIVY_ environment
    # trivy-options: '--parallelism 4'

    # Skip known harmless issues
    trivy-ignores: '.trivyignore'

    # Only report fixed vulnerabilities
    # only-fixed: true  # Add custom args if needed
```

## Alternatives

- **trivy-action v2**: `aquasecurity/trivy-action@v2` - stable but older
- **Docker container**: `docker run aquasec/trivy:latest` directly in run step
- **Setup then run**: `aquasecurity/trivy-action/setup` + custom `run` step
- **External scanning**: Use Dependabot, Snyk, or GitHub Advanced Security instead

## References

- Trivy GitHub Action: https://github.com/aquasecurity/trivy-action
- Trivy Documentation: https://aquasecurity.github.io/trivy/
- GitHub Code Scanning: https://docs.github.com/en/code-security/code-scanning
- SARIF Specification: https://docs.oasis-open.org/sarif/sarif/v2.1.0/
- Workflow Syntax: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
- Trivy Ignore File: https://aquasecurity.github.io/trivy/v0.55/configuration/ignore/.trivyignore/
