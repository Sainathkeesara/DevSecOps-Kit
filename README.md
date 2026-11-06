# DevSecOps-Kit
> A working engineer's DevOps and DevSecOps reference for scanning, secrets, SBOMs, supply chain security, policy, infrastructure automation, and observability.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit/commits/master) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order - read that before this table.

## Who this is for

A working DevOps and DevSecOps engineer's quick-reference: first-contact notes, runnable snippets, configs, and starter templates for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

Scope runs from Linux and Git fundamentals up through infrastructure as code and Kubernetes delivery, then into the security tooling that rides on top of it. Cross-cutting folders hold concept primers, how-to guides, runbooks, cheatsheets, starter templates, environment promotion configs, and a lab sandbox that the per-tool folders lean on. Every entry is written to be adapted for real infrastructure work rather than read end to end.

## Quick links

- [Produce and read an SBOM with Syft (shift-left lesson)](learn/03-shift-left/10-syft-sbom.md)
- [Gate container images on Trivy findings in CI (shift-left lesson)](learn/03-shift-left/09-trivy-ci-gate.md)
- [Trivy CI gate config for severity-based blocking](trivy/configs/trivy-ci-gate.yml)
- [Find SQL injection patterns with Semgrep SAST (shift-left lesson)](learn/03-shift-left/05-semgrep-sast.md)
- [Search git history and verify secrets with TruffleHog (shift-left lesson)](learn/03-shift-left/04-trufflehog-history.md)

## Layout

