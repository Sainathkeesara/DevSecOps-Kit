# Trivy CI/CD pipeline recipes

## Purpose

Trivy fits into CI/CD pipelines at several stages: post-build image scanning, filesystem scanning on the repository, IaC misconfiguration checks, and secret scanning. Each CI platform has its own syntax for orchestration, but the Trivy commands are portable. This doc covers repeatable recipes for GitHub Actions, GitLab CI, and Jenkins — with caching, severity gating, and SARIF upload.

## When to use

Use these recipes when you need to integrate vulnerability scanning into build pipelines where developers can act on findings. SARIF upload to GitHub Code Scanning or GitLab SAST makes findings visible inline on pull requests and merge requests. Severity gating ensures critical issues block deployment. Matrix scanning parallelizes multiple target types (image, config, filesystem) to avoid sequential scan time.

## Prerequisites

- Trivy installed in CI runner (official script or pre-baked image)
- CI platform access to vulnerability database (outbound HTTPS to `github.com` or mirrored DB)
- For GitHub Actions: `github/codeql-action/upload-sarif` action available
- For GitLab CI: SAST license or `sast` report type enabled
- For Jenkins: Pipeline plugin and `emailext` step for notifications (optional)

## Steps

### 1. GitHub Actions — full matrix scan

A workflow that scans the built image, the filesystem, and IaC configs in parallel, then uploads SARIF results to GitHub Code Scanning.

```yaml
name: Trivy scan
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  TRIVY_CACHE_DIR: /tmp/.trivy-cache
  IMAGE_TAG: ${{ github.sha }}

jobs:
  scan:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        target: [image, fs, config]
    steps:
      - uses: actions/checkout@v4

      - name: Build image (image scan only)
        if: matrix.target == 'image'
        run: docker build -t app:$IMAGE_TAG .

      - name: Cache Trivy DB
        uses: actions/cache@v4
        with:
          path: ${{ env.TRIVY_CACHE_DIR }}
          key: trivy-db-${{ runner.os }}

      - name: Run Trivy ${{ matrix.target }}
        run: |
          case "${{ matrix.target }}" in
            image)
              trivy image --format sarif --severity CRITICAL,HIGH \
                --ignore-unfixed --output results.sarif app:$IMAGE_TAG
              ;;
            fs)
              trivy fs --format sarif --severity CRITICAL,HIGH \
                --ignore-unfixed --output results.sarif .
              ;;
            config)
              trivy config --format sarif --severity CRITICAL,HIGH \
                --ignore-unfixed --output results.sarif .
              ;;
          esac

      - name: Upload SARIF
        if: always()
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: results.sarif
```

The matrix strategy runs three scans in parallel. Each uploads its own SARIF file. The `if: always()` ensures SARIF uploads even when Trivy finds issues (it exits non-zero by default for findings). One gotcha: the image scan requires the image to be built first, so the `image` matrix entry runs a build step before scanning.

### 2. GitLab CI — multi-stage scanning with severity gating

A `.gitlab-ci.yml` job that scans on MRs and schedules deeper scans nightly.

```yaml
trivy-scan:
  stage: security
  image: docker:latest
  services:
    - docker:dind
  variables:
    TRIVY_CACHE_DIR: /tmp/.trivy-cache
    TRIVY_SEVERITY: CRITICAL,HIGH
  script:
    - apk add --no-cache curl
    - curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
    - trivy image --format sarif --severity $TRIVY_SEVERITY
        --ignore-unfixed --output gl-trivy-api.sarif
        $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - trivy fs --format sarif --severity $TRIVY_SEVERITY
        --ignore-unfixed --output gl-trivy-fs.sarif .
  artifacts:
    reports:
      sast: gl-trivy-api.sarif
      sast: gl-trivy-fs.sarif
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_PIPELINE_SOURCE == "schedule"
```

