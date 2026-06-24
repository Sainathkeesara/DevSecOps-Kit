# DevSecOps-Kit
> A working engineer's devops and devsecops reference — scripts, how-to guides, runbooks, and templates for infrastructure automation, security scanning, CI/CD, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Files](https://img.shields.io/badge/files-621-blue)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Shell](https://img.shields.io/badge/Shell-223-4EAA25?logo=gnubash&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Terraform](https://img.shields.io/badge/Terraform-40-7B42BC?logo=terraform&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)
[![Markdown](https://img.shields.io/badge/Markdown-255-000000?logo=markdown&logoColor=white)](https://github.com/Sainathkeesara/DevSecOps-Kit)

---

## What's in here

A curated collection of production-ready shell scripts, how-to guides, runbooks, snippets, and templates covering the tools and practices a practising DevSecOps engineer reaches for daily. Every entry is version-specific, scenario-grounded, and designed to be adapted for real infrastructure work.

The kit spans Kubernetes, Terraform, CI/CD pipelines, observability stacks, Linux system administration, container registries, and security scanning (Trivy, Semgrep, Checkov, TruffleHog, Syft, Grype, CodeQL, ZAP, Falco, Cosign, OPA, GitGuardian, Snyk) with CVE-specific remediation guidance.

---

## Coverage

| Tool | Scripts | Docs | Snippets | Templates | More |
|------|--------:|-----:|---------:|----------:|------|
| Linux | 50 | 38 | 2 | 16 | runbooks:1 |
| Kubernetes | 17 | 19 | 1 | 3 | — |
| Kafka | 17 | 3 | 2 | — | — |
| Terraform | 15 | 16 | 2 | 12 | environments:13 |
| Jenkins | 4 | 11 | 4 | 1 | — |
| Ansible | 11 | 9 | 1 | — | — |
| CI/CD | 16 | 12 | 1 | — | ArgoCD, Flux |
| Observability | 14 | 9 | 1 | — | — |
| OCI / Container Registries | 11 | 7 | 1 | — | — |
| Docker | 7 | 6 | 1 | — | — |
| Vault | 8 | 5 | 2 | — | notes:3 |
| Git | 8 | 17 | 1 | — | — |
| Helm | 3 | 3 | — | — | — |
| Checkov | 2 | 3 | 4 | 10 | notes:4, configs:2, manifests:2, notebooks, policies |
| Semgrep | 3 | 4 | 2 | — | notes:3, configs, notebooks:1, manifests:2, dockerfiles:2 |
| Trivy | 5 | 6 | 1 | 6 | notes:3, configs:2, notebooks:2, manifests:2, dockerfiles |
| TruffleHog | 3 | 1 | 2 | 11 | notes:3, configs:2, notebooks, dockerfiles |
| Syft | 3 | 2 | 1 | 7 | notes:4, configs, notebooks, dockerfiles |
| Grype | 3 | — | 2 | — | notes:4, configs |
| CodeQL | 1 | 1 | 3 | — | notes:3, configs |
| ZAP | 1 | 2 | 3 | — | notes:4, configs |
| Falco | — | — | — | — | notes:3, configs:3 |
| Cosign | 2 | — | 1 | — | notes:4, configs |
| OPA | 1 | — | 2 | — | notes:3, configs |
| GitGuardian | 1 | — | 2 | — | notes:4, configs:2 |
| Snyk | — | — | 1 | — | notes:4, configs |
| Terrascan | — | — | 2 | — | notes:3 |
| Dependabot | — | — | — | — | notes:3, configs |

---

## Quick links

- [Keyless Cosign signing for GitHub Actions](cosign/configs/keyless-signing-github-actions.yaml) — Keyless container signing workflow using GitHub OIDC
- [Dependabot alerts and security updates walkthrough](dependabot/notes/dependabot-alerts-security-updates.md) — Enabling alerts and auto-fix PRs
- [Learning path and progress tracker](00_index/learning-path.md) — Structured progression from beginner to advanced
- [Cosign getting-started pitfalls](cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md) — Common trip-ups from the official Cosign tutorial
- [First-time Dependabot setup guide](dependabot/notes/2026-06-22-first-time-dependabot-setup.md) — Enabling Dependabot and triggering version-bump PRs

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`.github/`** — PR template, CODEOWNERS, workflow README
- **`CHANGELOG.md`** — Release history and version changelog
- **`CONTRIBUTING.md`** — Contribution guidelines and development setup
- **`assets/`** — Static images and diagrams used by guides and project docs
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/` / `tetragon/`** — Vulnerability scanner and security tool content
- **`terrascan/`** — Terrascan primers, notes, and IaC scan snippets
- **`dependabot/`** — Dependabot primer, notes, and dependency update configs
- **`opa/`** — OPA/Gatekeeper policies and snippets
- **`vault/`** — HashiCorp Vault primers and notes
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Docker, Linux automation, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform modules (EventBridge Lambda, networking)

---

## Status

Actively maintained with weekly additions. Current focus areas: OWASP ZAP DAST scanning primers, Cosign container image signing, Falco runtime security rules, Kubernetes security CVEs, Terraform provisioning patterns, and CI/CD pipeline integration scripts.

---

_Last updated: 2026-06-23_
