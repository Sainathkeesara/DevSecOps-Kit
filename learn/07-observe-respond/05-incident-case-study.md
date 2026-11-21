---
last_verified: 2026-11-21
tool_version: "3.5.0"
sources:
  - https://github.com/DefectDojo/django-DefectDojo/releases
  - /work/DevSecOps-Kit/defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md
  - /work/DevSecOps-Kit/defectdojo/scripts/product-scan-import.py
---

# Respond to a vulnerable-dependency incident

You have a Grafana dashboard that surfaces SLO health, scanner gate results, and runtime alerts in one view. Now you'll use that visibility to drive a real incident response: a CVE advisory drops for a transitive dependency in your stack, the scanner gate catches it, and you need to track the finding from alert through patched deployment in DefectDojo — then close the loop with a timeline and follow-up actions.

## What you'll learn
- Work through a CVE case study from advisory to patched deployment
- Write the timeline and the follow-up actions

## Before you start
- [A security and SLO dashboard in Grafana](04-grafana-security-dashboard.md) — Grafana dashboard `security-slo` provisioned from `grafana/configs/security-slo-dashboard.json`, querying Prometheus datasource `my-first-prometheus`. The "Scanner gate - findings" panel shows `scanner_findings_total`.
- [Bring all findings together in DefectDojo](../03-shift-left/14-defectdojo-findings.md) — DefectDojo product `sample-app` with engagement `ci-scan` (id 5), deduplication and close-old-findings enabled. Four scanner imports (Gitleaks SARIF, Semgrep JSON, Trivy Scan, ZAP Scan) create Tests under this engagement. `product-engagement-setup.py` and `product-scan-import.py` from `../../defectdojo/scripts/` available.
- DefectDojo API token with product, engagement, test, and finding write permissions
- Python 3.8+ with `requests` installed (`pip install requests`)
- A running sample app image you can rebuild (e.g., `ghcr.io/your-org/sample-app:latest`)

## Walkthrough

### 1. Simulate the advisory: a vulnerable transitive dependency appears

In this scenario, a CVE is published for a transitive Python dependency (`urllib3<2.0.0` — CVE-2023-45803, CVSS 7.5). Your Semgrep scan runs in CI and surfaces it. The finding appears in the Grafana "Scanner gate - findings" panel as an increased count.

Generate a fresh Semgrep report that includes this CVE (adjust the path to your sample app):

```bash
semgrep scan --config p/ci --json=semgrep-incident-report.json /work/DevSecOps-Kit/lab/sample-app
```

You should see: `semgrep-incident-report.json` with at least one finding tagged `CVE-2023-45803` (or similar CVE for the vulnerable version in your lockfile).

### 2. Re-import into DefectDojo using `reimport-scan`

Reuse the same engagement (`ci-scan`, id 5) so deduplication works. The `reimport-scan` endpoint will update the existing Semgrep Test, close findings absent from the new report, and add the new CVE finding.

```bash
export DEFECTDOJO_URL="http://localhost:8080"
export DEFECTDOJO_TOKEN="your-api-token"

python3 ../../defectdojo/scripts/product-scan-import.py semgrep-incident-report.json "Semgrep JSON Report"
```

You should see: output confirming import into engagement 5, with the new Test id (or updated existing Test id). The finding for `CVE-2023-45803` now appears in DefectDojo under product `sample-app` → Findings, status **Active**.

### 3. Verify the finding appears on the Grafana dashboard

The "Scanner gate - findings" panel queries `scanner_findings_total`. After the reimport, the count should increment by 1 (the new CVE finding).

```bash
curl -s "http://localhost:9090/api/v1/query?query=scanner_findings_total" | jq '.data.result[0].value[1]'
```

You should see: a numeric value that increased by 1 compared to before the import.

> **Why this matters:** The dashboard gives you immediate visibility that the scanner gate caught something new. You don't wait for a daily report — the panel updates on the Prometheus scrape interval.

### 4. Triage the finding in DefectDojo

Open DefectDojo UI → **Products → sample-app → Findings**. Filter by the new CVE (`CVE-2023-45803`).

For this finding:
1. Click the finding title to open details.
2. Note the **Component** (the vulnerable package, e.g., `urllib3`) and **Version** (e.g., `1.26.15`).
3. Set **Severity** to `High` (matches CVSS 7.5).
4. Add a **Tag**: `incident-cve-2023-45803` — this lets you filter all findings related to this incident.
5. Leave status as **Active** (remediation not done yet).

### 5. Remediate: update the dependency and rebuild

In your sample app's dependency file (e.g., `requirements.txt` or `pyproject.toml`), pin the fixed version:

```
urllib3>=2.0.0
```

Rebuild the image and push:

```bash
docker build -t ghcr.io/your-org/sample-app:patched-$(date +%s) /work/DevSecOps-Kit/lab/sample-app
docker push ghcr.io/your-org/sample-app:patched-$(date +%s)
```

### 6. Re-run the scanner and re-import to verify closure

Regenerate the Semgrep report against the patched image/code:

```bash
semgrep scan --config p/ci --json=semgrep-postfix-report.json /work/DevSecOps-Kit/lab/sample-app
```

Re-import into the same engagement (deduplication will match the finding by title + component + path):

```bash
python3 ../../defectdojo/scripts/product-scan-import.py semgrep-postfix-report.json "Semgrep JSON Report"
```

In DefectDojo UI, the finding for `CVE-2023-45803` should now transition from **Active** → **Verified** → **Closed** (because `close_old_findings` is enabled on the engagement and the finding is absent from the new report).

