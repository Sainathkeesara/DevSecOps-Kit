---
last_verified: 2026-10-14
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

**Plan file**: `zap/configs/ci-dast-automation-framework-plan.yaml`

The kit ships that plan instead of embedding a second copy of it here — a copy
that drifts out of step with the file you actually run is worse than no example
at all. Read it as a starting point: one context (`ci-target`) with a form-based
login, then a spider job, a passive-scan config job, an AJAX spider job, an
active-scan job with a narrow rule policy, and a JSON report job.

The plan has no `vars:` block. Every `{{PLACEHOLDER}}` it references —
`TARGET_URL`, `LOGIN_URL`, `AUTH_METHOD`, `SESSION_TOKEN`, `SCAN_USER`,
`SCAN_PASS`, `REPORT_DIR` — is supplied by the caller at run time, either as
`-job NAME value` arguments or as environment variables on the container. The
`docker run` below uses the environment form, which is why each `-e` has a
matching placeholder in the plan. Note the active-scan test is
`alertCount` with `risk: HIGH`, `count: 0`, `operator: "=="` and
`onFail: INFO` — it raises the HIGH alerts but does not by itself fail the run,
so the CI gate has to read the report rather than trust the exit status alone.

The scaffold's plan, `zap/templates/zap-dast-integration-scaffold/zap-automation-plan.yaml`,
has the same shape and is driven by
`zap/templates/zap-dast-integration-scaffold/scripts/run-zap-dast.sh`, which takes
the plan file as its third argument.

**Execution**:

Run from the kit root, so `$(pwd)` resolves the `zap/` path:

```bash
docker run --rm \
  -v "$(pwd)/zap/configs/ci-dast-automation-framework-plan.yaml:/zap/wrk/plan.yaml:ro" \
  -v "$(pwd)/reports:/zap/wrk/reports" \
  -e TARGET_URL=https://staging.example.com \
  -e LOGIN_URL=https://staging.example.com/login \
  -e AUTH_METHOD=formBasedAuthentication \
  -e SESSION_TOKEN=JSESSIONID \
  -e SCAN_USER=ci-scanner \
  -e SCAN_PASS="$SCAN_PASS_SECRET" \
  -e REPORT_DIR=/zap/wrk/reports \
  ghcr.io/zaproxy/zaproxy:stable \
  zap.sh -cmd -autorun /zap/wrk/plan.yaml
```

**Verification**:

1. The container did not abort before the first job — that means the plan file mounted correctly
2. All jobs in plan execute without ERROR status
3. Spider and AJAX spider tests pass (minimum URLs discovered)
4. Report file written under the mounted `REPORT_DIR`, and no `{{...}}` placeholder survives into the report title or filename
5. HIGH-alert count read from the JSON report is within the threshold your CI gate enforces — the plan's own `alertCount` test is `onFail: INFO`, so it reports rather than blocks

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
| Container aborts before any job runs | The `docker run` mount path does not point at a file that exists — `-v "$(pwd)/plan.yaml:..."` resolves against your current directory, not the kit | Mount the file that is actually on disk (`zap/configs/ci-dast-automation-framework-plan.yaml`) and run from the kit root |
| Placeholders left unsubstituted in the report | A `{{PLACEHOLDER}}` in the plan has no matching `-e` or `-job` argument | Every placeholder in the plan needs a caller-supplied value; `REPORT_DIR` is the one most often missed |

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
- `zap/configs/ci-dast-automation-framework-plan.yaml` — the plan this document mounts
- `zap/templates/zap-dast-integration-scaffold/zap-automation-plan.yaml` — scaffold plan variant
- `zap/templates/zap-dast-integration-scaffold/scripts/run-zap-dast.sh` — scaffold runner