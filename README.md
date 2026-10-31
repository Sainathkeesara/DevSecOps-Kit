# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)]

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it. Cross-cutting layers hold concept primers, how-to guides, runbooks, shell toolkits, cheatsheets, and starter templates that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [learn/01-foundations/02-shell-scripting.md](learn/01-foundations/02-shell-scripting.md) — Shell scripting foundations
- [linux/scripts/find-large-logs.sh](linux/scripts/find-large-logs.sh) — Find large logs
- [cosign/docs/keyless-signing-patterns.md](cosign/docs/keyless-signing-patterns.md) — Keyless signing patterns
- [terraform/docs/terraform-testing-patterns.md](terraform/docs/terraform-testing-patterns.md) — Terraform testing patterns
- [terraform/templates/module-registry-publish-consume/README.md](terraform/templates/module-registry-publish-consume/README.md) — Module registry publish consume

## Layout

- **`00_index/`** — Navigation: topic map, quick links, glossary, learning path
- **`docs/`** — Concept primers, how-to guides, reference, runbooks, security docs, troubleshooting, setup guides, and `docs/notes/`
- **`scripts/`** — Shell toolkits organised by domain (`scripts/bash/`), deployment and rollback wrappers (`scripts/pipeline/`), and repository utilities, plus `scripts/notes/` and `scripts/snippets/`
- **`snippets/`** — Copy-paste ready cheatsheets and one-liners, plus `snippets/configs/`, `snippets/notes/`, and `snippets/snippets/`
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng, and per-tool scaffolds, plus `templates/configs/`, `templates/notes/`, and `templates/templates/`
- **`environments/`** — Terraform environment configs (dev / staging / prod) with promotion workflow and docs
- **`lab/`** — Mini-projects and learning sandboxes
- **`assets/`** — Architecture diagrams and workflow illustrations

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|---------------|
| trufflehog | 4 | 4 | 3 | 2 | 3 | 28 | 2 | 2 | 2026-09-04 |
| checkov | 4 | 6 | 4 | 3 | 4 | 16 | 3 | 0 | 2026-07-19 |
| syft | 4 | 8 | 4 | 1 | 2 | 13 | 4 | 1 | 2026-09-03 |
| trivy | 8 | 6 | 6 | 3 | 1 | 10 | 2 | 1 | 2026-10-14 |
| zap | 6 | 5 | 3 | 3 | 4 | 7 | 1 | 1 | 2026-09-05 |
| snyk | 5 | 4 | 2 | 3 | 1 | 10 | 1 | 1 | 2026-10-07 |
| opa | 4 | 4 | 2 | 2 | 4 | 8 | 4 | 0 | 2026-10-24 |
| codeql | 4 | 4 | 2 | 2 | 5 | 7 | 3 | 1 | 2026-08-26 |
| gitguardian | 5 | 4 | 4 | 3 | 2 | 8 | 0 | 0 | 2026-10-14 |
| ansible | 3 | 1 | 4 | 3 | 1 | 15 | 0 | 0 | 2026-09-22 |
| grype | 5 | 3 | 9 | 2 | 2 | 0 | 2 | 1 | 2026-10-14 |
| semgrep | 3 | 8 | 3 | 1 | 2 | 0 | 3 | 2 | 2026-09-29 |
| falco | 5 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2026-07-19 |
| snippets | 2 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 2026-10-19 |
| terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | 0 | 2026-07-10 |
| terraform | 3 | 1 | 4 | 6 | 1 | 0 | 1 | 0 | 2026-10-28 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2026-08-26 |
| github-actions | 7 | 1 | 1 | 7 | 3 | 0 | 2 | 0 | 2026-10-14 |
| defectdojo | 4 | 2 | 3 | 2 | 2 | 6 | 0 | 0 | 2026-08-04 |
| dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 2026-07-21 |
| cosign | 5 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 2026-10-14 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 2026-07-09 |
| lab | 2 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 2026-10-25 |
| argocd | 6 | 2 | 0 | 2 | 0 | 12 | 3 | 0 | 2026-07-31 |
| kubernetes | 4 | 1 | 1 | 3 | 0 | 0 | 3 | 0 | 2026-07-15 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 2026-08-06 |
| assets | 5 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 2026-10-25 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 2026-07-12 |
| kustomize | 3 | 0 | 2 | 3 | 0 | 0 | 1 | 0 | 2026-07-08 |
| helm | 4 | 1 | 1 | 1 | 0 | 0 | 2 | 0 | 2026-09-21 |
| sonarqube | 3 | 0 | 1 | 2 | 1 | 0 | 0 | 0 | 2026-09-21 |
| opentofu | 4 | 2 | 0 | 3 | 0 | 0 | 0 | 0 | 2026-10-28 |
| grafana | 4 | 0 | 0 | 2 | 1 | 0 | 0 | 0 | 2026-09-26 |
| linux | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 2026-10-02 |
| gitleaks | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 2026-10-07 |
| tfsec | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 2026-10-19 |
| nuclei | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 2026-10-15 |
| prometheus | 5 | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 2026-09-20 |
| scripts | 4 | 0 | 0 | 1 | 2 | 0 | 0 | 0 | 2026-07-16 |
| templates | 2 | 1 | 1 | 3 | 1 | 45 | 0 | 0 | 2026-09-20 |
| docs | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2026-10-18 |
| environments | 5 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 2026-10-25 |

_Counts are the files inside each category folder; a few folders also hold files at their root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, and Assets' diagrams), which the category columns don't itemise. `Last verified` is the most recent `last_verified` marker anywhere in that tool's files._

</details>

## Status

OpenTofu and Terraform terrain expanded: OpenTofu vs Terraform migration decision matrix and cloud workspace automation configs now available. Thinner corners persist for tfsec, Nuclei, and Prometheus until first configs and scripts land. Argo CD carries the app-of-apps multi-environment scaffold (dev/staging/prod) with bootstrap and Helm values. Environments promotion workflow and asset tracking still landing.

---
_Last updated: 2026-11-01_