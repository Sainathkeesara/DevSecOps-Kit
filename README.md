# DevSecOps-Kit
> A working engineer's devops and devsecops reference — scripts, how-to guides, runbooks, and templates for infrastructure automation, security scanning, CI/CD, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-653-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-229-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-273-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-40-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of production-ready shell scripts, how-to guides, runbooks, snippets, and templates covering infrastructure automation, container orchestration, CI/CD pipelines, observability stacks, and a broad security scanning practice. The kit spans Kubernetes, Terraform, Ansible, Docker, Jenkins, Kafka, and Linux administration, with security tooling across Trivy, Semgrep, Checkov, TruffleHog, Syft, Grype, CodeQL, ZAP, Falco, Cosign, OPA, GitGuardian, Snyk, Terrascan, Dependabot, Tetragon, and HashiCorp Vault — all with CVE-specific remediation guidance.

---

## Coverage

| Tool | Scripts | Docs | Snippets | Templates | More |
|------|--------:|-----:|---------:|----------:|------|
| Linux | 50 | 38 | 2 | 16 | runbooks:1 |
| Kubernetes | 17 | 12 | 1 | 3 | — |
| Kafka | 17 | 3 | 2 | — | — |
| Terraform | 15 | 16 | 1 | 12 | environments:12 |
| Jenkins | 4 | 13 | 4 | 1 | — |
| Ansible | 11 | 7 | 1 | — | — |
| CI/CD | 16 | 9 | 1 | — | — |
| Observability | 14 | 8 | 1 | — | — |
| OCI / Container Registries | 11 | 7 | 1 | — | — |
| Docker | 7 | 4 | 1 | — | — |
| Vault | 7 | 4 | 2 | — | notes:3, configs:1 |
| Git | 8 | 17 | 1 | — | — |
| Helm | 3 | 3 | — | — | — |
| Checkov | 2 | 3 | 4 | 10 | notes:4, configs:2, manifests:2, notebooks, policies |
| Semgrep | 3 | 4 | 2 | — | notes:3, configs, notebooks:1, manifests:2, dockerfiles:2 |
| Trivy | 5 | 3 | 1 | 6 | notes:3, configs:2, manifests:2, notebooks:2, dockerfiles |
| TruffleHog | 3 | 1 | 2 | 11 | notes:3, configs:2, notebooks, dockerfiles |
| Syft | 3 | 2 | 1 | 7 | notes:4, configs, notebooks, dockerfiles |
| Grype | 4 | — | 2 | — | notes:4, configs, notebooks |
| CodeQL | 1 | 1 | 3 | — | notes:3, configs, manifests |
| ZAP | 1 | 2 | 3 | — | notes:4, configs |
| Falco | 1 | 2 | 1 | — | notes:3, configs:3 |
| Cosign | 2 | — | 1 | — | notes:4, configs |
| OPA | 1 | 1 | 3 | — | notes:3, configs |
| GitGuardian | 2 | 2 | 2 | — | notes:4, configs:2 |
| Snyk | 1 | 1 | 1 | — | notes:4, configs:2 |
| Terrascan | 1 | — | 2 | — | notes:3, configs |
| Dependabot | — | — | — | — | notes:3, configs |
| Tetragon | — | — | — | — | notes:2, configs |

---

## Quick links

- [Vault Agent auto-auth with Kubernetes service accounts](vault/docs/vault-agent-auto-auth-kubernetes.md) — Wire Vault Agent sidecar auth via Kubernetes service account
- [Terrascan custom S3 bucket policy rules](terrascan/configs/tried-custom-s3-rule.yaml) — Custom Rego rules for S3 public access and encryption
- [ZAP CI DAST Automation Framework plan](zap/configs/ci-dast-automation-framework-plan.yaml) — Headless scanning pipeline plan for CI environments
- [Falco file access detector in Go](falco/snippets/tried-file-access-detector.go) — Go snippet that reads Falco JSON and alerts on sensitive file access
- [Snyk multi-project CI pipeline](snyk/docs/multi-project-ci-pipeline.md) — Per-service monitoring in multi-project CI pipelines

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`.github/`** — PR template, CODEOWNERS, workflow README
- **`CHANGELOG.md`** — Release history and version changelog
- **`CONTRIBUTING.md`** — Contribution guidelines and development setup
- **`assets/`** — Static images and diagrams used by guides and project docs
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/` / `tetragon/`** — Vulnerability scanner and security tool content
- **`terrascan/` / `opa/` / `vault/` / `dependabot/`** — IaC compliance, policy engine, secrets management, and dependency updates
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Docker, Linux automation, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform modules (EventBridge Lambda, networking)

---

## Status

Actively maintained with weekly additions. Current focus: expanding OPA admission control patterns, Falco runtime security coverage, ZAP DAST integration, Vault auto-auth workflows, and foundational concept primers across Linux, Git, CI/CD, and container security.

---

_Last updated: 2026-06-28_
