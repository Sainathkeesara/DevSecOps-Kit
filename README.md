# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![License](https://img.shields.io/github/license/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it. Cross-cutting layers hold concept primers, how-to guides, runbooks, shell toolkits, cheatsheets, and starter templates that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

**1243 files across 43 top-level folders (37 tool folders + 6 cross-cutting).**

## Quick links

- [Lab multi-node demo config](lab/configs/2026-10-25-multi-node-demo.yaml) — Three practice boxes that talk to each other
- [Lab quickstart trip-ups](lab/notes/2026-10-25-lab-quickstart-trips.md) — What tripped me up on the lab quickstart
- [Minimal lab environment with Python](lab/snippets/2026-10-25-minimal-lab-env.py) — Throwaway practice box using lab config format
- [Install OPA and first policy evaluation](opa/notes/2026-10-24-install-opa-first-policy-eval.md) — First Rego policy eval with OPA
- [Vault secret access patterns](docs/concepts/secrets-access-management/scripts/vault-secrets-access-patterns.sh) — Common Vault secret access patterns practice

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`docs/`** — Concepts, how-to guides, reference, runbooks, security docs, troubleshooting, setup guides, and `docs/notes/`
- **`scripts/`** — Shell toolkits organised by domain (`scripts/bash/`), deployment and rollback wrappers (`scripts/pipeline/`), and repository utilities, plus `scripts/notes/` and `scripts/snippets/`
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners, plus `snippets/configs/`, `snippets/notes/`, and `snippets/snippets/`
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng, and per-tool scaffolds, plus `templates/configs/`, `templates/notes/`, and `templates/templates/`
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|----------:|----------:|---------------|
| trufflehog | 4 | 4 | 3 | 2 | 3 | 28 | 2 | 2 | 3 | 0 | 51 | 2026-10-13 |
| checkov | 4 | 6 | 4 | 3 | 4 | 16 | 3 | 0 | 4 | 1 | 45 | 2026-09-17 |
| syft | 4 | 8 | 4 | 1 | 2 | 13 | 4 | 1 | 4 | 0 | 41 | 2026-10-13 |
| trivy | 8 | 6 | 6 | 3 | 1 | 10 | 2 | 1 | 2 | 0 | 39 | 2026-10-19 |
| zap | 6 | 5 | 3 | 3 | 4 | 7 | 1 | 1 | 1 | 0 | 31 | 2026-10-19 |
| codeql | 4 | 4 | 2 | 2 | 5 | 7 | 3 | 1 | 2 | 0 | 30 | 2026-10-22 |
| opa | 4 | 4 | 2 | 2 | 4 | 8 | 4 | 0 | 1 | 0 | 29 | 2026-10-24 |
| snyk | 5 | 4 | 2 | 3 | 1 | 10 | 1 | 1 | 1 | 0 | 28 | 2026-10-08 |
| gitguardian | 5 | 4 | 4 | 3 | 2 | 8 | 0 | 0 | 1 | 0 | 27 | 2026-10-14 |
| ansible | 3 | 1 | 4 | 3 | 1 | 15 | 0 | 0 | 0 | 0 | 27 | 2026-10-19 |
| grype | 5 | 3 | 9 | 2 | 2 | 0 | 2 | 1 | 2 | 0 | 26 | 2026-10-14 |
| semgrep | 3 | 8 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 0 | 25 | 2026-10-18 |
| falco | 5 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 0 | 24 | 2026-10-15 |
| snippets | 2 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 23 | 2026-10-19 |
| terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 0 | 22 | 2026-10-10 |
| terraform | 3 | 1 | 4 | 6 | 1 | 0 | 0 | 0 | 0 | 0 | 22 | 2026-08-10 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2 | 0 | 21 | 2026-09-29 |
| github-actions | 7 | 1 | 1 | 7 | 3 | 0 | 2 | 0 | 0 | 0 | 21 | 2026-10-22 |
| defectdojo | 4 | 2 | 3 | 2 | 2 | 6 | 0 | 0 | 0 | 0 | 19 | 2026-10-23 |
| dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 19 | 2026-10-14 |
| cosign | 5 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 19 | 2026-10-14 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-25 |
| lab | 2 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 18 | 2026-10-25 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| kubernetes | 4 | 1 | 1 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 12 | 2026-10-20 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| assets | 5 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-10-11 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| kustomize | 3 | 1 | 2 | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 10 | 2026-10-24 |
| helm | 4 | 1 | 1 | 1 | 0 | 0 | 2 | 0 | 0 | 0 | 9 | 2026-10-23 |
| sonarqube | 3 | 0 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-23 |
| opentofu | 4 | 1 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 8 | 2026-10-23 |
| grafana | 4 | 0 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-14 |
| linux | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-02 |
| gitleaks | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-07 |
| tfsec | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-19 |
| nuclei | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-15 |
| prometheus | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-10-14 |
| scripts | 4 | 0 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-18 |
| templates | 2 | 1 | 1 | 3 | 1 | 3 | 0 | 0 | 0 | 0 | 11 | 2026-10-20 |
| docs | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-10-18 |
| environments | 5 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 20 | 2026-10-14 |

_Counts are the files inside each category folder; a few folders also hold files at their root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, and Assets' diagrams), which the category columns don't itemise. `Last verified` is the most recent `last_verified` marker anywhere in that tool's files._

</details>

## Status

First-contact notes are still landing where the kit was thin: a Lab multi-node demo, OPA first policy eval, and Vault secret access patterns. The thinner corners are still the tools carrying notes only: tfsec, Nuclei, and Prometheus until their first configs and scripts land.

---
_Last updated: 2026-10-25_