---
last_verified: 2026-08-17
tool_version: n/a
sources: []
---

# Spurious placeholder file reference cleanup — 2026-08-17

> Quick audit of file references in training docs that don't correspond to real files in the DevSecOps-Kit repo.

## What I found

I searched the `docs/` tree for filenames listed in the task (`main.tf`, `values.yaml`, `kustomization.yaml`, `prometheus.yml`, `zap.sh`, `checkov -f plan.json`, `trivy-scan.yml`, `ci.yml`, `semgrep-ci.yml`, `semmp.yml`) and classified each hit.

## Spurious — no corresponding file exists in the repo

| Reference | Where it appears | Verdict |
|---|---|---|
| `zap.sh` | Not found in any doc file | **Spurious** — no such file anywhere in the repo. Remove or replace with a real OWASP ZAP script reference. |
| `semmp.yml` | Not found in any doc file | **Spurious** — appears to be a typo for `semgrep.yml` or `semgrep-ci.yml`. No file with this name exists. |

## Legitimate — kept as-is

| Reference | Why it's fine |
|---|---|
| `main.tf` | Standard Terraform filename used as a code-block example in Terraform how-to guides. Not a claim that a `main.tf` file lives in the repo. |
| `values.yaml` | Standard Helm chart filename shown in Helm examples. Legitimate user-creation example. |
| `kustomization.yaml` | Standard Kustomize filename shown in Kustomize/FluxCD examples. |
| `prometheus.yml` | Standard Prometheus config filename shown in monitoring examples. |
| `checkov -f plan.json` | Valid Checkov CLI syntax: `-f` is the file flag, `plan.json` is the argument. This is a command example, not a file path. |
| `.github/workflows/ci.yml` | Generic CI workflow example shown in CI/CD toolkit docs. Users create this in their own repos. |
| `.github/workflows/semgrep-ci.yml` | Semgrep CI workflow example in `semgrep/docs/github-actions-ci-from-scratch.md`. Users create this in their own repos. |
| `.github/workflows/trivy-scan.yml` | Trivy scanning workflow example in `docs/how-to/trivy-github-actions.md`. Users create this in their own repos. |

## What I changed

No doc files were modified this cycle. The two genuinely spurious references (`zap.sh`, `semmp.yml`) do not appear in any current doc — they were listed in the task description as examples of the class of problem, not as active references in the tree. The remaining filenames are either valid CLI syntax or legitimate user-creation examples embedded in how-to guides.

## What to watch next

If `zap.sh` or `semmp.yml` get added to any doc in a future rework, they should be replaced with real OWASP ZAP or Semgrep script references that point to actual files under `scripts/bash/`.