You should see: the finding shows **Closed** with the timestamp of this reimport. The "Scanner gate - findings" panel in Grafana decrements back to the baseline count.

### 7. Write the incident timeline

Create a markdown file capturing the end-to-end timeline. Save it as `docs/incidents/INC-2023-45803-urllib3.md`:

```markdown
# Incident: CVE-2023-45803 in urllib3 (transitive)

**Product:** sample-app
**Engagement:** ci-scan (id 5)
**Finding tag:** incident-cve-2023-45803
**Severity:** High (CVSS 7.5)
**Status:** Closed

## Timeline

| Time (UTC) | Event |
|------------|-------|
| 2024-01-15 08:12 | CVE-2023-45803 published (urllib3 < 2.0.0) |
| 2024-01-15 08:45 | Semgrep CI scan runs; finding imported to DefectDojo Test #12 |
| 2024-01-15 08:47 | Grafana "Scanner gate - findings" panel alerts: count incremented |
| 2024-01-15 08:50 | On-call engineer acknowledges; finding triaged in DefectDojo, tagged `incident-cve-2023-45803` |
| 2024-01-15 09:10 | Dependency pinned to `urllib3>=2.0.0` in `requirements.txt` |
| 2024-01-15 09:25 | Patched image built and pushed: `ghcr.io/your-org/sample-app:patched-1705312500` |
| 2024-01-15 09:30 | Semgrep re-scan runs; finding absent from report |
| 2024-01-15 09:32 | Reimport via `reimport-scan`; finding transitions Active → Verified → Closed |
| 2024-01-15 09:33 | Grafana panel returns to baseline; Slack alert resolves |

## Follow-up actions

| Action | Owner | Due | Status |
|--------|-------|-----|--------|
| Add `urllib3>=2.0.0` constraint to base image Dockerfile | Platform team | 2024-01-22 | Pending |
| Enable Dependabot alerts for transitive deps in all repos | Security team | 2024-01-22 | Pending |
| Document `reimport-scan` workflow in runbook | DevOps lead | 2024-01-18 | Done |
| Add SLO alert on `scanner_findings_total` > baseline + 0 | SRE | 2024-01-18 | Done |

## Lessons learned

- Deduplication + close-old-findings on the engagement made closure automatic — no manual finding cleanup needed.
- The Grafana dashboard gave immediate visibility (< 2 min) that the scanner gate caught the CVE.
- Tagging the finding with `incident-cve-2023-45803` let us filter the incident scope instantly in DefectDojo and Grafana (via label).
- Reusing the same engagement for daily CI scans is critical — otherwise deduplication doesn't work across runs.
```

### 8. Link the timeline from DefectDojo

In the DefectDojo finding (or the Test), add the timeline file as an attachment or reference in the description:

```
Incident timeline: docs/incidents/INC-2023-45803-urllib3.md
```

This keeps the tracking and the narrative together.

## Exercise

Working alone against your running stack:

1. Pick a real or simulated CVE for a transitive dependency in your sample app (or add a vulnerable version to `requirements.txt` temporarily).
2. Run Semgrep, import via `reimport-scan` into the `ci-scan` engagement, and confirm the finding appears **Active** in DefectDojo.
3. Verify the "Scanner gate - findings" panel in Grafana increments.
4. Fix the dependency, rebuild the image, re-run Semgrep, re-import.
5. Confirm the finding transitions to **Closed** and the Grafana panel returns to baseline.
6. Write an incident timeline markdown file (`docs/incidents/INC-<CVE>-<component>.md`) with the table format above — timeline, follow-up actions, lessons learned.
7. Link the timeline from the DefectDojo finding.

Do not paste the solution into the lesson file.

## Check your work

```bash
# 1. Verify the finding was imported and then closed (check via API)
curl -H "Authorization: Token $DEFECTDOJO_TOKEN" \
  "$DEFECTDOJO_URL/api/v2/findings/?engagement=5&tags=incident-cve-2023-45803" | \
  jq '.results[] | {title: .title, status: .status, verified: .verified, closed: .is_closed}'
```
Expected: one result with `status: "Closed"`, `verified: true`, `is_closed: true`.

```bash
# 2. Verify Grafana panel returned to baseline
curl -s "http://localhost:9090/api/v1/query?query=scanner_findings_total" | jq '.data.result[0].value[1]'
```
Expected: numeric value matching the count before the incident (no net increase).

```bash
# 3. Verify incident timeline file exists and has required sections
ls -la docs/incidents/INC-*.md
head -40 docs/incidents/INC-*.md
```
Expected: file exists with `## Timeline`, `## Follow-up actions`, and `## Lessons learned` sections.

## Common mistakes

- **Using a new engagement for the reimport.** Deduplication only works within the same engagement. Keep daily CI scans in one long-running engagement (e.g., 30+ days).
- **Forgetting to enable `close_old_findings` on the engagement.** Without it, the finding stays **Active** forever even after the fix — you must close it manually.
- **Using `import-scan` instead of `reimport-scan`.** Creates a new Test every run, breaks deduplication, and the old finding never closes.
- **Not tagging the finding.** Without a tag like `incident-cve-XXXX`, you can't filter the incident scope across DefectDojo and Grafana (if you expose tags as labels).
- **Treating the timeline as optional.** The timeline is the audit trail — without it, you have no record of MTTR, root cause, or follow-up actions for the next retro.

## Next

[Capstone: a secure delivery pipeline](../../00_index/learning-path.md)