# DevSecOps-Kit
> A working engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Cosign, Falco, OPA, Vault, Terraform, ZAP, and more.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, SBOMs and supply chain security, runtime security, policy engines, and infrastructure automation. Every entry is scenario-grounded and designed to be adapted for real infrastructure work. The kit is organised by tool for quick lookup and hands-on practice.

## Quick links

- [Git first repo stage and log](git/scripts/2026-08-24-first-repo-stage-log.sh) — Script for staging and logging changes in a first Git repo
- [Spurious script reference cleanup](docs/notes/2026-08-23-spurious-script-reference-cleanup.md) — Cleanup pass for incorrect script references across docs
- [Vault dynamic secrets for cloud IAM](vault/scripts/cloud-iam-dynamic-secrets.sh) — Vault dynamic secrets workflow for cloud IAM credentials
- [GitGuardian incident response workflow](gitguardian/docs/gitguardian-incident-response-workflow.md) — Walk through a secrets incident from detection to remediation
- [GitGuardian API integration](gitguardian/scripts/gitguardian-api-integration.py) — Scripted secret scanning via the GitGuardian API

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, and setup guides
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`scripts/`** — General repository scripts and utilities
- **`scripts/bash/`** — Shell toolkit scripts organised by tool (ansible, docker, k8s, linux, terraform, vault, jenkins, kafka, observability, and more)

Per-tool content folders follow a consistent shape — `notes/`, `scripts/`, `configs/`, `snippets/`, plus wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, GitGuardian, Snyk, Terrascan, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, and Linux.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|------:|---------------|
| trufflehog | 3 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 37 | 2026-08-21 |
| syft | 4 | 5 | 3 | 1 | 1 | 15 | 1 | 1 | 2 | 0 | 33 | 2026-08-13 |
| trivy | 4 | 4 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 33 | 2026-08-18 |
| checkov | 4 | 5 | 2 | 2 | 4 | 10 | 3 | 0 | 2 | 1 | 33 | 2026-07-20 |
| zap | 5 | 3 | 2 | 2 | 4 | 8 | 0 | 1 | 0 | 0 | 25 | 2026-07-20 |
| gitguardian | 4 | 2 | 3 | 2 | 2 | 9 | 0 | 0 | 0 | 0 | 22 | 2026-08-21 |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 20 | 2026-08-06 |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | 2026-08-13 |
| terrascan | 5 | 1 | 2 | 1 | 2 | 6 | 1 | 0 | 0 | 0 | 18 | 2026-08-09 |
| dependabot | 7 | 1 | 2 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 14 | 2026-08-18 |
| terraform | 3 | 1 | 4 | 4 | 1 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-08-10 |
| falco | 4 | 2 | 3 | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-07-19 |
| vault | 3 | 2 | 3 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | 12 | 2026-08-22 |
| opa | 3 | 1 | 1 | 1 | 3 | 0 | 3 | 0 | 0 | 0 | 12 | 2026-08-19 |
| codeql | 3 | 1 | 1 | 1 | 4 | 0 | 1 | 1 | 0 | 0 | 12 | 2026-05-31 |
| cosign | 4 | 0 | 3 | 1 | 1 | 0 | 2 | 0 | 0 | 0 | 11 | 2026-06-22 |
| snyk | 4 | 1 | 1 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | 10 | 2026-06-14 |
| argocd | 6 | 0 | 0 | 1 | 0 | 0 | 2 | 0 | 0 | 0 | 9 | 2026-08-12 |
| docker | 2 | 1 | 2 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 8 | 2026-08-05 |
| github-actions | 3 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 7 | 2026-08-04 |
| git | 3 | 0 | 3 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-08-24 |
| tetragon | 3 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-08-06 |
| ansible | 1 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-08-17 |
| sonarqube | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-07-19 |
| opentofu | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-07-20 |
| linux | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-08-17 |
| kustomize | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-07-08 |
| kubernetes | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 3 | 2026-07-15 |
| helm | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 3 | 2026-07-19 |
| defectdojo | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-08-04 |
| prometheus | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-07-13 |
| grafana | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-07-13 |

</details>

## Status

Foundational concept primers and practice exercises are complete across the toolchain, and per-tool quickstarts are being rounded out. Recent additions include Git repo staging and logging, Vault cloud IAM dynamic secrets, and GitGuardian incident-response workflow documentation. Current focus is finishing the remaining per-tool notes and expanding coverage across the toolchain.

---
_Last updated: 2026-08-24_
