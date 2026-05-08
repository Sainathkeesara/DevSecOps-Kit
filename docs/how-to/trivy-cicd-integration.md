# Trivy CI/CD Pipeline Integration

---
SQUIRREL:
  title: "Trivy CI/CD Pipeline Integration"
  category: "trivy"
  tags: ["trivy", "ci-cd", "vulnerability-scanning", "security", "devsecops"]
  last_verified: "2026-05-08"
  version: "Trivy 0.57+"
---

## Purpose

This guide provides steps to integrate Trivy vulnerability scanning into CI/CD pipelines as a post-build stage. Enables automated security scanning of container images, filesystem, and infrastructure code to detect vulnerabilities before deployment.

## When to use

- Adding security scanning to CI/CD pipelines (GitHub Actions, Jenkins, GitLab CI, etc.)
- Implementing shift-left security in DevSecOps workflows
- Scanning container images before production deployment
- Detecting vulnerabilities in application dependencies and OS packages
- Enforcing security gates in deployment pipelines

## Prerequisites

- Trivy installed (version 0.57+ recommended)
- CI/CD environment with supported runners (Linux, macOS)
- Sufficient storage for Trivy vulnerability database (~500MB)
- Network access for database downloads (or local mirror)
- Appropriate permissions for image scanning

---

## Integration Patterns

### GitHub Actions

```yaml
name: Security Scan

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Trivy scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'

      - name: Upload results to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: trivy-results.sarif
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    sh '''
                        trivy image \
                            --format json \
                            --output trivy-results.json \
                            --exit-code 1 \
                            --severity HIGH,CRITICAL \
                            myapp:latest || true
                    '''
                }
                
                archiveArtifacts artifacts: 'trivy-results.json', allowEmptyArchive: true
            }
        }
    }
    
    post {
        always {
            junit allowEmptyResults: true, testResults: '**/trivy-results.json'
        }
    }
}
```

### GitLab CI

```yaml
stages:
  - build
  - security
  - deploy

trivy-scan:
  stage: security
  image:
    name: aquasec/trivy:latest
    entrypoint: [""]
  variables:
    TRIVY_DB_REPO: "ghcr.io/aquasecurity/trivy-db:2"
  script:
    - trivy fs --scanners vuln,config .
    - trivy image --severity HIGH,CRITICAL myapp:latest
  artifacts:
    reports:
      sarif: trivy-results.sarif
  allow_failure: true
```

---

## Post-Build Stage Configuration

### Basic Configuration

```bash
#!/usr/bin/env bash
set -euo pipefail

SCAN_TARGET="${SCAN_TARGET:-.}"
OUTPUT_FORMAT="${OUTPUT_FORMAT:-json}"
OUTPUT_FILE="${OUTPUT_FILE:-trivy-results.json}"
SEVERITY="${SEVERITY:-HIGH,CRITICAL}"
EXIT_CODE="${EXIT_CODE:-0}"

trivy fs \
    --scanners vuln,config,misconfig \
    --severity "$SEVERITY" \
    --format "$OUTPUT_FORMAT" \
    --output "$OUTPUT_FILE" \
    "$SCAN_TARGET"
```

### Container Image Scanning

```bash
#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-myapp:latest}"
SEVERITY="${SEVERITY:-HIGH,CRITICAL}"
OUTPUT_FILE="${OUTPUT_FILE:-trivy-image-results.json}"

trivy image \
    --severity "$SEVERITY" \
    --format json \
    --output "$OUTPUT_FILE" \
    "$IMAGE_NAME"
```

---

## Configuration Options

| Option | Description | Values |
|--------|-------------|--------|
| `--scanners` | Scanner types to use | vuln, config, misconfig, secret, license |
| `--severity` | Minimum severity level | UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL |
| `--format` | Output format | json, sarif, table, cyclonedx, spdx |
| `--exit-code` | Exit code on findings | 0 (always success), 1 (fail on vuln) |

---

## Severity-Based Filtering

### Scan with Different Thresholds

```bash
# Build pipeline - scan only CRITICAL
trivy image --severity CRITICAL myapp:latest

# Pre-deployment - scan HIGH and above
trivy image --severity HIGH,CRITICAL myapp:latest

# Dev workflow - scan all
trivy image myapp:latest
```

---

## Verification

### Verify Trivy Installation

```bash
trivy version
trivy --version
```

### Test Scan

```bash
# Quick filesystem scan
trivy fs --scanners vuln .

# Quick image scan
trivy image myapp:latest
```

---

## Common Errors

| Error | Cause | Solution |
|-------|-------|---------|
| `db not found` | Database not initialized | Run `trivy image --download-db-only` |
| `permission denied` | Insufficient read access | Check file/directory permissions |
| `module not found` | Trivy not installed | Install via: `brew install trivy` or `curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh` |
| `tar: invalid tar format` | Corrupted database | Delete cache and re-download |

---

## References

- [Trivy Documentation](https://trivy.dev/)
- [Trivy GitHub Actions](https://github.com/aquasecurity/trivy-action)
- [Trivy Jenkins Plugin](https://plugins.jenkins.io/trivy/)
- [Trivy GitLab CI](https://docs.gitlab.com/ee/user/application_security/sast/#trivy)