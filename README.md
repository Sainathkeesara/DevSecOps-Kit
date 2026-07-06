# DevSecOps-Kit
> A working engineer's devops and devsecops reference — scripts, notes, snippets, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, CI/CD, and infrastructure automation.

| Last commit | Repo size | Languages |
|-------------|-----------|-----------|
| [![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) | [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) | [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Language count](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) |

---

## Who this is for

A working DevSecOps engineer's quick-reference for Trivy, Semgrep, Checkov, Grype, TruffleHog, Syft, Cosign, OPA, Falco, and HashiCorp Vault. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering the tools and practices a practising security engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans vulnerability scanning (Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan), secret detection (TruffleHog, GitGuardian), supply chain security (Syft, Cosign, Dependabot), runtime security (Falco, Tetragon), policy engines (OPA), secrets management (Vault), CI/CD, Linux, Kubernetes, Terraform, Docker, and Kafka — with CVE-specific remediation guidance.

---

## Quick links

- [zap-automation-plan.yaml](zap/templates/zap-dast-integration-scaffold/zap-automation-plan.yaml) — Headless DAST scanning configuration for CI
- [DefectDojo primer](defectdojo/notes/0000-primer-defectdojo.md) — What DefectDojo is, key terminology, and local Docker Compose startup
- [Install DefectDojo and import first scan report](defectdojo/snippets/install-defectdojo-first-scan-report.sh) — Clone repo, start stack, and point browser at localhost:8080
- [ZAP DAST full scan plan](zap/templates/zap-dast-integration/plans/full-scan.yaml) — Full scan plan for CI-integrated DAST with ZAP Automation Framework
- [ZAP DAST quick scan plan](zap/templates/zap-dast-integration/plans/quick-scan.yaml) — Quick scan plan for CI-integrated DAST with ZAP Automation Framework

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`defectdojo/`** — DefectDojo vulnerability management, notes, and snippets
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/` / `tetragon/`** — Vulnerability scanner and runtime security tool content
- **`terrascan/` / `opa/`** — IaC compliance and policy engine primers
- **`dependabot/`** — Dependabot primer, notes, and dependency update configs
- **`defectdojo/`** — DefectDojo vulnerability management platform notes, scripts, configs, and snippets
- **`vault/`** — HashiCorp Vault primers and notes
- **`git/`** — Git primers, notes, and version control reference
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux automation, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform modules (EventBridge Lambda)
- **`assets/`** — Static images and diagrams
- **`.github/`** — GitHub templates (PR template, CODEOWNERS, CI workflow docs)
- **`CHANGELOG.md`** — Release history and version tracking
- **`CONTRIBUTING.md`** — Contribution guidelines and workflow

---

## Coverage

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|
| Trivy | 3 | 5 | 2 | 1 | 3 | 2 | 6 | 2 | 1 |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 |
| Checkov | 4 | 2 | 2 | 4 | 3 | 2 | 10 | 1 | — |
| TruffleHog | 3 | 3 | 2 | 2 | 2 | 1 | 19 | 2 | 1 |
| Syft | 4 | 3 | 1 | 1 | 2 | — | 7 | 1 | 1 |
| Grype | 4 | 5 | 1 | 2 | 1 | — | — | 1 | 1 |
| CodeQL | 3 | 1 | 1 | 3 | 1 | 1 | — | — | — |
| ZAP | 4 | 2 | 2 | 3 | 2 | — | 16 | — | 1 |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | — |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — |
| Falco | 3 | 3 | 3 | 1 | 2 | — | — | — | — |
| Cosign | 4 | 2 | 1 | 1 | — | — | — | — | — |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — |
| Terrascan | 4 | 1 | 1 | 2 | — | — | — | — | — |
| Dependabot | 3 | — | 1 | — | — | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | — |
| Git | 1 | 8 | — | 1 | 25 | — | — | — | — |
| Docker | — | 4 | — | 1 | 2 | — | — | — | — |
| Kubernetes | — | 17 | — | 1 | 11 | — | 3 | — | — |
| Terraform | — | 16 | — | 1 | 27 | — | 12 | — | — |
| Helm | — | 3 | — | — | 3 | — | — | — | — |
| Ansible | — | 11 | — | 1 | 17 | — | — | — | — |
| Observability | — | 14 | — | 1 | 7 | — | — | — | — |
| OCI Registries | — | 11 | — | 1 | 7 | — | — | — | — |
| Jenkins | — | 5 | — | 4 | 14 | — | 1 | — | — |
| DefectDojo | 1 | 1 | — | — | — | — | — | — | — |

---

## Status

Active maintenance with weekly additions. Current focus areas: Kubernetes CVE remediation, ZAP Automation Framework, Grype SARIF output integration, Vault policy-as-code, and OPA admission control wiring.

---

_Last updated: 2026-07-05_