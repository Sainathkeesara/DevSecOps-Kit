---
last_verified: 2026-10-24
tool_version: n/a
sources: []
---

# How I wired Kustomize into my manifest workflow

## Purpose

This document describes a practical pattern for integrating Kustomize into a Kubernetes manifest workflow that spans multiple environments (dev, staging, prod) with a CI/CD pipeline. The approach keeps base manifests DRY, uses overlays for environment-specific configuration, and renders final YAML in CI before ArgoCD or kubectl apply.

## When to use

- You manage Kubernetes manifests directly (no Helm charts) and want environment separation without duplication.
- Your team prefers pure YAML over templating languages.
- You need a GitOps-friendly render step that produces auditable output.
- You already use `kubectl` and want to leverage the built-in Kustomize (`kubectl kustomize`) for simplicity, with the standalone binary as an option for advanced features.

## Prerequisites

- `kubectl` v1.28+ (includes Kustomize v5.x built-in)
- Optional: standalone `kustomize` binary v5.4+ for alpha plugins or `--enable-helm`
- A Git repository for manifests (monorepo or dedicated manifests repo)
- CI pipeline that can run `kubectl kustomize` or `kustomize build`
- Basic understanding of Kustomize bases, overlays, patches, and transformers (see the primer and quickstart notes in `kustomize/notes/`)

## Repository layout

```
manifests/
├── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── secret.yaml
├── overlays/
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   ├── patches/
│   │   │   ├── replicas.yaml
│   │   │   └── resources.yaml
│   │   └── configmap-dev.yaml
│   ├── staging/
│   │   ├── kustomization.yaml
│   │   ├── patches/
│   │   │   ├── replicas.yaml
│   │   │   └── resources.yaml
│   │   └── configmap-staging.yaml
│   └── prod/
│       ├── kustomization.yaml
│       ├── patches/
│       │   ├── replicas.yaml
│       │   └── resources.yaml
│       └── configmap-prod.yaml
└── components/           # Optional: reusable component patterns
    ├── monitoring/
    │   ├── kustomization.yaml
    │   └── servicemonitor.yaml
    └── ingress/
        ├── kustomization.yaml
        └── ingress.yaml
```

This layout is one way to organize it; the docs also suggest a flatter structure with `components/` at the same level as `base/`. Choose what matches your team's mental model.

## Base kustomization

```yaml
# manifests/base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
  - configmap.yaml
  - secret.yaml

commonLabels:
  app.kubernetes.io/managed-by: kustomize
  app.kubernetes.io/part-of: my-platform

configMapGenerator:
  - name: app-config
    files:
      - config.yaml=config/app.yaml
    behavior: replace

secretGenerator:
  - name: app-secrets
    envs:
      - secrets/env.list
    behavior: replace

generatorOptions:
  disableNameSuffixHash: true
  labels:
    app.kubernetes.io/component: config
  annotations:
    config.kubernetes.io/local-config: "true"
```

Key points:
- `generatorOptions.disableNameSuffixHash: true` with `behavior: replace` lets the ConfigMap/Secret update in-place when the source file changes, without breaking Deployment references.
- `commonLabels` applies to every resource, which helps selectors stay in sync (unlike `namePrefix` which only affects names).

## Environment overlays

Each overlay references the base and adds environment-specific transforms.

```yaml
# manifests/overlays/dev/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: dev

resources:
  - ../../base

patches:
  - path: patches/replicas.yaml
    target:
      kind: Deployment
  - path: patches/resources.yaml
    target:
      kind: Deployment

configMapGenerator:
  - name: app-config
    files:
      - config.yaml=config/app-dev.yaml
    behavior: replace

commonAnnotations:
  environment: development
  last-updated-by: "ci-pipeline"
```

```yaml
# manifests/overlays/dev/patches/replicas.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
```

```yaml
# manifests/overlays/dev/patches/resources.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    spec:
      containers:
        - name: my-app
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "512Mi"
```

Staging and prod overlays follow the same pattern with different values (replicas: 3/5, higher resource limits, namespace: staging/prod, prod adds `commonAnnotations.environment: production`).

## CI render and validate step

In CI, render each overlay and validate the output before promoting. This catches drift, missing patches, or malformed YAML early.

