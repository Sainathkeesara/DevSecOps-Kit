---
last_verified: 2026-09-23
tool_version: "v3.5.2"
sources:
  - https://github.com/argoproj/argo-cd/releases/tag/v3.5.2
  - https://github.com/argoproj/argo-cd/blob/master/docs/user-guide/best_practices.md
---

# How I wired ArgoCD into my GitOps workflow

## Purpose

This doc records one way to go from an empty cluster to ArgoCD deploying from Git. I started from the pinned install, synced a first plain-YAML Application, then grew the layout along the documented ladder (plain YAML, then Kustomize overlays, then Helm per-env values, then an app-of-apps root). The docs also describe ApplicationSets as an alternative, so treat this as one working path rather than the only layout.

## When to use

Use this path when a team wants Git as the single source of truth for what runs in the cluster and wants deploys to happen by merging rather than by running commands against the cluster. It fits a service with plain manifests today that may need per-environment differences later.

## Prerequisites

- A Kubernetes cluster with `kubectl` pointing at it.
- A Git repo for Kubernetes manifests, kept separate from the application source repo (more on why below).

## Steps

### 1. Install ArgoCD from a pinned release manifest

I create the namespace first, then apply the install manifest pinned to the release tag I am running. The server-side flags are required because of CRD size limits:

```bash
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.2/manifests/install.yaml
```

One thing I learned: do not use a floating install URL (the `stable` path). Pinning the manifest to the release tag means the manifests cannot silently change meaning when a new release ships.

### 2. Keep manifests in a separate Git repo from app source

I put the Kubernetes manifests in their own repo instead of alongside the application code. The reasons that convinced me: config-only changes (like bumping replicas) no longer trigger full CI builds, the audit log stays clean, write access can be split between app developers and whoever owns deploys, and CI cannot loop forever writing image tags back into the repo it just built from.

### 3. Sync a first plain-YAML Application

The smallest thing I got working was a single Application pointing at a directory of plain manifests, with an automatic sync policy so every merge to the tracked revision deploys itself. Seeing the Application flip to synced and healthy in the UI after the first sync is the moment the workflow clicks.

### 4. Grow into Kustomize overlays per environment

Once one environment worked, I added a `base/` plus one overlay per environment (`overlays/dev`, `overlays/staging`, `overlays/prod`), with one Application per overlay. Each overlay stays a small patch set on top of the shared base, so dev-only tweaks never leak into the prod overlay.

### 5. Move to Helm with per-environment value files when values diverge

When the differences between environments became mostly values rather than patches, the Helm shape fit better: one chart with a shared `values.yaml` plus a per-environment file such as `values-prod.yaml` referenced through the Application's value files. This is one step on the ladder, not a requirement — plain YAML or Kustomize remain fine if they cover the need.

### 6. Wrap it with an app-of-apps root Application

The last step I took was a root Application whose only job is to sync the directory holding all the other Applications. Adding a service then means adding its Application manifest to Git rather than clicking through the UI, which keeps the whole setup reproducible from the repo alone.

### Antipatterns I avoided

- Tracking `replicas` in Git while a Horizontal Pod Autoscaler owns the field. I omit `replicas` from the manifests and leave room for imperativeness where a controller owns the field.
- Pinning a remote Kustomize or Helm base to a branch head. I pin to a Git tag or commit SHA so the base cannot change meaning overnight.

## Verify

- `kubectl get applications -n argocd` lists each Application I created.
- Every Application reports synced and healthy in the ArgoCD UI after its first sync.
- Merging a manifest change to the tracked revision flips the affected Application to out-of-sync and then back to synced without anyone touching the cluster directly.

## References

- [ArgoCD best practices](https://github.com/argoproj/argo-cd/blob/master/docs/user-guide/best_practices.md)
- [ArgoCD v3.5.2 release](https://github.com/argoproj/argo-cd/releases/tag/v3.5.2)
