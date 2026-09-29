---
last_verified: 2026-09-29
tool_version: 1.105.0
sources:
  - https://semgrep.dev/docs/ci/
  - https://semgrep.dev/docs/semgrep-app/
  - https://github.com/semgrep/semgrep-action
---

# Semgrep Integration Reference for Code Scanning

## Purpose

This document provides a reference for integrating Semgrep as a code scanning engine within CI/CD pipelines. It covers installation methods, configuration patterns, SARIF output for GitHub/GitLab code scanning, and operational considerations for production deployments.

## When to Use

Use this reference when:

- Adding static analysis to a CI pipeline for the first time
- Migrating from another SAST tool (CodeQL, SonarQube, Bandit) to Semgrep
- Configuring organization-wide policy enforcement across repositories
- Setting up scheduled scans or PR-gated scanning with gated merges

## Prerequisites

- Semgrep CLI ≥ 1.100.0 or `semgrep/semgrep-action` ≥ v1
- CI runner with internet access (for community rule registry) or pre-cached rules
- GitHub/GitLab/GitHub Enterprise with code scanning enabled (for SARIF upload)
- Optional: Semgrep Cloud Platform account for centralized findings dashboard

## Configuration Patterns

### Minimal GitHub Actions Workflow

```yaml
name: Semgrep Code Scanning
on:
  push:
    branches: [main]
  pull_request:
  schedule:
    - cron: '0 6 * * 1'  # weekly Monday 06:00 UTC
jobs:
  semgrep:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      - uses: semgrep/semgrep-action@v1
        with:
          config: auto
          generate-sarif: true
      - uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
```

### Organization Policy Configuration

Create `.semgrep.yml` at repository root to define enforced rules:

```yaml
rules:
  - id: no-hardcoded-secrets
    patterns:
      - pattern-either:
          - pattern: $X = "$SECRET"
          - pattern: $X = '$SECRET'
      - metavariable-regex:
          metavariable: $X
          regex: (?i)(password|secret|token|api_key|apikey)
    message: Hardcoded secret detected
    languages: [python, javascript, typescript, go, java]
    severity: ERROR
    mode: taint
```

### Ruleset Composition

Combine multiple rule sources in `config`:

```yaml
config: >
  auto
  p/security-audit
  p/secrets
  .semgrep.yml
```

Order determines precedence; later entries override earlier rule IDs.

## Steps

### 1. Choose Installation Method

| Method | Use Case | Cache Behavior |
|--------|----------|----------------|
| `semgrep/semgrep-action@v1` | GitHub Actions, quick start | Caches registry in runner tool cache |
| `pipx install semgrep` / `brew install semgrep` | Local development, self-hosted runners | Manual cache management |
| Docker (`returntocorp/semgrep`) | Air-gapped, custom base images | Build-time rule baking |

### 2. Select Rule Sources

- `auto` — Community registry (3000+ rules, all languages)
- `p/security-audit` — Curated security rules (OWASP Top 10, CWE)
- `p/secrets` — Secret detection patterns
- `p/ci` — CI/CD misconfiguration rules
- Local `.semgrep.yml` — Organization-specific rules

### 3. Configure SARIF Output

Enable `generate-sarif: true` in the action, or `--sarif` CLI flag. Upload with platform-native action:

```bash
semgrep --config auto --sarif --output semgrep.sarif /src
```

```yaml
- uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: semgrep.sarif
    category: semgrep
```

### 4. Tune Severity Thresholds

```yaml
with:
  config: auto
  severity: WARNING  # ERROR only for gated merges
```

For PR gates, use `severity: ERROR` and `fail-on: error` to block merges on critical findings.

### 5. Exclude Generated/Vendor Code

Create `.semgrepignore`:

```
# Build artifacts
dist/
build/
*.min.js
*.bundle.js

# Vendored dependencies
vendor/
node_modules/
third_party/

# Test fixtures with intentional vulnerabilities
tests/fixtures/
testdata/
```

### 6. Enable Incremental Scanning (Large Repos)

```yaml
with:
  config: auto
  args: --max-target-bytes 1000000 --jobs 4
```

Limits per-file size and parallelizes across cores.

## Verify

1. Run workflow on a test PR with known violations
2. Confirm SARIF upload appears in **Security → Code scanning alerts**
3. Verify `.semgrepignore` excludes intended paths (check workflow logs)
4. Validate custom rules fire using `semgrep --test --config .semgrep.yml`

## Rollback

If a rule causes excessive false positives:

1. Temporarily raise severity: `severity: INFO` in rule definition
2. Or exclude the rule ID: `exclude: [rule-id]` in workflow config
3. Fix rule pattern and re-enable

```yaml
with:
  config: auto
  exclude: |
    flask-debug-enabled
    django-debug-true
```

## Common Errors

### Registry Download Timeout

**Symptom:** First run exceeds 10 minutes on `config: auto`

**Resolution:** Pre-cache rules in a separate step or use a smaller ruleset:

```yaml
- run: semgrep --config auto --dry-run /tmp  # warm cache
```

Or pin a specific ruleset version:

```yaml
config: p/security-audit@v1.2.3
```

### SARIF Upload Fails with "Invalid SARIF"

**Symptom:** `github/codeql-action/upload-sarif` reports schema errors

**Resolution:** Ensure Semgrep version ≥ 1.100.0 (SARIF 2.1.0 compliant). Upgrade action:

```yaml
uses: semgrep/semgrep-action@v1.105.0
```

### Custom Rules Not Merging with `auto`

**Symptom:** Rules in `.semgrep.yml` don't run alongside `config: auto`

**Resolution:** Use multi-line config string (see Ruleset Composition above). The action concatenates sources; it does not merge rule objects.

### Memory Exhaustion on Large Codebases

**Symptom:** OOM kill on monorepos (>500k lines)

**Resolution:** Add resource limits and chunk scanning:

```yaml
with:
  config: auto
  args: --max-target-bytes 500000 --jobs 2
```

Or split by language in matrix jobs.

## References

- [Semgrep CI Documentation](https://semgrep.dev/docs/ci/)
- [Semgrep Action Repository](https://github.com/semgrep/semgrep-action)
- [SARIF Specification](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html)
- [Community Rule Registry](https://semgrep.dev/explore)