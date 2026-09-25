# Quick Links

## I need to...

### Audit and remediate CVEs
- [Ansible CVE-2026-33228 path verification](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md)
- [Trivy CVE severity filtering](../scripts/bash/ci_cd_toolkit/trivy-severity-filter.sh)
- [TruffleHog PR secret scan reusable workflow](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- [Falco K8s admission control rule](../falco/manifests/falco-k8s-admission-control.yaml)
- [DefectDojo vulnerability scanner setup](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml) — DefectDojo scanner integration scaffold with finding ingestion

### Build and sign container images
- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- [Cosign verification patterns](../cosign/docs/cosign-verification-patterns.md)
- [Container signing pipeline integration](../cosign/docs/container-signing-pipeline.md) — Where signing and verification stages belong in an image pipeline, keyless vs key-based signing, and the verify gate that rejects unsigned images
- [Cosign key management workflow](../cosign/scripts/cosign-key-management-workflow.sh)
- [Custom Cosign image](../cosign/dockerfiles/custom-cosign-image.Dockerfile)
- [Multi-stage SBOM Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- [Multi-stage Grype scan Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- [Build a multi-service Docker Compose app](../docker/scripts/build-multi-service-compose-app.sh)
- [Multi-service Compose scaffold](../docker/templates/multi-service-setup/README.md) — Web plus API plus Postgres with health-gated startup and named volumes
- [Multi-service Compose file](../docker/templates/multi-service-setup/compose.yaml) — Three services on one Compose network with a health-conditioned database dependency
- [Syft + Trivy Kubernetes scan scaffold](../syft/templates/syft-trivy-k8s-scan-scaffold/README.md)

### Diagnose failures
- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md)
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md)
- [Vault seal/unseal troubleshooting](../docs/troubleshooting/vault-seal-unseal.md)

### Explore Syft SBOM capabilities
- [Syft CLI scan vs library mode](../syft/notebooks/source-vs-library-multiarch.ipynb) — When to use CLI scan mode vs library mode for multi-arch image SBOMs
- [Multi-language SBOM generation with release upload](../syft/scripts/syft-sbom-generation.py) — Generate SBOMs for every language ecosystem in a repo and attach them to a GitHub release

### Understand secrets management
- [Vault static vs dynamic secrets](../vault/notebooks/static-vs-dynamic-secrets.ipynb) — Comparing Vault static vs dynamic secrets for cloud IAM credential management

### Explore Tetragon observability
- [Tetragon observability tutorial](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md)
- [Minimal network tracing policy](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml)
- [Tetragon event collection pipeline](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- [Build a small Tetragon policy from scratch](../tetragon/scripts/build-tetragon-policy.sh) — Generate a minimal TracingPolicy watching execve calls and verify it applies

### Visualize metrics
- [Grafana primer](../grafana/notes/0000-primer-grafana.md)
- [First Grafana datasource](../grafana/configs/2026-09-19-first-datasource.yaml) — Wire one Prometheus backend into Grafana so a first panel query has something to read
- [First dashboard browser check](../grafana/notes/2026-09-19-first-dashboard-browser.md) — What to inspect in the dashboard browser once the UI is reachable

### Tune runtime detection
- [Falco primer](../falco/notes/0000-primer-falco.md)
- [Falco rule optimization with priority-based filtering](../falco/docs/rule-optimization-priority-filtering.md) — Rank the noisiest rules first, then cut volume with lists, macros, and priority-tiered routing
- [First custom Falco rule](../falco/configs/first-custom-rule-detect-shell-in-container.yaml)
- [Falco K8s admission control rule](../falco/manifests/falco-k8s-admission-control.yaml)

### Get started with vulnerability scanning
- [Install Trivy and run a first container scan](../trivy/notes/2026-09-05-install-trivy-first-container-scan.md)
- [Install ZAP and run a baseline scan](../zap/notes/2026-09-05-install-zap-first-baseline-scan.md)
- [Nuclei primer](../nuclei/notes/0000-primer-nuclei.md)
- [Trivy primer](../trivy/notes/0000-primer-trivy.md)
- [Trivy scanning performance optimization](../trivy/notes/scanning-performance-optimization.md)
- [Trivy ignore-rules pipeline](../trivy/scripts/ignore-rules-pipeline.sh)
- [Trivy SARIF code-scanning output](../trivy/docs/ci-pipeline-sarif-output.md)
- [Multi-arch vulnerability scanning with Trivy](../trivy/docs/multi-arch-vulnerability-scanning.md)
- [Container vulnerability scan with Trivy](../trivy/scripts/container-vuln-scan.sh)
- [Minimal Grype scan](../grype/scripts/minimal-grype-scan.sh)
- [CI-ready Grype scanning](../grype/scripts/ci-ready-grype-scan.sh)
- [SBOM generation with Syft](../syft/scripts/gen-multi-format-sboms.sh)
- [Syft output format comparison](../syft/notebooks/output-format-comparison.ipynb)
- [Snyk vulnerability prioritization with reachability and Fix PRs](../snyk/docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md)
- [Snyk multi-language scan scaffold](../snyk/templates/snyk-multilang-scan-scaffold/README.md)

### Learn Linux shell scripting
- [Linux VM terminal first commands](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- [Linux shell scripting tutorial confusions](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md)
- [Cron job configuration](../linux/configs/2026-08-06-cron-job-configuration.ini)

### Manage infrastructure as code
- [Terraform primer](../terraform/notes/0000-primer-terraform.md)
- [Small reusable Terraform module](../terraform/configs/small-module-from-scratch.hcl) — Environment-aware naming and tagging with variables, locals, and outputs
- [Composing Terraform modules](../terraform/docs/terraform-module-composition.md)
- [Terraform workspace variable precedence](../terraform/configs/workspace-variable-precedence.hcl)
- [First environment comparison](../environments/notes/2026-09-19-first-environment-comparison.md) — Dev vs staging vs prod variable differences worth understanding before changing anything
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md)
- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md)
- [Helm primer](../helm/notes/0000-primer-helm.md)
- [Helm quickstart trip-ups](../helm/notes/2026-09-21-quickstart-tripped-me-up.md) — Things that tripped me up walking through a first Helm setup
- [Minimal Helm chart](../helm/manifests/2026-09-21-minimal-service-chart.yaml) — A bare minimum Helm chart to validate the chart scaffolding pattern
- [Kustomize primer](../kustomize/notes/0000-primer-kustomize.md)
- [Kustomize quickstart trip-ups](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md) — Things that tripped me up walking through a first Kustomize setup
- [Minimal Kustomize config with overlay](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml) — A bare minimum kustomization plus overlay to validate the patching pattern
- [Kustomize tutorial manifest](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)
- [ArgoCD primer](../argocd/notes/0000-primer-argocd.md)
- [ArgoCD private repo credentials and RBAC](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- [ArgoCD quickstart trip-ups](../argocd/notes/2026-08-12-quickstart-tripups.md)
- [ArgoCD multi-environment GitOps delivery](../argocd/docs/multi-environment-gitops-delivery.md)
- [How ArgoCD fits the GitOps workflow](../argocd/docs/gitops-workflow-wiring.md) — Pinned install, separate manifests repo, plain YAML to Kustomize to Helm to app-of-apps
- [ArgoCD Helm guestbook application](../argocd/manifests/helm-guestbook-application.yaml) — Minimal Application spec wiring a Helm chart source into GitOps sync
- [Kubernetes cluster workflow wiring](../kubernetes/docs/cluster-workflow-wiring.md) — Namespace-per-environment layout with a Deployment plus Service per app
- [Namespace strategy: environment vs team](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml) — Environment-scoped versus team-scoped namespaces compared side by side
- [Small Kubernetes Deployment from scratch](../kubernetes/manifests/small-deployment-from-scratch.yaml) — Deployment to ReplicaSet to Pod chain behind a ClusterIP Service
- [Provision a Kubernetes cluster with Terraform + Ansible](../docs/how-to/k8s-terraform-ansible-provisioning.md)

### Manage policies and compliance
- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md)
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh)
- [Gatekeeper constraint template design patterns](../opa/docs/constraint-template-design-patterns.md)
- [Gatekeeper policy library scaffold](../opa/templates/gatekeeper-policy-library-scaffold/README.md)
- [Gatekeeper production deployment manifest](../opa/manifests/gatekeeper-production-deployment.yaml)
- [Test Gatekeeper policies locally](../opa/templates/gatekeeper-policy-library-scaffold/tests/test-policies.sh)
- [Export Gatekeeper audit results](../opa/scripts/export-audit-results.sh)
- [Terrascan primer](../terrascan/notes/0000-primer-terrascan.md)

