---
last_verified: 2026-10-27
tool_version: n/a
sources: []
---

# tfsec — following the quickstart, what tripped me up

## What I did

Ran tfsec against a small Terraform module and worked through the quickstart flow.

## Steps

1. Installed tfsec and confirmed it was on PATH.
2. Ran `tfsec .` in the module directory.
3. Reviewed findings grouped by severity.
4. Added an ignore annotation for a known-acceptable check, then re-ran to confirm it was suppressed.

## What tripped me up

- The first run flagged checks I hadn't configured yet, so the noise drowned out real issues. Filtering by severity early helped.
- Ignore comments need the exact check ID; a typo silently does nothing.
- Running from the wrong directory scans the wrong tree, so confirm the working directory first.

## What I'd try next

Pin a severity threshold in CI and only fail on critical/high.
