# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it: Trivy, Syft, Grype, Checkov, tfsec, Terrascan, Semgrep, CodeQL, SonarQube, ZAP, Nuclei, Cosign, Falco, Tetragon, OPA, Vault, and the secret scanners — TruffleHog, Gitleaks, and GitGuardian. Cross-cutting layers hold the concept primers, how-to guides, runbooks, shell toolkits, cheatsheets, and starter templates that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Grype in a vulnerability-management pipeline](grype/docs/vulnerability-management-pipeline-integration.md) — The loop around a scan: picking a target, caching the vulnerability database, exporting once and gating separately, diffing against the last accepted report, and routing findings to a tracker
- [GitGuardian scanning migration patterns](gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md) — Adopting or replacing secret scanning without losing coverage: ggshield v1 to v2 config, moving off TruffleHog or Gitleaks, consolidating per-repo config into an org baseline
- [GitGuardian org secret-scanning policy](gitguardian/configs/policy-configuration.yaml) — One reviewable file recording which detectors stay enforced, which paths are ignored and why, who owns findings per directory, and what an incident handoff must carry
- [Hosted vs self-managed secret scanning](gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb) — Where scan content travels, who operates the service, and a per-tier scoring function that treats data residency as a veto rather than a weight
- [Minimal Falco runtime config](falco/configs/2026-10-03-minimal-runtime-config.yaml) — The daemon config Falco is pointed at with `--config`: which rule files load, JSON alert output, and the rate limit that decides whether a looping rule floods the log

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
| checkov | 4 | 6 | 3 | 3 | 4 | 20 | 3 | 0 | 4 | 1 | 48 | 2026-09-17 |
| trufflehog | 4 | 2 | 3 | 2 | 2 | 21 | 1 | 1 | 2 | 0 | 38 | 2026-09-04 |
| syft | 4 | 6 | 4 | 1 | 1 | 15 | 2 | 1 | 3 | 0 | 37 | 2026-09-03 |
| trivy | 6 | 4 | 6 | 2 | 1 | 11 | 2 | 1 | 2 | 0 | 35 | 2026-09-05 |
| zap | 6 | 5 | 3 | 2 | 4 | 8 | 1 | 1 | 1 | 0 | 31 | 2026-09-30 |
| gitguardian | 4 | 4 | 3 | 3 | 2 | 9 | 0 | 0 | 1 | 0 | 26 | 2026-10-03 |
| codeql | 4 | 2 | 1 | 1 | 5 | 8 | 2 | 1 | 1 | 0 | 25 | 2026-09-18 |
| opa | 3 | 2 | 2 | 1 | 3 | 9 | 4 | 0 | 0 | 0 | 24 | 2026-08-27 |
| falco | 4 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 0 | 23 | 2026-09-30 |
| semgrep | 3 | 7 | 3 | 1 | 2 | 0 | 2 | 2 | 3 | 0 | 23 | 2026-09-29 |
| snyk | 4 | 2 | 1 | 2 | 1 | 11 | 1 | 1 | 0 | 0 | 23 | 2026-09-02 |
| terraform | 3 | 1 | 4 | 5 | 1 | 0 | 0 | 0 | 0 | 0 | 21 | 2026-08-10 |
| terrascan | 5 | 2 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 0 | 21 | 2026-09-27 |
| grype | 4 | 2 | 8 | 1 | 2 | 0 | 2 | 1 | 1 | 0 | 21 | 2026-10-03 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 1 | 0 | 20 | 2026-08-30 |
| environments | 4 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 19 | 2026-09-30 |
| cosign | 4 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 18 | 2026-09-25 |
| dependabot | 7 | 3 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 18 | 2026-09-26 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-23 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| github-actions | 5 | 0 | 0 | 4 | 2 | 0 | 2 | 0 | 0 | 0 | 13 | 2026-09-21 |
| lab | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-09-20 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| ansible | 3 | 1 | 3 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| assets | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 9 | 2026-09-30 |
| kubernetes | 2 | 1 | 0 | 1 | 0 | 0 | 3 | 0 | 0 | 0 | 7 | 2026-09-22 |
| defectdojo | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| kustomize | 3 | 0 | 0 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 6 | 2026-09-21 |
| linux | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-02 |
| opentofu | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| sonarqube | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| helm | 3 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 5 | 2026-09-21 |
| grafana | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-09-26 |
| gitleaks | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-19 |
| prometheus | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2026-09-20 |
| nuclei | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |
| tfsec | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2026-09-20 |

_Counts are the files inside each category folder; a few folders also hold files at their root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, and Assets' diagrams), which the category columns don't itemise. `Last verified` is the most recent `last_verified` date in that tool's doc front-matter._

</details>

## Status

Primers and first-contact notes are complete across the toolchain, so the depth work is operational rather than introductory. Recent additions went after the two places a security toolchain actually gets hard: the pipeline around a vulnerability scan — target choice, database caching, report retention, and diffing against the last accepted result — and the moves teams make when adopting or replacing secret scanning. The thinner corners are the tools carrying notes only: tfsec, Nuclei, Prometheus, Gitleaks, and Grafana.

---
_Last updated: 2026-10-04_