### Manage secrets and access
- [HashiCorp Vault primer](../vault/notes/0000-primer-vault.md)
- [Install Vault and run a first command](../vault/notes/2026-08-26-install-vault-first-command.md)
- [Vault PKI workflow](../vault/scripts/vault-pki-workflow.sh) — Vault PKI secrets engine: root CA, role, issuance, rotation, revocation with CRL verification
- [Vault KV CRUD operations](../vault/scripts/vault-kv-crud.sh)
- [Vault multi-environment access control](../vault/configs/multi-environment-access-control.hcl)
- [Vault AWS secrets engine policy](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl)
- [Vault dynamic secrets for cloud IAM](../vault/scripts/cloud-iam-dynamic-secrets.sh)
- [Vault Agent auto-auth on Kubernetes](../vault/docs/vault-agent-auto-auth-kubernetes.md)
- [Vault Agent sidecar for secret refresh](../vault/manifests/vault-sidecar-secrets-refresh.yaml)

### Practice and learn
- [Version control with Git fundamentals](../docs/concepts/git-001-version-control-fundamentals.md)
- [CI/CD pipeline concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md)
- [Pipeline artifact promotion practice](../docs/concepts/ci-cd-pipeline-concepts/scripts/2026-09-18-practice-pipeline-artifact-promotion.sh) — Build once, then promote the same artifact staging → prod only when checks pass
- [Application Security Testing concepts](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md)
- [SCA and dependency exercises](../docs/concepts/application-security-testing-concepts/snippets/2026-08-26-appsec-sca-dependency-exercises.py)
- [Infrastructure as Code fundamentals](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md)
- [Terraform validate-then-plan loop](../docs/concepts/infrastructure-as-code/snippets/2026-09-18-validate-and-plan-terraform.sh) — fmt, init, validate, and plan before ever running apply
- [Common Linux scripting patterns in Python](../docs/concepts/linux-shell-fundamentals/snippets/2026-09-18-common-linux-scripting-patterns.py) — Subprocess, env defaults, file iteration, and loud failure for scripting practice
- [Supply-chain CI verification gate](../docs/concepts/software-supply-chain-security/scripts/ci-pipeline-verification.py) — Prevention, reachability triage, and SBOM governance gates for a pipeline step
- [Applying secrets & access management](../docs/concepts/secrets-access-management/snippets/2026-08-25-applying-secrets-access-management.py)
- [Applying version control in DevSecOps](../docs/concepts/version-control-with-git/snippets/2026-08-25-applying-version-control-in-devsecops.py)
- [Lab primer](../lab/notes/0000-primer-lab.md) — What the lab scratch space is for and how mini-projects are organised
- [First lab environment](../lab/configs/2026-09-19-first-lab-env.yaml) — A one-machine practice box you can rebuild from when experiments get messy
- [DefectDojo tutorial check](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh) — Verify DefectDojo setup and tutorial prerequisites before starting

