# DevSecOps-Kit
> A working-engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Cosign, OPA, Falco, Vault, and Terraform.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

---

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

The kit spans security scanners (Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, GitGuardian, Snyk, Terrascan, ZAP), runtime and supply-chain tools (Cosign, Falco, Tetragon, OPA, Vault), CI/CD and orchestration (Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu), and supporting platforms (Git, Prometheus, Grafana, observability, SonarQube, DefectDojo, Dependabot).

---

## Quick links

- [Architecture overview](assets/architecture-overview.png) — DevSecOps pipeline architecture diagram
- [CI/CD workflow diagram](assets/cicd-workflow.png) — CI/CD pipeline workflow illustration
- [DevSecOps pipeline illustration](assets/devsecops-pipeline.png) — End-to-end DevSecOps pipeline overview
- [ArgoCD README layout note](argocd/notes/2026-07-25-readme-layout.md) — Documenting the ArgoCD root folder in README Layout
- [Git notes primer](git/notes/0000-primer-git.md) — What is Git? — quick primer

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`assets/`** — Architecture diagrams and workflow illustrations
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

---

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | Policies | Last verified | Total |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|---------:|:-------------:|------:|
| Trivy | 3 | 5 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — | 2026-07-06 | 25 |
| TruffleHog | 3 | 3 | 2 | 2 | 2 | 1 | 21 | 2 | 1 | — | 2026-07-06 | 37 |
| ZAP | 5 | 2 | 2 | 4 | 3 | — | 16 | — | 1 | — | 2026-07-20 | 33 |
| Checkov | 4 | 2 | 2 | 4 | 5 | 2 | 10 | 2 | — | 1 | 2026-07-20 | 32 |
| Syft | 4 | 3 | 1 | 1 | 5 | — | 7 | 1 | 1 | — | 2026-07-06 | 23 |
| Grype | 4 | 8 | 1 | 2 | 1 | 2 | — | 1 | 1 | — | — | 20 |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — | — | 18 |
| Terraform | 2 | 3 | 1 | 1 | — | — | — | — | — | — | 2026-07-15 | 7 |
| Falco | 4 | 3 | 3 | 1 | 2 | — | — | — | — | — | 2026-07-19 | 13 |
| CodeQL | 3 | 1 | 1 | 4 | 1 | 1 | — | — | 1 | — | — | 12 |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — | — | 11 |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | 1 | — | — | 11 |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | 1 | — | — | 10 |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — | — | 9 |
| Cosign | 4 | 2 | 1 | 1 | — | 1 | — | — | — | — | — | 9 |
| Terrascan | 5 | 1 | 1 | 2 | — | — | — | — | — | — | 2026-07-10 | 9 |
| Dependabot | 6 | — | 3 | — | — | — | — | — | — | — | 2026-07-21 | 9 |
| Git | 3 | 2 | — | 1 | — | — | — | — | — | — | 2026-07-26 | 6 |
| Docker | 2 | 1 | — | — | — | — | — | — | 2 | — | 2026-07-12 | 5 |
| ArgoCD | 3 | — | — | — | — | 1 | — | — | — | — | 2026-07-25 | 4 |
| Helm | 2 | — | — | — | — | 1 | — | — | — | — | 2026-07-19 | 3 |
| Kubernetes | 2 | — | — | — | — | 1 | — | — | — | — | 2026-07-15 | 3 |
| Kustomize | 2 | — | 1 | — | — | — | — | — | — | — | 2026-07-08 | 3 |
| GitHub Actions | 2 | — | 1 | — | — | — | — | — | — | — | 2026-07-14 | 3 |
| SonarQube | 2 | — | — | 1 | — | — | — | — | — | — | 2026-07-19 | 3 |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — | — | 3 |
| OpenTofu | 2 | — | 1 | — | — | — | — | — | — | — | 2026-07-20 | 3 |
| DefectDojo | 1 | — | — | 1 | — | — | — | — | — | — | — | 2 |
| Grafana | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Observability | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Linux | 1 | — | — | — | — | — | — | — | — | — | — | 1 |

</details>

---

## Status

Currently expanding tool coverage with foundational concept primers for secrets management, version control, infrastructure as code, and Linux/shell fundamentals; practice exercises across multiple domains; and ongoing CVE remediation guides for the security toolchain.

---

_Last updated: 2026-07-30_