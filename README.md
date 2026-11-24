# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference for scanning, secrets, SBOMs, supply-chain security, policy, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit/commits/master) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps and DevSecOps engineer's quick-reference: first-contact notes, runnable snippets, configs, and starter templates for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it — scanning (Trivy, Syft, Grype, Semgrep, CodeQL, Snyk, ZAP, Nuclei), secrets (TruffleHog, Gitleaks, GitGuardian, Vault, Cosign), policy (OPA, Falco, Tetragon, Checkov, Terrascan, tfsec), and delivery (Docker, Kubernetes, Helm, Kustomize, Argo CD, GitHub Actions, Terraform, OpenTofu, Ansible). Cross-cutting folders hold concept primers, cheatsheets, runbooks, starter templates, environment promotion configs, and a lab sandbox. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Grafana security SLO dashboard config](grafana/configs/security-slo-dashboard.json) — Grafana security and SLO dashboard definition
- [Grafana security dashboard lesson](learn/07-observe-respond/04-grafana-security-dashboard.md) — Build a security and SLO dashboard in Grafana
- [Prometheus security alerts lesson](learn/07-observe-respond/03-prometheus-security-alerts.md) — Alert on the app and on security events with Prometheus
- [Signed images only lesson](learn/06-policy-secrets-runtime/05-signed-images-only.md) — Gatekeeper + Ratify admit only digest-pinned, Cosign-signed images
- [Falco detect shell lesson](learn/06-policy-secrets-runtime/07-falco-detect-shell.md) — Falco runtime shell detection, tuned by priority and filters

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`learn/`** — Ordered lessons that follow the learning path (stage-by-stage, hands-on)
- **`docs/`** — Concepts, how-to guides, reference, runbooks, troubleshooting, setup notes
- **`scripts/`** — Shell toolkits, pipeline helpers, and reusable utilities
- **`snippets/`** — Copy-paste cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, and platform tooling
- **`environments/`** — Terraform environment configs (dev / staging / prod) and promotion workflow
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`<tool>/`** — Per-tool folders (notes, docs, scripts, configs, snippets, templates, manifests, dockerfiles, notebooks)

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Total | Last verified |
|------|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
| TruffleHog | 4 | 4 | 3 | 2 | 3 | 28 | 2 | 2 | 3 | 51 | 2026-10-13 |
| Checkov | 4 | 6 | 4 | 4 | 4 | 16 | 3 | | 4 | 47 | 2026-09-17 |
| Syft | 5 | 8 | 5 | 1 | 3 | 13 | 4 | 1 | 4 | 44 | 2026-10-27 |
| Trivy | 8 | 6 | 6 | 4 | 1 | 10 | 2 | 1 | 2 | 40 | 2026-10-19 |
| Terraform | 3 | 2 | 4 | 12 | 1 | 5 | 1 | | | 35 | 2026-10-30 |
| OPA / Gatekeeper | 5 | 4 | 2 | 2 | 8 | 8 | 5 | | 1 | 35 | 2026-10-27 |
| Ansible | 3 | 1 | 5 | 3 | 1 | 21 | | | | 34 | 2026-10-27 |
| CodeQL | 5 | 4 | 2 | 2 | 6 | 7 | 3 | 1 | 2 | 32 | 2026-10-27 |
| OWASP ZAP | 6 | 5 | 3 | 3 | 4 | 7 | 1 | 1 | 1 | 31 | 2026-10-14 |
| Snyk | 6 | 4 | 2 | 3 | 1 | 10 | 1 | 1 | 1 | 29 | 2026-10-27 |
| GitGuardian | 6 | 4 | 4 | 3 | 2 | 8 | | | 1 | 28 | 2026-10-27 |
| Argo CD | 6 | 3 | 1 | 2 | | 11 | 5 | | | 28 | 2026-10-27 |
| Grype | 5 | 3 | 9 | 2 | 3 | | 2 | 1 | 2 | 27 | 2026-10-14 |
| Semgrep | 3 | 8 | 3 | 1 | 2 | | 3 | 2 | 3 | 25 | 2026-10-18 |
| Falco | 6 | 4 | 3 | 4 | 1 | 4 | 1 | | 2 | 25 | 2026-10-27 |
| GitHub Actions | 7 | 1 | 1 | 8 | 3 | | 2 | | | 22 | 2026-10-20 |
| Terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | | 1 | 22 | 2026-10-10 |
| HashiCorp Vault | 4 | 3 | 4 | 3 | 2 | | 2 | 1 | 2 | 21 | 2026-08-30 |
| Kubernetes | 4 | 2 | 2 | 3 | | 5 | 4 | | | 20 | 2026-10-29 |
| Cosign | 5 | 4 | 3 | 2 | 1 | | 2 | 2 | 1 | 20 | 2026-10-30 |
| Docker | 2 | 2 | 3 | 1 | | 7 | 1 | 3 | | 19 | 2026-09-23 |
| Dependabot | 7 | 4 | 2 | 5 | | | | | 1 | 19 | 2026-10-14 |
| DefectDojo | 4 | 2 | 3 | 2 | 2 | 6 | | | | 19 | 2026-10-23 |
| Kustomize | 3 | 1 | 2 | 10 | | | 1 | | | 17 | 2026-10-24 |
| Helm | 4 | 1 | 1 | 1 | | | 2 | | | 13 | 2026-10-20 |
| Grafana | 4 | 1 | 1 | 3 | 1 | | 1 | | | 11 | 2026-10-26 |
| Tetragon | 3 | 1 | 3 | 4 | | | | | | 11 | 2026-09-26 |
| Git | 3 | 1 | 4 | 1 | 1 | | | | | 10 | 2026-09-22 |
| OpenTofu | 4 | 2 | 1 | 3 | | | | | | 10 | 2026-10-28 |
| Gitleaks | 3 | 1 | 3 | 2 | | | | | | 9 | 2026-10-25 |
| Linux | 3 | 1 | 2 | 1 | | | | | | 7 | 2026-10-02 |
| SonarQube | 3 | | 1 | 2 | 1 | | | | | 7 | 2026-09-21 |
| Prometheus | 5 | | 1 | | 1 | | | | | 7 | 2026-10-25 |
| tfsec | 3 | | 1 | 1 | 1 | | | | | 6 | 2026-10-19 |
| Nuclei | 3 | | 1 | 1 | | | | | | 5 | 2026-10-15 |

</details>

Counts reflect files inside each category subfolder. `Last verified` is the most recent `last_verified` marker found in that tool's docs' front-matter.

## Status

Recently added Grafana security dashboards and Prometheus security alerts, plus signed-image admission and Falco shell-detection notes. tfsec, Nuclei, Prometheus, and SonarQube remain thin corners where first configs or scripts are still sparse.

---
_Last updated: 2026-11-22_
