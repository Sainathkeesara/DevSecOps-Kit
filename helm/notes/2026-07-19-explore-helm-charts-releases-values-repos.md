---
last_verified: 2026-07-19
tool_version: n/a
sources: []
---

# Exploring Helm — charts, releases, values, and repositories

> First-person notes from poking around Helm after the primer. What worked, where I got stuck, and what I'd try next.

## Charts

I created a chart with `helm create my-app` and opened the folder. The `templates/` directory holds Kubernetes manifest templates, and `values.yaml` has defaults. I changed `replicaCount` from 1 to 3 and ran `helm template my-app ./my-app` to see the rendered YAML. That made template injection click.

## Releases

A release is a deployed chart with a name. `helm install my-app ./my-app` created a release. `helm list` showed it. I upgraded the image tag with `helm upgrade my-app ./my-app --set image.tag=v2`, and `helm history my-app` showed revision 1 and 2. Rolling back with `helm rollback my-app 1` reverted cleanly.

## Values

Values control what gets rendered. I used `--set` for single overrides and `-f staging-values.yaml` for a whole file. The file approach is cleaner for anything beyond one or two overrides, but I wasn't sure at first whether `-f` replaces or merges with the default `values.yaml` — it merges, which I confirmed by printing the rendered output.

## Repositories

`helm repo add bitnami https://charts.bitnami.io/bitnami` registers a repo. `helm search repo nginx` found charts. I installed one with `helm install my-nginx bitnami/nginx`. `helm repo update` refreshes the local index. I forgot to run update after adding a repo and got no results from search, which was confusing for a minute.

## What I'd try next

I want to package my own chart, push it to a repo, and test values overrides across dev and staging environments.
