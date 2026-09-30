---
last_verified: 2026-09-30
tool_version: n/a
---

# ZAP integration reference for application security testing

## Purpose

This document provides an authoritative reference for integrating OWASP ZAP into automated security testing pipelines. It covers the three primary integration patterns: Docker-based baseline scans for CI smoke testing, ZAP Automation Framework plans for declarative multi-step scans, and REST API control for programmatic workflows. Each pattern is documented with complete configuration, execution steps, verification criteria, and rollback procedures.

## When to use

- **Baseline scan (Docker)**: Every staging deploy in CI/CD. Fast, non-destructive passive scan that catches header regressions, CSP issues, and cookie configuration problems.
- **Automation Framework plan**: Pre-release deep assessments or regulated environments requiring auditable, version-controlled scan definitions. Combines spider, AJAX spider, passive scan, active scan, and reporting in a single declarative file.
- **REST API control**: Custom orchestration where scan logic depends on runtime conditions (dynamic target discovery, conditional authentication, multi-environment promotion gates).

## Prerequisites

- Docker runtime with network access to the target application
- Target application deployed and reachable (staging, pre-prod, or dedicated test environment)
- For authenticated scans: valid credentials and understanding of the application's login flow (form-based, OAuth, SSO, header-based)
- For active scans: explicit authorization and a non-production environment — active scanning sends attack payloads that can modify state or disrupt services
- `jq` installed for JSON parsing in shell-based API workflows

## Integration patterns

### Pattern 1: Docker baseline scan (CI smoke test)

**Command**:

```bash
docker run --rm \
  -v "$(pwd)/reports:/zap/wrk" \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py -t https://staging.example.com -r zap-report.html
```

**Key options**:

| Option | Description |
|--------|-------------|
| `-t` | Target URL to scan |
| `-r` | HTML report output path |
| `-J` | JSON report output path |
| `-d` | Delay after spider completes (seconds) |
| `-m` | Minutes to run (timeout) |
| `-x` | XML report output path |

**Exit codes**: 0 = no alerts above threshold, 1 = warnings, 2 = failures (configurable via `-a` and `-w` flags for alert thresholds).

**Verification**:

1. Report generated at specified path
2. Spider discovered expected URL count (check report summary)
3. No HIGH alerts in passive findings
4. Exit code matches CI gate policy

**Rollback**: None required — baseline scan is read-only. If scan fails due to target unreachable, fix deployment and re-run.

### Pattern 2: ZAP Automation Framework plan (declarative multi-step)

**Plan file** (`zap-ci-plan.yaml`):

```yaml
env:
  contexts:
    - name: ci-target
      urls:
        - "{{TARGET_URL}}"
      includePaths:
        - ".*"
      excludePaths:
        - ".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff2?|ttf|eot)(\\?.*)?$"
        - ".*/logout"
        - ".*/health"
      authentication:
        method: "formBasedAuthentication"
        parameters:
          loginPageUrl: "{{LOGIN_URL}}"
          loginRequestData: "username={%username%}&password={%password%}"
        verificationStrategy: "response"
      sessionManagement:
        method: "cookie"
        parameters:
          sessionTokenNames:
            - "JSESSIONID"
      users:
        - name: ci-user
          credentials:
            username: "{{SCAN_USER}}"
            password: "{{SCAN_PASS}}"

vars:
  TARGET_URL: "https://staging.example.com"
  LOGIN_URL: "https://staging.example.com/login"
  SCAN_USER: "ci-scanner"
  SCAN_PASS: "changeme"
  REPORT_DIR: "/zap/wrk/reports"

jobs:
  - type: spider
    parameters:
      context: ci-target
      user: ci-user
      maxChildren: 10
      maxDepth: 5
      maxDuration: 2
    tests:
      - type: spiderStats
        onFail: WARN
        statistic: urls_added
        value: 1
        operator: ">="

  - type: passiveScan-config
    parameters:
      maxAlertsPerRule: 10
      scanOnlyInScope: true

  - type: spiderAjax
    parameters:
      context: ci-target
      user: ci-user
      maxDuration: 5
      maxCrawlDepth: 5
      numberOfBrowsers: 1
    tests:
      - type: spiderAjaxStats
        onFail: WARN
        statistic: urls_added
        value: 1
        operator: ">="

  - type: activeScan
    parameters:
      context: ci-target
      user: ci-user
      maxDuration: 20
      maxScansInUI: 5
      threadPerHost: 4
      alertThreshold: MEDIUM
    policyDefinition:
      rules:
        - id: 40012
          threshold: MEDIUM
          strength: DEFAULT
        - id: 40018
          threshold: MEDIUM
          strength: DEFAULT
        - id: 90019
          threshold: MEDIUM
          strength: DEFAULT
        - id: 40014
          threshold: MEDIUM
          strength: DEFAULT
        - id: 40024
          threshold: MEDIUM
          strength: DEFAULT
    tests:
      - type: alertCount
        onFail: FAIL
        action: raise_alerts
        risk: HIGH
        count: 0
        operator: "=="

  - type: report
    parameters:
      template: traditional-json-plus
      reportDir: "{{REPORT_DIR}}"
      reportFileName: "zap-report-{{DATE:yyyyMMdd-HHmmss}}.json"
      reportTitle: "CI DAST Scan — {{TARGET_URL}}"
      display: false
```

