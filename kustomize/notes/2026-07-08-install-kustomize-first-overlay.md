---
last_verified: 2026-07-08
tool_version: n/a
sources: []
---

# Install Kustomize and create my first overlay

I installed kustomize via `kubectl` — it ships built-in since 1.14 so `kubectl kustomize --help` just worked. I also tried the standalone binary from the GitHub releases page when I wanted to test the latest version.

## What I followed

Grabbed the sample nginx deployment from the Kubernetes docs as a base and created a dev overlay that changes the replica count and adds a configmap.

## What worked

- `kubectl kustomize overlays/dev/` printed merged YAML immediately — no file editing of the base.
- Adding `namePrefix: dev-` in the overlay kustomization prefixed everything, so I didn't have to rename resources manually.
- Patching a Deployment's replicas with a strategic merge patch was intuitive — just write the fields you want to override.

## Got stuck on

- **Patch target matching** — My first patch didn't apply because I forgot the `group`, `version`, `kind` in the patch target selector. The error message said "no matching resource" and I stared at it for 10 minutes before realizing the target needs the full GVK.
- **Overlay file ordering** — I assumed `patches` would be applied top to bottom but some transformers run at different phases. Had to read the docs to learn that patches and transformers have a specific execution order.

## What I'd try next

Set up three overlays (dev, staging, prod) with different namespaces and see how common transformers like `images` and `replicas` work across all of them from a single config.