- **00_index/** - Navigation: topic map, quick links, glossary, learning path
- **learn/** - Ordered lessons that follow the learning path (stage-by-stage, hands-on)
- **docs/** - Concepts, how-to guides, reference, runbooks, troubleshooting, setup notes
- **scripts/** - Shell toolkits, pipeline helpers, and reusable utilities
- **snippets/** - Copy-paste cheatsheets and one-liners
- **templates/** - Starter configs for Kubernetes, Terraform, and platform tooling
- **environments/** - Terraform environment configs (dev / staging / prod) and promotion workflow
- **lab/** - Mini-projects and learning sandboxes
- **assets/** - Architecture diagrams and workflow illustrations
- **<tool>/** - Per-tool folders (notes, docs, scripts, configs, snippets, templates, manifests, dockerfiles, notebooks, policies)

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Templates | Manifests | Dockerfiles | Notebooks | Policies | Total | Last verified |
|------|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|-----:|------:|---------------|
| docs | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 221 | 2026-10-18 |
| scripts | 4 | 0 | 0 | 1 | 2 | 0 | 0 | 0 | 0 | 0 | 196 | 2026-10-18 |
| trufflehog | 4 | 4 | 3 | 2 | 3 | 26 | 2 | 2 | 3 | 0 | 49 | 2026-10-13 |
| checkov | 4 | 6 | 4 | 3 | 4 | 16 | 3 | 0 | 4 | 1 | 45 | 2026-09-17 |
| templates | 2 | 1 | 1 | 3 | 1 | 3 | 0 | 0 | 0 | 0 | 45 | 2026-10-20 |
| syft | 5 | 8 | 5 | 1 | 3 | 13 | 4 | 1 | 4 | 0 | 44 | 2026-10-27 |
| trivy | 8 | 6 | 6 | 4 | 1 | 10 | 2 | 1 | 2 | 0 | 40 | 2026-11-04 |
| ansible | 3 | 1 | 5 | 3 | 1 | 21 | 0 | 0 | 0 | 0 | 34 | 2026-10-27 |
| codeql | 5 | 4 | 2 | 2 | 6 | 7 | 3 | 1 | 2 | 0 | 32 | 2026-10-27 |
| zap | 6 | 5 | 3 | 3 | 4 | 7 | 1 | 1 | 1 | 0 | 31 | 2026-10-19 |
| opa | 5 | 4 | 2 | 2 | 4 | 8 | 4 | 0 | 1 | 0 | 30 | 2026-10-27 |
| snyk | 6 | 4 | 2 | 3 | 1 | 10 | 1 | 1 | 1 | 0 | 29 | 2026-10-27 |
| terraform | 3 | 2 | 4 | 6 | 1 | 5 | 1 | 0 | 0 | 0 | 29 | 2026-10-30 |
| argocd | 6 | 3 | 1 | 2 | 0 | 11 | 5 | 0 | 0 | 0 | 28 | 2026-10-28 |
| gitguardian | 6 | 4 | 4 | 3 | 2 | 8 | 0 | 0 | 1 | 0 | 28 | 2026-10-27 |
| grype | 5 | 3 | 9 | 2 | 3 | 0 | 2 | 1 | 2 | 0 | 27 | 2026-10-14 |
| falco | 6 | 4 | 3 | 4 | 1 | 4 | 1 | 0 | 2 | 0 | 25 | 2026-10-27 |
| semgrep | 3 | 8 | 3 | 1 | 2 | 0 | 3 | 2 | 3 | 0 | 25 | 2026-10-18 |
| environments | 5 | 1 | 2 | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 23 | 2026-10-25 |
| snippets | 2 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 23 | 2026-10-19 |
| github-actions | 7 | 1 | 1 | 8 | 3 | 0 | 2 | 0 | 0 | 0 | 22 | 2026-11-03 |
| terrascan | 5 | 3 | 2 | 2 | 2 | 6 | 1 | 0 | 1 | 0 | 22 | 2026-10-10 |
| vault | 4 | 3 | 4 | 3 | 2 | 0 | 2 | 1 | 2 | 0 | 21 | 2026-09-29 |
| cosign | 5 | 4 | 3 | 2 | 1 | 0 | 2 | 2 | 1 | 0 | 20 | 2026-10-30 |
| kubernetes | 4 | 2 | 2 | 3 | 0 | 5 | 4 | 0 | 0 | 0 | 20 | 2026-10-29 |
| defectdojo | 4 | 2 | 3 | 2 | 2 | 6 | 0 | 0 | 0 | 0 | 19 | 2026-10-23 |
| dependabot | 7 | 4 | 2 | 5 | 0 | 0 | 0 | 0 | 1 | 0 | 19 | 2026-10-14 |
| docker | 2 | 2 | 3 | 1 | 0 | 7 | 1 | 3 | 0 | 0 | 19 | 2026-09-25 |
| lab | 3 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 17 | 2026-10-25 |
| assets | 5 | 1 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 14 | 2026-10-25 |
| learn | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 13 | 2026-11-06 |
| tetragon | 3 | 1 | 3 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 11 | 2026-09-26 |
| git | 3 | 1 | 4 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-09-22 |
| grafana | 4 | 1 | 1 | 2 | 1 | 0 | 1 | 0 | 0 | 0 | 10 | 2026-10-26 |
| kustomize | 3 | 1 | 2 | 3 | 0 | 0 | 1 | 0 | 0 | 0 | 10 | 2026-10-24 |
| opentofu | 4 | 2 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 10 | 2026-10-28 |
| gitleaks | 3 | 1 | 3 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 9 | 2026-10-25 |
| helm | 4 | 1 | 1 | 1 | 0 | 0 | 2 | 0 | 0 | 0 | 9 | 2026-10-23 |
| linux | 3 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-02 |
| prometheus | 5 | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-25 |
| sonarqube | 3 | 0 | 1 | 2 | 1 | 0 | 0 | 0 | 0 | 0 | 7 | 2026-10-23 |
| tfsec | 3 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 6 | 2026-10-19 |
| nuclei | 3 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 2026-10-15 |
| 00_index | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 |  |

Counts reflect files inside each category subfolder. Some folders also hold files at their root or in project-specific subfolders, so the total may exceed the sum of category columns. "Last verified" is the most recent last_verified marker found in that folder.

</details>

## Status

Shift-left lessons and a Trivy CI gate config landed recently under learn/ and trivy/. Thinner corners remain for tfsec, Nuclei, Prometheus, and SonarQube where first configs or scripts are still sparse. Argo CD carries an app-of-apps multi-environment scaffold, and environments/assets keep the promotion and tracking workflow moving.

---
_Last updated: 2026-11-07_
