# DevSecOps-Kit
> A working-engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Cosign, OPA, Falco, Vault, Terraform, and more.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Every entry is scenario-grounded and designed to be adapted for real infrastructure work. The kit spans 32 tools organised for quick lookup and hands-on practice.

## Quick links

- [Syft output format comparison notebook](syft/notebooks/output-format-comparison.ipynb) — SPDX vs CycloneDX vs GitHub vs native JSON side by side
- [Syft + Trivy Kubernetes scan scaffold](syft/templates/syft-trivy-k8s-scan-scaffold/README.md) — SBOM generation and vulnerability gating for workload images
- [ArgoCD quickstart trip-ups](argocd/notes/2026-08-12-quickstart-tripups.md) — What tripped me up following the official ArgoCD quickstart
- [ArgoCD GitOps sync sample app](argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml) — Minimal Application manifest with sync options
- [Terraform module composition guide](terraform/docs/terraform-module-composition.md) — Reusable module structure across environments

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, and setup guides
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng
- **`scripts/bash/`** — Shell toolkit scripts organised by tool (ansible, docker, k8s, linux, terraform, vault, jenkins, kafka, observability, etc.)
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`.github/`** — Repo hygiene (CODEOWNERS, PR template, Dependabot config)

Per-tool content folders, each with `notes/`, `scripts/`, `configs/`, `snippets/`, and wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, GitGuardian, Snyk, Terrascan, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, and Linux.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Last verified | Total |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|:-------------:|------:|
| trufflehog | 3 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 2026-05-27 | 37 |
| zap | 5 | 3 | 2 | 2 | 4 | 16 | 0 | 1 | 0 | 0 | 2026-07-20 | 33 |
| syft | 4 | 5 | 3 | 1 | 1 | 15 | 1 | 1 | 2 | 0 | 2026-05-30 | 33 |
| checkov | 4 | 5 | 2 | 2 | 4 | 10 | 2 | 0 | 2 | 1 | 2026-05-27 | 32 |
| trivy | 3 | 3 | 5 | 2 | 1 | 6 | 2 | 1 | 2 | 0 | 2026-05-26 | 25 |
| terraform | 3 | 1 | 4 | 4 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-08-04 | 20 |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 2026-05-26 | 20 |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | 2026-06-08 | 20 |
| terrascan | 5 | 1 | 2 | 1 | 2 | 6 | 1 | 0 | 0 | 0 | 2026-07-10 | 18 |
| falco | 4 | 2 | 3 | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-19 | 13 |
| codeql | 3 | 1 | 1 | 1 | 4 | 0 | 1 | 1 | 0 | 0 | 2026-06-14 | 12 |
| vault | 3 | 2 | 2 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | 2026-06-15 | 11 |
| gitguardian | 4 | 1 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 2026-06-14 | 11 |
| dependabot | 7 | 0 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-08 | 11 |
| snyk | 4 | 1 | 1 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | 2026-06-14 | 10 |
| opa | 3 | 1 | 1 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 2026-06-15 | 9 |
| cosign | 4 | 0 | 2 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 2026-06-22 | 9 |
| docker | 2 | 1 | 2 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 2026-07-12 | 8 |
| argocd | 6 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 2026-08-12 | 8 |
| github-actions | 3 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 2026-08-04 | 7 |
| tetragon | 3 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-06 | 6 |
| git | 3 | 0 | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-12 | 6 |
| sonarqube | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-19 | 3 |
| opentofu | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-20 | 3 |
| kustomize | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-08 | 3 |
| kubernetes | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 2026-07-15 | 3 |
| helm | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 2026-07-19 | 3 |
| defectdojo | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-08-04 | 3 |
| linux | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-06 | 3 |
| ansible | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | — | 2 |
| prometheus | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | — | 1 |
| grafana | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | — | 1 |

</details>

## Status

Foundational concept primers and practice exercises are complete across the toolchain, and per-tool quickstarts are being rounded out. Recent additions cover the Syft output format comparison notebook, a Syft + Trivy Kubernetes scan scaffold, ArgoCD GitOps sync setup, and further Terraform module composition patterns. Current focus is rounding out the remaining tool notes and expanding cross-tool integration scaffolds.

---
_Last updated: 2026-08-13_