# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

959 files across 34 tool-specific folders plus cross-cutting docs, scripts, snippets, templates, and lab environments. Covers vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

## Quick links

- [Syft source vs library multiarch notebook](syft/notebooks/source-vs-library-multiarch.ipynb) — Syft CLI scan vs library mode: when to use each and how per-architecture results differ for multi-arch images
- [Vault static vs dynamic secrets notebook](vault/notebooks/static-vs-dynamic-secrets.ipynb) — Comparing Vault static vs dynamic secrets for cloud IAM credential management
- [Vault PKI workflow script](vault/scripts/vault-pki-workflow.sh) — Vault PKI secrets engine workflow: root CA, role, issuance, re-issue rotation, revocation with CRL verification
- [Ansible inventory with group and host vars](ansible/configs/2026-09-15-inventory-groups-host-vars.yaml) — A YAML inventory showing shared group vars with per-host overrides
- [Vault Agent sidecar for secret refresh](vault/manifests/vault-sidecar-secrets-refresh.yaml) — Inject a Vault Agent sidecar so pods pick up rotated secrets without restarts

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, and setup guides
- **`scripts/`** — Shell toolkits organised by tool (`scripts/bash/`), deployment and rollback wrappers (`scripts/pipeline/`), and repository utilities
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng, and per-tool scaffolds
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`.github/`** — CODEOWNERS, PR template, and Dependabot config

Per-tool content folders follow a consistent shape — `notes/`, `scripts/`, `configs/`, `snippets/`, plus wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Nuclei, Semgrep, Checkov, tfsec, Terrascan, Grype, Syft, TruffleHog, Gitleaks, GitGuardian, Snyk, Terraform, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, and Linux.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|---------:|------:|---------------|
| checkov | 4 | 5 | 2 | 3 | 4 | 20 | 3 | 0 | 2 | 1 | 44 | — |
| trufflehog | 4 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 38 | 2026-09-04 |
| syft | 4 | 6 | 3 | 1 | 1 | 15 | 2 | 1 | 3 | 0 | 36 | — |
| trivy | 6 | 4 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 35 | 2026-09-05 |
| zap | 6 | 3 | 2 | 2 | 4 | 8 | 0 | 1 | 0 | 0 | 26 | 2026-09-05 |
| opa | 3 | 2 | 2 | 1 | 3 | 9 | 4 | 0 | 0 | 0 | 24 | — |
| snyk | 4 | 2 | 1 | 2 | 1 | 11 | 1 | 1 | 0 | 0 | 23 | — |
| gitguardian | 4 | 2 | 3 | 2 | 2 | 9 | 0 | 0 | 0 | 0 | 22 | — |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | — |
| terraform | 3 | 1 | 4 | 4 | 1 | 0 | 0 | 0 | 0 | 0 | 20 | 2026-08-04 |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 20 | — |
| terrascan | 5 | 1 | 2 | 1 | 2 | 6 | 1 | 0 | 0 | 0 | 18 | 2026-07-10 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 1 | 1 | 1 | 0 | 19 | 2026-08-26 |
| cosign | 4 | 1 | 3 | 1 | 1 | 0 | 2 | 2 | 0 | 0 | 14 | — |
| dependabot | 7 | 1 | 2 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 14 | 2026-08-08 |
| falco | 4 | 2 | 3 | 3 | 1 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-07-19 |
| codeql | 4 | 1 | 1 | 1 | 4 | 0 | 1 | 1 | 0 | 0 | 13 | 2026-08-26 |
| github-actions | 4 | 0 | 0 | 3 | 2 | 0 | 2 | 0 | 0 | 0 | 11 | 2026-08-26 |
| argocd | 6 | 0 | 0 | 1 | 0 | 0 | 2 | 0 | 0 | 0 | 9 | 2026-08-12 |
| docker | 2 | 1 | 2 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 8 | 2026-07-12 |
| git | 3 | 0 | 3 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-07-26 |
| ansible | 2 | 0 | 3 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-08-25 |
| tetragon | 3 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-08-06 |
| opentofu | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-07-20 |
| kubernetes | 2 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 4 | 2026-07-15 |
| kustomize | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-07-08 |
| helm | 2 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 3 | 2026-07-19 |
| sonarqube | 2 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-07-19 |
| linux | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-08-17 |
| prometheus | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-07-13 |
| grafana | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-07-13 |
| gitleaks | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-09-10 |
| nuclei | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-09-10 |
| tfsec | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2026-09-10 |

</details>

## Status

Foundational concept primers and practice exercises are complete across the toolchain, and per-tool quickstarts are being rounded out. Recent additions include an Ansible YAML inventory with group and host vars, a Vault PKI secrets engine workflow, and Syft multi-arch comparison notebooks. Current focus is finishing per-tool notes and deepening policy-as-code and supply-chain coverage.

---
_Last updated: 2026-09-17_