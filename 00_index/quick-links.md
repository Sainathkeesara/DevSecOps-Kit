# Quick Links

## I need to...

### Get started with a new concept
- [Application Security Testing Concepts](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — SAST, DAST, SCA, and key security testing terminology
- [CI/CD Pipeline Concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md) — Stages, gates, triggers, and pipeline fundamentals
- [Configuration Management](../docs/concepts/configuration-management/0000-primer-configuration-management.md) — Desired state, idempotency, drift, and config management fundamentals
- [Configuration Management in DevSecOps](../docs/concepts/configuration-management/2026-07-14-devsecops-patterns.md) — Patterns: desired state as source of truth, drift, GitOps, and pairing CM with scanners
- [Container & Runtime Security](../docs/concepts/container-runtime-security/0000-primer-container-runtime-security.md) — Image vs runtime security, syscalls, eBPF
- [Software Supply Chain Security](../docs/concepts/software-supply-chain-security/0000-primer-software-supply-chain-security.md) — Supply chain attacks, SBOM, signing, and dependency verification
- [Version Control with Git](../docs/concepts/version-control-with-git/0000-primer-version-control-with-git.md) — Repos, commits, branches, and collaboration workflows
- [Containers & Orchestration](../docs/concepts/containers-orchestration/0000-primer-containers-orchestration.md) — Images, containers, registries, and Kubernetes fundamentals
- [Infrastructure as Code](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md) — What IaC is, why it matters, and key terminology
- [Linux & Shell Fundamentals](../docs/concepts/linux-shell-fundamentals/0000-primer-linux-shell-fundamentals.md) — What Linux and the shell are, why they matter, and core terminology
- [Observability & Monitoring](../docs/concepts/observability-monitoring/0000-primer-observability-monitoring.md) — Metrics, logs, traces, SLOs, and telemetry fundamentals
- [Secrets & Access Management](../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md) — Controlling access and handling credentials securely
- [OWASP Top 10 SAST rule mapping](../docs/concepts/application-security-testing-concepts/snippets/2026-07-10-owasp-top10-sast.sh) — SAST rule snippets mapped to OWASP Top 10 categories

### Learn a specific tool
- [Trivy primer](../trivy/notes/0000-primer-trivy.md)
- [Semgrep primer](../semgrep/notes/0000-primer-semgrep.md)
- [Checkov primer](../checkov/notes/0000-primer-checkov.md)
- [Grype primer](../grype/notes/0000-primer-grype.md)
- [CodeQL primer](../codeql/notes/0000-primer-codeql.md)
- [Snyk primer](../snyk/notes/0000-primer-snyk.md)
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md)
- [OWASP ZAP primer](../zap/notes/0000-primer-zap.md)
- [Falco primer](../falco/notes/0000-primer-falco.md)
- [Cosign primer](../cosign/notes/0000-primer-cosign.md)
- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md)
- [Terrascan primer](../terrascan/notes/0000-primer-terrascan.md)
- [Dependabot primer](../dependabot/notes/0000-primer-dependabot.md)
- [Tetragon primer](../tetragon/notes/0000-primer-tetragon.md)
- [HashiCorp Vault primer](../vault/notes/0000-primer-vault.md)
- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md)
- [DefectDojo primer](../defectdojo/notes/0000-primer-defectdojo.md)
- [Git primer](../git/notes/0000-primer-git.md)
- [Simulate CI locally with Git](../git/scripts/2026-07-10-local-ci-simulation.sh)
- [ArgoCD primer](../argocd/notes/0000-primer-argocd.md)
- [Docker primer](../docker/notes/0000-primer-docker.md)
- [Helm primer](../helm/notes/0000-primer-helm.md)
- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md)
- [Kustomize primer](../kustomize/notes/0000-primer-kustomize.md)
- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md)
- [SonarQube primer](../sonarqube/notes/0000-primer-sonarqube.md)
- [SonarQube first scan run](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md)
- [Terraform primer](../terraform/notes/0000-primer-terraform.md)
- [Grafana primer](../grafana/notes/0000-primer-grafana.md)
- [Observability primer](../observability/notes/0000-primer-observability.md)
- [Prometheus primer](../prometheus/notes/0000-primer-prometheus.md)

