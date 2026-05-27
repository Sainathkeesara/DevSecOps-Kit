# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference — scripts, how-to guides, runbooks, and templates for Kubernetes, Linux, Terraform, CI/CD, observability, and security tooling.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-437-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-182-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-185-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-38-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of production-ready **shell scripts**, **how-to guides**, **runbooks**, **snippets**, and **templates** covering the tools and practices a practicing DevOps or DevSecOps engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans Kubernetes, Linux system administration, Terraform, CI/CD pipelines, observability stacks, container registries, and security scanning (Trivy, Semgrep, Checkov) with CVE-specific remediation guidance.

---

## Coverage

| Tool | Scripts | Docs | Snippets | Templates | More |
|------|--------:|-----:|---------:|----------:|----:|
| Linux | 50 | 39 | 2 | 14 | lab:3 |
| Kubernetes | 17 | 11 | 1 | 3 | — |
| Kafka | 17 | 3 | 2 | — | — |
| Terraform | 15 | 17 | 1 | 12 | modules:7, environments:12, lab:8 |
| CI/CD | 17 | 13 | 1 | — | — |
| Observability | 14 | 9 | 1 | — | — |
| Ansible | 11 | 8 | 1 | — | — |
| OCI / Container Registries | 11 | 8 | 1 | — | — |
| Docker | 7 | 7 | 1 | — | — |
| Vault | 7 | 6 | 1 | — | — |
| Git | 8 | 20 | 1 | — | — |
| Jenkins | 4 | 14 | 4 | 1 | — |
| Helm | 3 | 2 | — | — | — |
| Checkov | — | — | 2 | — | notes:3 |
| Semgrep | — | — | 1 | — | notes:3 |
| Trivy | 1 | — | 1 | — | notes:3, configs:1 |

---

## Quick links

- [checkov/notes/2026-05-26-cli-vs-sdk-comparison.md](checkov/notes/2026-05-26-cli-vs-sdk-comparison.md) — Comparing CLI and SDK scanning approaches for Terraform
- [checkov/snippets/scan-terraform-dir.py](checkov/snippets/scan-terraform-dir.py) — Python snippet for Checkov SDK scanning
- [semgrep/notes/2026-05-26-install-semgrep-pitfalls.md](semgrep/notes/2026-05-26-install-semgrep-pitfalls.md) — What tripped me up installing and running Semgrep
- [trivy/configs/trivy-scan-config.yaml](trivy/configs/trivy-scan-config.yaml) — Trivy configuration for targeted scanning
- [trivy/notes/2026-05-26-trivy-quickstart.md](trivy/notes/2026-05-26-trivy-quickstart.md) — Following the official Trivy quickstart

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary
- **`.github/`** — PR template, CODEOWNERS, workflow README
- **`checkov/` / `semgrep/` / `trivy/`** — Security scanner notes, scripts, configs
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

_Last updated: 2026-05-26_
