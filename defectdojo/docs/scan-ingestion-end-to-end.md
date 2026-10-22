---
last_verified: 2026-10-22
tool_version: n/a
sources: []
---

# DefectDojo — scan-tool ingestion end-to-end

> First-contact notes on wiring a scan tool's report into DefectDojo so findings land in an engagement and can be triaged. This is one way to wire it; I have not run it against a live DefectDojo instance, so treat the commands as a sketch to verify against your own instance.

## Purpose
Move scan results from an external scanner into DefectDojo as findings tied to a product and an engagement, so they can be deduplicated, triaged, and tracked to resolution. The kit already ships an ingestion helper (`defectdojo/scripts/product-scan-import.py`) that authenticates to DefectDojo's API and posts scan results; this note describes the end-to-end wiring around it.

## When to use
Use this flow when a scan has finished and its report needs to become actionable findings in DefectDojo rather than sitting in a standalone report file. It fits CI pipelines that already produce a scan report and want one place to track findings across tools.

## Prerequisites
- A DefectDojo instance reachable from the runner, with API access enabled.
- API credentials available to the runner as secrets, never committed to the repo.
- A scan report file produced by the scanner, in a format the ingestion helper can read.
- The helper script `defectdojo/scripts/product-scan-import.py` present in the repo.

## Steps
1. Create (or reuse) a Product in DefectDojo for the target being scanned, and an Engagement under it that represents the scan campaign.
2. Run the scanner against the target and save the report to a known path.
3. Call the ingestion helper, passing the engagement, scan type, and report file path. The helper authenticates and posts the scan results; a non-successful response causes the helper to fail, so a CI step depending on it fails fast.
4. In DefectDojo, confirm findings appear under the engagement, then deduplicate and triage by severity.

## Verify
- The helper exits non-zero and prints the error body when authentication fails or the engagement id is wrong.
- Findings show up on the Engagement's findings page with the expected scan type and severity; re-importing the same report should not duplicate findings.
- No secrets are logged: the helper reads credentials from environment variables and never prints them.

## References
- `defectdojo/scripts/product-scan-import.py` — the ingestion helper this flow calls.
- `defectdojo/notes/0000-primer-defectdojo.md` — first-contact notes on DefectDojo concepts (products, engagements, findings).
