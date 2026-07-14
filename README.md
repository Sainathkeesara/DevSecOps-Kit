# DevSecOps-Kit

> A working engineer's devops and devsecops reference — notes, snippets, configs, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, observability, and infrastructure automation.

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before the table below.

| Last commit | Repo size | Top language | Languages |
|-------------|-----------|--------------|-----------|
| [![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) | [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) | [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) | [![Language count](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) |

---

## Who this is for

A working DevSecOps engineer's quick-reference for Trivy, Semgrep, Checkov, Grype, TruffleHog, Syft, Cosign, OPA, Falco, Grafana, Prometheus, and HashiCorp Vault. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering the tools and practices a practising security engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans vulnerability scanning (Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan), secret detection (TruffleHog, GitGuardian), supply chain security (Syft, Cosign, Dependabot), runtime security (Falco, Tetragon), policy engines (OPA), secrets management (Vault), observability (Grafana, Prometheus), CI/CD, Linux, Kubernetes, Terraform, Docker, and Kafka — with CVE-specific remediation guidance.

---

## Quick links

- [Grafana primer](grafana/notes/0000-primer-grafana.md) — First-contact notes for the Grafana dashboard and visualization layer
- [Observability primer](observability/notes/0000-primer-observability.md) — First-contact notes on logs, metrics, traces, SLIs, and SLOs
- [Prometheus primer](prometheus/notes/0000-primer-prometheus.md) — First-contact notes for the Prometheus time-series metrics system
- [Applying AppSec in DevSecOps](docs/concepts/application-security-testing-concepts/2026-07-12-applying-appsec-in-devsecops.md) — Where SAST, DAST, SCA, and secrets scanning fit in a pipeline
- [AppSec practice exercises](docs/concepts/application-security-testing-concepts/snippets/2026-07-12-appsec-practice-exercises.py) — Hands-on exercises for AppSec testing fundamentals

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`assets/`** — Static assets referenced by docs: architecture diagrams and workflow illustrations
- **`argocd/`** — ArgoCD GitOps continuous delivery notes, manifests, and first-app deployments
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/` / `tetragon/`** — Vulnerability scanner and runtime security tool content
- **`terrascan/` / `opa/`** — IaC compliance and policy engine primers
- **`defectdojo/`** — Vulnerability management, triage, and tracking platform
- **`dependabot/`** — Dependabot primer, notes, and dependency update configs
- **`vault/`** — HashiCorp Vault primers and notes
- **`git/`** — Git primers, notes, and version control reference
- **`docker/`** — Docker image authoring, runtime, and container security notes
- **`github-actions/`** — GitHub Actions CI/CD workflows, runners, and reusable actions
- **`helm/`** — Helm chart authoring, releases, and repository management notes
- **`kubernetes/`** — Kubernetes cluster administration, manifests, and workload patterns
- **`kustomize/`** — Kustomize overlay and base configuration notes
- **`sonarqube/`** — SonarQube static analysis, Quality Gates, and profiles
- **`opentofu/`** — OpenTofu IaC notes, providers, state, and modules
- **`grafana/`** — Grafana dashboard, visualization, and alerting notes
- **`prometheus/`** — Prometheus metrics, scraping, PromQL, and alerting notes
- **`observability/`** — Observability concepts: logs, metrics, traces, SLIs, SLOs
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux automation, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform modules (EventBridge Lambda)
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
| ZAP | 4 | 2 | 2 | 3 | 3 | — | 16 | — | 1 | — |
| Syft | 4 | 3 | 1 | 1 | 5 | — | 7 | 1 | 1 | — |
| Checkov | 4 | 2 | 2 | 4 | 3 | 2 | 10 | 1 | — | 1 |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — |
| Grype | 4 | 6 | 1 | 2 | 1 | 2 | — | 1 | 1 | — |
| Falco | 3 | 3 | 3 | 1 | 2 | — | — | — | — | — |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | — | — |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | — | — |
| CodeQL | 3 | 1 | 1 | 3 | 1 | 1 | — | — | — | — |
| Terrascan | 5 | 1 | 1 | 2 | — | — | — | — | — | — |
| Cosign | 4 | 2 | 1 | 1 | — | — | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — |
| Dependabot | 5 | — | 2 | — | — | — | — | — | — | — |
| DefectDojo | 1 | — | — | 1 | — | — | — | — | — | — |
| Git | 3 | 2 | — | 1 | — | — | — | — | — | — |
| ArgoCD | 2 | — | — | — | — | 1 | — | — | — | — |
| Docker | 2 | — | — | — | — | — | — | — | 2 | — |
| Helm | 1 | — | — | — | — | — | — | — | — | — |
| Kubernetes | 1 | — | — | — | — | — | — | — | — | — |
| GitHub Actions | 1 | — | — | — | — | — | — | — | — | — |
| SonarQube | 1 | — | — | — | — | — | — | — | — | — |
| OpenTofu | 1 | — | — | — | — | — | — | — | — | — |
| Grafana | 1 | — | — | — | — | — | — | — | — | — |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — |
| Observability | 1 | — | — | — | — | — | — | — | — | — |
| Kustomize | 2 | — | 1 | — | — | — | — | — | — | — |

</details>

---

## Status

Currently working through L1 first-contact notes for Grafana, Prometheus, and observability concepts, alongside Kubernetes CVE remediation, ZAP Automation Framework, Grype SARIF output integration, Vault policy-as-code, and OPA admission control wiring.

---

_Last updated: 2026-07-14_
