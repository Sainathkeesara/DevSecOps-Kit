# DevSecOps-Kit

> A working engineer's devops and devsecops reference — notes, snippets, configs, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before the table below.

---

## Who this is for

A working DevSecOps engineer's quick-reference for Trivy, Semgrep, Checkov, Grype, TruffleHog, Syft, Cosign, OPA, Falco, and HashiCorp Vault. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and secrets management. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

The kit spans tools including Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan, TruffleHog, GitGuardian, Syft, Cosign, Dependabot, Falco, Tetragon, OPA, Vault, ZAP, DefectDojo, SonarQube, Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu, Git, Prometheus, Grafana, and observability — with CVE-specific remediation guidance, Linux system administration, and CI/CD pipeline toolkits.

---

## Quick links

- [Explore Falco CLI, rules, events, and output](falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md) — Walk through Falco's CLI flags, rule syntax, event output, and driver modes
- [Explore Helm charts, releases, values, and repos](helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md) — First look at Helm chart structure, releases, values, and repo management
- [Explore SonarQube quality gates and profiles](sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md) — Quality Gates, Quality Profiles, and project analysis walkthrough
- [Checkov v3 migration guide](checkov/docs/checkov-v3-migration-guide.md) — Migrate Checkov configs from v2 to v3 with config file changes and policy path updates
- [AppSec + secrets integration exercise](docs/concepts/application-security-testing-concepts/snippets/2026-07-19-appsec-secrets-integration.py) — Practice connecting AppSec scanning with secret detection in a unified workflow

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

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | Policies | Total |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|---------:|------:|
| Trivy | 3 | 5 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — | 25 |
| TruffleHog | 3 | 3 | 2 | 2 | 2 | 1 | 21 | 2 | 1 | — | 37 |
| ZAP | 4 | 2 | 2 | 4 | 3 | — | 16 | — | 1 | — | 32 |
| Checkov | 4 | 2 | 2 | 4 | 4 | 2 | 10 | 1 | — | 1 | 30 |
| Syft | 4 | 3 | 1 | 1 | 5 | — | 7 | 1 | 1 | — | 23 |
| Grype | 4 | 7 | 1 | 2 | 1 | 2 | — | 1 | 1 | — | 19 |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — | 18 |
| Falco | 4 | 3 | 3 | 1 | 2 | — | — | — | — | — | 13 |
| Terraform | 2 | 3 | 1 | — | — | — | — | — | — | — | 13 |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — | 11 |
| CodeQL | 3 | 1 | 1 | 3 | 1 | 1 | — | — | — | — | 10 |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | — | — | 10 |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — | 9 |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | — | — | 9 |
| Cosign | 4 | 2 | 1 | 1 | — | 1 | — | — | — | — | 9 |
| Terrascan | 5 | 1 | 1 | 2 | — | — | — | — | — | — | 9 |
| Dependabot | 5 | — | 3 | — | — | — | — | — | — | — | 8 |
| Git | 3 | 2 | — | 1 | — | — | — | — | — | — | 6 |
| Docker | 2 | 1 | — | — | — | — | — | — | 2 | — | 5 |
| ArgoCD | 2 | — | — | — | — | 1 | — | — | — | — | 3 |
| Helm | 2 | — | — | — | — | 1 | — | — | — | — | 3 |
| Kubernetes | 2 | — | — | — | — | 1 | — | — | — | — | 3 |
| Kustomize | 2 | — | 1 | — | — | — | — | — | — | — | 3 |
| GitHub Actions | 2 | — | 1 | — | — | — | — | — | — | — | 3 |
| SonarQube | 2 | — | — | 1 | — | — | — | — | — | — | 3 |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — | 3 |
| DefectDojo | 1 | — | — | 1 | — | — | — | — | — | — | 2 |
| OpenTofu | 1 | — | — | — | — | — | — | — | — | — | 1 |
| Grafana | 1 | — | — | — | — | — | — | — | — | — | 1 |
| Observability | 1 | — | — | — | — | — | — | — | — | — | 1 |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — | 1 |

</details>

---

## Status

Currently expanding foundational concept docs — Falco CLI exploration, Helm chart management, SonarQube quality gates and profiles, Checkov v3 migration guide, and AppSec secrets integration exercises.

---

_Last updated: 2026-07-20_
