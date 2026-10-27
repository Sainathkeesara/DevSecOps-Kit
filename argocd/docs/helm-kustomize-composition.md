---
last_verified: 2026-10-27
tool_version: n/a
sources:
  - https://argo-cd.readthedocs.io/en/stable/user-guide/helm
  - https://argo-cd.readthedocs.io/en/release-3.4/user-guide/kustomize/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/parameters
---

# Helm + Kustomize composition in ArgoCD

## Purpose

Combine Helm rendering with Kustomize overlays so a single ArgoCD Application can pull a chart from a registry, then apply environment-specific patches on top.

## When to use

- A team ships a third-party chart (e.g. ingress-nginx) but needs org-specific patches (labels, annotations, extra containers) without forking the chart.
- Different environments need different values plus resource patches that Kustomize handles better than Helm values (JSON patches, strategic merges).

## Prerequisites

- ArgoCD 2.x with Kustomize and Helm support enabled (both ship by default).
- A Git repo layout with a `kustomization.yaml` that references the chart via the `helmCharts` field or via `--enable-helm` build option.

## Patterns

### Pattern 1 — Kustomize `helmCharts` (recommended)

Declare the chart inside `kustomization.yaml` and let Kustomize render it before applying patches.

```yaml
# kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
helmCharts:
  - name: ingress-nginx
    repo: <chart-repo-url>
    version: 4.x
    releaseName: ingress-nginx
    namespace: ingress
    valuesFile: values.yaml
patches:
  - path: patch-extra-labels.yaml
```

ArgoCD detects `helmCharts` and renders the chart automatically; no `--enable-helm` flag needed.

### Pattern 2 — `--enable-helm` build option

For overlays that use Kustomize's Helm inflator generator, enable Helm rendering in the Application's build options.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  source:
    path: overlays/prod
    kustomize:
      buildOptions: "--enable-helm"
```

Use this when the overlay calls `helm template`-style generators internally.

## Pitfalls

- **Double rendering**: declaring the chart both in `helmCharts` and passing `--enable-helm` renders it twice, producing duplicate resources. Pick one.
- **Value file globs**: `valueFiles` supports globs, but ordering matters — later files override earlier ones. Keep a single base `values.yaml` plus per-env files.
- **Parameter overrides drift**: CLI/UI overrides are not tracked in Git. Prefer `.argocd-source.yaml` in the app directory for Git-tracked overrides, or commit values files.
- **Sync waves**: when composing Helm + Kustomize, use sync waves to order CRD installation before controllers.
- **Prune with care**: Kustomize-generated resources are owned by ArgoCD; enabling prune on mixed charts can delete resources managed by the chart's hooks.

## Verify

```bash
argocd app sync <app> --dry-run
argocd app diff <app>
```

Confirm the rendered manifest includes both the chart resources and the patch-applied changes.

## References

- https://argo-cd.readthedocs.io/en/stable/user-guide/helm
- https://argo-cd.readthedocs.io/en/release-3.4/user-guide/kustomize/
- https://argo-cd.readthedocs.io/en/stable/user-guide/parameters