```yaml
# .github/workflows/render-manifests.yaml (example)
name: Render and Validate Manifests

on:
  push:
    branches: [main]
    paths:
      - 'manifests/**'
  pull_request:
    paths:
      - 'manifests/**'

jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Render dev overlay
        run: |
          mkdir -p rendered/dev
          kubectl kustomize manifests/overlays/dev > rendered/dev/all.yaml
          echo "::notice::Rendered dev: $(wc -l rendered/dev/all.yaml) lines"

      - name: Render staging overlay
        run: |
          mkdir -p rendered/staging
          kubectl kustomize manifests/overlays/staging > rendered/staging/all.yaml

      - name: Render prod overlay
        run: |
          mkdir -p rendered/prod
          kubectl kustomize manifests/overlays/prod > rendered/prod/all.yaml

      - name: Validate with kubeconform
        uses: docker://ghcr.io/yannh/kubeconform:v0.6.7
        with:
          args: -strict -schema-location default -schema-location 'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/{{.NormalizedKubernetesVersion}}-standalone{{.KindSuffix}}.json' rendered/

      - name: Check for secrets in rendered output
        run: |
          if grep -r "password:\|secret:\|token:" rendered/ --include="*.yaml" | grep -v "^Binary"; then
            echo "::error::Potential secret found in rendered manifests"
            exit 1
          fi

      - name: Upload rendered manifests as artifact
        uses: actions/upload-artifact@v4
        with:
          name: rendered-manifests
          path: rendered/
          retention-days: 7
```

This workflow:
1. Renders each overlay to a flat YAML file (one per environment).
2. Runs `kubeconform` for schema validation against the target Kubernetes version.
3. Scans for accidental secrets in the rendered output.
4. Publishes the rendered manifests as an artifact for the deployment job or ArgoCD to consume.

## Image promotion without editing YAML

Use `kustomize edit set image` in CI to update image tags across environments. This avoids manual YAML edits and keeps the promotion auditable.

```bash
# In CI after building and pushing the image
IMAGE_TAG="${{ github.sha }}"
kustomize edit set image my-app=ghcr.io/myorg/my-app:${IMAGE_TAG}
```

Run this in a temporary clone of the manifests repo, commit the updated `kustomization.yaml` files, and push. ArgoCD detects the change and syncs. The standalone `kustomize` binary is preferred here because `kubectl kustomize` lacks the `edit` subcommand.

## Component reuse (optional)

For cross-cutting concerns like monitoring, ingress, or sidecars, define components that overlays can opt into.

```yaml
# manifests/components/monitoring/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - servicemonitor.yaml
```

```yaml
# manifests/overlays/prod/kustomization.yaml (addition)
components:
  - ../../components/monitoring
  - ../../components/ingress
```

Components are composable and keep overlays clean. The docs also show a `helmCharts` field for inflating Helm charts directly in Kustomize (requires `--enable-helm` in the standalone binary and the `argocd-cm` ConfigMap for ArgoCD).

## Verify

After rendering, verify the output manually or in CI:

```bash
# Render and inspect
kubectl kustomize manifests/overlays/prod | head -100

# Dry-run apply to check for server-side validation errors
kubectl apply --dry-run=server -k manifests/overlays/prod

# Diff against live cluster (if kubectl context is set)
kubectl diff -k manifests/overlays/prod
```

Expected outcomes:
- Rendered YAML contains all resources from base + overlay patches.
- `kubeconform` passes with no schema violations.
- `kubectl diff` shows only intentional changes (replica count, image tag, config values).

## Common errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `no matches for kind "Deployment" in version "apps/v1"` | Patch target selector missing `group`, `version`, `kind` | Add `target:` block with full GVK to each patch entry |
| `Service selector does not match Deployment labels` | `namePrefix` applied but `commonLabels` not used | Replace `namePrefix` with `commonLabels` in overlay, or add `commonLabels` to sync selectors |
| ConfigMap not updating on file change | `generatorOptions.disableNameSuffixHash` missing or `behavior: create` (default) | Set `disableNameSuffixHash: true` and `behavior: replace` in base `generatorOptions` |
| `kubectl apply -k` fails with "resource mapping not found" | CRD not installed in cluster before applying | Install CRDs first (e.g., cert-manager CRDs from the project's release page) |
| `kubeconform` rejects valid-looking YAML | Schema version mismatch or strict mode | Match `--kubernetes-version` to your cluster version; use `-strict` only when needed |

## References

- Kustomize primer: `kustomize/notes/0000-primer-kustomize.md`
- Quickstart trip-ups: `kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md`
- Tutorial script: `kustomize/scripts/2026-10-20-kustomize-tutorial.sh`