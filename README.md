# DevSecOps-Kit

> A working engineer's devops and devsecops reference — notes, snippets, configs, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before the table below.

---

## Who this is for

A working DevSecOps engineer's quick-reference for Trivy, Semgrep, Checkov, Grype, TruffleHog, Syft, Cosign, OPA, Falco, and HashiCorp Vault. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and secrets management. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

The kit spans tools including Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan, TruffleHog, GitGuardian, Syft, Cosign, Dependabot, Falco, Tetragon, OPA, Vault, ZAP, DefectDojo, SonarQube, Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu, Git, Prometheus, Grafana, and observability — with CVE-specific remediation guidance, Linux system administration, and CI/CD pipeline toolkits.

---

## Quick links

- [SonarQube first SonarScanner run](sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh) — Run your first project analysis with the SonarScanner CLI
- [ZAP Docker quickstart JSON export](zap/snippets/2026-07-16-zap-docker-quickstart-json-export.sh) — Spin up ZAP in Docker and export a baseline scan as JSON
- [Ansible bootstrap](scripts/ansible/bootstrap.sh) — Provision a host with the Ansible toolkit baseline
- [Pipeline deploy](scripts/pipeline/deploy.sh) — Deploy step used by the kit's pipeline scripts
- [Bump version](scripts/bump-version.sh) — Version-bump helper used across the kit

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`argocd/`** — ArgoCD GitOps delivery notes, manifests, and first-app deployments
- **`checkov/` / `semgrep/` / `trivy/` / `trufflehog/` / `syft/`** — Security scanner notes, scripts, configs
- **`grype/` / `codeql/` / `zap/` / `snyk/` / `gitguardian/` / `falco/` / `cosign/` / `tetragon/`** — Vulnerability scanner and runtime security tool content
- **`terrascan/` / `opa/`** — IaC compliance and policy engine primers
- **`defectdojo/`** — Vulnerability management platform notes
- **`dependabot/`** — Dependency update configs and alerts
- **`vault/`** — HashiCorp Vault primers, configs, and scripts
- **`git/`** — Git primers, branching, and version control
- **`docker/`** — Docker image authoring, CLI, and container security
- **`github-actions/`** — GitHub Actions CI/CD workflows and runners
- **`helm/` / `kubernetes/` / `kustomize/`** — Kubernetes ecosystem notes
- **`sonarqube/` / `opentofu/`** — Static analysis and IaC tool primers
- **`grafana/` / `observability/` / `prometheus/`** — Metrics, logs, traces, dashboards
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`lab/`** — Mini-projects and sandboxes
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform primers, configs, scripts, and EventBridge Lambda modules
- **`.github/`** — GitHub templates (PR template, CODEOWNERS)
- **`CHANGELOG.md`** — Release history and version tracking
- **`CONTRIBUTING.md`** — Contribution guidelines and workflow

---

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | Policies |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|---------:|
| Trivy | 3 | 5 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — |
| TruffleHog | 3 | 3 | 2 | 2 | 2 | 1 | 21 | 2 | 1 | — |
| ZAP | 4 | 2 | 2 | 4 | 3 | — | 16 | — | 1 | — |
| Syft | 4 | 3 | 1 | 1 | 5 | — | 7 | 1 | 1 | — |
| Checkov | 4 | 2 | 2 | 4 | 3 | 2 | 10 | 1 | — | 1 |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — |
| Grype | 4 | 6 | 1 | 2 | 1 | 2 | — | 1 | 1 | — |
| Falco | 3 | 3 | 3 | 1 | 2 | — | — | — | — | — |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | — | — |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | — | — |
| CodeQL | 3 | 1 | 1 | 3 | 1 | 1 | — | — | — | — |
| Terrascan | 5 | 1 | 1 | 2 | — | — | — | — | — | — |
| Cosign | 4 | 2 | 1 | 1 | — | 1 | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — |
| Dependabot | 5 | — | 2 | — | — | — | — | — | — | — |
| DefectDojo | 1 | — | — | 1 | — | — | — | — | — | — |
| Git | 3 | 2 | — | 1 | — | — | — | — | — | — |
| ArgoCD | 2 | — | — | — | — | 1 | — | — | — | — |
| Kustomize | 2 | — | 1 | — | — | — | — | — | — | — |
| Docker | 2 | — | — | — | — | — | — | — | 2 | — |
| Helm | 1 | — | — | — | — | 1 | — | — | — | — |
| Kubernetes | 2 | — | — | — | — | 1 | — | — | — | — | — |
| GitHub Actions | 2 | — | 1 | — | — | — | — | — | — | — |
| SonarQube | 1 | — | — | 1 | — | — | — | — | — | — |
| OpenTofu | 1 | — | — | — | — | — | — | — | — | — |
| Grafana | 1 | — | — | — | — | — | — | — | — | — |
| Observability | 1 | — | — | — | — | — | — | — | — | — |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — |
| Terraform | 2 | 1 | 1 | — | — | — | — | — | — | — |

</details>

---

## Status

Currently fleshing out the Kubernetes ecosystem (first pod/service manifest, first Helm chart values) and rounding out the scanner set — most recently a SonarQube first-scan run and a ZAP Docker quickstart. Foundational concept docs and per-tool primers are in good shape; next focus is deeper how-to coverage and cross-tool CI/CD recipes.

---

_Last updated: 2026-07-17_
