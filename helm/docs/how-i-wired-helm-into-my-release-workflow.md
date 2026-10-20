---
last_verified: 2026-10-20
tool_version: "n/a"
sources: []
---
# How I wired Helm into my release workflow

## Purpose
This doc captures how Helm fits into a simple release workflow: templating manifests, managing releases across environments, and promoting changes safely.

## Prerequisites
- Helm installed locally or in CI
- Access to target Kubernetes cluster
- A chart in source control (or ability to package and publish)

## Workflow steps
1. **Source control**: Keep charts in a repo alongside app code or in a dedicated charts repo.
2. **Environment values**: Use per-environment values files (e.g., `values-dev.yaml`, `values-staging.yaml`, `values-prod.yaml`).
3. **Validate**: Run `helm lint` and `helm template` in CI to catch errors before deploy.
4. **Package/publish** (optional): `helm package` and push to a chart repository for sharing.
5. **Deploy**: Use `helm upgrade --install` with `--namespace` and `--values` to apply changes idempotently.
6. **Verify**: Check rollout status with `kubectl rollout status` or `helm status`.

## Release strategy notes
- Use semantic versioning for chart and app versions.
- Prefer `--atomic` in CI for safer rollbacks on failure.
- Keep sensitive values in secrets management, not in plain values files.
- Use `--wait` to ensure resources are ready before proceeding.

## Verify
- `helm lint ./mychart` passes
- `helm template` renders expected manifests
- `helm upgrade --install` succeeds and resources are healthy

## Common gotchas
- Values precedence: `--set` overrides values files; order matters
- Release names are namespaced - same name in different namespaces is fine
- CRDs require careful handling (install timing matters)
