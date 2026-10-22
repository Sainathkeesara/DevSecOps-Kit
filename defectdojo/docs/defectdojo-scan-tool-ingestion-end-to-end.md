---
last_verified: 2026-10-22
tool_version: "n/a"
sources: []
---
# DefectDojo scan-tool ingestion: end-to-end integration

## Purpose
This document describes the end-to-end integration of scan tools with DefectDojo for continuous vulnerability ingestion. It covers the complete flow from scanner execution through API import to finding lifecycle management.

## When to use
- Automating scan result ingestion in CI/CD pipelines
- Centralizing vulnerability findings from multiple scanners (Trivy, Grype, Semgrep, ZAP, SARIF)
- Tracking remediation status across scan runs
- Building a single pane of glass for application security findings

## Prerequisites
- DefectDojo instance with API v2 enabled
- API token with product, engagement, and test write permissions
- Scanner reports in DefectDojo-supported formats (JSON, SARIF, XML)
- Network connectivity from CI runners to the DefectDojo API endpoint

## Steps

### 1. Prepare product and engagement context
Create or retrieve the Product and Engagement that will receive findings. This context must exist before scan import.

```bash
# Using the kit's setup script
DEFECTDOJO_TOKEN=<token> python3 product-engagement-setup.py \
  --product-name "my-application" \
  --engagement-name "ci-scan" \
  --engagement-days 30
```

The script returns `product_id` and `engagement_id` for downstream use.

### 2. Generate scanner report
Run the scanner and produce output in a format DefectDojo parses. Common examples:

| Scanner | Command | Output format | DefectDojo scan_type |
|---------|---------|---------------|----------------------|
| Trivy | `trivy image --format json --output report.json <image>` | JSON | `Trivy Scan` |
| Grype | `grype <image> -o json > report.json` | JSON | `Grype Scan` |
| Semgrep | `semgrep scan --json=report.json` | JSON | `Semgrep JSON Report` |
| ZAP | `zap-api-scan.py -t <target> -r report.json` | JSON | `ZAP Scan` |
| Generic | Any tool producing SARIF 2.1.0 | SARIF | `SARIF` |

### 3. Import report via reimport-scan endpoint
Use the `reimport-scan` endpoint (not `import-scan`) for CI workflows. Reimport updates the existing Test, closes findings no longer present in the new report, and avoids duplicate Test accumulation.

```bash
DEFECTDOJO_TOKEN=<token> python3 product-scan-import.py \
  report.json "Trivy Scan"
```

The script performs:
1. Product lookup/creation by name
2. Engagement lookup/creation on that product
2. POST to `/api/v2/reimport-scan/` with `engagement`, `scan_type`, and `file` multipart form data

### 4. Configure deduplication and severity handling
Set these engagement fields to control finding lifecycle:

- `deduplication_on_engagement: true` — enables finding deduplication across reimports (default: false)
- `close_old_findings: true` — closes findings absent from the latest report (default: false)
- `close_old_findings_product_scope: false` — limits closure to the current engagement when true
- `minimum_severity` — filters findings below the threshold (e.g., "Medium")

### 5. Tag imports for traceability
Include tags in the import request to enable filtering:

```json
{
  "tags": ["ci", "main-branch", "build-1234"]
}
```

Tags appear on the Test and all associated Findings, enabling dashboards filtered by pipeline run.

### 6. Automate in CI pipeline
Integrate the import step into the CI job that runs scans:

```yaml
# GitHub Actions example
- name: Run Trivy scan
  run: trivy image --format json --output trivy-report.json myapp:latest

- name: Import to DefectDojo
  env:
    DEFECTDOJO_TOKEN: ${{ secrets.DEFECTDOJO_TOKEN }}
    DEFECTDOJO_URL: ${{ vars.DEFECTDOJO_URL }}
  run: |
    python3 product-scan-import.py trivy-report.json "Trivy Scan"
```

### 7. Track remediation across runs
On subsequent pipeline executions, the same engagement receives new reports. With deduplication enabled:
- New findings appear as Active
- Fixed findings transition to Verified → Closed
- Recurring findings retain history and notes
- Finding URLs remain stable for ticket linking

## Verify
- Findings appear under the correct Product → Engagement → Test in the DefectDojo UI
- Reimport updates the existing Test rather than creating a new one
- Deduplication prevents duplicate findings across runs
- Tags are present on the Test and Findings for filtering
- Severity distribution matches scanner output

## Common errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `HTTP 403` on import | Token lacks write permission on Product/Engagement/Test | Grant API token appropriate role permissions |
| `HTTP 404` on `/api/v2/reimport-scan/` | API v2 not enabled or wrong base URL | Verify `DEFECTDOJO_URL` ends with `/api/v2` path |
| Findings not appearing | Wrong `scan_type` string (case-sensitive) | Match exactly: `Trivy Scan`, `Semgrep JSON Report`, `SARIF`, etc. |
| Duplicate Tests on each run | Using `import-scan` instead of `reimport-scan` | Switch to `reimport-scan` endpoint |
| Product type not found | Default product_type ID 1 missing | Create a Product Type in UI first, or specify valid `--product-type` |
| Engagement dates invalid | `target_end` before `target_start` | Ensure `--engagement-days` is positive |

## References
- DefectDojo API v2 documentation: `/api/v2/doc/` on your instance
- Kit scripts: `defectdojo/scripts/product-engagement-setup.py`, `defectdojo/scripts/product-scan-import.py`
- Related doc: `defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md`