---
last_verified: 2026-09-19
tool_version: "v3.5.3"
sources:
  - https://cloudaqube.com/blog/gitops-argocd-tutorial
  - https://github.com/argoproj/argo-cd/releases/tag/v3.5.3
  - https://github.com/ShandilyaM/gitops-argocd-microservices
  - https://github.com/HrushiYadav/argocd-gitops
---

# How I wired ArgoCD into a multi-environment GitOps delivery workflow

## Purpose

This doc describes one way to run dev, staging, and prod off a single GitOps repo with ArgoCD doing the deploying. I wrote it after working through the guestbook starter and a multi-env microservices reference; the pattern below is what I would copy for the next service. The docs also suggest alternatives (ApplicationSets, app-of-apps), so treat this as a starting point rather than the only layout.

## Prerequisites

- A Kubernetes cluster with ArgoCD v3.5.3 installed. I installed it with `kubectl create namespace argocd` followed by a server-side apply of `install.yaml` — server-side apply is mandatory because the ApplicationSet CRDs exceed the client-side annotation size limit. I reach the UI with `kubectl port-forward svc/argocd-server -n argocd 8080:443` and grab the initial admin password from the `argocd-initial-admin-secret` secret, which I delete after the first login.
- A Git repo holding both the app manifests and the per-environment values (the GitOps repo). CI builds and tests but never touches the cluster directly.

## Steps

### 1. Lay out one directory per environment

I keep a shared Helm chart and one values file per environment (`values-dev.yaml`, `values-staging.yaml`, `values-prod.yaml`). The smallest version of this I got working first was the guestbook starter: manifests in `apps/guestbook/` (a Deployment on image `gcr.io/google-samples/gb-frontend:v5` with 2 replicas plus a Service), synced from `path: apps/guestbook` with `targetRevision: main` and destination server (https://kubernetes.default.svc), namespace `guestbook`, and `syncOptions: [CreateNamespace=true]`.

### 2. Create one Application per environment

Each environment gets its own Application pointing at the same repo but a different values file. The per-service, per-env split matters: one giant Application means a single sync failure blocks every team, so I scope Applications per team or service.

### 3. Split sync policy by environment

Dev and staging run auto-sync so every merge to main deploys itself within a few minutes (ArgoCD polls roughly every 3 minutes, or I configure a webhook for faster pickup). Prod stays manual — I promote with `argocd app sync <service>-prod` after staging looks good. The reference I followed gates prod further with a canary (steps of 10/25/50/100 percent) backed by a Prometheus analysis check that aborts the rollout if HTTP 5xx errors cross 1 percent over 5 minutes, scaling the canary back down automatically.

### 4. Keep CI and CD separated

CI builds the image, runs tests, pushes a tagged image, then updates the image tag in the GitOps repo as a commit. ArgoCD notices the new commit and syncs. CI never holds cluster credentials — only ArgoCD writes to the cluster. Using immutable image tags (or digests) is what makes this work; with a mutable tag ArgoCD cannot detect that anything changed.

### 5. Leave the safety catches on until the manifests earn trust

Two settings I deliberately start conservative: I run with `prune: false` for about a week because a mistyped `path:` that matches zero resources combined with `prune: true` can delete live workloads, and I run auto-sync without self-heal in staging and prod so an emergency `kubectl` fix does not get reverted out from under me before I have committed it. The guestbook self-heal demo (scaling the Deployment to 5 replicas and watching Git's 2 replicas reassert itself within a minute) is a good lab exercise for seeing this behavior before enabling it anywhere real. Secrets stay out of plain Git entirely — Sealed Secrets, the External Secrets Operator, or SOPS instead.

## Verify

- Each Application shows `Synced` and `Healthy` in the ArgoCD UI after its first manual sync.
- Merging a manifest change to main flips dev to `OutOfSync` and then back to `Synced` without anyone clicking anything.
- Prod stays `OutOfSync` until I explicitly run the sync command for the prod Application.
- Changing an image tag commit in the GitOps repo rolls the new image out; pushing a `latest` tag does nothing visible, confirming immutable tags are required.

## What I'd try next

The next step I want to try is replacing the hand-created per-env Applications with an ApplicationSet using the git generator, so adding a service is just adding one new manifest file with no ArgoCD config changes — the local Kind plus app-of-apps starter template lays out exactly that shape with a bootstrap script, a root Application, and per-app charts. After that I want to attempt the canary analysis gate in a lab cluster before trusting it anywhere shared.
