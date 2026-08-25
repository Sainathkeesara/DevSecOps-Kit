# Quick Links

## I need to...

### Get started with vulnerability scanning
- [Trivy primer](../trivy/notes/0000-primer-trivy.md) — Universal vulnerability scanner for containers and Kubernetes
- [Trivy scanning performance optimization](../trivy/notes/scanning-performance-optimization.md) — Tuning scan time and resource use on large targets
- [Trivy ignore-rules pipeline](../trivy/scripts/ignore-rules-pipeline.sh) — Vulnerability scanning pipeline with custom ignore rules
- [Trivy SARIF code-scanning output](../trivy/docs/ci-pipeline-sarif-output.md) — Feed Trivy results into GitHub Code Scanning
- [Multi-arch vulnerability scanning with Trivy](../trivy/docs/multi-arch-vulnerability-scanning.md) — Scanning multi-architecture images and manifests
- [Container vulnerability scan with Trivy](../trivy/scripts/container-vuln-scan.sh) — Scan Docker images for vulnerabilities
- [Minimal Grype scan](../grype/scripts/minimal-grype-scan.sh) — Quick Grype scan with minimal setup
- [CI-ready Grype scanning](../grype/scripts/ci-ready-grype-scan.sh) — Grype wrapper for CI pipelines
- [SBOM generation with Syft](../syft/scripts/gen-multi-format-sboms.sh) — Generate SBOMs in multiple formats
- [Syft output format comparison](../syft/notebooks/output-format-comparison.ipynb) — SPDX vs CycloneDX vs GitHub vs native JSON, side by side

### Scan for secrets
- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md) — Secret scanning with regex patterns and entropy analysis
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md) — Secrets detection with ggshield CLI
- [GitGuardian incident response workflow](../gitguardian/docs/gitguardian-incident-response-workflow.md) — Walk through a secrets incident from detection to remediation
- [GitGuardian API integration](../gitguardian/scripts/gitguardian-api-integration.py) — Scripted secret scanning via the GitGuardian API
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh) — Quick TruffleHog repo scan
- [Secrets detection workflow analysis](../docs/concepts/secrets-access-management/notebooks/secrets-detection-remediation-workflow-analysis.ipynb) — Notebook exploring detect, alert, and remediate stages for leaked secrets
- [Configure Dependabot for private registries](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md) — Pointing Dependabot at registries GitHub can't reach by default
- [Dependabot alerts and security updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md) — Enable automatic dependency fix PRs

### Run static analysis
- [Semgrep primer](../semgrep/notes/0000-primer-semgrep.md) — Static analysis with custom rules across multiple languages
- [Checkov primer](../checkov/notes/0000-primer-checkov.md) — IaC security scanner for Terraform, Kubernetes, CloudFormation
- [CodeQL primer](../codeql/notes/0000-primer-codeql.md) — Semantic code analysis with custom QL queries
- [Custom Semgrep rule example](../semgrep/snippets/first-custom-rule.yaml) — Write your first Semgrep rule
- [Semgrep rule performance optimization](../semgrep/docs/semgrep-rule-performance-optimization.md) — Combining patterns for efficient scanning in large codebases

### Set up CI/CD pipelines
- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md) — Get started with GitHub Actions
- [Explore GitHub Actions](../github-actions/notes/2026-08-04-explore-github-actions.md) — Latest GitHub Actions workflows and patterns
- [CI/CD security scanner wrapper](../docs/concepts/linux-shell-fundamentals/scripts/ci-cd-pipeline-security-scanner-wrapper.sh) — Single entry point that chains multiple scanner stages
- [ZAP baseline scan for CI](../zap/notes/2026-07-20-install-zap-baseline-scan.md) — Non-intrusive DAST in CI
- [Trivy CI/CD pipeline recipes](../trivy/docs/ci-cd-pipeline-recipes.md) — Multi-pattern Trivy scanning recipes

### Build and sign container images
- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile) — Minimal Dockerfile to get started
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh) — Cosign quickstart for image signing
- [Cosign key management workflow](../cosign/scripts/cosign-key-management-workflow.sh) — Rotate signing keys without breaking existing attestations
- [Multi-stage SBOM Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile) — SBOM generation in CI images
- [Multi-stage Grype scan Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile) — Scanning images during the build
- [Build a multi-service Docker Compose app](../docker/scripts/build-multi-service-compose-app.sh) — Docker Compose app from scratch
- [Syft + Trivy Kubernetes scan scaffold](../syft/templates/syft-trivy-k8s-scan-scaffold/README.md) — SBOM and vulnerability gating for workload images

