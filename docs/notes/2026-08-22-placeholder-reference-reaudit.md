---
last_verified: 2026-08-22
tool_version: n/a
sources: []
---

# Spurious placeholder reference re-audit — 2026-08-22

> Follow-up to docs-007: re-check the training docs after the latest doc rework for placeholder file references that don't map to real files in the repo.

## What I did

I grepped the whole kit for the filenames called out in the task (`main.tf`, `values.yaml`, `kustomization.yaml`, `prometheus.yml`, `zap.sh`) plus the two extras from the earlier audit (`semmp.yml`, `trivy-scan.yml`, `semgrep-ci.yml`).

## What I found

- `zap.sh` only shows up in the ZAP notes and docs as the ZAP desktop/daemon launcher — that's the real upstream entrypoint, not a repo file we're supposed to ship. Not spurious.
- `semmp.yml` appears only inside the two prior audit notes (`2026-08-17-spurious-placeholder-cleanup.md`, `2026-08-19-workflow-stubs-review.md`); no how-to prose references it. It's a typo example, not a live link.
- `main.tf`, `values.yaml`, `kustomization.yaml`, `prometheus.yml` are standard filenames shown inside how-to code blocks and CLI examples. They're user-creation examples, not claims about files living in the repo.

## Conclusion

The rework didn't introduce any new broken placeholder reference into the training how-to docs. The earlier bulk cleanup already covered the real cases. Nothing to remove this pass.
