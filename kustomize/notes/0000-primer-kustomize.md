---
last_verified: 2026-07-08
tool_version: n/a
sources: []
---

# Kustomize — quick primer

> First-day notes for someone who's never used Kustomize. Personal voice, plain language.

## What is it?

Kustomize is a configuration customization tool for Kubernetes YAML. From what I've read, you take a base set of manifests (deployments, services, configmaps, etc.) and overlay environment-specific changes without editing the original files. I think of it like a patching system — define what's common once in a "base" and describe only the differences for dev, staging, and prod in "overlays".

## What does it do?

It reads a `kustomization.yaml` that lists resources and patches, then spits out the final YAML to stdout. The base manifests stay untouched; environment-specific values live in their own overlay directory. Kustomize is built into `kubectl` since 1.14, so if you have kubectl you already have it.

## Why does it exist?

Before Kustomize, teams either copied YAML files per environment (which drifted apart) or used Helm with Go-style variable interpolation. Kustomize lands in the middle: pure YAML, no templating language. What you see in the output is exactly what the patches describe — no hidden variable substitutions to debug. That clicked for me because I want to keep manifests in the same repo as app code without a separate chart repo.

## Key terminology

- **Base** — The directory with the core Kubernetes manifests and a `kustomization.yaml` that lists them. This is the "source of truth" for the common config.
- **Overlay** — A directory with its own `kustomization.yaml` that references one or more bases and adds patches, name prefixes, namespace changes, or labels. Each environment gets its own overlay.
- **Patch** — A partial YAML file (strategic merge patch or JSON patch) that overrides specific fields in the base resource without rewriting the whole thing.
- **`kustomization.yaml`** — The config file that ties everything together: resource list, bases, patches, transformers, and generators.
- **Transformer** — A built-in config modifier that adds labels, namespaces, annotations, or name prefixes across all resources in a kustomization.

## A tiny example

```yaml
# base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
```

```yaml
# overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base

patches:
  - path: increase-replicas.yaml
```

Then `kubectl kustomize overlays/prod/` prints the prod-ready YAML without touching `base/deployment.yaml`.

## What I'll cover next

Install Kustomize and create my first overlay with a real deployment, then experiment with common transformers like name prefix and namespace injection across multiple environments.
