# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

1103 files across 43 top-level folders — 35 tool folders, plus the cross-cutting `docs/`, `scripts/`, `snippets/`, `templates/`, `environments/`, `lab/`, `assets/`, and `00_index/` layers. The toolchain runs from Linux and Git fundamentals up through Kubernetes delivery, then into the security tooling that rides on top of it: Trivy, Syft, Grype, Checkov, tfsec, Terrascan, Semgrep, CodeQL, ZAP, Nuclei, SonarQube, Cosign, Falco, Tetragon, OPA, Vault, and the secret scanners. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

## Quick links

- [Grype vulnerability reporting migration patterns](grype/docs/grype-vulnerability-reporting-migration-patterns.md) — Moving a report from table to JSON to SARIF for a new downstream consumer, without changing the scan itself
- [Grype filtering configuration template](grype/configs/grype-filtering-configuration-template.yaml) — One versioned file stating the severity gate, fix-state filtering, path exclusions, and ignore rules that each carry a reason and an owner
- [Grype database vs registry sources](grype/notebooks/grype-db-vs-registry-sources.ipynb) — Choosing between a registry image scan and a DB-backed SBOM scan, with a runnable database-freshness check
- [Grype in a vulnerability-management pipeline](grype/docs/vulnerability-management-pipeline-integration.md) — Target choice, database caching, machine-readable reports, gate thresholds, tracker routing, and diffing against the last accepted result
- [GitGuardian secret-scanning migration patterns](gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md) — Moving a config to the ggshield v2 format, replacing another scanner, and rolling one baseline out across a monorepo

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

Trivy, Nuclei, Semgrep, Checkov, tfsec, Terrascan, Grype, Syft, TruffleHog, Gitleaks, GitGuardian, Snyk, Terraform, CodeQL, ZAP, Cosign, Falco, Tetragon, OPA, Vault, Ansible, ArgoCD, Dependabot, Docker, Git, GitHub Actions, Helm, Kubernetes, Kustomize, OpenTofu, Prometheus, Grafana, DefectDojo, SonarQube, Linux, Assets, and Lab.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|------:|-----:|--------:|--------:|---------:|----------:|----------:|------------:|----------:|----------:|----------:|---------------|
| checkov | 4 | 6 | 3 | 3 | 4 | 20 | 3 | 0 | 4 | 1 | 48 | 2026-10-02 |
| trufflehog | 4 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 38 | 2026-09-04 |
| syft | 4 | 6 | 4 | 1 | 1 | 15 | 2 | 1 | 3 | 0 | 37 | 2026-09-17 |
| trivy | 6 | 4 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 35 | 2026-09-05 |
| zap | 6 | 5 | 3 | 2 | 4 | 8 | 1 | 1 | 1 | 0 | 31 | 2026-10-02 |
| gitguardian | 4 | 4 | 3 | 3 | 2 | 9 | 0 | 0 | 1 | 0 | 26 | 2026-10-03 |
| codeql | 4 | 2 | 1 | 1 | 5 | 8 | 2 | 1 | 1 | 0 | 25 | 2026-09-25 |
| grype | 4 | 3 | 8 | 2 | 2 | 0 | 2 | 1 | 2 | 0 | 24 | 2026-10-05 |
| opa | 3 | 2 | 2 | 1 | 3 | 9 | 4 | 0 | 0 | 0 | 24 | 2026-09-02 |
| falco | 4 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 0 | 23 | 2026-10-03 |
| semgrep | 3 | 7 | 3 | 1 | 2 | 0 | 2 | 2 | 3 | 0 | 23 | 2026-09-29 |
| snyk | 4 | 2 | 1 | 2 | 1 | 11 | 1 | 1 | 0 | 0 | 23 | 2026-09-03 |
| terraform | 3 | 1 | 4 | 5 | 1 | 0 | 0 | 0 | 0 | 0 | 21 | 2026-09-22 |
| terrascan | 5 | 2 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 0 | 21 | 2026-09-27 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | 2026-08-29 |
| environments | 4 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 19 | 2026-09-30 |
| cosign | 4 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 18 | 2026-09-25 |
| dependabot | 7 | 3 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 18 | 2026-09-26 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-25 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| github-actions | 5 | 0 | 0 | 4 | 2 | 0 | 2 | 0 | 0 | 0 | 13 | 2026-09-21 |
| lab | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-09-20 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| ansible | 3 | 1 | 3 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| assets | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 9 | 2026-09-30 |
| kubernetes | 2 | 1 | 0 | 1 | 0 | 0 | 3 | 0 | 0 | 0 | 7 | 2026-09-22 |
| defectdojo | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| kustomize | 3 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 6 | 2026-09-22 |
| linux | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-03 |
| opentofu | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| sonarqube | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| helm | 3 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 5 | 2026-09-21 |
| grafana | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-09-26 |
| gitleaks | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-26 |
| prometheus | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-20 |
| nuclei | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |
| tfsec | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |

_Last verified is the most recent `last_verified` value recorded anywhere in that tool's folder. Totals above are the files inside each category folder; a few folders also hold files at their root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, and Assets' diagrams), which the category columns don't itemise._

</details>

## Status

Primers and per-tool quickstarts are complete across most of the toolchain; the depth now sits in operational patterns rather than first contact. The most recent additions went into Grype — a reporting migration guide for moving a report shape without touching the scan, a filtering configuration template that puts the severity gate and ignore rules in one reviewable file, and a notebook weighing a registry image scan against a DB-backed SBOM scan with a database-freshness check. Alongside that sits GitGuardian's secret-scanning migration patterns and a Linux system administration runbook with a single-entry-point health check and rollback script. Current focus is operational depth — host triage, reporting contracts, and the config files that sit underneath the tools.

---
_Last updated: 2026-10-05_