### Run infrastructure tasks
- [Ansible quickstart trip-ups](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md)
- [Ansible inventory with group and host vars](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml)
- [Minimal Ansible playbook: package and service](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- [How I wired Ansible into my infrastructure workflow](../ansible/docs/wired-ansible-infrastructure-workflow.md) — A site.yml entry point plus roles layout for a small infrastructure workflow
- [Roles vs tasks in Ansible](../ansible/notes/roles-vs-tasks.md) — When a reusable concern earns a role and when a task list stays readable
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh)
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh)
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh)

### Run static analysis
- [Semgrep primer](../semgrep/notes/0000-primer-semgrep.md)
- [Checkov primer](../checkov/notes/0000-primer-checkov.md)
- [Checkov 2.x to 3.x upgrade checklist](../checkov/docs/checkov-v3-upgrade-checklist.md) — Roll out the major-version upgrade on a trial branch without breaking the CI gate
- [Checkov cross-module scanning limitations](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb) — Static directory scan vs plan JSON scan for cross-module IaC
- [tfsec primer](../tfsec/notes/0000-primer-tfsec.md)
- [Checkov platform config](../checkov/configs/platform-config.yaml)
- [CodeQL primer](../codeql/notes/0000-primer-codeql.md)
- [Install CodeQL and run a first query](../codeql/notes/2026-08-26-install-codeql-first-query.md)
- [CodeQL query-writing patterns for JavaScript/TypeScript](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md) — Source, sink, and sanitizer patterns for custom data-flow queries
- [CodeQL CLI vs GitHub Actions scan modes](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb) — When to run CodeQL locally via the CLI versus declaratively in Actions
- [CodeQL multi-language repository scan](../codeql/manifests/codeql-multi-language-scan.yaml) — One workflow that analyses every language in a repo with a single status check
- [CodeQL custom query-pack scaffold](../codeql/templates/custom-query-pack-ci-harness/README.md) — Reusable layout for project-specific queries with CI and local test harness
- [Custom Semgrep rule example](../semgrep/snippets/first-custom-rule.yaml)
- [Semgrep rule performance optimization](../semgrep/docs/semgrep-rule-performance-optimization.md)
- [AST-based security pattern checker](../docs/concepts/application-security-testing-concepts/scripts/2026-08-26-ast-devsecops.py)