### Manage infrastructure as code
- [Terraform primer](../terraform/notes/0000-primer-terraform.md) — Declarative infrastructure provisioning
- [Composing Terraform modules](../terraform/docs/terraform-module-composition.md) — Reusable module structure, cross-environment composition, and workspace patterns
- [Terraform workspace variable precedence](../terraform/configs/workspace-variable-precedence.hcl) — Which values win when workspaces, tfvars, and CLI overlap
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md) — Open-source Terraform fork with same HCL syntax
- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md) — K8s objects and kubectl basics
- [Helm primer](../helm/notes/0000-primer-helm.md) — Package manager for Kubernetes charts
- [Kustomize primer](../kustomize/notes/0000-primer-kustomize.md) — Kubernetes YAML customization without templating
- [ArgoCD primer](../argocd/notes/0000-primer-argocd.md) — Declarative GitOps continuous delivery
- [ArgoCD private repo credentials and RBAC](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml) — Point ArgoCD at a private Git repository with scoped access
- [ArgoCD quickstart trip-ups](../argocd/notes/2026-08-12-quickstart-tripups.md) — Common first-run pitfalls and fixes
- [Provision a Kubernetes cluster with Terraform + Ansible](../docs/how-to/k8s-terraform-ansible-provisioning.md) — Full Terraform/Ansible provisioning project for a multi-node cluster

### Manage secrets and access
- [HashiCorp Vault primer](../vault/notes/0000-primer-vault.md) — Secrets management and dynamic secrets
- [Vault KV CRUD operations](../vault/scripts/vault-kv-crud.sh) — Key-value secret read/write operations
- [Vault multi-environment access control](../vault/configs/multi-environment-access-control.hcl) — HCL policies for env-based access
- [Vault dynamic secrets for cloud IAM](../vault/scripts/cloud-iam-dynamic-secrets.sh) — Vault dynamic secrets workflow for cloud IAM credentials

### Manage policies and compliance
- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md) — Policy engine for Kubernetes admission control
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh) — Write a basic Rego policy
- [Terrascan primer](../terrascan/notes/0000-primer-terrascan.md) — IaC static analysis with custom Rego rules

### Run infrastructure tasks
- [Ansible quickstart trip-ups](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md) — Common first-run pitfalls when following an Ansible quickstart
- [Minimal Ansible playbook: package and service](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml) — Install a package and start a service
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh) — Switch between K8s contexts
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh) — Restart Kubernetes deployments
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh) — Inspect running pod logs and exec

### Audit and remediate CVEs
- [Ansible CVE-2026-33228 path verification](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md) — Confirm the audit and remediation paths for the Ansible flatted CVE
- [Trivy CVE severity filtering](../scripts/bash/ci_cd_toolkit/trivy-severity-filter.sh) — Focus scans on the severities that matter
- [TruffleHog PR secret scan reusable workflow](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml) — Gate pull requests on secret scans

### Secure version control
- [Git primer](../git/notes/0000-primer-git.md) — Git concepts, commits, branches
- [Git first repo stage and log](../git/scripts/2026-08-24-first-repo-stage-log.sh) — Script for staging and logging changes in a first Git repo
- [Git hooks for security checks](../docs/concepts/version-control-with-git/scripts/git-hooks-devsecops-security-checks.sh) — Pre-commit hooks that run scans and secret checks in the dev loop

### Diagnose failures
- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md) — Debugging crashing pods
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md) — Common Terraform issue resolution
- [Vault seal/unseal troubleshooting](../docs/troubleshooting/vault-seal-unseal.md) — Recover access to sealed Vault

### Practice and learn
- [Version control with Git fundamentals](../docs/concepts/git-001-version-control-fundamentals.md) — Git concepts, commits, branches
- [CI/CD pipeline concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md) — Stages, gates, triggers
- [Application Security Testing concepts](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — SAST, DAST, SCA overview
- [Infrastructure as Code fundamentals](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md) — What IaC is and why it matters
- [Applying secrets & access management](../docs/concepts/secrets-access-management/snippets/2026-08-25-applying-secrets-access-management.py) — Practice keeping secrets out of source and the pipeline
- [Applying version control in DevSecOps](../docs/concepts/version-control-with-git/snippets/2026-08-25-applying-version-control-in-devsecops.py) — Practice how VCS metadata feeds a security gate

### Learn Linux shell scripting
- [Linux VM terminal first commands](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md) — First commands and common trip-ups after installing Linux in a VM
- [Linux shell scripting tutorial confusions](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md) — Common pitfalls and clarifications for shell scripting
- [Cron job configuration](../linux/configs/2026-08-06-cron-job-configuration.ini) — Sample cron job for scheduled automation

### Explore Tetragon observability
- [Tetragon observability tutorial](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md) — eBPF-based runtime observability with Tetragon
- [Minimal network tracing policy](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml) — Tetragon eBPF tracing policy for network events
- [Tetragon event collection pipeline](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh) — Pipeline for collecting and forwarding Tetragon events
