# Trivy Severity-Based Filtering for Vulnerability Triage

---
SQUIRREL:
  title: "Trivy Severity-Based Filtering"
  category: "trivy"
  tags: ["trivy", "vulnerability", "severity", "triage", "ci-cd", "security"]
  last_verified: "2026-05-10"
  version: "Trivy 0.57+"
---

## Purpose

This guide provides steps to implement severity-based filtering for Trivy vulnerability scanning in CI/CD pipelines. Enables targeted vulnerability triage by filtering findings based on severity levels, reducing noise and focusing on critical security issues.

## When to use

- Triage vulnerabilities during development workflow
- Filter vulnerability reports by severity threshold
- Implement progressive security gates in deployment pipelines
- Focus developer attention on critical vulnerabilities first
- Automate vulnerability remediation prioritization

## Prerequisites

- Trivy installed (version 0.57+ recommended)
- CI/CD pipeline with Trivy integration
- Understanding of vulnerability severity levels (UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL)
- Access to scan reports for validation

---

## Severity Levels

Trivy uses the following severity classification:

| Severity | Description | Typical Use Case |
|----------|-------------|------------------|
| UNKNOWN | Unclassified vulnerabilities | Initial triage |
| LOW | Minor security issues | Background awareness |
| MEDIUM | Moderate vulnerabilities | Pre-production scan |
| HIGH | Significant vulnerabilities | Pre-deployment gate |
| CRITICAL | Severe vulnerabilities | Block deployment |

---

## Filtering Configuration

### Basic Severity Filtering

```bash
# Scan only CRITICAL vulnerabilities
trivy image --severity CRITICAL myapp:latest

# Scan HIGH and CRITICAL vulnerabilities
trivy image --severity HIGH,CRITICAL myapp:latest

# Scan MEDIUM and above
trivy image --severity MEDIUM,HIGH,CRITICAL myapp:latest

# Scan all severities
trivy image --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL myapp:latest
```

### CI/CD Pipeline Integration

#### GitHub Actions

```yaml
name: Vulnerability Scan

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Scan Critical Only
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'myapp:${{ github.sha }}'
          severity: 'CRITICAL'
          exit-code: '1'
          ignore-unfixed: true

      - name: Scan High and Critical
        if: failure()
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'myapp:${{ github.sha }}'
          severity: 'HIGH,CRITICAL'
          exit-code: '1'
```

#### Jenkins Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t myapp:${BUILD_NUMBER} .'
            }
        }
        stage('Critical Security Scan') {
            steps {
                sh '''
                    trivy image \
                        --severity CRITICAL \
                        --exit-code 1 \
                        --ignore-unfixed \
                        myapp:${BUILD_NUMBER}
                '''
            }
        }
        stage('High + Security Scan') {
            when { failure() }
            steps {
                sh '''
                    trivy image \
                        --severity HIGH,CRITICAL \
                        --exit-code 1 \
                        myapp:${BUILD_NUMBER}
                '''
            }
        }
    }
}
```

---

## Vulnerability Triage Workflow

### Progressive Scanning Strategy

```bash
#!/usr/bin/env bash
# triage-vulnerabilities.sh - Progressive vulnerability triage

set -euo pipefail

IMAGE_NAME="${1:-}"

if [[ -z "$IMAGE_NAME" ]]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

echo "Starting progressive vulnerability triage for $IMAGE_NAME"

# Phase 1: Critical only (fail immediately)
echo "Phase 1: Critical severity scan..."
if trivy image --severity CRITICAL --exit-code 1 "$IMAGE_NAME"; then
    echo "No CRITICAL vulnerabilities found"
else
    echo "CRITICAL vulnerabilities detected - stopping pipeline"
    exit 1
fi

# Phase 2: High severity
echo "Phase 2: High severity scan..."
if trivy image --severity HIGH,CRITICAL --exit-code 1 "$IMAGE_NAME"; then
    echo "No HIGH vulnerabilities found"
else
    echo "HIGH vulnerabilities detected - review required"
fi

# Phase 3: Medium severity (report only)
echo "Phase 3: Medium severity scan..."
trivy image --severity MEDIUM,HIGH,CRITICAL --exit-code 0 "$IMAGE_NAME" || true

echo "Triage complete - all acceptable levels passed"
```

### Report Filtering

```bash
# Generate JSON report, then filter downstream
trivy image --format json --severity HIGH,CRITICAL myapp:latest > results.json

# Filter results using jq
jq '.Results[].Vulnerabilities[] | select(.Severity == "CRITICAL")' results.json

# Count by severity
jq '[.Results[].Vulnerabilities[].Severity] | group_by(.) | map({severity: .[0], count: length})' results.json
```

---

## Exit Code Behavior

| Exit Code | Behavior |
|-----------|----------|
| `--exit-code 0` | Always succeed, report findings |
| `--exit-code 1` | Fail on any vulnerability at specified severity |
| `--ignore-unfixed` | Skip vulnerabilities without known fix |

```bash
# Ignore unfixed vulnerabilities (recommended for CI/CD)
trivy image --severity HIGH --ignore-unfixed --exit-code 1 myapp:latest

# Fail on any vulnerability at threshold
trivy image --severity HIGH --exit-code 1 myapp:latest
```

---

## Verification

### Verify Filtering Works

```bash
# Test severity filtering
trivy image --severity CRITICAL --format table alpine:latest

# Check output contains only CRITICAL
trivy image --severity CRITICAL --format json alpine:latest | jq '.Results[].Vulnerabilities[].Severity' | sort -u

# Verify exit code behavior
trivy image --severity CRITICAL --exit-code 1 alpine:latest
echo "Exit code: $?"
```

### Validate CI/CD Integration

```bash
# Dry-run in CI environment
../../scripts/triage-vulnerabilities.sh myapp:dev

# Check artifact generation
ls -la trivy-*.json trivy-*.sarif 2>/dev/null || echo "No artifacts generated"
```

---

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `unknown severity` | Typo in severity name | Use: UNKNOWN, LOW, MEDIUM, HIGH, CRITICAL |
| `exit code 0 on vuln` | `--exit-code 0` set | Remove or set to `1` to fail on vuln |
| `no matches for severity` | No vulns at target level | Lower severity threshold for testing |

---

## References

- [Trivy Vulnerability Scanning](https://aquasecurity.github.io/trivy/docs/scanner/vulnerability/)
- [Severity Filtering Documentation](https://aquasecurity.github.io/trivy/docs/configuration/filtering/)