# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it. Cross-cutting layers hold concept primers, how-to guides, runbooks, shell toolkits, cheatsheets, and starter templates that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Installing Falco and waiting for my first event](falco/notes/2026-10-15-install-falco-first-event.md) — No cluster with watchable nodes here, so the install steps stay mapped-out rather than run
- [Following the Nuclei quickstart — what tripped me up](nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md) — Install, template fetch, target choice, and output handling, with a one-template plan
- [My first Nuclei template](nuclei/configs/2026-10-15-minimal-scan-template.yaml) — A single harmless word-matcher check at severity info for a practice page
- [Cosign — install and my first signing command](cosign/notes/2026-10-14-install-cosign-first-signing-command.md) — Binary install, keypair generation, and `cosign sign` against a full registry path
- [GitHub Actions — run my first workflow and record what happened](github-actions/notes/2026-10-14-run-first-workflow.md) — Push-triggered run from queued to green, plus the silent-folder and indentation gotchas

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, setup guides, and `docs/notes/`
- **`scripts/`** — Shell toolkits organised by domain (`scripts/bash/`), deployment and rollback wrappers (`scripts/pipeline/`), and repository utilities, plus `scripts/notes/` and `scripts/snippets/`
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners, plus `snippets/configs/`, `snippets/notes/`, and `snippets/snippets/`
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng, and per-tool scaffolds, plus `templates/configs/`, `templates/notes/`, and `templates/templates/`
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`.github/`** — CODEOWNERS, PR template, and Dependabot config

## Architecture Overview

![DevSecOps Kit Architecture](assets/architecture-overview.png)

Per-tool content folders follow a consistent shape — `notes/`, `scripts/`, `configs/`, `snippets/`, plus wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Nuclei, Semgrep, Checkov, tfsec, Terrascan, Grype, Syft, TruffleHog, Gitleaks, GitGuardian, Snyk, Terraform, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, Linux, Assets, and Lab.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|----------:|----------:|---------------|
| checkov | 4 | 6 | 4 | 3 | 4 | 20 | 3 | 0 | 4 | 1 | 49 | 2026-10-07 |
| trufflehog | 4 | 4 | 3 | 2 | 3 | 21 | 2 | 1 | 3 | 0 | 43 | 2026-10-14 |
| syft | 4 | 8 | 4 | 1 | 2 | 15 | 4 | 1 | 4 | 0 | 43 | 2026-10-14 |
| trivy | 7 | 6 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 38 | 2026-10-14 |
| zap | 6 | 5 | 3 | 2 | 4 | 8 | 1 | 1 | 1 | 0 | 31 | 2026-10-02 |
| gitguardian | 5 | 4 | 3 | 3 | 2 | 9 | 0 | 0 | 1 | 0 | 27 | 2026-10-14 |
| codeql | 4 | 4 | 1 | 1 | 5 | 8 | 3 | 1 | 2 | 0 | 29 | 2026-10-11 |
| opa | 3 | 4 | 2 | 2 | 4 | 9 | 4 | 0 | 1 | 0 | 29 | 2026-10-14 |
| grype | 5 | 3 | 8 | 2 | 2 | 0 | 2 | 1 | 2 | 0 | 25 | 2026-10-14 |
| falco | 5 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 0 | 24 | 2026-10-15 |
| semgrep | 3 | 7 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 0 | 24 | 2026-10-09 |
| snyk | 5 | 4 | 1 | 3 | 1 | 11 | 1 | 1 | 1 | 0 | 28 | 2026-10-08 |
| terraform | 3 | 1 | 4 | 5 | 1 | 0 | 0 | 0 | 0 | 0 | 21 | 2026-09-22 |
| terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 0 | 22 | 2026-10-10 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2 | 0 | 21 | 2026-10-11 |
| environments | 5 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 20 | 2026-10-14 |
| cosign | 5 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 19 | 2026-10-14 |
| dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 19 | 2026-10-14 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-25 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| github-actions | 6 | 0 | 0 | 5 | 3 | 0 | 2 | 0 | 0 | 0 | 16 | 2026-10-14 |
| lab | 2 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 14 | 2026-10-14 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| ansible | 3 | 1 | 3 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| assets | 5 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-10-11 |
| kubernetes | 3 | 1 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 9 | 2026-10-14 |
| defectdojo | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| kustomize | 3 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 6 | 2026-09-22 |
| linux | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-03 |
| opentofu | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| sonarqube | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| helm | 3 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 5 | 2026-09-21 |
| grafana | 4 | 0 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-14 |
| gitleaks | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-13 |
| prometheus | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-10-14 |
| nuclei | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-10-15 |
| tfsec | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |

_Counts are the files inside each category folder; a few folders also hold files at their root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, and Assets' diagrams), which the category columns don't itemise. `Last verified` is the most recent `last_verified` marker anywhere in that tool's files._

</details>

## Status

First-contact notes are still landing where the kit was thin: a Nuclei quickstart pass with a first hand-written scan template, a Falco install mapped out against a box with no nodes to watch, a first Cosign signing command, and a first GitHub Actions run from queued to green. The thinner corners are still the tools carrying notes only: tfsec, and Nuclei until that first template actually runs.

---
_Last updated: 2026-10-19_
