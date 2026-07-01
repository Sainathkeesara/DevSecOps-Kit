# DevSecOps-Kit
> A working engineer's devops and devsecops reference — scripts, how-to guides, runbooks, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, CI/CD, and infrastructure automation.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-672-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-231-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-278-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-40-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of shell scripts, how-to guides, runbooks, snippets, and templates covering the tools and practices a practising security engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans vulnerability scanning (Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan), secret detection (TruffleHog, GitGuardian), supply chain security (Syft, Cosign, Dependabot), runtime security (Falco, Tetragon), policy engines (OPA), secrets management (Vault), CI/CD, observability, Kubernetes, Terraform, Docker, Linux, and Kafka — with CVE-specific remediation guidance.

---

## Coverage

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | More |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|------|
| Trivy | 3 | 6 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — |
| Checkov | 4 | 2 | 2 | 4 | 3 | 2 | 10 | 1 | — | policies:1 |
| TruffleHog | 3 | 5 | 2 | 2 | 2 | 1 | 11 | 1 | 1 | — |
| Syft | 4 | 4 | 1 | 1 | 2 | — | 7 | 1 | 1 | — |
| Grype | 4 | 5 | 1 | 2 | 1 | — | — | 1 | 1 | — |
| CodeQL | 3 | 1 | 1 | 3 | 1 | 1 | — | — | — | — |
| ZAP | 4 | 3 | 2 | 3 | 2 | — | 10 | — | 1 | — |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | — | — |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — |
| Falco | 3 | 1 | 3 | 1 | 2 | — | — | — | — | — |
| Cosign | 4 | 2 | 1 | 1 | — | — | — | — | — | — |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — |
| Terrascan | 4 | 1 | 1 | 2 | — | — | — | — | — | — |
| Dependabot | 3 | — | 1 | — | — | — | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — |
| Vault | 3 | 10 | 2 | 1 | 2 | — | — | — | — | — |
| Linux | — | 50 | — | 2 | 40 | — | 14 | — | — | runbooks:1 |
| Kubernetes | — | 15 | — | 1 | 19 | — | 3 | — | — | — |
| Kafka | — | 17 | — | 2 | 3 | — | — | — | — | — |
| Terraform | — | 16 | — | 1 | 27 | — | 12 | — | — | envs:12, tf:5 |
| Jenkins | — | 5 | — | 4 | 14 | — | 1 | — | — | — |
| Ansible | — | 11 | — | 1 | 17 | — | — | — | — | playbooks:4 |
| Observability | — | 14 | — | 1 | 7 | — | — | — | — | — |
| OCI / Registries | — | 11 | — | 1 | 7 | — | — | — | — | — |
| Docker | — | 4 | — | 1 | 2 | — | — | — | — | security:2 |
| Helm | — | 3 | — | — | 3 | — | — | — | — | — |
| CI/CD | — | 15 | — | 1 | 7 | — | — | — | — | security:2 |
| Git | — | 8 | — | 1 | 25 | — | — | — | — | — |

---

## Quick links

- [TruffleHog PR secret scan reusable workflow](trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml) — Reusable GitHub Actions workflow for PR-level secret scanning with SARIF upload
- [Grype + Syft integration guide](grype/docs/grype-syft-integration-guide.md) — SBOM generation, offline scanning, and CI pipeline integration
- [Terrascan getting-started trip-ups](terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md) — L2 notes: install, scan, exit codes, and CI gating gotchas
- [ZAP DAST integration scaffold](zap/templates/zap-dast-integration/) — GitHub Actions workflow + Automation Framework plan scaffold for CI DAST scanning
- [Vault multi-environment access control policy](vault/configs/multi-environment-access-control.hcl) — HCL policy for dev/staging/prod engines

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/` / `tetragon/`** — Vulnerability scanner and runtime security tool content
- **`terrascan/` / `opa/`** — IaC compliance and policy engine primers
- **`dependabot/`** — Dependabot primer, notes, and dependency update configs
- **`vault/`** — HashiCorp Vault primers and notes
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

## Status

Active maintenance with weekly additions. Current focus areas: TruffleHog PR-level secret scanning, Grype SARIF output integration, ZAP DAST automation framework, and Terrascan CI gating workflows.

---

_Last updated: 2026-06-30_
