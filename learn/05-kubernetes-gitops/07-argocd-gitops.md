---
last_verified: 2026-11-16
tool_version: "v3.6.1"
sources:
  - https://github.com/argoproj/argo-cd/releases/tag/v3.6.1
  - https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app_rollback/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app_history/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app_sync/
  - https://computecentral.in/cicd/argocd/
---

# Deploy per environment from Git with Argo CD

You packaged the sample app as a Helm chart with per-environment values in the previous lesson, and you saw how to promote a change from dev to prod through a CI gate. This lesson wires those pieces together with Argo CD: instead of CI pushing to the cluster, you commit a change to Git and Argo CD reconciles the cluster to match, one environment at a time.

You will run the same frontend Helm chart in both development and production, each driven by its own child Application and its own values file, all under a single root Application that watches a Git directory. This continues the app-of-apps scaffold that the Argo CD primer introduced, and it replaces the manual CI promotion with continuous reconciliation.

## What you'll learn

- Manage dev and prod with an app-of-apps — a root Application watches a Git directory of child Application manifests, and each child Application deploys one service to one environment using per-environment Helm values files.
- Change the replica count in Git and watch the cluster follow — Argo CD continuously reconciles Git (desired state) against the live cluster, reports drift as `OutOfSync`, and converges on each Git change with automated sync (default reconciliation interval 120s plus up to 60s jitter, about 3 minutes at most).
- Roll back by reverting the commit — revert the Git commit by pull request, inspect deployment history with `argocd app history`, and know that `argocd app rollback` cannot run while automated sync is enabled.

## Before you start