### Scan for vulnerabilities
- [Scan Docker images with Trivy](../trivy/scripts/container-vuln-scan.sh)
- [Scan multi-service Docker Compose with Trivy](../trivy/scripts/compose-multi-scan.sh)
- [Automated image vulnerability scanning pipeline](../trivy/scripts/image-vuln-pipeline.sh)
- [Scan Python codebase with Semgrep](../semgrep/scripts/scan-python-codebase.sh)
- [Detect hardcoded secrets with Semgrep](../semgrep/scripts/detect-hardcoded-secrets.py)
- [Scan Terraform plan with Checkov](../checkov/scripts/scan-terraform-plan.sh)
- [Deep Terraform plan scan with Checkov](../checkov/scripts/deep-terraform-plan-scan.sh)
- [Scan Kubernetes manifests with Checkov](../checkov/snippets/scan-kubernetes.sh)
- [Scan Terraform directory with Checkov SDK](../checkov/snippets/scan-terraform-dir.py)
- [Scan single Terraform file with Checkov SDK](../checkov/snippets/scan-a-terraform-file.py)
- [Minimal Grype scan script](../grype/scripts/minimal-grype-scan.sh)
- [CI-ready Grype scanning wrapper](../grype/scripts/ci-ready-grype-scan.sh)
- [Vulnerability diff across two image versions](../grype/scripts/vuln-diff-two-images.sh)
- [Grype results to SARIF converter](../grype/scripts/grype-results-to-sarif.py)
- [Grype end-to-end scan pipeline](../grype/scripts/grype-end-to-end-scan-pipeline.sh) — Full SBOM generation to SARIF output in one script
- [ZAP baseline scan script](../zap/snippets/my-first-zap-baseline-scan.sh)
- [ZAP Docker quickstart with JSON export](../zap/snippets/2026-07-16-zap-docker-quickstart-json-export.sh)
- [DAST workflow from spider to active scan](../zap/scripts/dast-workflow-from-scratch.sh)
- [ZAP DAST SARIF code scanning](../zap/scripts/zap-dast-sarif-code-scanning.sh)
- [Snyk vulnerability scanning pipeline](../snyk/scripts/snyk-vuln-scan-pipeline.sh)

### Scan for secrets
- [Test fake secrets scan with TruffleHog](../trufflehog/snippets/fake-secrets-test.sh)
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- [Pre-commit secret scanning pipeline](../trufflehog/scripts/pre-commit-scan-pipeline.sh)
- [Multi-repo secret scanning pipeline](../trufflehog/scripts/multi-repo-scan-pipeline.sh)
- [Minimal ggshield pre-commit hook integration](../gitguardian/scripts/pre-commit-hook-ggshield.sh)
- [ggshield scheduled scanning config](../gitguardian/configs/.ggshield.yaml)

### Manage dependencies
- [Minimal Dependabot npm update config](../dependabot/configs/tried-npm-dependabot.yaml)
- [Dependabot npm version strategy config](../dependabot/configs/2026-07-10-npm-version-strategy.yaml)
- [Dependabot alerts and security updates](../dependabot/notes/dependabot-alerts-security-updates.md)
- [Enabling Dependabot alerts on a repository](../dependabot/notes/2026-07-10-enabling-dependabot-alerts.md)

### Sign and verify images
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- [Verify a signed image](../cosign/scripts/verify-signed-image.sh)
- [Cosign keyless GitHub Actions CI signing config](../cosign/configs/keyless-signing-github-actions.yaml)
- [Cosign keyless OIDC CI workflow](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)

### Build container images
- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)
- [Custom Dockerfile (this cycle)](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile)
- [Explore the Docker CLI](../docker/notes/2026-07-12-explore-docker-cli.md)

### Manage policies
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh)
- [Enforce image registry constraints](../opa/snippets/enforce-image-registry-constraints.rego)
- [Deny privileged containers and hostNetwork](../opa/snippets/deny-privileged-hostnetwork.rego)
- [Gatekeeper admission policy — block host network](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- [How I test OPA policies locally](../opa/scripts/how-i-test-policies-locally.sh)
- [Custom S3 bucket policy rule (config)](../terrascan/configs/tried-custom-s3-rule.yaml)
- [Multi-rule Semgrep pack with combinators](../semgrep/configs/multi-rule-pack.yaml)

### Run infrastructure tasks
- [k8s_toolkit usage guide](../docs/how-to/k8s_toolkit.md)
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh)
- [Drain a node](../scripts/bash/k8s_toolkit/node/drain-node.sh)
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh)
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh)
- [Decode K8s secret](../scripts/bash/k8s_toolkit/secret/decode-secret.sh)
- [Linux toolkit usage guide](../docs/how-to/linux_toolkit.md)
- [System health check](../scripts/bash/linux_toolkit/system/health-check.sh)
- [Network diagnostics](../scripts/bash/linux_toolkit/network/net-diag.sh)
- [User create](../scripts/bash/linux_toolkit/sysadmin/user-create.sh)
- [Terraform workflow script](../scripts/bash/terraform_toolkit/terraform-workflow.sh)
- [First Terraform config (HCL)](../terraform/configs/2026-07-15-first-config.tf)
- [Explore Terraform](../terraform/notes/2026-07-15-explore-terraform.md)
- [Terraform zip build helper](../terraform/scripts/2026-07-13-zip-build.sh)
- [Multi-environment setup](../scripts/bash/terraform_toolkit/multi-env/multi-env-setup.sh)
- [Deploy EKS cluster](../scripts/bash/terraform_toolkit/eks/eks-deploy.sh)
- [Set up Atlantis](../scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh)
- [AKS privilege escalation hardening](../scripts/bash/k8s_toolkit/security/aks-privilege-escalation-hardening.sh)
- [Samba file-share setup](../scripts/bash/linux_toolkit/samba-setup.sh)
- [OS patch report](../scripts/patch-report.sh)

### Troubleshoot issues
- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md)
- [Kafka consumer lag](../docs/troubleshooting/kafka-consumer-lag.md)
- [Vault seal/unseal](../docs/troubleshooting/vault-seal-unseal.md)
- [Jenkins failures](../docs/troubleshooting/jenkins-troubleshooting.md)
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md)
