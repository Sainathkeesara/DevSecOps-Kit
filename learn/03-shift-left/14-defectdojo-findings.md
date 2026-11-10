---
last_verified: 2026-11-10
tool_version: "3.5.0"
sources:
  - https://github.com/DefectDojo/django-DefectDojo/releases
  - /work/DevSecOps-Kit/defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md
  - /work/DevSecOps-Kit/defectdojo/scripts/product-scan-import.py
---

# Bring all findings together in DefectDojo

You have run four scanners — Gitleaks for secrets, Semgrep for SAST, Trivy for container vulnerabilities, and ZAP for DAST. Each produces its own report format and severity scale. This lesson shows how to import all of them into a single DefectDojo product and engagement, enable deduplication so recurring findings don't pile up, and close findings that you have fixed.

## What you'll learn
- Create or retrieve a DefectDojo product and engagement via API
- Import scan results from Gitleaks, Semgrep, Trivy, and ZAP using the `reimport-scan` endpoint
- Enable engagement-level deduplication and finding closure so remediation is tracked across runs
- Triage findings in the DefectDojo UI and mark fixed findings as Verified

## Before you start
- [Catch secrets before they land with Gitleaks](03-gitleaks-in-ci.md) — Gitleaks report in SARIF or JSON format
- [Find the SQL injection with Semgrep](05-semgrep-sast.md) — Semgrep JSON report
- [Gate the image on Trivy findings in CI](09-trivy-ci-gate.md) — Trivy JSON report
- [Scan the running app with ZAP](13-zap-baseline.md) — ZAP JSON report
- DefectDojo instance reachable (e.g., `docker compose up -d` from the [DefectDojo quickstart](https://github.com/DefectDojo/django-DefectDojo))
- API token with product, engagement, and test write permissions (create in DefectDojo → User Settings → API Token)
- Python 3.8+ with `requests` installed (`pip install requests`)
- Kit scripts available: `product-engagement-setup.py` and `product-scan-import.py` from `../../defectdojo/scripts/`

## Walkthrough

### 1. Set up the product and engagement

Use the setup script to create (or reuse) a product named `sample-app` and an engagement named `ci-scan`. The script is idempotent — running it again returns the existing IDs.

```bash
export DEFECTDOJO_URL="http://localhost:8080"
export DEFECTDOJO_TOKEN="your-api-token"
export PRODUCT_NAME="sample-app"
export ENGAGEMENT_NAME="ci-scan"

python3 ../../defectdojo/scripts/product-engagement-setup.py \
  --product-name "$PRODUCT_NAME" \
  --engagement-name "$ENGAGEMENT_NAME" \
  --engagement-days 30 \
  --output-format shell
```

You should see:
```
Using existing product 'sample-app' (id 1)
Using existing engagement 'ci-scan' (id 5)
product_id=1
engagement_id=5
```

If this is the first run, you will see `Created product 'sample-app' (id 1)` and `Created engagement 'ci-scan' (id 5)` instead. The script prints the IDs to stdout (or JSON with `--output-format json`) so you can capture them for the import step.

> **Why a 30-day engagement?** A longer engagement window lets you reimport daily CI scans into the same engagement without recreating it. The engagement stays "In Progress" until you close it manually.

### 2. Generate scan reports in DefectDojo-compatible formats

Each scanner needs to output a format DefectDojo can parse. Run these from your repository root (adjust paths to your sample app):

**Gitleaks** (produces SARIF, which DefectDojo ingests as `SARIF` scan type):
```bash
gitleaks git --config .gitleaks.toml --report-format sarif --report-path gitleaks-report.sarif
```

**Semgrep** (JSON output maps to `Semgrep JSON Report`):
```bash
semgrep scan --config p/python --json=semgrep-report.json /work/DevSecOps-Kit/lab/sample-app
```

**Trivy** (JSON output maps to `Trivy Scan`):
```bash
trivy image --format json --output trivy-report.json ghcr.io/your-org/sample-app:latest
```

**ZAP** (JSON output maps to `ZAP Scan`):
```bash
docker run --rm -t ghcr.io/zaproxy/zaproxy:stable zap-api-scan.py \
  -t http://host.docker.internal:8080 -r zap-report.json -f json
```

You should see: four report files (`gitleaks-report.sarif`, `semgrep-report.json`, `trivy-report.json`, `zap-report.json`) in the current directory.

### 3. Import each report using `reimport-scan`

The `product-scan-import.py` script handles product/engagement lookup and calls the `reimport-scan` endpoint. **Use `reimport-scan` (not `import-scan`)** — it updates the existing Test, closes findings absent from the new report, and prevents duplicate Test accumulation on every CI run.

Import all four reports:

```bash
# Gitleaks (scan type: SARIF)
python3 ../../defectdojo/scripts/product-scan-import.py gitleaks-report.sarif "SARIF"

# Semgrep (scan type: Semgrep JSON Report)
python3 ../../defectdojo/scripts/product-scan-import.py semgrep-report.json "Semgrep JSON Report"

# Trivy (scan type: Trivy Scan)
python3 ../../defectdojo/scripts/product-scan-import.py trivy-report.json "Trivy Scan"

# ZAP (scan type: ZAP Scan)
python3 ../../defectdojo/scripts/product-scan-import.py zap-report.json "ZAP Scan"
```

You should see output like:
```
Importing gitleaks-report.sarif as 'SARIF' into http://localhost:8080
  using product 'sample-app' (id 1)
  using engagement 'ci-scan' (id 5)
DefectDojo answered with HTTP 201:
{
  "id": 12,
  "title": "SARIF import",
  ...
}
Check the findings in the DefectDojo UI under product 'sample-app'.
```

The script validates the `scan_type` against DefectDojo's known parsers (case-sensitive: `Trivy Scan`, `Grype Scan`, `Semgrep JSON Report`, `ZAP Scan`, `Gitleaks Scan`, `Prowler Scan`, `SARIF`). A wrong scan type does not error — it silently drops the findings. The script guards against this.

### 4. Enable deduplication and finding closure on the engagement

By default, DefectDojo does not deduplicate findings across reimports. Enable these engagement settings so findings that reappear are recognized as the same issue, and findings that disappear are closed automatically.

In the DefectDojo UI:
1. Navigate to **Products → sample-app → Engagements → ci-scan**
2. Click **Edit**
3. Check:
   - **Deduplication on engagement** — enables finding deduplication across reimports
   - **Close old findings** — closes findings absent from the latest report
   - **Close old findings product scope** — leave unchecked to limit closure to this engagement only
4. Set **Minimum severity** to `Low` (or your threshold)
5. Save

You can also set these via API when creating the engagement (the `product-engagement-setup.py` script can be extended to pass these fields).

### 5. Tag imports for traceability

Add tags to each import so you can filter findings by pipeline run. The `product-scan-import.py` script can be extended to accept a `--tags` argument. For now, you can add tags in the UI after import (Tests → Tags), or modify the script to include:

```python
data = {
    "engagement": str(engagement_id),
    "scan_type": scan_type,
    "tags": ["ci", "main-branch", "build-1234"],
}
```

Tags appear on the Test and all associated Findings, enabling dashboards filtered by pipeline run.

### 6. Triage findings in the DefectDojo UI

Open **Findings** under the `sample-app` product. You will see findings from all four scanners in one list, normalized to DefectDojo's severity scale (Critical, High, Medium, Low, Info).

For each finding:
- **Active** — the finding exists in the latest scan
- **Verified** — you have confirmed the fix (click **Verify** after remediation)
- **False Positive** — the finding is not exploitable in your context
- **Risk Accepted** — you accept the risk with a justification
- **Duplicate** — DefectDojo identified it as a duplicate of another finding

With deduplication enabled, a finding that appeared in the Trivy scan on Monday and again on Wednesday will show as a single finding with history from both scans. A finding that was present Monday but absent Wednesday transitions to **Verified → Closed** automatically.

## Exercise

1. Start DefectDojo locally (`docker compose up -d` from the django-DefectDojo repo) and create an API token.
2. Run the four scanners against your sample app and generate the four report files.
3. Run `product-engagement-setup.py` to create the `sample-app` product and `ci-scan` engagement.
4. Import all four reports using `product-scan-import.py` with the correct scan types.
5. Enable deduplication and close-old-findings on the engagement in the UI.
6. In the Findings list, locate one finding from each scanner (Gitleaks, Semgrep, Trivy, ZAP). For one finding, click **Verify** to mark it fixed. For another, mark it **False Positive** with a note explaining why.
7. Re-run one scanner (e.g., Trivy) after fixing a vulnerability in the code, regenerate the report, and re-import. Confirm the fixed finding transitions to **Closed** and no new Test is created.

## Check your work

```bash
# Verify all four reports were imported (check Test count in DefectDojo UI or via API)
curl -H "Authorization: Token $DEFECTDOJO_TOKEN" \
  "$DEFECTDOJO_URL/api/v2/tests/?engagement=5" | jq '.results | length'
```
Expected: `4` (one Test per scanner import).

```bash
# Verify deduplication is enabled on the engagement
curl -H "Authorization: Token $DEFECTDOJO_TOKEN" \
  "$DEFECTDOJO_URL/api/v2/engagements/5/" | jq '{deduplication_on_engagement, close_old_findings}'
```
Expected: `{"deduplication_on_engagement": true, "close_old_findings": true}`.

```bash
# Verify findings from all four scanners appear
curl -H "Authorization: Token $DEFECTDOJO_TOKEN" \
  "$DEFECTDOJO_URL/api/v2/findings/?engagement=5" | jq '.results | group_by(.test.title) | map({scanner: .[0].test.title, count: length})'
```
Expected: four groups, one per scan type, each with at least one finding.

## Common mistakes
- Using `import-scan` instead of `reimport-scan` — creates a new Test on every run, piles up duplicates, and never closes old findings.
- Wrong `scan_type` string (case-sensitive) — `Trivy scan` (lowercase) drops all findings silently. Use the exact strings: `Trivy Scan`, `Semgrep JSON Report`, `ZAP Scan`, `SARIF`, `Gitleaks Scan`, `Grype Scan`, `Prowler Scan`.
- Forgetting `fetch-depth: 0` in `actions/checkout` for Gitleaks — without full git history, Gitleaks only scans the latest commit.
- Not enabling deduplication on the engagement — each reimport creates new Active findings even for the same vulnerability.
- Treating `.trivyignore` or Semgrep suppressions as the only remediation — also mark the finding **Verified** in DefectDojo so the tracking is complete.

## Next
[Infrastructure as code — concepts](../../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md)