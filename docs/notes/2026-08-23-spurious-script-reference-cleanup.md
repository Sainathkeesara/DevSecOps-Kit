---
last_verified: 2026-08-23
tool_version: n/a
sources: []
---

# Training doc script-reference cleanup — 2026-08-23

> Swept the training how-to docs for references to kit scripts that don't exist on disk, and fixed the ones I found.

## What I did

I grepped every `*.md` under `docs/` for backticked filenames ending in `.sh`, `.yml`, `.yaml`, `.tf`, `.json`, `.cfg`, `.conf`. For each hit I checked whether the referenced file actually exists in the repo (resolving both the literal path and the `scripts/bash/...` tree), and classified the reference as one of:

- a real kit file (kept)
- a user-creation example like `Create main.tf:` (kept)
- a standard system path like `/etc/prometheus/prometheus.yml` (kept)
- a spurious reference to a kit file that doesn't exist (fixed)

## What I found

Most references are legitimate. The named examples from the task (`main.tf`, `values.yaml`, `kustomization.yaml`, `prometheus.yml`, `zap.sh`) are all used correctly as user-creation examples or standard config filenames — confirmed by the earlier audit. I found two genuinely spurious references:

1. `docs/how-to/terraform-eks-cluster.md:341` — referenced `./scripts/cleanup.sh`, which doesn't exist. The real cleanup script is `scripts/bash/terraform_toolkit/eks/eks-cleanup.sh`. Updated the path.
2. `docs/how-to/linux/linux-iac-pipeline-workflows.md:702` — referenced `./scripts/ansible/bootstrap.sh`, which doesn't exist. The real bootstrap script is `ansible/scripts/bootstrap.sh`. Updated the path.

## What I'll cover next

If more how-to guides get added, re-run the same grep-and-verify sweep to catch any new dangling script references early.
