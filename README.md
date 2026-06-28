# DevSecOps-Kit
> A working engineer's devops and devsecops reference — scripts, how-to guides, runbooks, and templates for infrastructure automation, security scanning, CI/CD, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-649-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-228-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-271-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
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
| Semgrep | 3 | 2 | 1 | 2 | 4 | 2 | — | 1 | 2 | — |
| Checkov | 4 | 4 | 2 | 4 | 3 | 2 | 10 | 1 | — | policies:1 |
| TruffleHog | 3 | 6 | 2 | 2 | 1 | — | 11 | 1 | 1 | — |
| Syft | 4 | 5 | 1 | 1 | 2 | — | 7 | 1 | 1 | — |
| Grype | 4 | 5 | 1 | 2 | — | — | — | 1 | — | — |
| CodeQL | 3 | 2 | 1 | 3 | 1 | 1 | — | — | — | — |
| ZAP | 4 | 4 | 2 | 3 | 2 | — | — | — | — | — |
| Snyk | 4 | 2 | 2 | 1 | 1 | — | — | — | — | — |
| GitGuardian | 4 | 4 | 2 | 2 | 1 | — | — | — | — | — |
| Falco | 3 | 1 | 3 | 1 | 2 | — | — | — | — | — |
| Cosign | 4 | 3 | 1 | 1 | — | — | — | — | — | — |
| OPA | 3 | 2 | 1 | 2 | — | — | — | — | — | — |
| Terrascan | 3 | 1 | 1 | 2 | — | — | — | — | — | — |
| Dependabot | 3 | — | 1 | — | — | — | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — |
| Vault | 3 | 1 | 1 | 1 | 1 | — | — | — | — | scripts:8 |
| Linux | — | 50 | — | 2 | 38 | — | 16 | — | — | runbooks:1 |
| Kubernetes | — | 17 | — | 1 | 10 | — | 3 | — | — | — |
| Kafka | — | 17 | — | 2 | 3 | — | — | — | — | — |
| Terraform | — | 13 | — | 1 | 17 | — | 12 | — | — | envs:12, tf:5 |
| Jenkins | — | 4 | — | 4 | 13 | — | 1 | — | — | — |
| Ansible | — | 11 | — | 1 | 6 | — | — | — | — | playbooks:4 |
| Observability | — | 14 | — | 1 | 8 | — | — | — | — | — |
| OCI / Registries | — | 11 | — | 1 | 7 | — | — | — | — | — |
| Docker | — | 7 | — | 1 | 5 | — | — | — | — | security:2 |
| Helm | — | 3 | — | — | 2 | — | — | — | — | — |
| CI/CD | — | 17 | — | 1 | 10 | — | — | — | — | — |
| Git | — | 8 | — | 1 | 17 | — | — | — | — | — |

---

## Quick links

- [Custom S3 Terrascan rule](terrascan/configs/tried-custom-s3-rule.yaml) — Rego rule for S3 public access and encryption checks
- [CI-integrated DAST Automation Framework plan](zap/configs/ci-dast-automation-framework-plan.yaml) — Headless scanning pipeline for CI environments
- [Falco file access detector in Go](falco/snippets/tried-file-access-detector.go) — Go snippet that reads Falco JSON output and alerts on sensitive file access
- [Vault dev/test policy config](vault/configs/2026-06-26-dev-test-policies.hcl) — HCL policy configuration for KV v2 with separate dev and test access
- [Snyk multi-project CI pipeline](snyk/docs/multi-project-ci-pipeline.md) — Per-service monitoring and CI integration for monorepos

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

---

## Status

Active maintenance with weekly additions. Current focus areas: Terrascan custom Rego rules, ZAP DAST automation framework, Falco Go SDK snippets, Vault policy-as-code, and multi-project Snyk CI integration.

---

_Last updated: 2026-06-26_