### Scan for secrets
- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md)
- [Gitleaks primer](../gitleaks/notes/0000-primer-gitleaks.md)
- [First secret scan with Gitleaks](../gitleaks/notes/2026-09-19-first-secret-scan.md) — What to set up before a first scan, using a fake credential in a test repo
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md)
- [GitGuardian incident response workflow](../gitguardian/docs/gitguardian-incident-response-workflow.md)
- [GitGuardian API integration](../gitguardian/scripts/gitguardian-api-integration.py)
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- [Secrets detection workflow analysis](../docs/concepts/secrets-access-management/notebooks/secrets-detection-remediation-workflow-analysis.ipynb)
- [Configure Dependabot for private registries](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md)
- [Dependabot alerts and security updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md)

### Secure version control
- [Git primer](../git/notes/0000-primer-git.md)
- [How Git fits the version-control workflow](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- [Layered vs conditional Git config](../git/configs/config-strategy-layered-vs-conditional.yaml) — System/global/local tiers compared against includeIf context includes
- [Git first repo stage and log](../git/scripts/2026-08-24-first-repo-stage-log.sh)
- [Git hooks for security checks](../docs/concepts/version-control-with-git/scripts/git-hooks-devsecops-security-checks.sh)

### Set up CI/CD pipelines
- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md)
- [Install the GitHub CLI and run a first command](../github-actions/notes/2026-08-26-install-gh-cli-first-command.md)
- [My first GitHub Actions workflow](../github-actions/snippets/2026-08-26-first-workflow.yaml)
- [Reusing inputs with a composite action](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- [CI/CD security scanner wrapper](../docs/concepts/linux-shell-fundamentals/scripts/ci-cd-pipeline-security-scanner-wrapper.sh)
- [Docker CI/CD end-to-end](../docker/docs/cicd-end-to-end.md) — Build once in CI, smoke-test the image, push the verified tag, and deploy that exact tag
- [Reusable Docker build script](../docker/scripts/reusable-build.sh) — Single and multi-stage image builds with build args and cache-from support
- [ZAP baseline scan for CI](../zap/notes/2026-07-20-install-zap-baseline-scan.md)
- [Trivy CI/CD pipeline recipes](../trivy/docs/ci-cd-pipeline-recipes.md)
