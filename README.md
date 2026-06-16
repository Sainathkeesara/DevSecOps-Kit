# DevSecOps-Kit
> A working engineer's DevSecOps reference — scripts, how-to guides, runbooks, and templates for infrastructure automation, security scanning, CI/CD, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-557-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-213-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-230-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-38-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of production-ready shell scripts, how-to guides, runbooks, snippets, and templates covering the tools and practices a practising DevSecOps engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans Kubernetes, Terraform, CI/CD pipelines, observability stacks, Linux system administration, container registries, and security scanning (Trivy, Semgrep, Checkov, TruffleHog, Syft, Grype, CodeQL, ZAP, Falco, Cosign) with CVE-specific remediation guidance.

---

## Coverage

| Tool | Scripts | Docs | Snippets | Templates | More |
|------|--------:|-----:|---------:|----------:|----:|
| Linux | 50 | 39 | 2 | 14 | — |
| Kubernetes | 17 | 13 | 1 | 3 | — |
| Kafka | 17 | 3 | 2 | — | — |
| Terraform | 15 | 17 | 1 | 12 | modules:7, environments:12 |
| Jenkins | 4 | 13 | 4 | 1 | — |
| Ansible | 11 | 7 | 1 | — | — |
| CI/CD | 17 | 11 | 1 | — | ArgoCD, Flux |
| Observability | 14 | 3 | 1 | — | — |
| OCI / Container Registries | 11 | 7 | 1 | — | — |
| Docker | 7 | 5 | 1 | — | — |
| Vault | 7 | 6 | 1 | — | notes:3 |
| Git | 8 | 24 | 1 | — | — |
| Helm | 3 | 2 | — | — | — |
| Checkov | 6 | 2 | 4 | 5 | notes:4, configs:2, policies, notebooks |
| Semgrep | 4 | 3 | 2 | — | notes:3, configs, notebooks, Dockerfiles |
| Trivy | 7 | 2 | 1 | 6 | notes:3, configs:2, notebooks, Dockerfiles |
| TruffleHog | 5 | 1 | 2 | 6 | notes:3, configs:2 |
| Syft | 3 | 1 | 1 | — | notes:4, configs |
| Grype | 4 | — | 2 | — | notes:4 |
| CodeQL | 2 | — | 2 | — | notes:2, configs |
| ZAP | 3 | 1 | 3 | — | notes:4 |
| Falco | — | — | — | — | notes:2, configs:2 |
| Cosign | 1 | — | — | — | notes:2 |
| OPA | 1 | — | 2 | — | notes:2 |
| GitGuardian | 2 | — | 2 | — | notes:3, configs |
| Snyk | 1 | — | 1 | — | notes:3 |

---

## Quick links

- [Cosign — sign and verify container images](cosign/notes/2026-06-13-install-cosign-sign-first-image.md) — Install Cosign, sign an image, and verify signatures
- [Falco — runtime security primer](falco/notes/0000-primer-falco.md) — First-day primer on Falco runtime security
- [ZAP — spider scan against a test app](zap/notes/2026-06-13-spider-scan-test-app.md) — Run a ZAP spider scan against a test application
- [GitGuardian — ggshield quickstart trip-ups](gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md) — Quickstart walkthrough and common pitfalls
- [ZAP — authenticated scan with context](zap/snippets/authenticated-scan-with-context.sh) — Authenticated scanning using ZAP context

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary
- **`.github/`** — PR template, CODEOWNERS, workflow README
- **`assets/`** — Static images and diagrams used by guides and project docs
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/`** — Vulnerability scanner and security tool content
- **`terrascan/`** — Terrascan primers, notes, and IaC scan snippets
- **`opa/`** — OPA/Gatekeeper policies and snippets
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

Actively maintained with weekly additions. Current focus areas: OWASP ZAP DAST scanning primers, Cosign container image signing, Falco runtime security rules, Kubernetes security CVEs, Terraform provisioning patterns, and CI/CD pipeline integration scripts.

---

_Last updated: 2026-06-13_
