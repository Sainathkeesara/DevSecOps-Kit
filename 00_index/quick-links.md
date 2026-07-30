# Quick Links

## I need to...

### Get started with security scanning
- [Trivy primer](../trivy/notes/0000-primer-trivy.md) — Universal vulnerability scanner for containers and Kubernetes
- [Grype primer](../grype/notes/0000-primer-grype.md) — Vulnerability scanner for container images and filesystems
- [Syft primer](../syft/notes/0000-primer-syft.md) — SBOM generation for containers and filesystems
- [Minimal Grype scan](../grype/scripts/minimal-grype-scan.sh) — Quick Grype scan with minimal setup
- [Container vulnerability scan with Trivy](../trivy/scripts/container-vuln-scan.sh) — Scan Docker images for vulnerabilities
- [CI-ready Grype scanning](../grype/scripts/ci-ready-grype-scan.sh) — Grype wrapper for CI pipelines
- [SBOM generation with Syft](../syft/scripts/gen-multi-format-sboms.sh) — Generate SBOMs in multiple formats

### Scan for secrets
- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md) — Secret scanning with regex patterns and entropy analysis
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md) — Secrets detection with ggshield CLI
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh) — Quick TruffleHog repo scan
- [Minimal ggshield pre-commit hook](../gitguardian/scripts/pre-commit-hook-ggshield.sh) — Set up pre-commit secret scanning
- [Custom policy engine for ggshield](../gitguardian/snippets/custom-policy-engine-ggshield.sh) — Extend gitguardian detection rules

### Run static analysis
- [Semgrep primer](../semgrep/notes/0000-primer-semgrep.md) — Static analysis with custom rules across multiple languages
- [Scan Python codebase with Semgrep](../semgrep/scripts/scan-python-codebase.sh) — Python-specific Semgrep scan
- [Checkov primer](../checkov/notes/0000-primer-checkov.md) — IaC security scanner for Terraform, Kubernetes, CloudFormation
- [Scan Terraform plan with Checkov](../checkov/scripts/scan-terraform-plan.sh) — Plan-level IaC security scanning
- [CodeQL primer](../codeql/notes/0000-primer-codeql.md) — Semantic code analysis with custom QL queries
- [Custom Semgrep rule example](../semgrep/snippets/first-custom-rule.yaml) — Write your first Semgrep rule

### Set up CI/CD pipelines
- [Trivy CI pipeline with SARIF output](../trivy/docs/ci-pipeline-sarif-output.md) — SARIF integration for GitHub Code Scanning
- [Trivy CI/CD pipeline recipes](../trivy/docs/ci-cd-pipeline-recipes.md) — Multi-pattern Trivy scanning recipes
- [ZAP baseline scan for CI](../zap/notes/2026-07-20-install-zap-baseline-scan.md) — Non-intrusive DAST in CI
- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md) — Get started with GitHub Actions
- [First GitHub Actions workflow config](../github-actions/configs/2026-07-14-first-github-actions-workflow.yaml) — Minimal CI trigger
- [Checkov multi-iac scan project template](../checkov/templates/multi-iac-scan-project/) — Reusable Checkov CI scaffolding

### Build and sign container images
- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile) — Minimal Dockerfile to get started
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh) — Cosign quickstart for image signing
- [Verify a signed image](../cosign/scripts/verify-signed-image.sh) — Cosign verification workflow
- [Cosign keyless signing config](../cosign/configs/keyless-signing-github-actions.yaml) — OIDC-based keyless signing
- [Multi-stage SBOM Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile) — SBOM generation in CI images

### Manage infrastructure as code
- [Terraform primer](../terraform/notes/0000-primer-terraform.md) — Declarative infrastructure provisioning
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md) — Open-source Terraform fork with same HCL syntax
- [Terraform variables, outputs practice](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl) — Hands-on HCL exercises
- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md) — K8s objects and kubectl basics
- [Helm primer](../helm/notes/0000-primer-helm.md) — Package manager for Kubernetes charts
- [Kustomize primer](../kustomize/notes/0000-primer-kustomize.md) — Kubernetes YAML customization without templating
- [ArgoCD primer](../argocd/notes/0000-primer-argocd.md) — Declarative GitOps continuous delivery

### Manage secrets and access
- [HashiCorp Vault primer](../vault/notes/0000-primer-vault.md) — Secrets management and dynamic secrets
- [Vault KV CRUD operations](../vault/scripts/vault-kv-crud.sh) — Key-value secret read/write operations
- [Vault multi-environment access control](../vault/configs/multi-environment-access-control.hcl) — HCL policies for env-based access
- [Secrets access management concepts](../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md) — Controlling access and handling credentials securely
- [Dependabot alerts and security updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md) — Enable automatic dependency fix PRs

### Manage policies and compliance
- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md) — Policy engine for Kubernetes admission control
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh) — Write a basic Rego policy
- [Enforce image registry constraints](../opa/snippets/enforce-image-registry-constraints.rego) — Rego rule to restrict container registries
- [Terrascan primer](../terrascan/notes/0000-primer-terrascan.md) — IaC static analysis with custom Rego rules
- [Multi-rule Semgrep pack](../semgrep/configs/multi-rule-pack.yaml) — Compose multiple Semgrep rules with logical operators

### Run infrastructure tasks
- [k8s_toolkit usage guide](../docs/how-to/k8s_toolkit.md) — Kubernetes admin scripts for context, pods, nodes
- [Linux toolkit usage guide](../docs/how-to/linux_toolkit.md) — System admin scripts for security, networking, DNS
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh) — Switch between K8s contexts
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh) — Restart Kubernetes deployments
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh) — Inspect running pod logs and exec

### Diagnose failures
- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md) — Debug crashing pods
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md) — Common Terraform issue resolution
- [Vault seal/unseal troubleshooting](../docs/troubleshooting/vault-seal-unseal.md) — Recover access to sealed Vault
- [Jenkins failures](../docs/troubleshooting/jenkins-troubleshooting.md) — CI pipeline debugging

### Practice and learn
- [Linux fundamentals first steps](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md) — First terminal commands and directory layout
- [Version control with Git primer](../git/notes/0000-primer-git.md) — Git concepts, commits, branches
- [CI/CD pipeline concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md) — Stages, gates, triggers
- [Application Security Testing concepts](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — SAST, DAST, SCA overview
- [Infrastructure as Code fundamentals](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md) — What IaC is and why it matters
- [Software Supply Chain Security concepts](../docs/concepts/software-supply-chain-security/0000-primer-software-supply-chain-security.md) — SBOMs, signing, dependency verification