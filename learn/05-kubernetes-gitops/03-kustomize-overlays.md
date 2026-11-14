---
last_verified: 2026-11-14
tool_version: n/a
sources: []
---

# Environment overlays with Kustomize

You deployed the sample app on kind in the previous lesson with flat manifests you applied one file at a time. That works for one environment, but it breaks down the moment you need dev, staging, and prod to differ — you end up copying YAML and drifting the copies apart. This lesson shows how Kustomize keeps one base manifest set and applies environment-specific overlays on top, so you never edit the base for a particular environment.

## What you'll learn

- Write a base and dev/prod overlays for the app
- Explain when to use an overlay instead of a chart

## Before you start

- [Deploy and debug the sample app on kind](02-k8s-deploy-sample-app.md) — you should have a running kind cluster with the sample app Deployment, Service, namespace, and RBAC from the previous lesson
- kubectl with kustomize built in: `kubectl kustomize --help` should print usage (kustomize ships inside kubectl, no separate install needed)

## Walkthrough

1. Look at the base.

   The base lives under `kustomize/configs/environment-overlays/base/` and holds the Deployment, Service, and ConfigMap from the previous lesson, plus a `kustomization.yaml` that lists them and sets a shared namespace and name prefix:

   ```yaml
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization

   resources:
     - deployment.yaml
     - service.yaml
     - configmap.yaml

   commonLabels:
     app: sample-app
     managed-by: kustomize

   namePrefix: sample-app-

   namespace: sample-app
   ```

   Render it to see what Kustomize produces from the base alone:

   ```bash
   kubectl kustomize kustomize/configs/environment-overlays/base
   ```

   You should see the Deployment, Service, and ConfigMap YAML one after another, each carrying the `sample-app-` name prefix and the `sample-app` namespace.

2. Create the dev overlay.

   Save this as `kustomize/configs/environment-overlays/overlays/dev/kustomization.yaml`:

   ```yaml
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization

   resources:
     - ../../base

   namePrefix: dev-

   namespace: development

   commonLabels:
     env: debug

   images:
     - name: sample-app
       newTag: dev-latest
   ```

   It references the base with `../../base`, adds the `dev-` prefix so dev resources don't collide with prod, switches to the `development` namespace, and retags the image to `dev-latest`. Render it:

   ```bash
   kubectl kustomize kustomize/configs/environment-overlays/overlays/dev
   ```

   You should see the Deployment named `dev-sample-app`, running in namespace `development`, with image `sample-app:dev-latest`.

3. Create the prod overlay.

   Save this as `kustomize/configs/environment-overlays/overlays/prod/kustomization.yaml`:

   ```yaml
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization

   resources:
     - ../../base

   namespace: production

   commonLabels:
     env: production

   images:
     - name: sample-app
       newTag: stable

   patches:
     - path: patch-deployment.yaml
   ```

   And the patch it references, `kustomize/configs/environment-overlays/overlays/prod/patch-deployment.yaml`:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: sample-app
   spec:
     replicas: 5
   ```

   Prod keeps the base resource names (no prefix), moves to the `production` namespace, pins the image to `stable`, and scales the Deployment to five replicas via a strategic merge patch:

   ```bash
   kubectl kustomize kustomize/configs/environment-overlays/overlays/prod
   ```

   You should see `replicas: 5`, namespace `production`, and image `sample-app:stable`.

4. Compare dev and prod side by side.

   ```bash
   kubectl kustomize kustomize/configs/environment-overlays/overlays/dev | grep -E 'namespace:|name:|image:|replicas:'
   kubectl kustomize kustomize/configs/environment-overlays/overlays/prod | grep -E 'namespace:|name:|image:|replicas:'
   ```

   Dev should report `namespace: development`, `image: sample-app:dev-latest`, and `replicas: 2` (inherited from the base). Prod should report `namespace: production`, `image: sample-app:stable`, and `replicas: 5` (from the patch). Notice the base files never changed — only the overlays differ.

## When to use an overlay instead of a chart

Use a Kustomize overlay when you have one set of Kubernetes manifests that needs small, environment-specific variations (namespace, replica count, image tag, labels) and you want to stay in pure YAML with no templating language. The output is exactly what the overlays describe, which makes it easy to review and diff.

Use a Helm chart instead when you need to generate many related resources from templates, distribute the app as a versioned package to other teams, or let end users override values through a `values.yaml` without touching the manifests. Kustomize overlays and Helm charts solve overlapping problems; overlays are the lighter choice when you already keep manifests in the same repo as your application code.

## Exercise

Create a staging overlay from scratch, without copying the walkthrough blocks verbatim:

- A directory `kustomize/configs/environment-overlays/overlays/staging/` with its own `kustomization.yaml` that references `../../base`
- The staging namespace set to `staging`
- The image retagged to `stable` (same image as prod, different namespace)
- Three replicas

Then render it and confirm the staging Deployment runs three replicas in the `staging` namespace.

## Check your work

Run:

```bash
kubectl kustomize kustomize/configs/environment-overlays/overlays/staging | grep -E 'namespace:|replicas:|image:'
```

You should see exactly one `namespace: staging`, one `replicas: 3`, and `image: sample-app:stable`. Then confirm the base is untouched:

```bash
grep 'namespace:' kustomize/configs/environment-overlays/base/kustomization.yaml
```

which should still print `namespace: sample-app`.

## Common mistakes

- **Patching the wrong name.** If you add `namePrefix: dev-` to an overlay and then write a patch targeting `name: sample-app`, the patch will not match because Kustomize renamed the resource to `dev-sample-app`. Either skip the prefix or target the prefixed name.
- **Editing the base for one environment.** The base is the source of truth for what every environment shares; environment-specific values belong in overlays, never in `base/`.
- **Forgetting `imagePullPolicy: Never`** on locally-built images you later `kubectl apply` to kind, so kind's nodes try to pull from a registry and fail.

## Next

[Helm — quick primer](../../helm/notes/0000-primer-helm.md)
