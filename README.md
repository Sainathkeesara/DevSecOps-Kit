# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

1054 files across 35 tool folders plus cross-cutting docs, scripts, snippets, templates, and lab environments. Covers vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

## Quick links

- [Dependabot configuration template](dependabot/configs/dependabot-configuration-template.yaml) — A single dependabot.yml covering ecosystems, schedules, grouping, and review routing for real repositories
- [Auto-merge vs manual review](dependabot/notebooks/auto-merge-vs-manual-review.ipynb) — Operational trade-offs between auto-merging Dependabot PRs and reviewing each one by hand
- [Docker Compose production manifest](docker/manifests/docker-compose-production.yaml) — Replicated app service with rolling updates, resource limits, and restart policy
- [Cosign key rotation and migration patterns](cosign/docs/key-rotation-and-migration-patterns.md) — Rotate signing trust and migrate verification without leaving published images unverifiable
- [First CodeQL query](codeql/snippets/2026-09-24-first-codeql-query.py) — A minimal hardcoded-password query to save out and run with the CodeQL CLI

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

Trivy, Nuclei, Semgrep, Checkov, tfsec, Terrascan, Grype, Syft, TruffleHog, Gitleaks, GitGuardian, Snyk, Terraform, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, Linux, and Lab.

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
| codeql | 4 | 2 | 1 | 1 | 5 | 8 | 2 | 1 | 1 | 0 | 25 | 2026-09-25 |
| snyk | 4 | 2 | 1 | 2 | 1 | 11 | 1 | 1 | 0 | 0 | 23 | 2026-09-03 |
| gitguardian | 4 | 2 | 3 | 2 | 2 | 9 | 0 | 0 | 0 | 0 | 22 | 2026-08-21 |
| terraform | 3 | 1 | 4 | 5 | 1 | 0 | 0 | 0 | 0 | 0 | 21 | 2026-09-22 |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | 2026-07-21 |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 20 | 2026-08-06 |
| falco | 4 | 3 | 3 | 3 | 1 | 4 | 1 | 0 | 1 | 0 | 20 | 2026-09-19 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 1 | 1 | 1 | 0 | 19 | 2026-09-17 |
| terrascan | 5 | 1 | 2 | 1 | 2 | 6 | 1 | 0 | 0 | 0 | 18 | 2026-08-09 |
| environments | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 15 | 2026-09-19 |
| cosign | 4 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 18 | 2026-09-25 |
| dependabot | 7 | 1 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 16 | 2026-09-26 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| lab | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-09-20 |
| github-actions | 5 | 0 | 0 | 4 | 2 | 0 | 2 | 0 | 0 | 0 | 13 | 2026-09-21 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| ansible | 3 | 1 | 3 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-25 |
| kustomize | 3 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 6 | 2026-09-22 |
| kubernetes | 2 | 1 | 0 | 1 | 0 | 0 | 3 | 0 | 0 | 0 | 7 | 2026-09-22 |
| tetragon | 3 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-09-22 |
| defectdojo | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| opentofu | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| sonarqube | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| helm | 3 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 5 | 2026-09-21 |
| prometheus | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-20 |
| grafana | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-19 |
| linux | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-08-17 |
| gitleaks | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-19 |
| nuclei | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |
| tfsec | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |

_Kubernetes' total counts 2 notes, 1 doc, 1 config, and 3 manifests. Terraform's total includes a 7-file `eventbridge-lambda/` sample project on top of the categorised notes, docs, scripts, configs, and snippets. Lab's total includes 10 files under `lab/mini-projects/` outside the standard categories. Environments' total includes 12 Terraform files under `dev/`, `staging/`, and `prod/` outside the standard categories._

</details>

## Status

Foundational concept primers and practice exercises are complete across the toolchain, and per-tool quickstarts are being rounded out. Recent additions cover Dependabot configuration and auto-merge policy, a production Docker Compose manifest, Cosign key rotation and signing-mode comparisons, and a first CodeQL query example. Current focus is rounding out Docker, Cosign, Dependabot, CodeQL, Ansible, Kubernetes, and Tetragon first-contact notes.

---
_Last updated: 2026-09-26_