GitLab CI natively supports SARIF via the `sast` report artifact — findings appear in the MR's Security tab. The install step is necessary unless Trivy is pre-baked into the CI runner image. Caching the DB is trickier in GitLab than GitHub Actions; a custom image with a pre-downloaded DB is a practical alternative when cache keys don't map well across pipelines.

### 3. Jenkins — declarative pipeline with post-action gating

```groovy
pipeline {
    agent any
    environment {
        TRIVY_CACHE_DIR = '/tmp/.trivy-cache'
        IMAGE = 'app:latest'
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }
        stage('Scan image') {
            steps {
                sh 'trivy image --format sarif --severity CRITICAL,HIGH --output results.sarif $IMAGE'
            }
        }
        stage('Scan filesystem') {
            steps {
                sh 'trivy fs --severity CRITICAL --exit-code 1 .'
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'results.sarif'
        }
        failure {
            emailext subject: "Trivy scan failed in ${env.JOB_NAME}",
                     body: "Critical vulnerabilities found. Check ${env.BUILD_URL}",
                     to: 'security@example.com'
        }
    }
}
```

The `filesystem` scan uses `--exit-code 1` to gate the pipeline. The `image` scan produces SARIF for archiving rather than gating, so the CI observer can review findings without blocking the build. Splitting gate vs SARIF avoids the `--exit-code` + SARIF interaction documented in `ci-pipeline-sarif-output.md`.

### 4. Caching strategy across platforms

Trivy downloads its vulnerability DB on every run (~200 MB). Caching is the single biggest optimisation.

| Platform | Cache key | Path |
|----------|-----------|------|
| GitHub Actions | `trivy-db-${{ runner.os }}` | `~/.cache/trivy` |
| GitLab CI | Pre-baked image | `/home/trivy/.cache/trivy` |
| Jenkins | Shared workspace volume | `/tmp/.trivy-cache` |

For GitLab CI, the recommended approach is building a custom image once a day that includes the Trivy binary and a pre-downloaded DB:

```dockerfile
FROM alpine:3.19
RUN apk add --no-cache curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh \
    && trivy image --download-db-only --cache-dir /home/trivy/.cache/trivy
```

This cuts scan time from ~30s to under 5s.

## Verify

1. Push the pipeline config to a test branch — each recipe should produce a SARIF file or equivalent report artifact.
2. Introduce a known vulnerable dependency (e.g., `lodash@4.17.20` in a Node `package.json`) — the filesystem scan should flag it.
3. Check the CI platform's security tab (GitHub Code Scanning, GitLab SAST) — findings from the SARIF upload should appear grouped by severity.
4. Run the pipeline twice — the second run should be noticeably faster if caching is wired correctly.
5. Verify that the Jenkins gate stage (`--exit-code 1`) causes the pipeline to fail after scanning the filesystem.

## Common errors

- **DB download timeout**: Trivy exits with `unable to download vulnerability DB` — typically a network or proxy issue. Use `--db-repository` flag in air-gapped environments.
- **SARIF upload fails with "too many results"**: GitHub caps SARIF at ~25K results; add `--severity HIGH,CRITICAL` to reduce counts.
- **Matrix job fails only on image scan**: Missing `docker build` step in the matrix condition, or image tagged incorrectly. The `if: matrix.target == 'image'` guard must include the build step.
- **GitLab artifact `sast` conflicts with multiple files**: GitLab only accepts one SAST artifact; use a loop to combine multiple SARIF files or scan targets sequentially.
- **`--exit-code 1` exits before SARIF upload**: Trivy exits non-zero when findings exist and `--exit-code 1` is set. Use separate scan steps (one with SARIF, one with exit-code) or the `if: always()` pattern.

## References

- [Trivy documentation](https://aquasecurity.github.io/trivy/)
- [SARIF specification](https://docs.github.com/en/code-security/code-scanning/understanding-code-scanning-alerts/about-code-scanning-alerts-with-sarif)
