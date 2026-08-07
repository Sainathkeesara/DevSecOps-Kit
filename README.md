# DevSecOps-Kit
> A working-engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Cosign, OPA, Falco, Vault, Terraform, and more.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs. The kit covers scanners (Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, GitGuardian, Snyk, Terrascan, ZAP), runtime and supply-chain tools (Cosign, Falco, Tetragon, OPA, Vault), CI/CD and orchestration (Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu), and supporting platforms (Git, Prometheus, Grafana, observability, SonarQube, DefectDojo, Dependabot).

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Every entry is scenario-grounded and designed to be adapted for real infrastructure work. The kit spans 30+ tools across security scanning, runtime protection, supply chain, policy enforcement, and infrastructure automation — all organised for quick lookup and hands-on practice.

## Quick links

- [Secrets detection and remediation workflow analysis](docs/concepts/secrets-access-management/notebooks/secrets-detection-remediation-workflow-analysis.ipynb) — Notebook exploring detect, alert, and remediate stages for leaked secrets
- [Semgrep rule performance optimization](semgrep/docs/semgrep-rule-performance-optimization.md) — Combining patterns for efficient scanning in large codebases
- [Linux shell scripting tutorial confusions](lin/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md) — Common pitfalls and clarifications for shell scripting learners
- [Cron job configuration](lin/configs/2026-08-06-cron-job-configuration.ini) — Sample cron job for scheduled automation
- [Comparing community vs custom Semgrep rules](semgrep/notebooks/comparing-community-vs-custom-rules.ipynb) — Notebook comparing built-in and custom rule approaches

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
- **`lin/`** — Linux shell scripting tutorials and cron configurations
- **`sonarqube/` / `opentofu/`** — Static analysis and IaC tool primers
- **`grafana/` / `observability/` / `prometheus/`** — Metrics, logs, traces, dashboards
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform primers, configs, scripts, and EventBridge Lambda modules

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Last verified | Total |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|:-------------:|------:|
| TruffleHog | 3 | 2 | 3 | 2 | 2 | 16 | 1 | 1 | 2 | — | — | 32 |
| ZAP | 5 | 3 | 2 | 2 | 4 | 14 | — | 1 | — | — | 2026-07-20 | 31 |
| Checkov | 4 | 5 | 2 | 2 | 4 | 8 | 2 | — | 2 | 1 | 2026-07-20 | 30 |
| Trivy | 3 | 3 | 5 | 2 | 1 | 5 | 2 | 1 | 2 | — | — | 24 |
| Syft | 4 | 5 | 3 | 1 | 1 | 6 | 1 | 1 | 1 | — | 2026-07-06 | 23 |
| Grype | 4 | 1 | 8 | 1 | 2 | — | 2 | 1 | 1 | — | — | 20 |
| Semgrep | 3 | 5 | 3 | 1 | 2 | — | 2 | 2 | 2 | — | 2026-08-06 | 20 |
| Terraform | 3 | — | 4 | 10 | 1 | — | — | — | — | — | 2026-08-04 | 18 |
| Falco | 4 | 2 | 3 | 3 | 1 | — | — | — | — | — | 2026-07-19 | 13 |
| CodeQL | 3 | 1 | 1 | 1 | 4 | — | 1 | 1 | — | — | — | 12 |
| GitGuardian | 4 | 1 | 2 | 2 | 2 | — | — | — | — | — | — | 11 |
| Vault | 3 | 2 | 2 | 2 | 1 | — | — | 1 | — | — | — | 11 |
| Dependabot | 6 | — | 1 | 3 | — | — | — | — | — | — | 2026-07-21 | 10 |
| Snyk | 4 | 1 | 1 | 2 | 1 | — | — | 1 | — | — | — | 10 |
| Cosign | 4 | — | 2 | 1 | 1 | — | 1 | — | — | — | — | 9 |
| OPA | 3 | 1 | 1 | 1 | 3 | — | — | — | — | — | — | 9 |
| Terrascan | 5 | — | 1 | 1 | 2 | — | — | — | — | — | 2026-07-10 | 9 |
| Docker | 2 | 1 | 2 | 1 | — | — | — | 2 | — | — | 2026-08-05 | 8 |
| GitHub Actions | 3 | — | — | 2 | — | — | 2 | — | — | — | 2026-08-04 | 7 |
| Tetragon | 3 | — | 1 | 2 | — | — | — | — | — | — | 2026-08-06 | 6 |
| Git | 3 | — | 2 | — | 1 | — | — | — | — | — | 2026-07-26 | 6 |
| ArgoCD | 5 | — | — | — | — | — | 1 | — | — | — | 2026-08-01 | 6 |
| Ansible | — | — | 2 | — | — | — | — | — | — | — | — | 2 |
| DefectDojo | 2 | — | 1 | — | 1 | — | — | — | — | — | 2026-08-04 | 3 |
| Helm | 2 | — | — | — | — | — | 1 | — | — | — | 2026-07-19 | 3 |
| Kubernetes | 2 | — | — | — | — | — | 1 | — | — | — | 2026-07-15 | 3 |
| Kustomize | 2 | — | — | 1 | — | — | — | — | — | — | 2026-07-08 | 3 |
| OpenTofu | 2 | — | — | 1 | — | — | — | — | — | — | 2026-07-20 | 3 |
| SonarQube | 2 | — | — | — | 1 | — | — | — | — | — | 2026-07-19 | 3 |
| Grafana | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Linux | 1 | — | — | — | — | — | — | — | — | — | — | 1 |
| Observability | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — | 2026-07-13 | 1 |

</details>

## Status

Currently expanding tool coverage with foundational concept primers for secrets management, version control, infrastructure as code, and Linux/shell fundamentals; practice exercises across multiple domains; and ongoing CVE remediation guides for the security toolchain. The newest additions are secrets detection workflow analysis, Semgrep rule performance notes, Linux shell scripting tutorials, and Tetragon observability content.

---
_Last updated: 2026-08-07_
