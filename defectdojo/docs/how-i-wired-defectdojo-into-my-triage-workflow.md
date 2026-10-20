---
last_verified: 2026-10-20
tool_version: "n/a"
sources: []
---
# How I wired DefectDojo into my triage workflow

## Purpose
This doc describes how I integrated DefectDojo into a vulnerability triage workflow to track findings from scan ingestion through remediation and verification.

## Prerequisites
- DefectDojo instance accessible (UI or API)
- Scanner reports (e.g., Trivy, Grype) in supported formats
- Permissions to create/edit Products, Engagements, Tests, and Findings

## Workflow steps
1. **Organize**: Create/update Product and Engagement for the application/release cycle.
2. **Ingest**: Import scan results via API (preferred for CI) or UI (for ad-hoc). Use appropriate scan_type.
3. **Triage**: Review Findings - assign severity/priority, mark false positives, create notes, and link to tickets.
4. **Track remediation**: Use findings status and comments to coordinate fixes; reimport on subsequent scans to track resolution.
5. **Verify**: Confirm fixes are reflected after reimport; close or update findings accordingly.
6. **Report**: Use filters/dashboards to track metrics across engagements.

## Tips
- Prefer API ingestion in CI for consistency and traceability
- Set deduplication_on_engagement appropriately for reimports
- Keep minimum_severity aligned with team policy
- Tag imports (e.g., ci, branch, build-id) for easier filtering

## Verify
- Findings appear in the correct Engagement/Test
- Reimport updates existing findings without creating duplicates (when dedup enabled)
- Triage actions are recorded in finding history

## Common gotchas
- Wrong scan_type prevents proper parsing
- Missing permissions block import/triage actions
- Close-old-findings behavior needs to be understood before enabling
