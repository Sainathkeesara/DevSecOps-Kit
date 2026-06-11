# Quick Links

## Getting started
- [README](../README.md) — Repository overview
- [topics.md](topics.md) — Full topic index by tool
- [glossary.md](glossary.md) — Tool and domain terminology

## Set up a tool
- [Install Semgrep](../semgrep/notes/2026-05-25-install-semgrep.md)
- [Install Checkov](../checkov/notes/2026-05-25-scan-terraform-plan.md)
- [Install Trivy](../trivy/notes/2026-05-24-install-trivy.md)
- [Install Git](../scripts/bash/git/git-install.sh)
- [Install Jenkins](../scripts/bash/jenkins_toolkit/install-jenkins.sh)
- [Deploy Loki + Promtail](../scripts/bash/observability_toolkit/loki/loki-promtail-install.sh)
- [Deploy Grafana](../scripts/bash/observability_toolkit/grafana/grafana-install.sh)
- [Deploy Prometheus Node Exporter](../docs/how-to/observability/prometheus-node-exporter-installation.md)
- [Deploy OTel Collector](../scripts/bash/observability_toolkit/otel/otel-collector-install.sh)
- [Deploy Alertmanager](../scripts/bash/observability_toolkit/alertmanager/alertmanager-install.sh)
- [Set up Alertmanager HA cluster](../scripts/bash/observability_toolkit/alertmanager/alertmanager-ha-setup.sh)
- [Set up Buildkite agent](../scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh)
- [Set up CircleCI runner](../scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh)
- [Deploy Argo Workflows](../scripts/bash/argo_toolkit/argo-workflows-install.sh)
- [Deploy Flux v2](../scripts/bash/flux_toolkit/flux-install.sh)
- [Deploy Harbor registry](../scripts/bash/harbor/harbor-deploy.sh)
- [Deploy Docker Swarm cluster](../scripts/bash/docker_toolkit/docker-swarm-cluster-setup.sh)
- [Deploy EKS cluster](../scripts/bash/terraform_toolkit/eks/eks-deploy.sh)
- [Set up Atlantis](../scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh)
- [Set up Git credential helper for CI/CD](../scripts/bash/git/credential-helper-ci.sh)
- [Install GitHub Actions runner](../scripts/bash/git/github-runner-install.sh)
- [Install Syft and generate first SBOM](../syft/notes/2026-05-27-install-syft-first-sbom.md)
- [Install TruffleHog](../trufflehog/notes/2026-05-27-install-trufflehog.md)

## Troubleshoot a tool
- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md)
- [Kafka consumer lag](../docs/troubleshooting/kafka-consumer-lag.md)
- [Vault seal/unseal](../docs/troubleshooting/vault-seal-unseal.md)
- [Jenkins failures](../docs/troubleshooting/jenkins-troubleshooting.md)
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md)

