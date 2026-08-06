# Quick Links

## I need to...

### Get started with vulnerability scanning
- [Trivy primer](../trivy/notes/0000-primer-trivy.md) — Universal vulnerability scanner for containers and Kubernetes
- [Minimal Grype scan](../grype/scripts/minimal-grype-scan.sh) — Quick Grype scan with minimal setup
- [SBOM generation with Syft](../syft/scripts/gen-multi-format-sboms.sh) — Generate SBOMs in multiple formats
- [CI-ready Grype scanning](../grype/scripts/ci-ready-grype-scan.sh) — Grype wrapper for CI pipelines
- [Container vulnerability scan with Trivy](../trivy/scripts/container-vuln-scan.sh) — Scan Docker images for vulnerabilities

### Scan for secrets
- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md) — Secret scanning with regex patterns and entropy analysis
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md) — Secrets detection with ggshield CLI
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh) — Quick TruffleHog repo scan

### Run static analysis
- [Semgrep primer](../semgrep/notes/0000-primer-semgrep.md) — Static analysis with custom rules across multiple languages
- [Checkov primer](../checkov/notes/0000-primer-checkov.md) — IaC security scanner for Terraform, Kubernetes, CloudFormation
- [CodeQL primer](../codeql/notes/0000-primer-codeql.md) — Semantic code analysis with custom QL queries
- [Custom Semgrep rule example](../semgrep/snippets/first-custom-rule.yaml) — Write your first Semgrep rule

### Set up CI/CD pipelines
- [Trivy CI pipeline with SARIF output](../trivy/docs/ci-pipeline-sarif-output.md) — SARIF integration for GitHub Code Scanning
- [Trivy CI/CD pipeline recipes](../trivy/docs/ci-cd-pipeline-recipes.md) — Multi-pattern Trivy scanning recipes
- [ZAP baseline scan for CI](../zap/notes/2026-07-20-install-zap-baseline-scan.md) — Non-intrusive DAST in CI
- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md) — Get started with GitHub Actions

### Build and sign container images
- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile) — Minimal Dockerfile to get started
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh) — Cosign quickstart for image signing
- [Multi-stage SBOM Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile) — SBOM generation in CI images
- [Build a multi-service Docker Compose app](../docker/scripts/build-multi-service-compose-app.sh) — Docker Compose app from scratch

### Manage infrastructure as code
- [Terraform primer](../terraform/notes/0000-primer-terraform.md) — Declarative infrastructure provisioning
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md) — Open-source Terraform fork with same HCL syntax
- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md) — K8s objects and kubectl basics
- [Helm primer](../helm/notes/0000-primer-helm.md) — Package manager for Kubernetes charts
- [Kustomize primer](../kustomize/notes/0000-primer-kustomize.md) — Kubernetes YAML customization without templating
- [ArgoCD primer](../argocd/notes/0000-primer-argocd.md) — Declarative GitOps continuous delivery

### Manage secrets and access
- [HashiCorp Vault primer](../vault/notes/0000-primer-vault.md) — Secrets management and dynamic secrets
- [Vault KV CRUD operations](../vault/scripts/vault-kv-crud.sh) — Key-value secret read/write operations
- [Vault multi-environment access control](../vault/configs/multi-environment-access-control.hcl) — HCL policies for env-based access
- [Dependabot alerts and security updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md) — Enable automatic dependency fix PRs

### Manage policies and compliance
- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md) — Policy engine for Kubernetes admission control
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh) — Write a basic Rego policy
- [Terrascan primer](../terrascan/notes/0000-primer-terrascan.md) — IaC static analysis with custom Rego rules

### Run infrastructure tasks
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh) — Switch between K8s contexts
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh) — Restart Kubernetes deployments
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh) — Inspect running pod logs and exec

### Diagnose failures
- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md) — Debugging crashing pods
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md) — Common Terraform issue resolution
- [Vault seal/unseal troubleshooting](../docs/troubleshooting/vault-seal-unseal.md) — Recover access to sealed Vault

### Practice and learn
- [Linux fundamentals first steps](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md) — First terminal commands and directory layout
- [Version control with Git primer](../git/notes/0000-primer-git.md) — Git concepts, commits, branches
- [CI/CD pipeline concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md) — Stages, gates, triggers
- [Application Security Testing concepts](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — SAST, DAST, SCA overview
- [Infrastructure as Code fundamentals](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md) — What IaC is and why it matters

### Learn Linux shell scripting
- [Linux shell scripting tutorial confusions](../lin/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md) — Common pitfalls and clarifications for shell scripting
- [Cron job configuration](../lin/configs/2026-08-06-cron-job-configuration.ini) — Sample cron job for scheduled automation

### Explore Tetragon observability
- [Tetragon observability tutorial](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md) — eBPF-based runtime observability with Tetragon
- [Minimal network tracing policy](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml) — Tetragon eBPF tracing policy for network events
- [Tetragon event collection pipeline](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh) — Pipeline for collecting and forwarding Tetragon events