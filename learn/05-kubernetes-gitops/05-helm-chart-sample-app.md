---
last_verified: 2026-11-15
tool_version: n/a
sources: []
---

# Package the sample app as a Helm chart

In the previous lesson you ran the sample app on kind with flat Kustomize manifests, one file per environment. That works, but every environment needs its own copy of the YAML. This lesson shows how to bundle the app into a single Helm chart, use per-environment values files to vary replica count and image tag without touching the templates, and then install, upgrade, and roll back a release — Helm's take on environment-specific configuration, with release tracking built in.

## What you'll learn

- Scaffold a Helm chart and inspect its structure (Chart.yaml, values.yaml, templates/)
- Template the chart with `helm template` and review the rendered manifests before installing
- Use per-environment values files (`values-dev.yaml`, `values-prod.yaml`) to configure dev and prod without copying YAML
- Install, upgrade, and roll back a Helm release with `helm install`, `helm upgrade`, and `helm rollback`

## Before you start

- [Helm — quick primer](../../helm/notes/0000-primer-helm.md) — Helm concepts (chart, release, values.yaml) and basic commands like `helm install`, `helm list`, and `helm uninstall`
- [Environment overlays with Kustomize](03-kustomize-overlays.md) — the idea of environment-specific variation; here you do the same thing with Helm values instead of Kustomize overlays
- Helm installed: `helm version` should print a version; kubectl is optional for verifying rendered output

## Walkthrough

1. Scaffold the chart.

   ```bash
   helm create helm/charts/sample-app
   ```

   You should see `helm create` report that it created the chart directory with Chart.yaml, values.yaml, and a templates/ folder. The chart files for this lesson already exist under `helm/charts/sample-app/` — open them to follow along without running `helm create` again.

2. Inspect the chart structure.

   `helm/charts/sample-app/Chart.yaml`:

   ```yaml
   apiVersion: v2
   name: sample-app
   description: A Helm chart for the sample app
   type: application
   version: 0.1.0
   appVersion: "1.0.0"
   ```

   `apiVersion: v2` marks this as a Helm 3 chart. `version` is the chart version (bump it when you change the chart); `appVersion` is the version of the application the chart deploys.

   `helm/charts/sample-app/values.yaml`:

   ```yaml
   replicaCount: 2
   image:
     repository: sample-app
     tag: dev
     pullPolicy: Never
   service:
     type: ClusterIP
     port: 80
     targetPort: 8000
   ```

   `values.yaml` holds the default configuration. Templates reference these values with `{{ .Values.… }}` Go template syntax.

3. Render the chart without installing.

   ```bash
   helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values.yaml
   ```

   You should see rendered Deployment and Service YAML with `sample-app:dev` as the image and `replicas: 2`. Nothing is created in a cluster — `helm template` only prints what would be installed.

   Lint the chart to catch template errors early:

   ```bash
   helm lint helm/charts/sample-app
   ```

   You should see no errors.

4. Add per-environment values files.

   `helm/charts/sample-app/values-dev.yaml`:

   ```yaml
   replicaCount: 1
   image:
     tag: dev-latest
   ```

   And `helm/charts/sample-app/values-prod.yaml`:

   ```yaml
   replicaCount: 3
   image:
     tag: stable
   ```

   Each file overrides only the values that differ from `values.yaml`. Render both to confirm:

   ```bash
   helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values-dev.yaml | grep -E 'replicas:|image:'
   helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values-prod.yaml | grep -E 'replicas:|image:'
   ```

   Dev should render `replicas: 1` and `image: sample-app:dev-latest`. Prod should render `replicas: 3` and `image: sample-app:stable`. One chart, two environments — no copied YAML.

5. Install the dev release.

   ```bash
   helm install sample-app-dev helm/charts/sample-app \
     --namespace development \
     --values helm/charts/sample-app/values-dev.yaml \
     --create-namespace
   ```

   You should see `NAME: sample-app-dev` and a list of created resources. `helm list --namespace development` shows the release.

6. Upgrade the release.

   Change the dev replica count to 2:

   ```bash
   helm upgrade sample-app-dev helm/charts/sample-app \
     --namespace development \
     --values helm/charts/sample-app/values-dev.yaml \
     --set replicaCount=2
   ```

   `helm list --namespace development` now shows revision 2. `--set` overrides the values file, as shown in [values-file vs set flags](../../helm/configs/values-file-vs-set-flags.yaml).

7. Roll back the release.

   If the upgrade introduced a problem, roll back to the previous revision:

   ```bash
   helm rollback sample-app-dev 1 --namespace development
   ```

   You should see `The release has been rolled back.` `helm history sample-app-dev --namespace development` lists the revisions, and `helm list --namespace development` shows the release back at revision 1.

## Exercise

Create a staging release from scratch without copying the walkthrough blocks verbatim:

- Render `helm/charts/sample-app` with `values-prod.yaml` and confirm `replicas: 3` and `image: sample-app:stable`
- Install a staging release named `sample-app-staging` in namespace `staging` using `values-dev.yaml` plus `--set replicaCount=3`
- Check `helm list --namespace staging` shows the release, then roll it back to revision 1 after a fake "bad upgrade" (`helm upgrade … --set replicaCount=99` followed by `helm rollback`)

## Check your work

Run:

```bash
helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values-prod.yaml | grep -E 'replicas:|image:'
```

You should see `replicas: 3` and `image: sample-app:stable`.

Then:

```bash
helm history sample-app-dev --namespace development
```

You should see at least two revisions (install and upgrade/rollback).

## Common mistakes

- **Editing templates instead of values.** Environment-specific values belong in values files, not in `templates/*.yaml`. Editing templates per environment defeats the purpose of a single chart.
- **Forgetting `--create-namespace`.** If the target namespace does not exist, `helm install` fails unless you add `--create-namespace`.
- **Confusing `helm install` with `helm upgrade`.** `install` creates a new release (and fails if the name exists); `upgrade --install` creates or updates idempotently.

## Next

[Argo CD — quick primer](../../argocd/notes/0000-primer-argocd.md)
