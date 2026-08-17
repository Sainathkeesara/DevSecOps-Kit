# DevSecOps-Kit
> A working engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Cosign, Falco, OPA, Vault, Terraform, ZAP, and more.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, SBOMs and supply chain security, runtime security, policy engines, and infrastructure automation. Every entry is scenario-grounded and designed to be adapted for real infrastructure work. The kit is organised by tool for quick lookup and hands-on practice.

## Quick links

- [Spurious placeholder file reference cleanup](docs/notes/2026-08-17-spurious-placeholder-cleanup.md) — Audit of file references in training docs that don't correspond to real files
- [Linux VM terminal first commands](linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md) — First commands and common trip-ups after installing Linux in a VM
- [Checkov GitLab CI multi-cloud drift manifest](checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml) — GitLab CI template for multi-cloud IaC scanning with policy drift detection
- [Trivy scanning performance optimization](trivy/notes/scanning-performance-optimization.md) — Tuning scan time and resource use on large targets
- [Trivy ignore-rules pipeline](trivy/scripts/ignore-rules-pipeline.sh) — Trivy vulnerability scanning pipeline with custom ignore rules

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, and setup guides
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`scripts/bash/`** — Shell toolkit scripts organised by tool (ansible, docker, k8s, linux, terraform, vault, jenkins, kafka, observability, and more)
- **`.github/`** — Repo hygiene (CODEOWNERS, PR template, Dependabot config)

Per-tool content folders follow a consistent shape — `notes/`, `scripts/`, `configs/`, `snippets/`, plus wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, GitGuardian, Snyk, Terrascan, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, and Linux.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Last verified | Total |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|:-------------:|------:|
| trufflehog | 3 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | — | 37 |
| zap | 5 | 3 | 2 | 2 | 4 | 16 | 0 | 1 | 0 | 0 | 2026-07-20 | 33 |
| syft | 4 | 5 | 3 | 1 | 1 | 15 | 1 | 1 | 2 | 0 | 2026-08-13 | 33 |
| checkov | 4 | 5 | 2 | 2 | 4 | 10 | 2 | 0 | 2 | 1 | 2026-08-16 | 33 |
| trivy | 4 | 4 | 6 | 2 | 1 | 6 | 2 | 1 | 2 | 0 | 2026-08-16 | 28 |
| terraform | 3 | 1 | 4 | 4 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-08-10 | 20 |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 2026-08-06 | 20 |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | — | 20 |
| terrascan | 5 | 1 | 2 | 1 | 2 | 6 | 1 | 0 | 0 | 0 | 2026-08-09 | 18 |
| falco | 4 | 2 | 3 | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-19 | 13 |
| codeql | 3 | 1 | 1 | 1 | 4 | 0 | 1 | 1 | 0 | 0 | — | 12 |
| dependabot | 7 | 0 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-08 | 11 |
| gitguardian | 4 | 1 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | — | 11 |
| vault | 3 | 2 | 2 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | — | 11 |
| snyk | 4 | 1 | 1 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | — | 10 |
| cosign | 4 | 0 | 2 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | — | 9 |
| opa | 3 | 1 | 1 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | — | 9 |
| argocd | 6 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 2026-08-12 | 8 |
| docker | 2 | 1 | 2 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 2026-08-05 | 8 |
| github-actions | 3 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 2026-08-04 | 7 |
| git | 3 | 0 | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-26 | 6 |
| tetragon | 3 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-06 | 6 |
| defectdojo | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-08-04 | 3 |
| helm | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 2026-07-19 | 3 |
| kubernetes | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 2026-07-15 | 3 |
| kustomize | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-08 | 3 |
| opentofu | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-20 | 3 |
| sonarqube | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-19 | 3 |
| ansible | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | — | 2 |
| linux | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-17 | 3 |
| prometheus | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-13 | 2 |
| grafana | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-13 | 1 |

</details>

## Status

Foundational concept primers and practice exercises are complete across the toolchain, and per-tool quickstarts are being rounded out. Recent additions include a Linux first-commands note, a Checkov GitLab CI multi-cloud drift manifest, and continued Trivy expansion with scanning performance optimization and ignore-rules pipeline coverage. Current focus is expanding cross-tool integration scaffolds and finishing the remaining per-tool notes.

---
_Last updated: 2026-08-17_