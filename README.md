# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it: Trivy, Syft, Grype, Checkov, tfsec, Terrascan, Semgrep, CodeQL, SonarQube, ZAP, Nuclei, Cosign, Falco, Tetragon, OPA, Vault, and the secret scanners — TruffleHog, Gitleaks, and GitGuardian. Cross-cutting layers hold the concept primers, how-to guides, runbooks, shell toolkits, cheatsheets, and starter templates that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [CodeQL database migration guide](codeql/docs/codeql-database-migration-guide.md) — Move a CodeQL setup between database arrangements without losing coverage: language set, build mode, database location, or a stale database rebuild
- [CodeQL integration reference for security analysis](codeql/docs/codeql-integration-reference.md) — How the kit's CodeQL scan stages fit together: workflow files, manifests, and the local CLI loop as one pipeline map
- [Snyk security policy migration patterns](snyk/docs/snyk-security-policy-migration-patterns.md) — Move ignore rules, severity thresholds, and exclusion paths between policy forms without weakening the gate or losing accepted-risk suppressions
- [Snyk project configuration template](snyk/configs/snyk-project-configuration-template.yaml) — Per-project Snyk settings in one place: severity gate, scan targets, exclusions with reasons, and the ignore-policy pointer for multi-target repos
- [Choosing between CLI and API modes in Snyk](snyk/notebooks/cli-vs-api-modes.ipynb) — When to run a scan through the CLI versus the HTTP API: who can call each, how results are consumed, and how failures surface

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

Per-tool content folders follow a consistent shape — `notes/`, `scripts/`, `configs/`, `snippets/`, plus wherever useful `docs/`, `manifests/`, `dockerfiles/`, `notebooks/`, `policies/`, or `templates/`:

Trivy, Nuclei, Semgrep, Checkov, tfsec, Terrascan, Grype, Syft, TruffleHog, Gitleaks, GitGuardian, Snyk, Terraform, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, Linux, Assets, and Lab.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|----------:|----------:|---------------|
| checkov | 4 | 6 | 4 | 3 | 4 | 20 | 3 | 0 | 4 | 1 | 49 | 2026-10-07 |
| trufflehog | 4 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 38 | 2026-09-04 |
| syft | 4 | 8 | 4 | 1 | 1 | 15 | 2 | 1 | 3 | 0 | 39 | 2026-10-11 |
| trivy | 6 | 5 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 36 | 2026-10-11 |
| zap | 6 | 5 | 3 | 2 | 4 | 8 | 1 | 1 | 1 | 0 | 31 | 2026-10-02 |
| gitguardian | 4 | 4 | 3 | 3 | 2 | 9 | 0 | 0 | 1 | 0 | 26 | 2026-10-03 |
| codeql | 4 | 4 | 1 | 1 | 5 | 8 | 3 | 1 | 1 | 0 | 28 | 2026-10-11 |
| opa | 3 | 4 | 2 | 2 | 3 | 9 | 4 | 0 | 1 | 0 | 28 | 2026-10-06 |
| grype | 4 | 3 | 8 | 2 | 2 | 0 | 2 | 1 | 2 | 0 | 24 | 2026-10-05 |
| falco | 4 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 0 | 23 | 2026-10-03 |
| semgrep | 3 | 7 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 0 | 24 | 2026-10-11 |
| snyk | 5 | 4 | 1 | 3 | 1 | 11 | 1 | 1 | 1 | 0 | 28 | 2026-10-08 |
| terraform | 3 | 1 | 4 | 5 | 1 | 0 | 0 | 0 | 0 | 0 | 21 | 2026-09-22 |
| terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 0 | 22 | 2026-10-11 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | 2026-09-29 |
| environments | 4 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 19 | 2026-10-01 |
| cosign | 4 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 18 | 2026-09-25 |
| dependabot | 7 | 3 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 18 | 2026-09-26 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-25 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| github-actions | 5 | 0 | 0 | 4 | 2 | 0 | 2 | 0 | 0 | 0 | 13 | 2026-09-21 |
| lab | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-09-20 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| ansible | 3 | 1 | 3 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| assets | 4 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-10-11 |
| kubernetes | 2 | 1 | 0 | 1 | 0 | 0 | 3 | 0 | 0 | 0 | 7 | 2026-09-22 |
| defectdojo | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| kustomize | 3 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 6 | 2026-09-22 |
| linux | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-03 |
| opentofu | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| sonarqube | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| helm | 3 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 5 | 2026-09-21 |
| grafana | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-09-26 |
| gitleaks | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-07 |
| prometheus | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-20 |
| nuclei | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |
| tfsec | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |

_Counts are the files inside each category folder; a few folders also hold files at their root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, and Assets' diagrams), which the category columns don't itemise. `Last verified` is the most recent `last_verified` marker anywhere in that tool's files._

</details>

## Status

Primers and first-contact notes are complete across the toolchain, so the depth work is operational rather than introductory. Recent additions went after the places a security toolchain actually gets hard: the loop around a vulnerability scan — target choice, database caching, report retention, and diffing against the last accepted result — the moves teams make when adopting or replacing secret scanning, and running a single Gatekeeper ConstraintTemplate across dev, staging, and prod without breaking promotion order or fail-closed enforcement. The newest CodeQL additions stay on that thread: a database migration guide for moving setups between language sets, build modes, and database locations without losing coverage, and an integration reference mapping the kit's workflows, manifests, and local CLI loop into one pipeline. The thinner corners are the tools carrying notes only: tfsec, Nuclei, and Prometheus.

---
_Last updated: 2026-10-11_