## Compare semgrep scan vs semgrep ci
- [semgrep scan vs semgrep ci comparison notebook](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## Scan with Checkov (CI/CD)
- [Layered Checkov CI: PR gate + scheduled deep scan + merge block](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml)
- [Checkov SARIF scan — PR gate workflow](../checkov/manifests/checkov-sarif-pr-blocking.yaml)

## Deploy Trivy Operator
- [Trivy Operator deployment manifest](../trivy/manifests/trivy-operator-deployment.yaml) — Operator controller + node collector for cluster-wide vulnerability scanning

## Scan for CVEs
- [Kubernetes CVEs](topics.md#kubernetes)
- [Docker CVEs](topics.md#docker)
- [Jenkins CVE-2026-33001](../docs/security/jenkins/CVE-2026-33001.md)
- [Ansible CVE-2026-33228 remediation](../docs/security/ansible/CVE-2026-33228.md)
- [Docker CVE-2026-34040](../docs/security/docker/CVE-2026-34040.md)
- [Trivy CVE-2026-33634](../docs/security/trivy/CVE-2026-33634.md)
- [Trivy CVE-2026-33001](../docs/how-to/trivy/cve-2026-33001-remediation.md)
- [Vault go-getter CVE](../scripts/bash/vault/security/vault-go-getter-hardening.sh)
- [Scan with Semgrep](../semgrep/notes/0000-primer-semgrep.md)
- [Semgrep CI pipeline from scratch](../semgrep/docs/github-actions-ci-from-scratch.md)
- [Semgrep CI/CD integration guide](../semgrep/docs/semgrep-ci-integration.md)
- [Semgrep rule-writing approaches: pattern vs pattern-inside vs pattern-either](../semgrep/docs/comparing-rule-writing-approaches.md)
- [Diff-aware Semgrep CI pipeline (manifest)](../semgrep/manifests/diff-aware-semgrep-ci.yaml)
- [Scan with Checkov (K8s)](../checkov/snippets/scan-kubernetes.sh)
- [Scan with Checkov (Terraform)](../checkov/snippets/scan-terraform-dir.py)
- [Scan with Checkov (single file SDK)](../checkov/snippets/scan-a-terraform-file.py)
- [Checkov quickstart walkthrough](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md)
- [Checkov skip & severity config](../checkov/configs/checkov-skip-severity-config.yaml)
- [Checkov pre-commit hook with version pinning](../checkov/docs/pre-commit-hook-with-version-pinning.md)
- [Checkov integration patterns: plan scanning + custom policies](../checkov/docs/checkov-integration-patterns.md)
- [Checkov CI config with framework selection](../checkov/configs/checkov-ci-config.yaml)
- [Build Terraform scanning project with Checkov custom policies](../checkov/snippets/terraform-scan-custom-policies.py)
- [Multi-IaC scanning project scaffold (template)](../checkov/templates/multi-iac-scan-project/)
- [Scan Terraform plan with Checkov](../checkov/scripts/scan-terraform-plan.sh)
- [Custom Semgrep rule — privileged containers](../semgrep/snippets/catch-privileged-containers.yaml)
- [Detect hardcoded secrets with Semgrep](../semgrep/scripts/detect-hardcoded-secrets.py)
- [Multi-rule Semgrep pack with combinators](../semgrep/configs/multi-rule-pack.yaml)
- [Scan Docker images with Trivy](../trivy/scripts/container-vuln-scan.sh)
- [Scan multi-service Docker Compose with Trivy](../trivy/scripts/compose-multi-scan.sh)
- [Automated image vulnerability scanning pipeline](../trivy/scripts/image-vuln-pipeline.sh)
- [Trivy CI/CD pipeline integration](../docs/how-to/trivy-cicd-integration.md)
- [Trivy CI pipeline with SARIF output](../trivy/docs/ci-pipeline-sarif-output.md)
- [Trivy CI/CD pipeline recipes](../trivy/docs/ci-cd-pipeline-recipes.md)
- [Trivy multi-target scanner (image/fs/repo)](../trivy/scripts/multi-target-scanner.sh)
- [Trivy project config (.trivy.yaml)](../trivy/configs/.trivy.yaml)
- [Trivy SARIF output processing notebook](../trivy/notebooks/trivy-sarif-output-processing.ipynb)
- [Containerized Trivy scanning environment with custom policies (Dockerfile)](../trivy/dockerfiles/custom-policies.Dockerfile)
- [Trivy monorepo scanner scaffold (template)](../trivy/templates/trivy-monorepo-scanner/)

## Scan with Grype
- [Grype primer](../grype/notes/0000-primer-grype.md)
- [Install Grype and run first scan](../grype/notes/2026-05-31-install-grype.md)
- [My first Grype commands](../grype/snippets/my-first-grype-commands.sh)
- [Minimal Grype scan script](../grype/scripts/minimal-grype-scan.sh)
- [Minimal Grype scan with Go SDK](../grype/snippets/minimal-grype-scan.go)
- [Grype quickstart walkthrough](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md)
- [First Grype vulnerability scan](../grype/notes/2026-06-08-first-grype-scan.md)
- [CI-ready Grype scanning wrapper with severity thresholds](../grype/scripts/ci-ready-grype-scan.sh)

## Scan with OPA/Gatekeeper
- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md)
- [Install OPA and explore the REPL](../opa/notes/2026-06-06-install-opa-repl.md)
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh)

## Scan for SBOM generation
- [Syft primer](../syft/notes/0000-primer-syft.md)
- [Install Syft and generate first SBOM](../syft/notes/2026-05-27-install-syft-first-sbom.md)
- [Syft quickstart walkthrough](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)
- [Generate SPDX + CycloneDX SBOMs](../syft/snippets/tried-sbom-formats.sh)
- [Generate all Syft SBOM formats](../syft/scripts/gen-multi-format-sboms.sh)
- [Multi-image SBOM pipeline](../syft/scripts/multi-image-sbom-pipeline.sh)
- [Syft configuration (.syft.yaml)](../syft/configs/.syft.yaml)
- [SBOM format comparison: SPDX vs CycloneDX vs Syft JSON](../syft/docs/sbom-formats-comparison.md)
- [SBOM layer package analysis notebook](../syft/notebooks/sbom-layer-package-analysis.ipynb)

## Scan with Snyk
- [Snyk primer](../snyk/notes/0000-primer-snyk.md)
- [Install Snyk CLI and run first project test](../snyk/notes/2026-06-08-install-snyk-first-test.md)
- [Snyk quickstart walkthrough](../snyk/notes/2026-06-07-snyk-quickstart-walkthrough.md)
- [My first Snyk commands](../snyk/snippets/my-first-snyk-commands.sh)

## Scan with GitGuardian
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md)
- [Install ggshield and run first scan](../gitguardian/notes/2026-06-07-first-ggshield-scan.md)
- [My first ggshield commands](../gitguardian/snippets/my-first-ggshield-commands.sh)
- [ggshield scheduled scanning config](../gitguardian/configs/.ggshield.yaml)

