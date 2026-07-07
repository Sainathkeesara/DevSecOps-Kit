---
last_verified: 2026-07-06
tool_version: n/a
sources:
  - https://argo-cd.readthedocs.io/en/latest/getting_started/
---

# ArgoCD — quick primer

> First-day notes for someone who's never used ArgoCD. Personal voice, plain language.

## What is it?

ArgoCD is a GitOps tool for Kubernetes. Think of it as "the opposite of `kubectl apply`": instead of pushing changes to the cluster from your laptop, you declare the desired state in a Git repo, and ArgoCD continuously pulls that state into the cluster and makes reality match it.

The closest analogy is a thermostat. You set the temperature (the Git repo), the thermostat (ArgoCD) measures the room (the cluster), and if they differ it adjusts until the room matches the setting. The Git repo is the single source of truth.

## What does it do?

It watches a Git repository for manifests (Helm, Kustomize, or plain YAML), compares them to what's actually running in the cluster, and syncs the cluster to match. When someone edits the cluster by hand, ArgoCD flags it as "out of sync" so you can see drift.

## Why does it exist?

Before GitOps, teams ran `kubectl apply` from CI pipelines or ops laptops. That works until someone hotfixes a pod directly in the cluster and the next deploy clobbers it — or until nobody remembers what "production" is supposed to look like. ArgoCD makes the Git repo the authority, so every change is reviewable, reversible, and auditable.

## Key terminology

- **Application** — a tracked resource binding a Git source to a Kubernetes destination. Example: `argocd app create guestbook --repo ... --path guestbook`.
- **Sync** — the act of making the cluster match Git. Example: `argocd app sync guestbook`.
- **Out of sync** — cluster state differs from Git. Example: someone manually edited a Deployment replica count.
- **Self-heal** — auto-revert cluster drift back to Git on each reconcile. Example: set `syncPolicy.automated.selfHeal: true`.
- **Prune** — delete cluster resources that no longer exist in Git. Example: set `prune: true` or risk orphaned resources.
- **Repository** — the Git URL ArgoCD reads manifests from. Example: `argocd repo add https://github.com/me/apps.git`.
- **Health** — ArgoCD's view of whether a resource is running correctly (e.g. Pods Ready). Example: an app shows "Healthy" once its Deployment is available.

## A tiny example

```bash
# Install ArgoCD into its own namespace
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Get the initial admin password (stored in a Secret)
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

This drops ArgoCD into a cluster and prints the login password. After this you point it at a Git repo and let it sync.

## What I'll cover next

Next I'll actually install ArgoCD on a local cluster and deploy a sample app (argocd-002), then write my first Application manifest by hand (argocd-003). After that I want to understand sync waves and the difference between `selfHeal` and `prune`.
