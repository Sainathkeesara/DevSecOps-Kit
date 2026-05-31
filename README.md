# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference — scripts, how-to guides, runbooks, and templates for Kubernetes, Linux, Terraform, CI/CD, observability, and security tooling.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-473-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-191-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-197-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
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
| Kubernetes | 17 | 11 | 1 | 3 | — |
| Kafka | 17 | 3 | 2 | — | — |
| Terraform | 16 | 22 | 1 | 12 | modules:7, environments:12 |
| CI/CD | 16 | 11 | 1 | — | Argo, Flux |
| Observability | 14 | 12 | 1 | — | — |
| Ansible | 11 | 8 | 1 | — | — |
| OCI / Container Registries | 11 | 7 | 1 | — | — |
| Docker | 7 | 7 | 1 | — | — |
| Vault | 8 | 6 | 1 | — | — |
| Git | 8 | 19 | 1 | — | — |
| Jenkins | 4 | 14 | 4 | 1 | — |
| Helm | 3 | 3 | — | — | — |
| Checkov | — | 1 | 4 | — | notes:4, configs:2 |
| Semgrep | 2 | 2 | 2 | — | notes:3, configs:1 |
| Trivy | 3 | 1 | 1 | — | notes:3, configs:2 |
| TruffleHog | 2 | — | 2 | — | notes:3, configs:2 |
| Syft | 1 | — | 1 | — | notes:4 |

---

## Quick links

- [semgrep/configs/multi-rule-pack.yaml](semgrep/configs/multi-rule-pack.yaml) — Multi-rule Semgrep pack with operator combinators
- [checkov/configs/checkov-ci-config.yaml](checkov/configs/checkov-ci-config.yaml) — CI configuration with framework selection for Checkov
- [trufflehog/scripts/multi-repo-scan-pipeline.sh](trufflehog/scripts/multi-repo-scan-pipeline.sh) — Multi-repo secret scanning pipeline with TruffleHog
- [trufflehog/configs/custom-detector-rules.yaml](trufflehog/configs/custom-detector-rules.yaml) — Custom detector rules for proprietary secret patterns
- [semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb](semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb) — Comparing semgrep scan vs semgrep ci approaches

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

_Last updated: 2026-05-31_
