---
last_verified: 2026-11-15
tool_version: n/a
sources: []
---

# Package the sample app as a Helm chart

You deployed the sample app on kind with flat Kustomize manifests in the previous lesson. That works for one environment, but maintaining separate YAML for dev, staging, and prod quickly drifts. This lesson shows how to package the same app as a Helm chart with Go templates and per-environment values, then upgrade and roll back a release.

## What you'll learn

- Write a Helm chart with values per environment
- Upgrade and roll back a release

## Before you start

- [Helm — quick primer](../../helm/notes/0000-primer-helm.md) — charts, values, releases, and `helm install`/`helm upgrade`/`helm rollback`
- [Environment overlays with Kustomize](03-kustomize-overlays.md) — the sample app manifests (namespace, Deployment, Service) this chart packages
- Helm installed: `helm version` prints a version. `helm lint` and `helm template` run without a cluster, so most of this lesson can be done locally.

## Walkthrough

1. Look at the chart skeleton.

   The chart lives under `helm/charts/sample-app/` and contains `Chart.yaml` plus `values.yaml`, with per-environment overrides in `values-dev.yaml` and `values-prod.yaml`:

   ```bash
   ls helm/charts/sample-app
   ```

   `Chart.yaml` names the chart and sets its version. `values.yaml` holds defaults such as `replicaCount: 2`, `image.tag: dev`, and `service.port: 80`.

2. Write the Deployment template.

   Save this as `helm/charts/sample-app/templates/deployment.yaml`:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: sample-app
     labels:
       app: sample-app
   spec:
     replicas: {{ .Values.replicaCount }}
     selector:
       matchLabels:
         app: sample-app
     template:
       metadata:
         labels:
           app: sample-app
       spec:
         containers:
         - name: app
           image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
           imagePullPolicy: {{ .Values.image.pullPolicy }}
           ports:
           - containerPort: {{ .Values.service.targetPort }}
   ```

   Notice `replicas` and `containerPort` are **unquoted**: `replicas: {{ .Values.replicaCount }}`, not `replicas: "{{ .Values.replicaCount }}"`. Quoting a numeric template field renders it as a string (`replicas: "2"`), which Kubernetes admission rejects.

3. Write the Service template.

   Save this as `helm/charts/sample-app/templates/service.yaml`:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: sample-app
     labels:
       app: sample-app
   spec:
     type: {{ .Values.service.type }}
     selector:
       app: sample-app
     ports:
     - port: {{ .Values.service.port }}
       targetPort: {{ .Values.service.targetPort }}
       protocol: TCP
   ```

   `port` and `targetPort` are unquoted numbers too.

4. Lint the chart.

   ```bash
   helm lint helm/charts/sample-app
   ```

   You should see no errors — `helm lint` catches malformed templates and missing required fields without touching a cluster.

5. Render the dev and prod environments.

   ```bash
   helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values-dev.yaml
   helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values-prod.yaml
   ```

   Dev renders `replicas: 2` and `image: sample-app:dev-latest`. Prod renders `replicas: 5` and `image: sample-app:stable`. In both, `port: 80` and `containerPort: 8000` appear as plain numbers, not quoted strings. `helm template` renders locally with no cluster needed.

6. Upgrade and roll back a release.

   With a cluster available, install the dev release:

   ```bash
   helm upgrade --install sample-app helm/charts/sample-app --namespace sample-app --values helm/charts/sample-app/values-dev.yaml --create-namespace --wait
   ```

   Then change the image and upgrade again:

   ```bash
   helm upgrade --install sample-app helm/charts/sample-app --namespace sample-app --values helm/charts/sample-app/values-dev.yaml --set image.tag=dev-v2 --wait
   ```

   `helm history sample-app` lists the release revisions. If the new image breaks the rollout, roll back to the previous revision:

   ```bash
   helm rollback sample-app 1
   ```

   `--wait` blocks until the rollout completes; `--atomic` (used in CI) undoes the upgrade on failure so the previous release keeps serving.

## Exercise

Extend the chart skeleton under `helm/charts/sample-app/`:

1. Write `templates/deployment.yaml` and `templates/service.yaml` using the template syntax from the walkthrough, leaving numeric fields (`replicas`, `port`, `targetPort`, `containerPort`) **unquoted**.
2. Add `values-staging.yaml` with `replicaCount: 3`, `image.tag: stable`, `service.port: 80`, and `service.targetPort: 8000`.
3. Render staging:

   ```bash
   helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values.yaml --values helm/charts/sample-app/values-staging.yaml
   ```

   and confirm `replicas: 3`, `image: sample-app:stable`, `port: 80`, `containerPort: 8000`.
4. Write the `helm upgrade --install` command that deploys staging into namespace `staging`, and the `helm rollback` command that reverts it to revision 1.

## Check your work

Lint passes with no errors:

```bash
helm lint helm/charts/sample-app
```

Dev render shows plain numbers:

```bash
helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values-dev.yaml | grep -E 'replicas:|image:|port:|containerPort:'
```

You should see `replicas: 2`, `image: sample-app:dev-latest`, `port: 80`, and `containerPort: 8000` — each a plain number (for example `replicas: 2`, never `replicas: "2"`).

Staging render shows plain numbers:

```bash
helm template sample-app helm/charts/sample-app --values helm/charts/sample-app/values.yaml --values helm/charts/sample-app/values-staging.yaml | grep -E 'replicas:|image:|port:|containerPort:'
```

You should see `replicas: 3`, `image: sample-app:stable`, `port: 80`, `containerPort: 8000`.

Finally, confirm you can write the upgrade and rollback commands:

```bash
helm upgrade --install sample-app helm/charts/sample-app --namespace staging --values helm/charts/sample-app/values-staging.yaml --create-namespace --wait
helm rollback sample-app 1
```

These are correct even without a cluster to run them against.

## Common mistakes

- **Quoting numeric fields.** `replicas: "{{ .Values.replicaCount }}"` renders `replicas: "2"` (a string) and fails Kubernetes admission. Leave numerics unquoted: `replicas: {{ .Values.replicaCount }}`.
- **Forgetting `--create-namespace`.** `helm upgrade --install --namespace sample-app` fails if the namespace does not exist; add `--create-namespace` (or create it first).
- **Rolling back the wrong revision.** `helm rollback <release> <revision>` takes the revision number from `helm history <release>`, not the release name.

## Next

[Argo CD — quick primer](../../argocd/notes/0000-primer-argocd.md)