**Execution**:

```bash
docker run --rm \
  -v "$(pwd)/zap-ci-plan.yaml:/zap/wrk/plan.yaml:ro" \
  -v "$(pwd)/reports:/zap/wrk/reports" \
  -e TARGET_URL=https://staging.example.com \
  -e LOGIN_URL=https://staging.example.com/login \
  -e SCAN_USER=ci-scanner \
  -e SCAN_PASS="$SCAN_PASS_SECRET" \
  ghcr.io/zaproxy/zaproxy:stable \
  zap.sh -cmd -autorun /zap/wrk/plan.yaml
```

**Verification**:

1. All jobs in plan execute without ERROR status
2. Spider and AJAX spider tests pass (minimum URLs discovered)
3. Active scan test passes (zero HIGH alerts or configured threshold)
4. JSON report generated with expected structure
5. Report contains findings relevant to target technology stack

**Rollback**: If active scan disrupts target environment, stop container immediately (`docker kill <container_id>`). Restore any test data written during scan from backup. Re-run with reduced `maxDuration` or narrowed policy rules.

### Pattern 3: REST API control (programmatic orchestration)

**Daemon startup**:

```bash
docker run -d --name zap-daemon \
  -p 8080:8080 -p 8090:8090 \
  -v "$(pwd)/reports:/zap/wrk" \
  ghcr.io/zaproxy/zaproxy:stable \
  zap.sh -daemon -port 8080 -host 0.0.0.0 \
  -config api.disablekey=true \
  -config api.addrs.addr.name=.* \
  -config api.addrs.addr.regex=true
```

**Core workflow** (using `curl` + `jq`):

```bash
#!/usr/bin/env bash
set -euo pipefail

API="http://localhost:8090/JSON"
TARGET="https://staging.example.com"
REPORT_DIR="/zap/wrk/reports"

# 1. Define context
CONTEXT_ID=$(curl -s "$API/context/action/newContext/?contextName=ci-target" | jq -r '.contextId')

# 2. Include target in context
curl -s "$API/context/action/includeInContext/?contextName=ci-target&regex=$(printf '%s' "$TARGET" | sed 's/[[\.*^$()+?{|\\]/\\&/g').*" >/dev/null

# 3. Exclude static assets and logout
curl -s "$API/context/action/excludeFromContext/?contextName=ci-target&regex=.*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff2?|ttf|eot)(\\?.*)?$" >/dev/null
curl -s "$API/context/action/excludeFromContext/?contextName=ci-target&regex=.*/logout" >/dev/null

# 4. Spider scan
SPIDER_ID=$(curl -s "$API/spider/action/scan/?contextId=$CONTEXT_ID&url=$TARGET" | jq -r '.scan')
while true; do
  STATUS=$(curl -s "$API/spider/view/status/?scanId=$SPIDER_ID" | jq -r '.status')
  [ "$STATUS" = "100" ] && break
  sleep 5
done

# 5. Passive scan config
curl -s "$API/pscan/action/setMaxAlertsPerRule/?maxAlertsPerRule=10" >/dev/null
curl -s "$API/pscan/action/setScanOnlyInScope/?scanOnlyInScope=true" >/dev/null

# 6. Active scan (optional - use with caution)
SCAN_ID=$(curl -s "$API/ascan/action/scan/?contextId=$CONTEXT_ID&url=$TARGET&recurse=true&scanPolicyName=Default%20Policy" | jq -r '.scan')
while true; do
  STATUS=$(curl -s "$API/ascan/view/status/?scanId=$SCAN_ID" | jq -r '.status')
  [ "$STATUS" = "100" ] && break
  sleep 10
done

# 7. Generate reports
curl -s "$API/core/other/htmlreport/" -o "$REPORT_DIR/zap-report.html"
curl -s "$API/core/other/jsonreport/" -o "$REPORT_DIR/zap-report.json"

# 8. Shutdown
curl -s "$API/core/action/shutdown/" >/dev/null
```

