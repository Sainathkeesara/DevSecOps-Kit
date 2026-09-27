# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

1069 files across 37 tool folders, plus cross-cutting docs, scripts, snippets, templates, and lab environments. The toolchain runs from Linux and Git fundamentals up through Kubernetes delivery, then into the security tooling that rides on top of it: Trivy, Syft, Grype, Checkov, tfsec, Terrascan, Semgrep, CodeQL, ZAP, Nuclei, SonarQube, Cosign, Falco, Tetragon, OPA, Vault, and the secret scanners. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

## Quick links

- [Terrascan configuration template](terrascan/configs/terrascan-config-template.yaml) — The real `TerrascanConfig` schema: policy, notifications, rules, category, severity, and which keys Terrascan silently ignores
- [Terraform basics practice loop](docs/concepts/infrastructure-as-code/scripts/2026-09-27-terraform-basics-practice.sh) — Walk `init`/`validate`/`plan`/`apply` once on a provider-free config so you can see which command creates which file
- [Reusable module HCL pattern](docs/concepts/infrastructure-as-code/snippets/2026-09-27-reusable-module-hcl-pattern.sh) — One module folder owning a resource, every caller passing inputs, and no environment name hardcoded
- [DevOps automation shell patterns](docs/concepts/linux-shell-fundamentals/scripts/2026-09-27-devops-automation-shell-patterns.sh) — Per-step wrapping so one failure doesn't hide the rest, retry on transient errors, config read from a key=value file
- [Rego vs YAML rule authoring](terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb) — When a Terrascan rule needs real logic versus a declarative policy block, side by side

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, and setup guides
- **`scripts/`** — Shell toolkits organised by domain (`scripts/bash/`), deployment and rollback wrappers (`scripts/pipeline/`), and repository utilities
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng, and per-tool scaffolds
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`.github/`** — CODEOWNERS, PR template, and Dependabot config

Per-tool content folders follow a consistent shape — `notes/`, `scripts/`, `configs/`, `snippets/`, plus wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Nuclei, Semgrep, Checkov, tfsec, Terrascan, Grype, Syft, TruffleHog, Gitleaks, GitGuardian, Snyk, Terraform, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, Linux, and Lab.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|----------:|----------:|---------:|---------------|
| checkov | 4 | 6 | 2 | 3 | 4 | 20 | 3 | 0 | 3 | 1 | 46 | 2026-09-17 |
| trufflehog | 4 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 38 | 2026-09-04 |
| syft | 4 | 6 | 4 | 1 | 1 | 15 | 2 | 1 | 3 | 0 | 37 | 2026-09-03 |
| trivy | 6 | 4 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 35 | 2026-09-05 |
| zap | 6 | 3 | 3 | 2 | 4 | 8 | 0 | 1 | 0 | 0 | 27 | 2026-09-05 |
| opa | 3 | 2 | 2 | 1 | 3 | 9 | 4 | 0 | 0 | 0 | 24 | 2026-08-27 |
| codeql | 4 | 2 | 1 | 1 | 5 | 8 | 2 | 1 | 1 | 0 | 25 | 2026-09-18 |
| snyk | 4 | 2 | 1 | 2 | 1 | 11 | 1 | 1 | 0 | 0 | 23 | 2026-09-02 |
| gitguardian | 4 | 2 | 3 | 2 | 2 | 9 | 0 | 0 | 0 | 0 | 22 | 2026-08-21 |
| terraform | 3 | 1 | 4 | 5 | 1 | 0 | 0 | 0 | 0 | 0 | 21 | 2026-08-10 |
| terrascan | 5 | 2 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 0 | 21 | 2026-09-27 |
| grype | 4 | 1 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | — |
| semgrep | 3 | 5 | 3 | 1 | 2 | 0 | 2 | 2 | 2 | 0 | 20 | 2026-08-06 |
| falco | 4 | 3 | 3 | 3 | 1 | 4 | 1 | 0 | 1 | 0 | 20 | 2026-09-19 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 1 | 1 | 1 | 0 | 19 | 2026-08-30 |
| dependabot | 7 | 3 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 18 | 2026-09-26 |
| cosign | 4 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 18 | 2026-09-25 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-23 |
| environments | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 15 | 2026-09-19 |
| lab | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-09-20 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| github-actions | 5 | 0 | 0 | 4 | 2 | 0 | 2 | 0 | 0 | 0 | 13 | 2026-09-21 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| ansible | 3 | 1 | 3 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| kubernetes | 2 | 1 | 0 | 1 | 0 | 0 | 3 | 0 | 0 | 0 | 7 | 2026-09-22 |
| kustomize | 3 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 6 | 2026-09-21 |
| opentofu | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| defectdojo | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| sonarqube | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| helm | 3 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 5 | 2026-09-21 |
| grafana | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-09-26 |
| gitleaks | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-19 |
| linux | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-08-17 |
| prometheus | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-20 |
| nuclei | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |
| tfsec | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |

_Grype's notes carry no `last_verified` front-matter, so its column reads —. Totals above are the files inside each category folder; a few tools also hold files at the folder root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, Checkov's `.checkov.yaml` and `.pre-commit-config.yaml`), which the category columns don't itemise._

</details>

## Status

Foundational concept primers and practice exercises are complete across the toolchain, and per-tool quickstarts are being rounded out. Recent additions cover a Terrascan config template and its Rego-vs-YAML rule-authoring comparison, a provider-free Terraform practice loop and reusable-module pattern, and a set of automation-oriented shell patterns for the Linux fundamentals concept. Current focus is Terrascan configuration depth and Infrastructure-as-Code practice material.

---
_Last updated: 2026-09-27_
