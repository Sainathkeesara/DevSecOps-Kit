# DevSecOps-Kit
> A working engineer's devops and devsecops reference — scripts, how-to guides, runbooks, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, CI/CD, and infrastructure automation.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-659-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-230-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-274-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-40-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of shell scripts, how-to guides, runbooks, snippets, and templates covering the tools and practices a practising security engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans vulnerability scanning (Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan), secret detection (TruffleHog, GitGuardian), supply chain security (Syft, Cosign, Dependabot), runtime security (Falco, Tetragon), policy engines (OPA), secrets management (Vault), CI/CD, observability, Kubernetes, Terraform, Docker, Linux, and Kafka — with CVE-specific remediation guidance.

---

## Coverage

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | More |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|------|
| Trivy | 3 | 7 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — |
| Checkov | 4 | 4 | 2 | 4 | 3 | 2 | 10 | 1 | — | policies:1 |
| TruffleHog | 3 | 3 | 2 | 2 | 2 | — | 11 | 1 | 1 | — |
| Syft | 4 | 3 | 1 | 1 | 2 | — | 7 | 1 | 1 | — |
| Grype | 4 | 5 | 1 | 2 | — | — | — | 1 | 1 | — |
| CodeQL | 3 | 1 | 1 | 3 | 1 | 1 | — | — | — | — |
| ZAP | 4 | 2 | 2 | 3 | 2 | — | — | — | 1 | — |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | — | — |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — |
| Falco | 3 | 1 | 3 | 1 | 2 | — | — | — | — | — |
| Cosign | 4 | 2 | 1 | 1 | — | — | — | — | — | — |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — |
| Terrascan | 3 | 1 | 1 | 2 | — | — | — | — | — | — |
| Dependabot | 3 | — | 1 | — | — | — | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | — | scripts:9 |
| Linux | — | 50 | — | 2 | 40 | — | 16 | — | — | runbooks:1 |
| Kubernetes | — | 17 | — | 1 | 11 | — | 3 | — | — | — |
| Kafka | — | 17 | — | 2 | 3 | — | — | — | — | — |
| Terraform | — | 15 | — | 1 | 16 | — | 12 | — | — | envs:12, tf:5 |
| Jenkins | — | 4 | — | 4 | 11 | — | 1 | — | — | — |
| Ansible | — | 11 | — | 1 | 6 | — | — | — | — | playbooks:4 |
| Observability | — | 14 | — | 1 | 9 | — | — | — | — | — |
| OCI / Registries | — | 11 | — | 1 | 6 | — | — | — | — | — |
| Docker | — | 7 | — | 1 | 6 | — | — | — | — | — |
| Helm | — | 3 | — | — | 2 | — | — | — | — | — |
| CI/CD | — | 17 | — | 1 | 11 | — | — | — | — | — |
| Git | — | 8 | — | 1 | 20 | — | — | — | — | — |

---

## Quick links

- [Custom ZAP Docker image with Automation Framework plans](zap/dockerfiles/custom-zap-automation.Dockerfile) — Self-contained image with embedded quick-scan and full-scan plans for CI
- [ZAP DAST pipeline with SARIF and Code Scanning](zap/scripts/zap-dast-sarif-code-scanning.sh) — Run DAST, convert alerts to SARIF, upload to GitHub Code Scanning
- [Vault multi-environment access control policy](vault/configs/multi-environment-access-control.hcl) — HCL policy for dev/staging/prod engines
- [Multi-stage Grype vulnerability scanning Dockerfile](grype/dockerfiles/multi-stage-grype-scan.Dockerfile) — Build + scan + runtime stages with Grype
- [Grype results to SARIF converter](grype/scripts/grype-results-to-sarif.py) — Reusable Python script to convert Grype JSON output to SARIF 2.1.0

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

Active maintenance with weekly additions. Current focus areas: ZAP DAST automation framework, Grype SARIF output integration, Vault policy-as-code, and OPA admission control wiring.

---

_Last updated: 2026-06-28_