**Verification**:

1. Daemon starts and API responds at `http://localhost:8090/JSON/core/view/version/`
2. Context created with correct include/exclude patterns
3. Spider completes to 100% status
4. Active scan completes (if enabled) with expected alert counts
5. Reports generated and valid JSON/HTML

**Rollback**:

- Stop daemon: `curl -s "$API/core/action/shutdown/"` or `docker kill zap-daemon`
- Remove generated reports if scan was invalid
- Clear any test data created during authenticated scan

## Authentication patterns

| Auth type | Configuration approach |
|-----------|------------------------|
| Form-based | `formBasedAuthentication` with login URL, request data template, verification strategy |
| Script-based | Custom authentication script (Python/JS) loaded via `script` job type — handles OAuth, MFA, SAML |
| Header-based | `manualAuthentication` + `sessionManagement` with token header name — for API tokens, JWT |
| HTTP Basic/Digest | `httpAuthentication` with username/password — for internal services |

For script-based auth, place the script in `/zap/scripts/auth/` and reference it:

```yaml
jobs:
  - type: script
    parameters:
      name: "OAuth2 Auth"
      type: "standalone"
      engine: "Python"
      file: "/zap/scripts/auth/oauth2_flow.py"
```

## Common errors and resolutions

| Error | Cause | Resolution |
|-------|-------|------------|
| `403 Forbidden` on API calls | API key mismatch or `api.disablekey=true` not set | Verify `-config api.disablekey=true` or pass correct `apikey` parameter |
| Context not found in spider/active scan | Typo in context name between definition and job reference | Ensure `context:` parameter matches `env.contexts[].name` exactly |
| Active scan runs indefinitely | No `maxDuration` set or target has infinite crawl paths | Always set `maxDuration` (minutes) and `maxDepth` in context |
| Passive scan produces no alerts | `scanOnlyInScope: true` but context excludes all traffic | Verify context `includes` patterns match target URLs |
| Variable substitution fails | Case mismatch or extra whitespace in `{{VAR}}` template | Use consistent uppercase names, no spaces inside braces |
| AJAX spider fails to start | No display available in headless Docker | Ensure `numberOfBrowsers: 1` and container has Xvfb (included in official image) |
| Report template not found | Wrong template name in `report` job | Use `traditional-json`, `traditional-json-plus`, `traditional-html`, or custom template path |

## Performance tuning

| Parameter | Recommended range | Effect |
|-----------|-------------------|--------|
| `spider.maxDuration` | 2–5 min | Limits crawl time; increase for large apps |
| `spider.maxDepth` | 3–7 | Limits link-following depth |
| `spiderAjax.maxDuration` | 3–10 min | AJAX crawl time; increase for SPA |
| `activeScan.maxDuration` | 15–60 min | Active scan time budget |
| `activeScan.threadPerHost` | 2–5 | Parallel attack threads per host |
| `activeScan.maxScansInUI` | 3–10 | Concurrent active scans |

For large applications, split the plan into multiple files: one for spider + passive, one for active scan with narrowed scope.

## CI/CD integration checklist

- [ ] Baseline scan runs on every staging deploy (fast, <5 min)
- [ ] Full plan scan runs on pre-release tag or scheduled (slow, 20–60 min)
- [ ] Reports uploaded as CI artifacts (HTML for review, JSON for parsing)
- [ ] HIGH alert gate fails pipeline (configurable threshold)
- [ ] Secrets injected via CI secret store, never hardcoded
- [ ] Target environment isolated from production
- [ ] Scan results correlated with ticketing system (Jira, GitHub Issues)

## References

- OWASP ZAP Automation Framework documentation
- OWASP ZAP REST API documentation
- ZAP Docker image usage guide