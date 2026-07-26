# DevSecOps-Kit
> A working engineer's devops and devsecops reference for Trivy, Semgrep, Checkov, Grype, TruffleHog, Syft, Cosign, OPA, Falco, Vault, and Terraform. Notes, snippets, configs, and templates for vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and infrastructure automation.

[![Last commit](https://img.shields.io/github/last-commit/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Repo size](https://img.shields.io/github/repo-size/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Top language](https://img.shields.io/github/languages/top/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit) [![Languages](https://img.shields.io/github/languages/count/Sainathkeesara/DevSecOps-Kit)](https://github.com/Sainathkeesara/DevSecOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before the table below.

---

## Who this is for

A working devops/devsecops engineer's quick-reference: first-contact notes, runnable snippets, and configs for Trivy, Semgrep, Checkov, Grype, TruffleHog, Syft, Cosign, OPA, Falco, Vault, Terraform, and the broader Kubernetes, Docker, and CI/CD ecosystem. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

A curated collection of notes, scripts, snippets, and templates covering vulnerability scanning, secret detection, supply chain security, runtime security, policy engines, and secrets management. Every entry is scenario-grounded and designed to be adapted for real infrastructure work.

The kit spans tools including Trivy, Semgrep, Checkov, Grype, CodeQL, Snyk, Terrascan, TruffleHog, GitGuardian, Syft, Cosign, Dependabot, Falco, Tetragon, OPA, Vault, ZAP, DefectDojo, SonarQube, Docker, Kubernetes, Helm, Kustomize, ArgoCD, GitHub Actions, Terraform, OpenTofu, Git, Prometheus, Grafana, and observability — with CVE-specific remediation guidance, Linux system administration, and CI/CD pipeline toolkits.

---

## Quick links

- [Practice exercises: secrets access management](docs/concepts/secrets-access-management/snippets/2026-07-24-practice-exercises.py) — Python exercises for secrets management concepts
- [Practice exercises: version control with git](docs/concepts/version-control-with-git/scripts/2026-07-24-practice-exercises.sh) — Shell exercises for git workflows
- [Practice exercises: infrastructure as code](docs/concepts/infrastructure-as-code/snippets/2026-07-23-practice-exercises.hcl) — HCL exercises for Terraform variables and data sources
- [Practice exercises: Linux shell fundamentals](docs/concepts/linux-shell-fundamentals/scripts/2026-07-23-practice-exercises.sh) — Shell scripting exercises for Linux fundamentals
- [Practice exercises: software supply chain security](docs/concepts/software-supply-chain-security/snippets/2026-07-23-practice-exercises.sh) — Shell exercises for supply chain security concepts

---

## Layout

- **`00_index/`** — Navigation: topic index, quick links, glossary, learning path
- **`assets/`** — Architecture diagrams and workflow illustrations
- **`argocd/`** — ArgoCD GitOps delivery notes, manifests, and first-app deployments
- **`checkov/`** — IaC security scanner notes, scripts, configs, and custom policies
- **`codeql/`** — GitHub CodeQL semantic analysis notes, queries, and CI integration
- **`cosign/`** — Container image signing and verification notes and configs
- **`defectdojo/`** — Vulnerability management platform primers and setup
- **`dependabot/`** — Dependency update configs and alert guides
- **`docker/`** — Docker image authoring, CLI, and container security
- **`docs/`** — How-to guides, concepts, reference, runbooks, security docs, troubleshooting, setup guides
- **`environments/`** — Terraform environment configs (dev / staging / prod)
- **`falco/`** — Runtime security monitoring notes, rules, and configs
- **`git/`** — Git primers, branching, and version control
- **`gitguardian/`** — Secrets detection platform notes and ggshield configs
- **`github-actions/`** — GitHub Actions CI/CD workflows and runners
- **`grafana/`, `observability/`, `prometheus/`** — Metrics, logs, traces, dashboards
- **`grype/`** — Vulnerability scanner notes, scripts, configs, and SBOM integration
- **`helm/`, `kubernetes/`, `kustomize/`** — Kubernetes ecosystem notes and manifests
- **`linux/`** — Linux fundamentals, CLI, system administration, and security hardening
- **`opa/`** — Policy engine (OPA/Gatekeeper) notes, configs, and Rego snippets
- **`opentofu/`** — OpenTofu IaC tooling notes and configs
- **`proometheus/`** — Prometheus monitoring primer and configuration
- **`scripts/`** — Shell scripts organised by tool (bash toolkit directories)
- **`semgrep/`** — Static analysis tool notes, rules, configs, and CI integration
- **`snippets/`** — Copy-paste ready one-liners and cheatsheets across all domains
- **`snyk/`** — Developer security platform notes, configs, and CI pipelines
- **`sonarqube/`** — Static analysis platform notes and quality gate guides
- **`syft/`** — SBOM generation tool notes, configs, and pipeline scaffolds
- **`templates/`** — Starter configs for Kubernetes, Terraform, Linux, Jenkins, Logstash, syslog-ng
- **`terraform/`** — Terraform and OpenTofu primers, configs, scripts, and modules
- **`terrascan/`** — IaC compliance scanner notes, configs, and custom rules
- **`tetragon/`** — eBPF-based runtime security observability notes and configs
- **`trivy/`** — Vulnerability scanner notes, scripts, configs, and CI integration
- **`trufflehog/`** — Secret scanning tool notes, scripts, and pipeline templates
- **`vault/`** — HashiCorp Vault primers, configs, and dynamic secrets scripts
- **`zap/`** — DAST web application security testing notes, configs, and scan templates
- **`.github/`** — GitHub templates (PR template, CODEOWNERS)
- **`CHANGELOG.md`** — Release history and version tracking
- **`CONTRIBUTING.md`** — Contribution guidelines and workflow

---

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Docs | Manifests | Templates | Notebooks | Dockerfiles | Policies | Last verified |
|------|------:|--------:|--------:|---------:|-----:|----------:|----------:|----------:|------------:|---------:|---------------|
| Trivy | 3 | 5 | 2 | 1 | 3 | 2 | 6 | 2 | 1 | — | — |
| TruffleHog | 3 | 3 | 2 | 2 | 2 | 1 | 21 | 2 | 1 | — | — |
| ZAP | 5 | 2 | 2 | 4 | 3 | — | 16 | — | 1 | — | 2026-07-05 |
| Checkov | 4 | 2 | 2 | 4 | 5 | 2 | 10 | 2 | — | 1 | 2026-07-20 |
| Syft | 4 | 3 | 1 | 1 | 5 | — | 7 | 1 | 1 | — | 2026-07-06 |
| Grype | 4 | 8 | 1 | 2 | 1 | 2 | — | 1 | 1 | — | — |
| Semgrep | 3 | 3 | 1 | 2 | 4 | 2 | — | 1 | 2 | — | — |
| Terraform | 2 | 3 | 1 | 1 | — | — | — | — | — | — | — |
| Falco | 4 | 3 | 3 | 1 | 2 | — | — | — | — | — | 2026-07-06 |
| CodeQL | 3 | 1 | 1 | 4 | 1 | 1 | — | — | 1 | — | — |
| GitGuardian | 4 | 2 | 2 | 2 | 1 | — | — | — | — | — | — |
| Vault | 3 | 2 | 2 | 1 | 2 | — | — | — | 1 | — | — |
| Snyk | 4 | 1 | 2 | 1 | 1 | — | — | — | 1 | — | — |
| OPA | 3 | 1 | 1 | 3 | 1 | — | — | — | — | — | — |
| Cosign | 4 | 2 | 1 | 1 | — | 1 | — | — | — | — | — |
| Terrascan | 5 | 1 | 1 | 2 | — | — | — | — | — | — | — |
| Dependabot | 6 | — | 3 | — | — | — | — | — | — | — | — |
| Git | 3 | 2 | — | 1 | — | — | — | — | — | — | — |
| Docker | 2 | 1 | — | — | — | — | — | — | 2 | — | — |
| ArgoCD | 2 | — | — | — | — | 1 | — | — | — | — | — |
| Helm | 2 | — | — | — | — | 1 | — | — | — | — | — |
| Kubernetes | 2 | — | — | — | — | 1 | — | — | — | — | — |
| Kustomize | 2 | — | 1 | — | — | — | — | — | — | — | — |
| GitHub Actions | 2 | — | 1 | — | — | — | — | — | — | — | — |
| SonarQube | 2 | — | — | 1 | — | — | — | — | — | — | — |
| Tetragon | 2 | — | 1 | — | — | — | — | — | — | — | — |
| OpenTofu | 2 | — | 1 | — | — | — | — | — | — | — | — |
| DefectDojo | 1 | — | — | 1 | — | — | — | — | — | — | — |
| Grafana | 1 | — | — | — | — | — | — | — | — | — | — |
| Observability | 1 | — | — | — | — | — | — | — | — | — | — |
| Prometheus | 1 | — | — | — | — | — | — | — | — | — | — |
| Linux | 1 | — | — | — | — | — | — | — | — | — | — |

</details>

---

## Status

Currently expanding tool coverage with custom Dockerfiles for CodeQL, Snyk, and Vault; Linux fundamentals primer; and Dependabot alert configuration guides.

---

_Last updated: 2026-07-25_