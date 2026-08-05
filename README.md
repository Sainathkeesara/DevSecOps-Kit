# DevSecOps-Kit
> A working-engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Cosign, OPA, Falco, Vault, Terraform, and more.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs. The kit covers scanners (Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, GitGuardian, Snyk, Terrascan, ZAP), runtime and supply-chain tools (Cosign, Falco, Tetragon, OPA, Vault), CI/CD and orchestration (Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu), and supporting platforms (Git, Prometheus, Grafana, observability, SonarQube, DefectDojo, Dependabot).

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Every entry is scenario-grounded and designed to be adapted for real infrastructure work. The kit spans 35+ tools across security scanning, runtime protection, supply chain, policy enforcement, and infrastructure automation — all organised for quick lookup and hands-on practice.

## Quick links

- [Build a multi-service Docker Compose app](docker/scripts/build-multi-service-compose-app.sh) — Docker Compose app from scratch
- [Bootstrap a node with Ansible](ansible/scripts/2026-08-04-bootstrap-node.sh) — First Ansible bootstrap script
- [Bootstrap target node for Ansible](ansible/scripts/bootstrap-target-node.sh) — Target-node setup script
- [First Terraform configuration](terraform/configs/2026-08-04-first-configuration.hcl) — Initial Terraform config
- [Install Terraform on a first VM](terraform/notes/2026-08-04-install-terraform-first-vm.md) — Terraform first-install guide

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`ansible/`** — Ansible bootstrap and target-node scripts
- **`argocd/`** — ArgoCD GitOps delivery notes, manifests, and first-app deployments
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/` / `tetragon/`** — Vulnerability scanner and runtime security tool content
- **`terrascan/` / `opa/`** — IaC compliance and policy engine primers
- **`defectdojo/`** — Vulnerability management platform notes
- **`dependabot/`** — Dependency update configs and alerts
- **`vault/`** — HashiCorp Vault primers, configs, and scripts
- **`git/`** — Git primers, branching, and version control
- **`docker/`** — Docker image authoring, CLI, and container security
- **`github-actions/`** — GitHub Actions CI/CD workflows and runners
- **`helm/` / `kubernetes/` / `kustomize/`** — Kubernetes ecosystem notes
- **`linux/`** — Linux fundamentals, CLI, system administration, and security hardening
- **`sonarqube/` / `opentofu/`** — Static analysis and IaC tool primers
- **`grafana/` / `observability/` / `prometheus/`** — Metrics, logs, traces, dashboards
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform primers, configs, scripts, and EventBridge Lambda modules
- **`.github/`** — GitHub templates (PR template, CODEOWNERS)
- **`CHANGELOG.md`** — Release history and version tracking
- **`CONTRIBUTING.md`** — Contribution guidelines and workflow

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Last verified | Total |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|:-------------:|------:|
| Trivy | 3 | 3 | 5 | 2 | 1 | 4 | 2 | 1 | 2 | — | 2026-07-06 | 25 |
| TruffleHog | 3 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | — | 2026-07-06 | 37 |
| ZAP | 5 | 3 | 2 | 2 | 4 | 16 | — | 1 | — | — | 2026-07-20 | 33 |
| Checkov | 4 | 5 | 2 | 2 | 4 | 10 | 2 | — | 2 | 1 | 2026-07-20 | 32 |
| Syft | 4 | 5 | 3 | 1 | 1 | 7 | 1 | 1 | 1 | — | 2026-07-06 | 24 |
| Grype | 4 | 1 | 8 | 1 | 2 | — | 2 | 1 | 1 | — | — | 20 |
| Semgrep | 3 | 4 | 3 | 1 | 2 | — | 2 | 2 | 1 | — | — | 18 |
| Terraform | 3 | — | 3 | 2 | 1 | — | — | — | — | — | 2026-08-04 | 16 |
| Falco | 4 | 2 | 3 | 3 | 1 | — | — | — | — | — | 2026-07-19 | 13 |
| CodeQL | 3 | 1 | 1 | 1 | 4 | — | 1 | 1 | — | — | — | 12 |
| GitGuardian | 4 | 1 | 2 | 2 | 2 | — | — | — | — | — | — | 11 |
| Vault | 3 | 2 | 2 | 2 | 1 | — | — | 1 | — | — | — | 11 |
| Snyk | 4 | 1 | 1 | 2 | 1 | — | — | 1 | — | — | — | 10 |
| OPA | 3 | 1 | 1 | 1 | 3 | — | — | — | — | — | — | 9 |
| Cosign | 4 | — | 2 | 1 | 1 | — | 1 | — | — | — | — | 9 |
| Terrascan | 5 | — | 1 | 1 | 2 | — | — | — | — | — | 2026-07-10 | 9 |
| Dependabot | 6 | — | 1 | 3 | — | — | — | — | — | — | 2026-07-21 | 10 |
| Git | 3 | — | 2 | — | 1 | — | — | — | — | — | 2026-07-26 | 6 |
| Docker | 2 | — | 2 | — | — | — | — | 2 | — | — | 2026-07-12 | 6 |
| ArgoCD | 5 | — | — | — | — | — | 1 | — | — | — | 2026-07-25 | 6 |
| Helm | 2 | — | — | — | — | — | 1 | — | — | — | 2026-07-09 | 3 |
| Kubernetes | 2 | — | — | — | — | — | 1 | — | — | — | 2026-07-15 | 3 |
| Kustomize | 2 | — | — | 1 | — | — | — | — | — | — | 2026-07-08 | 3 |
| GitHub Actions | 3 | — | — | 2 | — | — | 2 | — | — | — | 2026-07-14 | 7 |
| SonarQube | 2 | — | — | — | 1 | — | — | — | — | — | 2026-07-09 | 3 |
| OpenTofu | 2 | — | — | 1 | — | — | — | — | — | — | 2026-07-09 | 3 |
| Tetragon | 2 | — | — | 1 | — | — | — | — | — | — | — | 3 |
| Grafana | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Observability | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Linux | 1 | — | — | — | — | — | — | — | — | — | — | 1 |
| Ansible | — | — | 2 | — | — | — | — | — | — | — | — | 2 |

</details>

## Status

Currently expanding tool coverage with foundational concept primers for secrets management, version control, infrastructure as code, and Linux/shell fundamentals; practice exercises across multiple domains; and ongoing CVE remediation guides for the security toolchain. Ansible toolkit scripts and Terraform first-configuration notes are the newest additions.

---
_Last updated: 2026-08-05_