## Scan with CodeQL
- [My first CodeQL analysis (workflow)](../codeql/configs/first-codeql-analysis.yml)
- [My first CodeQL query: hardcoded credentials in Python](../codeql/snippets/find-hardcoded-creds.ql)
- [Minimal CodeQL database + query runner](../codeql/scripts/first-codeql-analysis.sh)

## Build a Semgrep rule pack
- [Multi-rule pack with combinators](../semgrep/configs/multi-rule-pack.yaml)

## Custom Semgrep scanning Docker image
- [Custom Semgrep scanning image (Dockerfile)](../semgrep/dockerfiles/custom-scanning-image.Dockerfile)

## Compare scanning approaches
- [Checkov static vs plan scanning notebook](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb)
- [Semgrep scan vs semgrep ci notebook](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## Scan for leaked secrets
- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md)
- [Install TruffleHog and scan a repo](../trufflehog/notes/2026-05-27-install-trufflehog.md)
- [Test fake secrets scan with TruffleHog](../trufflehog/snippets/fake-secrets-test.sh)
- [TruffleHog quickstart walkthrough](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md)
- [Comparing TruffleHog scan modes: git vs filesystem vs S3](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md)
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- [Custom regex + entropy config for TruffleHog](../trufflehog/configs/trufflehog-custom-regex-config.yaml)
- [Pre-commit secret scanning pipeline](../trufflehog/scripts/pre-commit-scan-pipeline.sh)
- [Multi-repo secret scanning pipeline](../trufflehog/scripts/multi-repo-scan-pipeline.sh)
- [Custom detector rules for proprietary patterns](../trufflehog/configs/custom-detector-rules.yaml)
- [Analyzing TruffleHog false positives and severity tuning notebook](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)
- [TruffleHog secret scanning pipeline scaffold (template)](../trufflehog/templates/secret-scanning-pipeline/)

## Scan with OWASP ZAP
- [ZAP primer](../zap/notes/0000-primer-zap.md)
- [Install ZAP and explore the desktop UI](../zap/notes/2026-06-06-install-zap-desktop-ui.md)
- [My first ZAP baseline scan](../zap/snippets/my-first-zap-baseline-scan.sh)
- [ZAP quickstart walkthrough — UI gotchas](../zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md)
- [Authenticated scan with ZAP context](../zap/snippets/authenticated-scan-with-context.sh)

## Runtime security with Falco
- [Falco primer](../falco/notes/0000-primer-falco.md)
- [Install Falco and run first detection](../falco/notes/2026-06-10-install-falco-first-detection.md)
- [My first custom Falco rule: detect shell in container](../falco/configs/first-custom-rule-detect-shell-in-container.yaml)

