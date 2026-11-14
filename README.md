# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference for scanning, secrets, SBOMs, supply-chain security, policy, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit/commits/master) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps and DevSecOps engineer's quick-reference: first-contact notes, runnable snippets, configs, and starter templates for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it — scanning (Trivy, Syft, Grype, Semgrep, CodeQL, Snyk, ZAP, Nuclei), secrets (TruffleHog, Gitleaks, GitGuardian, Vault, Cosign), policy (OPA, Falco, Tetragon, Checkov, Terrascan, tfsec), and delivery (Docker, Kubernetes, Helm, Kustomize, Argo CD, GitHub Actions, Terraform, OpenTofu, Ansible). Cross-cutting folders hold concept primers, cheatsheets, runbooks, starter templates, environment promotion configs, and a lab sandbox. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Checkov IaC scan lesson](learn/04-iac/05-checkov-iac-scan.md) — Block public S3 buckets with Checkov
- [Checkov no-public-bucket policy](checkov/policies/ckv2-no-public-bucket/no_public_bucket.yaml) — Custom Checkov policy: no public read ACLs on S3 buckets
- [Public-read S3 bucket target](checkov/configs/public-bucket/main.tf) — Practice target for Checkov's public-bucket policy
- [Trivy config scan lesson](learn/04-iac/06-trivy-config-scan.md) — Scan Terraform configs with Trivy
- [Environment promotion lesson](learn/04-iac/04-environments-promotion.md) — Promote Terraform from dev to prod through CI

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
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|--------:|---------------|
| TruffleHog | 4 | 4 | 3 | 2 | 3 | 28 | 2 | 2 | 3 | 51 | 2026-10-13 |
| Checkov | 4 | 6 | 4 | 4 | 4 | 16 | 3 | 0 | 4 | 47 | 2026-09-17 |
| Syft | 5 | 8 | 5 | 1 | 3 | 13 | 4 | 1 | 4 | 44 | 2026-10-27 |
| Trivy | 8 | 6 | 6 | 4 | 1 | 10 | 2 | 1 | 2 | 40 | 2026-10-19 |
| Terraform | 3 | 2 | 4 | 12 | 1 | 5 | 1 | 0 | 0 | 35 | 2026-10-30 |
| Ansible | 3 | 1 | 5 | 3 | 1 | 21 | 0 | 0 | 0 | 34 | 2026-10-27 |
| CodeQL | 5 | 4 | 2 | 2 | 6 | 7 | 3 | 1 | 2 | 32 | 2026-10-27 |
| ZAP | 6 | 5 | 3 | 3 | 4 | 7 | 1 | 1 | 1 | 31 | 2026-10-14 |
| OPA | 5 | 4 | 2 | 2 | 4 | 8 | 4 | 0 | 1 | 30 | 2026-10-27 |
| Snyk | 6 | 4 | 2 | 3 | 1 | 10 | 1 | 1 | 1 | 29 | 2026-10-27 |
| Argo CD | 6 | 3 | 1 | 2 | 0 | 11 | 5 | 0 | 0 | 28 | 2026-10-27 |
| GitGuardian | 6 | 4 | 4 | 3 | 2 | 8 | 0 | 0 | 1 | 28 | 2026-10-27 |
| Grype | 5 | 3 | 9 | 2 | 3 | 0 | 2 | 1 | 2 | 27 | 2026-10-14 |
| Falco | 6 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 25 | 2026-10-27 |
| Semgrep | 3 | 8 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 25 | 2026-10-18 |
| GitHub Actions | 7 | 1 | 1 | 8 | 3 | 0 | 2 | 0 | 0 | 22 | 2026-10-20 |
| Terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 22 | 2026-10-10 |
| Vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2 | 21 | 2026-08-30 |
| Cosign | 5 | 4 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 20 | 2026-10-30 |
| Kubernetes | 4 | 2 | 2 | 3 | 0 | 5 | 4 | 0 | 0 | 20 | 2026-10-29 |
| DefectDojo | 4 | 2 | 3 | 2 | 2 | 6 | 0 | 0 | 0 | 19 | 2026-10-23 |
| Dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 19 | 2026-10-14 |
| Docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 3 | 0 | 19 | 2026-09-23 |
| Tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| Git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| Grafana | 4 | 1 | 1 | 2 | 1 | 0 | 1 | 0 | 0 | 10 | 2026-10-26 |
| Kustomize | 3 | 1 | 2 | 3 | 0 | 0 | 1 | 0 | 0 | 10 | 2026-10-24 |
| OpenTofu | 4 | 2 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-10-28 |
| Gitleaks | 3 | 1 | 3 | 2 | 0 | 0 | 0 | 0 | 0 | 9 | 2026-10-25 |
| Helm | 4 | 1 | 1 | 1 | 0 | 0 | 2 | 0 | 0 | 9 | 2026-10-20 |
| Linux | 3 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-02 |
| Prometheus | 5 | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 7 | 2026-10-25 |
| SonarQube | 3 | 0 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 7 | 2026-09-21 |
| tfsec | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 6 | 2026-10-19 |
| Nuclei | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-15 |

</details>

Counts reflect files inside each category subfolder. Some folders also hold files at their root or in project-specific subfolders, so the total may exceed the sum of category columns. `Last verified` is the most recent `last_verified` marker found in that tool's docs.

## Status

Shift-left lessons landed recently under `learn/`. Thinner corners remain for tfsec, Nuclei, Prometheus, and SonarQube where first configs or scripts are still sparse.

---
_Last updated: 2026-11-13_
