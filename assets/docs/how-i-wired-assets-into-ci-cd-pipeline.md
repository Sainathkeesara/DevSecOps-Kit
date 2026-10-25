---
last_verified: 2026-10-25
tool_version: n/a
sources: []
---

# How I wired assets into CI/CD pipeline

Notes on adding the image assets to the deployment flow.

## What I did

- Pointed the build at `assets/` so PNGs ship with the docs.
- Added a step that runs the inventory collector and stores the JSON.
- Verified the links resolve after deploy.

## What I'd try next

Wire a check that fails CI when an asset is orphaned.
