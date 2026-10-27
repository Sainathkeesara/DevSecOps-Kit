---
last_verified: 2026-10-27
tool_version: n/a
sources:
  - https://github.com/smantzou/app-of-apps-meetup-demo
  - https://cloudaqube.com/blog/gitops-argocd-tutorial
  - https://shattered.io/argo-cd-tutorial-gitops-kubernetes-12-steps-2026/
---

# ArgoCD App of Apps — Multi-Environment GitOps Scaffold

> A scaffold for the ArgoCD "App of Apps" pattern: one root Application watches a directory of child Applications, one per environment (development, staging, production). This is one way to lay it out; the docs also suggest ApplicationSets as an alternative, so treat this as a starting point rather than the only layout.

## Purpose

The App of Apps pattern keeps a single GitOps repository as the source of truth for every environment. A root Application points ArgoCD at a folder of child Application manifests; ArgoCD creates those child Applications and each one syncs its own set of services. Splitting by environment means a sync failure in development cannot block production, and each team can promote at its own pace.

## When to use

- You run more than one environment (dev, staging, prod) off the same GitOps repo.
- You want per-environment Applications so a bad sync in one environment does not cascade to the others.
- You are comfortable with ArgoCD already installed in the cluster (this scaffold assumes ArgoCD is running).

## Prerequisites

- ArgoCD installed and reachable in the target cluster (the root Application lives in the `argocd` namespace).
- `kubectl` configured to talk to that cluster.
- A Git repository to hold the scaffold (copy this folder into it as the GitOps root).

## Directory layout

```
.
├── apps/
│   ├── root-application.yaml   # Parent Application: watches apps/environments/
│   └── environments/
│       ├── development/
│       │   └── app.yaml        # Child Application for development
│       ├── staging/
│       │   └── app.yaml        # Child Application for staging
│       └── production/
│           └── app.yaml        # Child Application for production
├── services/
│   └── frontend/
│       ├── Chart.yaml          # Helm chart for the sample frontend service
│       └── values.yaml         # Base values shared across environments
├── values/
│   └── environments/
│       ├── development.yaml    # Environment-specific values override
│       ├── staging.yaml
│       └── production.yaml
└── bootstrap/
    └── apply-root.sh           # Applies the root Application to the cluster
```

## Steps to adopt

1. Copy this folder into your GitOps repository as its root.
2. Edit `apps/root-application.yaml`: set `spec.source.repoURL` to your GitOps repo URL and `targetRevision` to your default branch.
3. Edit each `apps/environments/<env>/app.yaml`: set `spec.source.repoURL` to the same repo, and adjust the destination namespace per environment if needed.
4. Tune `values/environments/<env>.yaml` per environment (replica counts, image tags, ingress).
5. Run `bootstrap/apply-root.sh` to create the root Application. ArgoCD then reads `apps/environments/` and creates one child Application per environment.
6. Verify each child Application reaches `Synced` and `Healthy` before promoting to the next environment.

## Verify

- `kubectl -n argocd get applications` lists `root-app` plus one child Application per environment.
- Each child Application shows `Synced` and `Healthy` after its first sync.
- Changing `values/environments/development.yaml` and pushing to the repo rolls the new values into the development namespace only; staging and production are untouched.
- A manual `kubectl` edit of a development resource drifts back to Git on the next ArgoCD reconcile.

## References

- [App of Apps pattern demo](https://github.com/smantzou/app-of-apps-meetup-demo)
- [ArgoCD GitOps tutorial](https://cloudaqube.com/blog/gitops-argocd-tutorial)
- [ArgoCD GitOps tutorial — pitfalls and prune/drift](https://shattered.io/argo-cd-tutorial-gitops-kubernetes-12-steps-2026/)
