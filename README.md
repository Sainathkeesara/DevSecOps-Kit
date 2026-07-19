# DevSecOps-Kit

> A working engineer's devops and devsecops reference — notes, snippets, configs, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![License](https://img.shields.io/github/license/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before the table below.

---

## Who this is for

A working DevSecOps engineer's quick-reference for Trivy, Semgrep, Checkov, Grype, TruffleHog, Syft, Cosign, OPA, Falco, and HashiCorp Vault. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and secrets management. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

The kit spans tools including Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan, TruffleHog, GitGuardian, Syft, Cosign, Dependabot, Falco, Tetragon, OPA, Vault, ZAP, DefectDojo, SonarQube, Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu, Git, Prometheus, Grafana, and observability — with CVE-specific remediation guidance, Linux system administration, and CI/CD pipeline toolkits.

---

## Quick links

- [Checkov v3 migration guide](checkov/docs/checkov-v3-migration-guide.md) — Migrating Checkov configurations from v2 to v3
- [AppSec + secrets integration exercise](docs/concepts/application-security-testing-concepts/snippets/2026-07-19-appsec-secrets-integration.py) — Crossing security testing and secrets management
- [Dependabot Python project config](dependabot/configs/2026-07-18-python-project-version-update.yaml) — Weekly pip dependency updates with Dependabot
- [Docker custom networking and volumes](docker/scripts/2026-07-18-custom-network-volume-mounts.sh) — Run a container with bridge networking and named volumes
- [Terraform cleanup script](terraform/scripts/2026-07-18-cleanup.sh) — Destroy infrastructure across Terraform workspaces

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

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | Policies |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|---------:|
| Trivy | 3 | 5 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — |
| TruffleHog | 3 | 3 | 2 | 2 | 2 | 1 | 21 | 2 | 1 | — |
| ZAP | 4 | 2 | 2 | 4 | 3 | — | 16 | — | 1 | — |
| Checkov | 4 | 2 | 2 | 4 | 4 | 2 | 10 | 1 | — | 1 |
| Syft | 4 | 3 | 1 | 1 | 5 | — | 7 | 1 | 1 | — |
| Grype | 4 | 7 | 1 | 2 | 1 | 2 | — | 1 | 1 | — |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — |
| Falco | 3 | 3 | 3 | 1 | 2 | — | — | — | — | — |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | — | — |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | — | — |
| CodeQL | 3 | 1 | 1 | 3 | 1 | 1 | — | — | — | — |
| Terrascan | 5 | 1 | 1 | 2 | — | — | — | — | — | — |
| Cosign | 4 | 2 | 1 | 1 | — | 1 | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — |
| Dependabot | 5 | — | 3 | — | — | — | — | — | — | — |
| DefectDojo | 1 | — | — | 1 | — | — | — | — | — | — |
| Git | 3 | 2 | — | 1 | — | — | — | — | — | — |
| ArgoCD | 2 | — | — | — | — | 1 | — | — | — | — |
| Kustomize | 2 | — | 1 | — | — | — | — | — | — | — |
| Docker | 2 | 1 | — | — | — | — | — | — | 2 | — |
| Helm | 1 | — | — | — | — | 1 | — | — | — | — |
| Kubernetes | 2 | — | — | — | — | 1 | — | — | — | — |
| GitHub Actions | 2 | — | 1 | — | — | — | — | — | — | — |
| SonarQube | 1 | — | — | 1 | — | — | — | — | — | — |
| OpenTofu | 1 | — | — | — | — | — | — | — | — | — |
| Grafana | 1 | — | — | — | — | — | — | — | — | — |
| Observability | 1 | — | — | — | — | — | — | — | — | — |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — |
| Terraform | 2 | 3 | 1 | — | — | — | — | — | — | — |

</details>

---

## Status

The kit has 764 files across 31 tool directories plus docs, scripts, templates, and lab content. Most recently added: a Checkov v3 migration guide, an AppSec + secrets integration exercise, a Python project Dependabot config, Docker networking/volume scripts, and Terraform deploy/cleanup scripts. The next focus areas are cross-tool CI/CD recipes and expanding the Kubernetes ecosystem coverage.

---

_Last updated: 2026-07-19_
