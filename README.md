# DevSecOps-Kit

> A working engineer's DevSecOps reference: first-contact notes, runnable snippets, configs, and starter templates for security tooling, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit/commits/master) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevSecOps engineer's quick-reference: first-contact notes, runnable snippets, configs, and starter templates for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it. Cross-cutting folders hold concept primers, how-to guides, runbooks, cheatsheets, starter templates, environment promotion configs, and a lab sandbox that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Bring all findings together in DefectDojo](learn/03-shift-left/14-defectdojo-findings.md) — Aggregate scanner findings in DefectDojo
- [Sign the image and attach the SBOM with Cosign](learn/03-shift-left/12-cosign-sign.md) — Sign an image and attach its SBOM
- [Follow tainted data with CodeQL](learn/03-shift-left/06-codeql-dataflow.md) — Trace tainted data from source to sink
- [Keep dependencies patched with Dependabot](learn/03-shift-left/08-dependabot-updates.md) — Keep dependencies patched automatically
- [Produce and read an SBOM with Syft](learn/03-shift-left/10-syft-sbom.md) — Generate and inspect a software bill of materials

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
- **`<tool>/`** — Per-tool folders (notes, docs, scripts, configs, snippets, templates, manifests, dockerfiles, notebooks, policies)

## Coverage

<details><summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|-------|:-------------|
| trufflehog | 4 | 4 | 3 | 2 | 3 | 28 | 2 | 2 | 3 |  | 51 | 2026-10-13 |
| checkov | 4 | 6 | 4 | 3 | 4 | 16 | 3 |  | 4 | 1 | 45 | 2026-09-17 |
| syft | 5 | 8 | 5 | 1 | 3 | 13 | 4 | 1 | 4 |  | 44 | 2026-10-27 |
| trivy | 8 | 6 | 6 | 4 | 1 | 10 | 2 | 1 | 2 |  | 40 | 2026-10-19 |
| ansible | 3 | 1 | 5 | 3 | 1 | 21 |  |  |  |  | 34 | 2026-10-27 |
| codeql | 5 | 4 | 2 | 2 | 6 | 7 | 3 | 1 | 2 |  | 32 | 2026-10-27 |
| zap | 6 | 5 | 3 | 3 | 4 | 7 | 1 | 1 | 1 |  | 31 | 2026-10-14 |
| opa | 5 | 4 | 2 | 2 | 4 | 8 | 4 |  | 1 |  | 30 | 2026-10-27 |
| snyk | 6 | 4 | 2 | 3 | 1 | 10 | 1 | 1 | 1 |  | 29 | 2026-10-27 |
| terraform | 3 | 2 | 4 | 6 | 1 | 5 | 1 |  |  |  | 29 | 2026-10-30 |
| argocd | 6 | 3 | 1 | 2 |  | 11 | 5 |  |  |  | 28 | 2026-10-27 |
| gitguardian | 6 | 4 | 4 | 3 | 2 | 8 |  |  | 1 |  | 28 | 2026-10-27 |
| grype | 5 | 3 | 9 | 2 | 3 |  | 2 | 1 | 2 |  | 27 | 2026-10-14 |
| falco | 6 | 4 | 3 | 4 | 1 | 4 | 1 |  | 2 |  | 25 | 2026-10-27 |
| semgrep | 3 | 8 | 3 | 1 | 2 |  | 3 | 2 | 3 |  | 25 | 2026-10-18 |
| github-actions | 7 | 1 | 1 | 8 | 3 |  | 2 |  |  |  | 22 | 2026-10-20 |
| terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 |  | 1 |  | 22 | 2026-10-10 |
| vault | 4 | 3 | 4 | 3 | 2 |  | 2 | 1 | 2 |  | 21 | 2026-08-30 |
| cosign | 5 | 4 | 3 | 2 | 1 |  | 2 | 2 | 1 |  | 20 | 2026-10-30 |
| kubernetes | 4 | 2 | 2 | 3 |  | 5 | 4 |  |  |  | 20 | 2026-10-29 |
| defectdojo | 4 | 2 | 3 | 2 | 2 | 6 |  |  |  |  | 19 | 2026-10-23 |
| dependabot | 7 | 4 | 2 | 5 |  |  |  |  | 1 |  | 19 | 2026-10-14 |
| docker | 2 | 2 | 3 | 1 |  | 7 | 1 | 3 |  |  | 19 | 2026-09-23 |
| tetragon | 3 | 1 | 3 | 4 |  |  |  |  |  |  | 11 | 2026-09-26 |
| git | 3 | 1 | 4 | 1 | 1 |  |  |  |  |  | 10 | 2026-09-22 |
| grafana | 4 | 1 | 1 | 2 | 1 |  | 1 |  |  |  | 10 | 2026-10-26 |
| kustomize | 3 | 1 | 2 | 3 |  |  | 1 |  |  |  | 10 | 2026-10-24 |
| opentofu | 4 | 2 | 1 | 3 |  |  |  |  |  |  | 10 | 2026-10-28 |
| gitleaks | 3 | 1 | 3 | 2 |  |  |  |  |  |  | 9 | 2026-10-25 |
| helm | 4 | 1 | 1 | 1 |  |  | 2 |  |  |  | 9 | 2026-10-20 |
| linux | 3 | 1 | 2 | 1 |  |  |  |  |  |  | 7 | 2026-10-02 |
| prometheus | 5 |  | 1 |  | 1 |  |  |  |  |  | 7 | 2026-10-25 |
| sonarqube | 3 |  | 1 | 2 | 1 |  |  |  |  |  | 7 | 2026-09-21 |
| tfsec | 3 |  | 1 | 1 | 1 |  |  |  |  |  | 6 | 2026-10-19 |
| nuclei | 3 |  | 1 | 1 |  |  |  |  |  |  | 5 | 2026-10-15 |

Cells show file counts per subfolder; blank means none. `Last verified` is the most recent `last_verified` marker in that tool's docs. See `00_index/topics.md` for the per-tool file map.

</details>

## Status

Recently added shift-left lessons landed under `learn/` for DefectDojo, Cosign, CodeQL, Dependabot, and Syft. Thinner corners remain for tfsec, Nuclei, Prometheus, and SonarQube where first configs or scripts are still sparse.

---

_Last updated: 2026-11-10_