## Manage secrets with Vault
- [Vault primer](../vault/notes/0000-primer-vault.md)
- [Install Vault and explore the CLI](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
- [My first Vault read/write commands](../vault/snippets/vault-read-write.go)

## Run a Kubernetes task
- [k8s_toolkit usage guide](../docs/how-to/k8s_toolkit.md)
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh)
- [Drain a node](../scripts/bash/k8s_toolkit/node/drain-node.sh)
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh)
- [Rollout status check](../scripts/bash/k8s_toolkit/rollout-status.sh)
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh)
- [Pod exec](../scripts/bash/k8s_toolkit/pod/exec-pod.sh)
- [Pod logs](../scripts/bash/k8s_toolkit/pod/pod-logs.sh)
- [Decode K8s secret](../scripts/bash/k8s_toolkit/secret/decode-secret.sh)
- [Namespace resource report](../scripts/bash/k8s_toolkit/report/namespace-report.sh)
- [Clean up jobs](../scripts/bash/k8s_toolkit/job/cleanup-jobs.sh)
- [Production deployment template](../templates/k8s/production-deployment.yaml)
- [Deploy production app](../templates/k8s/deploy-prod-app.sh)
- [Kubectl cheatsheet](../snippets/kubectl-cheatsheet.md)

## Run a Linux administration task
- [Linux toolkit usage guide](../docs/how-to/linux_toolkit.md)
- [System health check](../scripts/bash/linux_toolkit/system/health-check.sh)
- [Disk usage](../scripts/bash/linux_toolkit/system/disk-usage.sh)
- [Service management](../scripts/bash/linux_toolkit/service/manage-services.sh)
- [Network diagnostics](../scripts/bash/linux_toolkit/network/net-diag.sh)
- [Process manager](../scripts/bash/linux_toolkit/process/process-manager.sh)
- [User create](../scripts/bash/linux_toolkit/sysadmin/user-create.sh)
- [User modify](../scripts/bash/linux_toolkit/sysadmin/user-modify.sh)
- [System backup](../scripts/bash/linux_toolkit/sysadmin/system-backup.sh)
- [Security check](../scripts/bash/linux_toolkit/security/security-check.sh)
- [Linux cheatsheet](../snippets/linux-cheatsheet.md)

## Run a Terraform workflow
- [Terraform workflow script](../scripts/bash/terraform_toolkit/terraform-workflow.sh)
- [Multi-environment setup](../scripts/bash/terraform_toolkit/multi-env/multi-env-setup.sh)
- [Terraform commands cheatsheet](../snippets/terraform-commands.md)
- [State management guide](../docs/how-to/terraform-state-management.md)
- [Module composition guide](../docs/how-to/terraform-module-composition-workspaces.md)

## Work with Kafka
- [Kafka toolkit usage guide](../docs/how-to/kafka_toolkit.md)
- [Topic list](../scripts/bash/kafka_toolkit/topics/topic-list.sh)
- [Topic create](../scripts/bash/kafka_toolkit/topics/topic-create.sh)
- [Topic config](../scripts/bash/kafka_toolkit/topics/topic-config.sh)
- [Topic delete](../scripts/bash/kafka_toolkit/topics/topic-delete.sh)
- [Consumer group management](../scripts/bash/kafka_toolkit/consumers/consumer-groups.sh)
- [Consumer lag monitoring](../scripts/bash/kafka_toolkit/monitoring/consumer-lag.sh)
- [Cluster health check](../scripts/bash/kafka_toolkit/admin/cluster-health.sh)
- [ACL management](../scripts/bash/kafka_toolkit/acl/manage-acls.sh)
- [Kafka cheatsheet](../snippets/kafka-cheatsheet.md)

## Work with container registries
- [OCI registry toolkit usage guide](../docs/how-to/oci_registry_toolkit.md)
- [List repos](../scripts/bash/oci_registry_toolkit/registry/list-repos.sh)
- [List tags](../scripts/bash/oci_registry_toolkit/registry/list-tags.sh)
- [Find old tags](../scripts/bash/oci_registry_toolkit/tags/find-old-tags.sh)
- [Harbor deploy](../scripts/bash/harbor/harbor-deploy.sh)
- [ACR deploy](../scripts/bash/azure_toolkit/acr/acr-deploy.sh)
- [GAR deploy](../scripts/bash/oci_registry_toolkit/gar/gar-deploy.sh)
- [Quay deploy](../scripts/bash/oci_registry_toolkit/quay/quay-deploy.sh)
- [OCI registry cheatsheet](../snippets/oci-registry-cheatsheet.md)
