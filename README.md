# DevSecOps-Kit
> A working engineer's devops and devsecops reference for vulnerability scanning, secret detection, SBOMs, supply chain security, runtime security, policy engines, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working devops and devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it. Cross-cutting layers hold concept primers, how-to guides, runbooks, shell toolkits, cheatsheets, and starter templates that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

**1187 files across 43 top-level folders (37 tool folders + 6 cross-cutting).**

## Quick links

- [OpenTofu test quickstart followup](opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md) — What happened after following the OpenTofu test quickstart: commands run, output captured, and where it tripped
- [Helm build and deploy chart script](helm/scripts/build-and-deploy-chart.sh) — End-to-end script that builds a Helm chart and deploys it to a cluster
- [DefectDojo API vs UI ingestion config](defectdojo/configs/api-vs-ui-ingestion.yaml) — Comparison of importing scan results via API versus the DefectDojo web UI
- [DefectDojo wired into triage workflow](defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md) — How DefectDojo fits into the daily vulnerability triage process
- [Helm wired into release workflow](helm/docs/how-i-wired-helm-into-my-release-workflow.md) — How Helm charts, values, and releases integrate into a real deployment pipeline

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
| docs | 0 | 213 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 213 | 2026-10-18 |
| scripts | 4 | 0 | 192 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 196 | 2026-10-18 |
| trufflehog | 4 | 4 | 9 | 2 | 3 | 28 | 2 | 2 | 3 | 0 | 51 | 2026-10-13 |
| templates | 0 | 1 | 0 | 3 | 1 | 41 | 0 | 0 | 0 | 0 | 45 | 2026-09-20 |
| checkov | 4 | 6 | 5 | 3 | 4 | 16 | 3 | 0 | 4 | 1 | 45 | 2026-09-17 |
| syft | 4 | 8 | 6 | 1 | 2 | 13 | 4 | 1 | 4 | 0 | 41 | 2026-10-13 |
| trivy | 8 | 6 | 8 | 3 | 1 | 10 | 2 | 1 | 2 | 0 | 39 | 2026-10-19 |
| zap | 6 | 5 | 4 | 3 | 4 | 7 | 1 | 1 | 1 | 0 | 31 | 2026-10-19 |
| snyk | 5 | 4 | 8 | 3 | 1 | 10 | 1 | 1 | 1 | 1 | 28 | 2026-10-08 |
| opa | 3 | 4 | 2 | 2 | 4 | 8 | 4 | 0 | 1 | 4 | 28 | 2026-10-06 |
| codeql | 4 | 4 | 2 | 1 | 5 | 7 | 3 | 1 | 2 | 0 | 28 | 2026-10-09 |
| gitguardian | 5 | 4 | 6 | 3 | 2 | 8 | 0 | 0 | 1 | 0 | 27 | 2026-10-14 |
| ansible | 3 | 1 | 4 | 3 | 1 | 15 | 0 | 0 | 0 | 0 | 27 | 2026-10-19 |
| semgrep | 3 | 8 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 0 | 25 | 2026-10-18 |
| grype | 5 | 3 | 8 | 2 | 2 | 0 | 2 | 1 | 2 | 0 | 25 | 2026-10-14 |
| falco | 5 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 0 | 24 | 2026-10-15 |
| snippets | 2 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 23 | 2026-10-19 |
| terrascan | 5 | 3 | 3 | 2 | 2 | 6 | 1 | 0 | 1 | 2 | 22 | 2026-10-10 |
| terraform | 3 | 1 | 4 | 6 | 1 | 0 | 0 | 0 | 0 | 0 | 22 | 2026-08-10 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2 | 0 | 21 | 2026-09-29 |
| environments | 5 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 20 | 2026-10-14 |
| dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 19 | 2026-10-14 |
| cosign | 5 | 3 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 19 | 2026-10-14 |
| github-actions | 7 | 0 | 0 | 6 | 3 | 0 | 2 | 0 | 0 | 0 | 18 | 2026-10-20 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 2 | 0 | 0 | 18 | 2026-09-25 |
| argocd | 6 | 2 | 0 | 2 | 0 | 0 | 3 | 0 | 0 | 0 | 13 | 2026-09-23 |
| kubernetes | 4 | 1 | 1 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 12 | 2026-10-20 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| defectdojo | 4 | 1 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-10-20 |
| assets | 5 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-10-11 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| grafana | 4 | 0 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-14 |
| sonarqube | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-09-21 |
| opentofu | 4 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-20 |
| linux | 3 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-02 |
| kustomize | 3 | 0 | 1 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 7 | 2026-09-22 |
| helm | 4 | 1 | 1 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 8 | 2026-10-20 |
| gitleaks | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-07 |
| tfsec | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-19 |
| nuclei | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-15 |
| prometheus | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-10-14 |
| lab | 2 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-09-20 |
| 00_index | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 | 2026-10-21 |

_Counts are the files inside each category folder; a few folders also hold files at their root or in project sub-folders (Terraform's EventBridge sample, Lab's mini-projects, Environments' dev/staging/prod Terraform, and Assets' diagrams), which the category columns don't itemise. `Last verified` is the most recent `last_verified` marker anywhere in that tool's files._

</details>

## Status

First-contact notes are still landing where the kit was thin: an OpenTofu test quickstart pass, a first Helm build-and-deploy script, DefectDojo wired into a triage workflow, and Helm wired into a release workflow. The thinner corners are still the tools carrying notes only: tfsec, Nuclei, and Prometheus until their first configs and scripts land.

---
_Last updated: 2026-10-21_