- [Argo CD — quick primer](../../argocd/notes/0000-primer-argocd.md) — Application, Sync, OutOfSync, Self-heal, Prune, and how to install Argo CD and reach its server.
- [Package the sample app as a Helm chart](05-helm-chart-sample-app.md) — a Helm chart with per-environment values, `helm template`, `helm upgrade --install`, and `helm rollback`.
- [Promote a change from dev to prod](../04-iac/04-environments-promotion.md) — promoting a reviewed change from dev to prod through a CI gate; here the promotion happens through Git plus Argo CD instead.
- `kubectl` installed: `kubectl version --client` prints a client version.
- `argocd` CLI installed: `argocd version --client` prints a client version.
- Argo CD v3.6.1 installed in a cluster you can reach with `kubectl` (the primer's install step).

## Walkthrough

1. Look at the app-of-apps scaffold.

   The scaffold under `argocd/templates/app-of-apps-multienv/` lays out one root Application plus one child Application per environment:

   ```bash
   find argocd/templates/app-of-apps-multienv/apps -name 'app.yaml' | sort
   ```

   You should see `apps/environments/development/app.yaml` and `apps/environments/production/app.yaml`.

   The root Application (`apps/root-application.yaml`) watches `path: apps/environments` in the Git repo and creates those child Applications automatically:

   ```yaml
   apiVersion: argoproj.io/v1alpha1
   kind: Application
   metadata:
     name: root-app
     namespace: argocd
   spec:
     project: default
     source:
       repoURL: https://github.com/example/gitops-repo.git
       targetRevision: main
       path: apps/environments
     destination:
       server: https://kubernetes.default.svc
       namespace: argocd
     syncPolicy:
       automated:
         prune: true
         selfHeal: true
   ```

   Each child Application points at the same Helm chart (`services/frontend`) but a different values file — `values/environments/development.yaml` (`replicaCount: 2`) for development and `values/environments/production.yaml` (`replicaCount: 5`) for production — and deploys into its own namespace (`frontend-dev`, `frontend-production`). See [multi-environment GitOps delivery](../../argocd/docs/multi-environment-gitops-delivery.md) for the reasoning behind splitting sync policy by environment.

2. Make sure Argo CD is installed and reachable.

   The primer installs Argo CD v3.6.1 with server-side apply, which is mandatory because the ApplicationSet CRDs exceed the client-side annotation size limit:

   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.1/manifests/install.yaml
   ```

   Reach the server and log in:

   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   argocd login localhost:8080 --username admin
   ```

3. Apply the root Application so Argo CD creates the child Applications.

   Run the bootstrap script from the scaffold root:

   ```bash
   argocd/templates/app-of-apps-multienv/bootstrap/apply-root.sh
   ```

   You should see: `Root Application applied. ArgoCD creates the child Applications under apps/environments/ on its next reconcile (default ~3 minutes).`

   Confirm Argo CD picked up both children:

   ```bash
   kubectl -n argocd get applications
   ```

   You should see `root-app`, `frontend-development`, and `frontend-production`.

4. Change the replica count in Git and watch the cluster follow.

   Edit `argocd/templates/app-of-apps-multienv/values/environments/development.yaml`, changing `replicaCount: 2` to `replicaCount: 3`, then commit and push to the Git repo Argo CD tracks.

   Argo CD reconciles Git against the live cluster on its default interval and reports drift as `OutOfSync` until it converges. To sync without waiting:

   ```bash
   argocd app sync frontend-development
   ```

   Then check the Deployment:

   ```bash
   kubectl -n frontend-dev get deployment frontend
   ```

   You should see `READY` go to `3/3` and `AVAILABLE` show 3 replicas.

   Pushing a `:latest` image tag changes nothing in Git, so Argo CD sees nothing to sync — use immutable tags or digests.

5. Roll back by reverting the commit.

   See the deployment history:

   ```bash
   argocd app history frontend-development
   ```

   You should see a list of revisions with the most recent one at the top.

   To roll back, revert the Git commit that raised the replica count through a pull request, then merge it. Argo CD sees the reverted Git state and converges the cluster back to 2 replicas. Do not run `argocd app rollback frontend-development` — while automated sync is enabled it fails with `rollback cannot be initiated when auto-sync is enabled`. Roll back in Git instead.

## Exercise

Working alone, in a copy of `argocd/templates/app-of-apps-multienv/`:

1. Add a `staging` child Application mirroring `apps/environments/production/app.yaml`, named `frontend-staging`, deploying into namespace `frontend-staging` and using `values/environments/staging.yaml`. Create `values/environments/staging.yaml` with `replicaCount: 3` and `image.tag: 1.27`. The root Application already watches the whole `apps/environments` directory, so the new child is picked up automatically — do not edit the root Application.
2. Commit the new child Application and the staging values file, push, and confirm Argo CD creates `frontend-staging` and brings it to `Synced`.
3. Change `staging.yaml` to `replicaCount: 5`, commit, push, and confirm the staging Deployment rolls to 5 replicas.
4. Revert the replica-count change in Git and confirm the staging Deployment returns to 3 replicas.

Do not paste the solution into the lesson file.

## Check your work

```bash
kubectl -n argocd get applications
```

lists `root-app` plus one child Application per environment (`frontend-development`, `frontend-production`, and your `frontend-staging`).

Each child shows `Synced` after its first sync:

```bash
argocd app get frontend-staging
```

The sync status line reads `Synced` and the health line reads `Healthy`.

The staging Deployment reflects the values file:

```bash
kubectl -n frontend-staging get deployment frontend
```

shows `READY` of `5/5` before the revert and `3/3` after you revert and re-sync.

## Common mistakes

- **Editing the cluster directly.** A manual `kubectl scale` in staging drifts from Git; Argo CD flags it `OutOfSync` and (with self-heal) reverts it on the next reconcile. Make every change in Git.
- **Rolling back with `argocd app rollback`.** It fails while automated sync is enabled (`rollback cannot be initiated when auto-sync is enabled`). Revert the Git commit instead.
- **Pushing `:latest`.** A mutable tag changes nothing in Git, so Argo CD has nothing to detect and nothing to sync. Use immutable tags or digests.

## Next

[Rego basics and testing policies](../06-policy-secrets-runtime/01-rego-basics.md)
