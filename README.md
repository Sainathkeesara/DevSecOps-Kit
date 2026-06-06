# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference — scripts, how-to guides, runbooks, and templates for infrastructure automation, security scanning, CI/CD, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-508-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-200-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-211-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-38-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of production-ready **shell scripts**, **how-to guides**, **runbooks**, **snippets**, and **templates** covering the tools and practices a practising DevOps or DevSecOps engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans Kubernetes, Terraform, CI/CD pipelines, observability stacks, Linux system administration, container registries, and security scanning (Trivy, Semgrep, Checkov, TruffleHog, Syft, Grype, CodeQL, ZAP) with CVE-specific remediation guidance.

---

## Coverage

| Tool | Scripts | Docs | Snippets | Templates | More |
|------|--------:|-----:|---------:|----------:|----:|
| Linux | 50 | 39 | 2 | 14 | — |
| Kubernetes | 17 | 11 | 1 | 3 | — |
| Kafka | 17 | 3 | 2 | — | — |
| Terraform | 15 | 22 | 1 | 12 | modules:7, environments:12 |
| Jenkins | 4 | 14 | 4 | 1 | — |
| Ansible | 11 | 8 | 1 | — | — |
| CI/CD | 16 | 11 | 1 | — | ArgoCD, Flux |
| Observability | 14 | 12 | 1 | — | — |
| OCI / Container Registries | 11 | 7 | 1 | — | — |
| Docker | 7 | 7 | 1 | — | — |
| Vault | 7 | 6 | 1 | — | — |
| Git | 8 | 19 | 1 | — | — |
| Helm | 3 | 3 | — | — | — |
| Checkov | — | 1 | 4 | — | notes:4, configs:2, policies, notebooks |
| Semgrep | 2 | 3 | 2 | — | notes:3, configs, notebooks, Dockerfiles |
| Trivy | 5 | 2 | 1 | 6 | notes:3, configs:2, notebooks, Dockerfiles |
| TruffleHog | 2 | 1 | 2 | — | notes:3, configs:2 |
| Syft | 2 | — | 1 | — | notes:4, configs |
| Grype | 1 | — | 1 | — | notes:3 |
| CodeQL | — | — | 2 | — | notes:2, configs |
| ZAP | — | — | 2 | — | notes:3 |

---

## Quick links

- [zap/notes/0000-primer-zap.md](zap/notes/0000-primer-zap.md) — First-day primer on OWASP ZAP
- [zap/notes/2026-06-06-install-zap-desktop-ui.md](zap/notes/2026-06-06-install-zap-desktop-ui.md) — Installing ZAP and exploring the desktop UI
- [zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md](zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md) — ZAP quickstart walkthrough and UI gotchas
- [zap/snippets/my-first-zap-baseline-scan.sh](zap/snippets/my-first-zap-baseline-scan.sh) — First ZAP baseline scan from the CLI
- [zap/snippets/authenticated-scan-with-context.sh](zap/snippets/authenticated-scan-with-context.sh) — Authenticated scan using ZAP context

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary
- **`.github/`** — PR template, CODEOWNERS, workflow README
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/`** — Vulnerability scanner and SAST tool content
- **`vault/`** — HashiCorp Vault primers and notes
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organized by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Docker, Linux automation, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform modules (EventBridge Lambda, networking)

---

## Status

Actively maintained with weekly additions. Current focus areas: OWASP ZAP DAST scanning primers, Kubernetes security CVEs, Terraform provisioning patterns, CI/CD pipeline integration scripts, and observability stack deployment guides.

---

_Last updated: 2026-06-06_
