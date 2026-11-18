# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference for scanning, secrets, SBOMs, supply-chain security, policy, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit/commits/master) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps and DevSecOps engineer's quick-reference: first-contact notes, runnable snippets, configs, and starter templates for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it — scanning (Trivy, Syft, Grype, Semgrep, CodeQL, Snyk, ZAP, Nuclei), secrets (TruffleHog, Gitleaks, GitGuardian, Vault, Cosign), policy (OPA, Falco, Tetragon, Checkov, Terrascan, tfsec), and delivery (Docker, Kubernetes, Helm, Kustomize, Argo CD, GitHub Actions, Terraform, OpenTofu, Ansible). Cross-cutting folders hold concept primers, cheatsheets, runbooks, starter templates, environment promotion configs, and a lab sandbox. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Detect a shell in a container with Falco](learn/06-policy-secrets-runtime/07-falco-detect-shell.md) — Falco runtime detection lesson
- [Reject privileged and root pods with Gatekeeper](learn/06-policy-secrets-runtime/02-gatekeeper-admission.md) — Gatekeeper admission lesson
- [Gatekeeper pod-security constraint](opa/manifests/gatekeeper-pod-security.yaml) — Blocks privileged and root pods
- [Deliver app secrets from Vault into Kubernetes](learn/06-policy-secrets-runtime/04-vault-k8s-injection.md) — Vault injection lesson
- [Rego basics and testing policies](learn/06-policy-secrets-runtime/01-rego-basics.md) — OPA Rego fundamentals

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
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|------:|---------------|
| TruffleHog | 4 | 4 | 3 | 2 | 3 | 28 | 2 | 2 | 3 | 51 | 2026-10-20 |
| Checkov | 4 | 6 | 4 | 4 | 4 | 16 | 3 | 0 | 4 | 47 | 2026-11-12 |
| Syft | 5 | 8 | 5 | 1 | 3 | 13 | 4 | 1 | 4 | 44 | 2026-10-27 |
| Trivy | 8 | 6 | 6 | 4 | 1 | 10 | 2 | 1 | 2 | 40 | 2026-11-04 |
| Terraform | 3 | 2 | 4 | 12 | 1 | 5 | 1 | 0 | 0 | 35 | 2026-11-11 |
| OPA / Gatekeeper | 5 | 4 | 2 | 2 | 8 | 8 | 5 | 0 | 1 | 35 | 2026-11-17 |
| Ansible | 3 | 1 | 5 | 3 | 1 | 21 | 0 | 0 | 0 | 34 | 2026-10-27 |
| CodeQL | 5 | 4 | 2 | 2 | 6 | 7 | 3 | 1 | 2 | 32 | 2026-10-27 |
| OWASP ZAP | 6 | 5 | 3 | 3 | 4 | 7 | 1 | 1 | 1 | 31 | 2026-10-19 |
| Snyk | 6 | 4 | 2 | 3 | 1 | 10 | 1 | 1 | 1 | 29 | 2026-10-27 |
| GitGuardian | 6 | 4 | 4 | 3 | 2 | 8 | 0 | 0 | 1 | 28 | 2026-10-27 |
| Argo CD | 6 | 3 | 1 | 2 | 0 | 11 | 5 | 0 | 0 | 28 | 2026-10-28 |
| Grype | 5 | 3 | 9 | 2 | 3 | 0 | 2 | 1 | 2 | 27 | 2026-10-27 |
| Semgrep | 3 | 8 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 25 | 2026-10-18 |
| Falco | 6 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 25 | 2026-10-27 |
| GitHub Actions | 7 | 1 | 1 | 8 | 3 | 0 | 2 | 0 | 0 | 22 | 2026-11-03 |
| Terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 22 | 2026-10-10 |
| Cosign | 5 | 4 | 3 | 2 | 1 | 0 | 3 | 2 | 1 | 21 | 2026-11-17 |
| HashiCorp Vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2 | 21 | 2026-10-11 |
| Kubernetes | 4 | 2 | 2 | 3 | 0 | 5 | 4 | 0 | 0 | 20 | 2026-10-29 |
| Docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 3 | 0 | 19 | 2026-10-28 |
| Dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 19 | 2026-10-14 |
| DefectDojo | 4 | 2 | 3 | 2 | 2 | 6 | 0 | 0 | 0 | 19 | 2026-10-23 |
| Kustomize | 3 | 1 | 2 | 10 | 0 | 0 | 1 | 0 | 0 | 17 | 2026-11-16 |
| Helm | 4 | 1 | 1 | 1 | 0 | 0 | 2 | 0 | 0 | 13 | 2026-11-15 |
| Tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| Git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| OpenTofu | 4 | 2 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-10-28 |
| Grafana | 4 | 1 | 1 | 2 | 1 | 0 | 1 | 0 | 0 | 10 | 2026-10-27 |
| Gitleaks | 3 | 1 | 3 | 2 | 0 | 0 | 0 | 0 | 0 | 9 | 2026-10-26 |
| Linux | 3 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-31 |
| SonarQube | 3 | 0 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 7 | 2026-10-23 |
| Prometheus | 5 | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 7 | 2026-10-25 |
| tfsec | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 6 | 2026-10-28 |
| Nuclei | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-15 |

</details>

Counts reflect files inside each category subfolder. Some folders also hold files at their root or in project-specific subfolders, so the total may exceed the sum of category columns. `Last verified` is the most recent `last_verified` marker found in that tool's docs.

## Status

Recent additions under `learn/` focus on policy, secrets, and runtime security. Thinner corners remain for tfsec, Nuclei, Prometheus, and SonarQube where first configs or scripts are still sparse.

---
_Last updated: 2026-11-18_
