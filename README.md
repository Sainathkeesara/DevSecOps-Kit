# DevSecOps-Kit
> A working engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, Syft, TruffleHog, Falco, OPA, Vault, and more.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![License](https://img.shields.io/github/license/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before the table below.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and secrets management. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

The kit spans tools including Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan, TruffleHog, GitGuardian, Syft, Cosign, Dependabot, Falco, Tetragon, OPA, Vault, ZAP, DefectDojo, SonarQube, Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu, Git, Prometheus, Grafana, and observability — with CVE-specific remediation guidance, Linux system administration, and CI/CD pipeline toolkits.

## Quick links

- [Secrets access management practice exercises](docs/concepts/secrets-access-management/snippets/2026-07-24-practice-exercises.py) — Python exercises for secret handling and access management
- [Version control with Git practice exercises](docs/concepts/version-control-with-git/scripts/2026-07-24-practice-exercises.sh) — Hands-on Git exercises for branching, merging, and collaboration
- [Infrastructure as Code practice exercises](docs/concepts/infrastructure-as-code/snippets/2026-07-23-practice-exercises.hcl) — HCL exercises for Terraform resource composition
- [Linux & Shell practice exercises](docs/concepts/linux-shell-fundamentals/scripts/2026-07-23-practice-exercises.sh) — Shell scripting and command-line exercises
- [Supply chain security practice exercises](docs/concepts/software-supply-chain-security/snippets/2026-07-23-practice-exercises.sh) — SBOM and dependency verification exercises

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

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | Policies | Total |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|---------:|------:|
| Trivy | 3 | 6 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — | 25 |
| TruffleHog | 3 | 7 | 2 | 2 | 2 | 1 | 21 | 2 | 1 | — | 41 |
| ZAP | 5 | 4 | 2 | 4 | 3 | — | 16 | — | 1 | — | 35 |
| Checkov | 4 | 2 | 2 | 4 | 5 | 2 | 10 | 2 | — | 1 | 32 |
| Syft | 4 | 4 | 1 | 1 | 5 | — | 7 | 1 | 1 | — | 24 |
| Grype | 4 | 8 | 1 | 2 | 1 | 2 | — | 1 | 1 | — | 20 |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — | 18 |
| Terraform | 2 | 3 | 1 | 1 | — | — | — | — | — | — | 7 |
| Falco | 4 | 3 | 3 | 1 | 2 | — | — | — | — | — | 13 |
| CodeQL | 3 | 1 | 1 | 4 | 1 | 1 | — | — | 1 | — | 12 |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — | 11 |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | 1 | — | 11 |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | 1 | — | 10 |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — | 9 |
| Cosign | 4 | 2 | 1 | 1 | — | 1 | — | — | — | — | 9 |
| Terrascan | 5 | 1 | 1 | 2 | — | — | — | — | — | — | 9 |
| Dependabot | 6 | — | 3 | — | — | — | — | — | — | — | 9 |
| Git | 3 | 2 | — | 1 | — | — | — | — | — | — | 6 |
| Docker | 2 | 1 | — | — | — | — | — | — | 2 | — | 5 |
| ArgoCD | 2 | — | — | — | — | 1 | — | — | — | — | 3 |
| Helm | 2 | — | — | — | — | 1 | — | — | — | — | 3 |
| Kubernetes | 2 | — | — | — | — | 1 | — | — | — | — | 3 |
| Kustomize | 2 | — | 1 | — | — | — | — | — | — | — | 3 |
| GitHub Actions | 2 | — | 1 | — | — | — | — | — | — | — | 3 |
| SonarQube | 2 | — | — | 1 | — | — | — | — | — | — | 3 |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — | 3 |
| OpenTofu | 2 | — | 1 | — | — | — | — | — | — | — | 3 |
| DefectDojo | 1 | — | — | 1 | — | — | — | — | — | — | 2 |
| Grafana | 1 | — | — | — | — | — | — | — | — | — | 1 |
| Observability | 1 | — | — | — | — | — | — | — | — | — | 1 |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — | 1 |
| Linux | 1 | — | — | — | — | — | — | — | — | — | 1 |

</details>

## Status

Currently expanding tool coverage with foundational concept primers for secrets management, version control, infrastructure as code, and Linux/shell fundamentals; practice exercises across multiple domains; and ongoing CVE remediation guides for the security toolchain.

---
_Last updated: 2026-07-27_
