# DevSecOps-Kit
> A working-engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Cosign, OPA, Falco, Vault, Terraform, and more.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Every entry is scenario-grounded and designed to be adapted for real infrastructure work. The kit spans 34 tools across security scanning, runtime protection, supply chain, policy enforcement, and infrastructure automation — all organised for quick lookup and hands-on practice.

## Quick links

- [Composing Terraform modules across environments](terraform/docs/terraform-module-composition.md) — Reusable module structure, cross-environment composition, and workspace patterns
- [Terraform workspace variable precedence](terraform/configs/workspace-variable-precedence.hcl) — Which values win when workspaces, tfvars, and CLI overlap
- [Git hooks for devsecops security checks](docs/concepts/version-control-with-git/scripts/git-hooks-devsecops-security-checks.sh) — Pre-commit hooks that run scans and secret checks in the dev loop
- [Dependabot for custom/private registries](dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md) — Pointing Dependabot at registries GitHub can't reach by default
- [Tetragon eBPF observability tutorial](tetragon/notes/2026-08-06-tetragon-observability-tutorial.md) — Watching container process and network events at the kernel level

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

Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, GitGuardian, Snyk, Terrascan, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, and Lin.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Last verified | Total |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|:-------------:|------:|
| trufflehog | 3 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | — | 37 |
| zap | 5 | 3 | 2 | 2 | 4 | 16 | 0 | 1 | 0 | 0 | 2026-07-20 | 33 |
| checkov | 4 | 5 | 2 | 2 | 4 | 10 | 2 | 0 | 2 | 1 | 2026-07-20 | 32 |
| trivy | 3 | 3 | 5 | 2 | 1 | 6 | 2 | 1 | 2 | 0 | — | 25 |
| syft | 4 | 5 | 3 | 1 | 1 | 7 | 1 | 1 | 1 | 0 | 2026-07-06 | 24 |
| terraform | 3 | 1 | 4 | 4 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-08-10 | 20 |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 2026-08-06 | 20 |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | — | 20 |
| terrascan | 5 | 1 | 2 | 1 | 2 | 6 | 1 | 0 | 0 | 0 | 2026-08-09 | 18 |
| falco | 4 | 2 | 3 | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-19 | 13 |
| codeql | 3 | 1 | 1 | 1 | 4 | 0 | 1 | 1 | 0 | 0 | — | 12 |
| vault | 3 | 2 | 2 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | — | 11 |
| gitguardian | 4 | 1 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | — | 11 |
| dependabot | 7 | 0 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-08 | 11 |
| snyk | 4 | 1 | 1 | 2 | 1 | 0 | 0 | 1 | 0 | 0 | — | 10 |
| opa | 3 | 1 | 1 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | — | 9 |
| cosign | 4 | 0 | 2 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | — | 9 |
| docker | 2 | 1 | 2 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 2026-08-05 | 8 |
| GitHub Actions | 3 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 2026-08-04 | 7 |
| tetragon | 3 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-06 | 6 |
| git | 3 | 0 | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-26 | 6 |
| argocd | 5 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 2026-08-01 | 6 |
| sonarqube | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-07-19 | 3 |
| opentofu | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-20 | 3 |
| kustomize | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-08 | 3 |
| kubernetes | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 2026-07-15 | 3 |
| helm | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 2026-07-19 | 3 |
| defectdojo | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-08-04 | 3 |
| lin | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-08-06 | 2 |
| ansible | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | — | 2 |
| prometheus | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-13 | 1 |
| observability | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-13 | 1 |
| linux | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-21 | 1 |
| grafana | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-07-13 | 1 |

</details>

## Status

Foundational concept primers and practice exercises are complete for the full tool chain. The kit is now in active refinement: recent additions include Terraform module composition and workspace variable precedence, Dependabot custom-registry configuration, Tetragon eBPF observability, Git-hook security checks, and a Terrascan scanning pipeline scaffold. Next focus is deepening CI/CD integration recipes and CVE remediation runbooks for the security toolchain.

---
_Last updated: 2026-08-10_
