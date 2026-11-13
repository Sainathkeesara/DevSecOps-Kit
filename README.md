# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference for scanning, secrets, SBOMs, supply-chain security, policy, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit/commits/master) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps and DevSecOps engineer's quick-reference: first-contact notes, runnable snippets, configs, and starter templates for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it — scanning (Trivy, Syft, Grype, Semgrep, CodeQL, Snyk, ZAP, Nuclei), secrets (TruffleHog, Gitleaks, GitGuardian, Vault, Cosign), policy (OPA, Falco, Tetragon, Checkov, Terrascan, tfsec), and delivery (Docker, Kubernetes, Helm, Kustomize, Argo CD, GitHub Actions, Terraform, OpenTofu, Ansible). Cross-cutting folders hold concept primers, cheatsheets, runbooks, starter templates, environment promotion configs, and a lab sandbox. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Checkov IaC scanner primer](checkov/notes/0000-primer-checkov.md) — Scan Terraform plans with Checkov
- [Checkov deep Terraform plan scan](checkov/scripts/deep-terraform-plan-scan.sh) — Deep scan of a Terraform plan before apply
- [Trivy scanner primer](trivy/notes/0000-primer-trivy.md) — Container image vulnerability scanning primer
- [Environment promotion lesson](learn/04-iac/04-environments-promotion.md) — Promote Terraform from dev to prod through CI
- [dev backend config](terraform/configs/environments-promotion/environments/dev/backend.hcl) — Remote backend config for the dev environment

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`learn/`** — Ordered lessons that follow the learning path (stage-by-stage, hands-on)
- **`docs/`** — Concepts, how-to guides, reference, runbooks, troubleshooting, setup notes
- **`scripts/`** — Shell toolkits, pipeline helpers, and reusable utilities
- **`snippets/`** — Copy-paste cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, and platform tooling
- **`environments/`** — Terraform environment configs (dev / staging / prod) and promotion workflow
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`<tool>/`** — Per-tool folders (notes, docs, scripts, configs, snippets, templates, manifests, dockerfiles, notebooks)

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|--------:|---------------|
| trufflehog | 4 | 4 | 3 | 2 | 3 | 0 | 2 | 2 | 3 | 51 | 2026-10-13 |
| checkov | 4 | 6 | 4 | 3 | 4 | 0 | 3 | 0 | 4 | 45 | 2026-09-17 |
| syft | 5 | 8 | 5 | 1 | 3 | 0 | 4 | 1 | 4 | 44 | 2026-10-27 |
| trivy | 8 | 6 | 6 | 4 | 1 | 0 | 2 | 1 | 2 | 40 | 2026-10-19 |
| terraform | 3 | 2 | 4 | 6 | 1 | 0 | 1 | 0 | 0 | 35 | 2026-10-30 |
| ansible | 3 | 1 | 5 | 3 | 1 | 0 | 0 | 0 | 0 | 34 | 2026-10-27 |
| codeql | 5 | 4 | 2 | 2 | 6 | 0 | 3 | 1 | 2 | 32 | 2026-10-27 |
| zap | 6 | 5 | 3 | 3 | 4 | 0 | 1 | 1 | 1 | 31 | 2026-10-14 |
| opa | 5 | 4 | 2 | 2 | 4 | 0 | 4 | 0 | 1 | 30 | 2026-10-27 |
| snyk | 6 | 4 | 2 | 3 | 1 | 0 | 1 | 1 | 1 | 29 | 2026-10-27 |
| gitguardian | 6 | 4 | 4 | 3 | 2 | 0 | 0 | 0 | 1 | 28 | 2026-10-27 |
| argocd | 6 | 3 | 1 | 2 | 0 | 0 | 5 | 0 | 0 | 28 | 2026-10-27 |
| grype | 5 | 3 | 9 | 2 | 3 | 0 | 2 | 1 | 2 | 27 | 2026-10-14 |
| falco | 6 | 4 | 3 | 4 | 1 | 0 | 1 | 0 | 2 | 25 | 2026-10-27 |
| semgrep | 3 | 8 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 25 | 2026-10-18 |
| terrascan | 5 | 3 | 2 | 2 | 2 | 0 | 1 | 0 | 1 | 22 | 2026-10-10 |
| github-actions | 7 | 1 | 1 | 8 | 3 | 0 | 2 | 0 | 0 | 22 | 2026-10-20 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2 | 21 | 2026-08-30 |
| cosign | 5 | 4 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 20 | 2026-10-30 |
| kubernetes | 4 | 2 | 2 | 3 | 0 | 0 | 4 | 0 | 0 | 20 | 2026-10-29 |
| docker | 2 | 2 | 3 | 1 | 0 | 0 | 1 | 3 | 0 | 19 | 2026-09-23 |
| defectdojo | 4 | 2 | 3 | 2 | 2 | 0 | 0 | 0 | 0 | 19 | 2026-10-23 |
| dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 19 | 2026-10-14 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| grafana | 4 | 1 | 1 | 2 | 1 | 0 | 1 | 0 | 0 | 10 | 2026-10-26 |
| kustomize | 3 | 1 | 2 | 3 | 0 | 0 | 1 | 0 | 0 | 10 | 2026-10-24 |
| opentofu | 4 | 2 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-10-28 |
| gitleaks | 3 | 1 | 3 | 2 | 0 | 0 | 0 | 0 | 0 | 9 | 2026-10-25 |
| helm | 4 | 1 | 1 | 1 | 0 | 0 | 2 | 0 | 0 | 9 | 2026-10-20 |
| sonarqube | 3 | 0 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 7 | 2026-09-21 |
| prometheus | 5 | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 7 | 2026-10-25 |
| linux | 3 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-02 |
| tfsec | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 6 | 2026-10-19 |
| nuclei | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-15 |

</details>

Counts reflect files inside each category subfolder. Some folders also hold files at their root or in project-specific subfolders, so the total may exceed the sum of category columns. `Last verified` is the most recent `last_verified` marker found in that tool's docs.

## Status

Shift-left lessons landed recently under `learn/`. Thinner corners remain for tfsec, Nuclei, Prometheus, and SonarQube where first configs or scripts are still sparse.

---
_Last updated: 2026-11-12_
