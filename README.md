# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference — scripts, how-to guides, runbooks, and templates for Kubernetes, Linux, Terraform, CI/CD, observability, and security tooling.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-456-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-187-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-194-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-38-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of production-ready **shell scripts**, **how-to guides**, **runbooks**, **snippets**, and **templates** covering the tools and practices a practising DevOps or DevSecOps engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans Kubernetes, Linux system administration, Terraform, CI/CD pipelines, observability stacks, container registries, and security scanning (Trivy, Semgrep, Checkov, TruffleHog, Syft) with CVE-specific remediation guidance.

---

## Coverage

| Tool | Scripts | Docs | Snippets | Templates | More |
|------|--------:|-----:|---------:|----------:|----:|
| Linux | 50 | 39 | 2 | 14 | — |
| Kubernetes | 17 | 13 | 1 | 3 | — |
| Kafka | 17 | 3 | 2 | — | — |
| Terraform | 15 | 17 | 1 | 12 | modules:7, environments:12 |
| CI/CD | 16 | 10 | 1 | — | Argo, Flux |
| Observability | 14 | 9 | 1 | — | — |
| Ansible | 11 | 6 | 1 | — | runbooks:1 |
| OCI / Container Registries | 11 | 7 | 1 | — | — |
| Docker | 7 | 6 | 1 | — | security:2 |
| Vault | 7 | 4 | 1 | — | — |
| Git | 8 | 17 | 1 | — | — |
| Jenkins | 4 | 13 | 4 | 1 | — |
| Helm | 3 | 2 | — | — | — |
| Checkov | — | 1 | 3 | — | notes:4, configs:1 |
| Semgrep | 2 | 2 | 2 | — | notes:3 |
| Trivy | 2 | — | 1 | — | notes:3, configs:1 |
| TruffleHog | — | — | 2 | — | notes:3, configs:1 |
| Syft | — | — | 1 | — | notes:2 |

---

## Quick links

- [semgrep/docs/github-actions-ci-from-scratch.md](semgrep/docs/github-actions-ci-from-scratch.md) — Building a Semgrep CI pipeline from scratch with GitHub Actions
- [semgrep/scripts/detect-hardcoded-secrets.py](semgrep/scripts/detect-hardcoded-secrets.py) — Python script to detect hardcoded secrets with Semgrep
- [trufflehog/configs/trufflehog-custom-regex-config.yaml](trufflehog/configs/trufflehog-custom-regex-config.yaml) — Custom regex and entropy configuration for TruffleHog
- [trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md](trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md) — Walkthrough of the TruffleHog quickstart
- [trufflehog/snippets/scan-github-repo-for-secrets.sh](trufflehog/snippets/scan-github-repo-for-secrets.sh) — Scan a GitHub repository for leaked secrets with TruffleHog

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary
- **`.github/`** — PR template, CODEOWNERS, workflow README
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organized by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Docker, Linux automation, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform modules (EventBridge Lambda, networking)

---

## Status

Actively maintained with weekly additions. Current focus areas: Kubernetes security CVEs, Terraform provisioning patterns, CI/CD pipeline integration scripts, and observability stack deployment guides.

---

_Last updated: 2026-05-29_
