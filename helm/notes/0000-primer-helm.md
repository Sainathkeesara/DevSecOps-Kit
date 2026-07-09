---
last_verified: 2026-07-09
tool_version: n/a
sources: []
---

# Helm — quick primer

> First-day notes for someone who's never used Helm. Personal voice, plain language.

## What is it?

Helm is a package manager for Kubernetes. From what I've read, it takes application definitions — templates for deployments, services, configmaps, and the rest — packages them into a versioned archive called a chart, and deploys them to a cluster with a single command. It's like `apt` or `npm` but for Kubernetes manifests.

## What does it do?

Helm lets me install, upgrade, and roll back applications on Kubernetes without copying raw YAML files around. It uses Go templates to inject environment-specific values (image tags, replica counts, domain names) so I don't maintain one copy of every manifest per environment. Commands like `helm install`, `helm upgrade`, and `helm rollback` manage the full lifecycle.

## Why does it exist?

Before Helm, deploying an app to Kubernetes meant maintaining dozens of plain YAML files and manually replacing values for each environment. If I needed ten microservices with dev, staging, and prod variants, that was sixty copies of YAML that could drift apart. Helm bundles everything into a single chart with a `values.yaml` file, so one command deploys and upgrades consistently. It's the default way to share Kubernetes applications — every major project publishes an official Helm chart.

## Key terminology

- **Chart** — A packaged collection of Kubernetes manifest templates, metadata, and default values. Example: `helm repo add bitnami https://charts.bitnami.io/bitnami` adds a chart repository.
- **Release** — A running instance of a chart in a cluster with a specific name and configuration. Example: `helm install my-nginx bitnami/nginx` creates a release called `my-nginx`.
- **`values.yaml`** — The default configuration file for a chart, defining image tags, resource limits, service types, and other tunables. Each environment can override it.
- **Repository** — A server hosting packaged charts, like Docker Hub for images. Example: `helm search repo nginx` finds available charts.
- **Hook** — A special annotation that runs a job at specific points in a release lifecycle (pre-install, post-upgrade, etc.). Example: database migration jobs run as hooks before the main app starts.
- **Rollback** — Reverting a release to a previous revision if an upgrade breaks something. Example: `helm rollback my-nginx 3` reverts to revision 3.

## A tiny example

```bash
helm repo add bitnami https://charts.bitnami.io/bitnami
helm install my-redis bitnami/redis --set auth.enabled=false
```

This installs a Redis chart from the Bitnami repository with authentication disabled so I can connect immediately. `helm list` shows the running release, and `helm uninstall my-redis` tears it down.

## What I'll cover next

I want to create my own chart for a simple app, override values for a staging environment, and then look at how Helm fits into a CI/CD pipeline. After that I'll explore release history and rollback mechanics when an upgrade goes sideways.
