# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

1025 files across 31 tool-specific folders plus cross-cutting docs, scripts, snippets, templates, and lab environments. Covers vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

## Quick links

- [Falco K8s admission control rule](falco/manifests/falco-k8s-admission-control.yaml) — Custom Falco rule detecting shell execution inside containers for admission enforcement
- [ArgoCD multi-environment GitOps delivery](argocd/docs/multi-environment-gitops-delivery.md) — Patterns for deploying to dev, staging, and prod environments through GitOps
- [Falco rule optimization with priority-based filtering](falco/docs/rule-optimization-priority-filtering.md) — Rank the noisiest rules first, then cut volume with lists, macros, cheap-first conditions, and priority-tiered routing
- [CodeQL multi-language repository scan](codeql/manifests/codeql-multi-language-scan.yaml) — Analyse every language in a multi-language repo in one workflow run with a single status check
- [CodeQL custom-queries CI workflow](codeql/templates/custom-query-pack-ci-harness/.github/workflows/codeql-custom-queries.yml) — Exercise the query pack in CI the same way the local test script does

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, and setup guides
- **`scripts/`** — Shell toolkits organised by tool (`scripts/bash/`), deployment and rollback wrappers (`scripts/pipeline/`), and repository utilities
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng, and per-tool scaffolds
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`.github/`** — CODEOWNERS, PR template, and Dependabot config

Per-tool content folders follow a consistent shape — `notes/`, `scripts/`, `configs/`, `snippets/`, plus wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Nuclei, Semgrep, Checkov, tfsec, Terrascan, Grype, Syft, TruffleHog, Gitleaks, GitGuardian, Snyk, Terraform, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, and Linux.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|------:|---------------|
| checkov | 4 | 6 | 2 | 3 | 4 | 20 | 3 | 0 | 3 | 1 | 46 | 2026-09-18 |
| trufflehog | 4 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 38 | 2026-09-04 |
| syft | 4 | 6 | 4 | 1 | 1 | 15 | 2 | 1 | 3 | 0 | 37 | 2026-09-17 |
| trivy | 6 | 4 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 35 | 2026-09-05 |
| zap | 6 | 3 | 2 | 2 | 4 | 8 | 0 | 1 | 0 | 0 | 26 | 2026-09-05 |
| opa | 3 | 2 | 2 | 1 | 3 | 9 | 4 | 0 | 0 | 0 | 24 | 2026-09-02 |
| snyk | 4 | 2 | 1 | 2 | 1 | 11 | 1 | 1 | 0 | 0 | 23 | 2026-09-03 |
| gitguardian | 4 | 2 | 3 | 2 | 2 | 9 | 0 | 0 | 0 | 0 | 22 | 2026-08-21 |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | 2026-07-21 |
| terraform | 3 | 1 | 4 | 4 | 1 | 0 | 0 | 0 | 0 | 0 | 20 | 2026-08-11 |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 20 | 2026-08-06 |
| terrascan | 5 | 1 | 2 | 1 | 2 | 6 | 1 | 0 | 0 | 0 | 18 | 2026-08-09 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 1 | 1 | 1 | 0 | 19 | 2026-09-17 |
| cosign | 4 | 1 | 3 | 1 | 1 | 0 | 2 | 2 | 0 | 0 | 14 | 2026-08-25 |
| dependabot | 7 | 1 | 2 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 14 | 2026-08-20 |
| falco | 4 | 3 | 3 | 3 | 1 | 1 | 0 | 0 | 0 | 0 | 15 | 2026-09-19 |
| codeql | 5 | 2 | 2 | 1 | 5 | 8 | 2 | 1 | 1 | 0 | 27 | 2026-09-19 |
| github-actions | 4 | 0 | 0 | 3 | 2 | 0 | 2 | 0 | 0 | 0 | 11 | 2026-09-10 |
| argocd | 6 | 1 | 0 | 1 | 0 | 0 | 2 | 0 | 0 | 0 | 10 | 2026-08-17 |
| docker | 2 | 1 | 2 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 8 | 2026-08-05 |
| git | 3 | 0 | 3 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-07-26 |
| ansible | 2 | 0 | 3 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-09-15 |
| tetragon | 3 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-08-06 |
| opentofu | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-09-10 |
| kubernetes | 2 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 4 | 2026-09-10 |
| kustomize | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-07-08 |
| helm | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 3 | 2026-07-19 |
| sonarqube | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-07-19 |
| linux | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-08-17 |
| defectdojo | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-08-04 |
| prometheus | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-07-13 |
| grafana | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-07-13 |
| gitleaks | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-09-10 |
| nuclei | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-09-10 |
| tfsec | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-09-10 |

_Terraform's total includes a 7-file `eventbridge-lambda/` sample project on top of the categorised notes, docs, scripts, configs, and snippets._

</details>

## Status

Foundational concept primers and practice exercises are complete across the toolchain, and per-tool quickstarts are being rounded out. Recent additions include a Falco rule-optimization guide, a CodeQL multi-language scan workflow with a custom query-pack harness, and a Checkov cross-module scanning notebook. Current focus is finishing per-tool notes and deepening runtime-detection and supply-chain coverage.

---
_Last updated: 2026-09-19_