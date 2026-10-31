# Quick Links

## I need to...

### Audit and remediate CVEs

- [Ansible CVE-2026-33228 path verification](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md)
- [Lab multi-node demo config](../lab/configs/2026-10-25-multi-node-demo.yaml)
- [Lab quickstart trip-ups](../lab/notes/2026-10-25-lab-quickstart-trips.md)
- [Trivy CVE severity filtering](../scripts/bash/ci_cd_toolkit/trivy-severity-filter.sh)
- [TruffleHog PR secret scan reusable workflow](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- [Falco K8s admission control rule](../falco/manifests/falco-k8s-admission-control.yaml)
- [DefectDojo vulnerability scanner setup](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml)
- [DefectDojo API vs UI ingestion config](../defectdojo/configs/api-vs-ui-ingestion.yaml)
- [Flatted CVE-2026-33228 runbook](../docs/runbooks/cve-2026-33228-ansible-flatted.md)
- [Kaniko CVE-2026-28406 runbook](../docs/how-to/docker-kaniko-cve-2026-28406.md)
- [DefectDojo wired into triage workflow](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md)

### Build and sign container images

- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- [Install Cosign and run a first signing command](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md)
- [Cosign verification patterns](../cosign/docs/cosign-verification-patterns.md)
- [Container signing pipeline integration](../cosign/docs/container-signing-pipeline.md)
- [Cosign key management workflow](../cosign/scripts/cosign-key-management-workflow.sh)
- [Cosign signature configuration](../cosign/configs/cosign-signature-configuration.yaml)
- [Key-based vs keyless signing](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)
- [Cosign key rotation and migration patterns](../cosign/docs/key-rotation-and-migration-patterns.md)
- [Custom Cosign image](../cosign/dockerfiles/custom-cosign-image.Dockerfile)
- [Multi-stage SBOM Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- [Multi-stage Grype scan Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- [Build a multi-service Docker Compose app](../docker/scripts/build-multi-service-compose-app.sh)
- [Helm build and deploy chart script](../helm/scripts/build-and-deploy-chart.sh)
- [Multi-service Compose scaffold](../docker/templates/multi-service-setup/README.md)
- [Docker Compose production manifest](../docker/manifests/docker-compose-production.yaml)
- [Syft + Trivy Kubernetes scan scaffold](../syft/templates/syft-trivy-k8s-scan-scaffold/README.md)
- [Helm wired into release workflow](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- [Keyless signing patterns](../cosign/docs/keyless-signing-patterns.md)

### Diagnose failures

- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md)
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md)
- [Vault seal/unseal troubleshooting](../docs/troubleshooting/vault-seal-unseal.md)
- [Jenkins troubleshooting](../docs/troubleshooting/jenkins-troubleshooting.md)
- [Kafka consumer lag](../docs/troubleshooting/kafka-consumer-lag.md)
- [Linux production system administration runbook](../linux/docs/system-administration-runbook.md)
- [Host health check and rollback](../linux/scripts/health-check-and-rollback.sh)
- [Find large logs](../linux/scripts/find-large-logs.sh)

### Generate SBOMs and scan for vulnerabilities

- [Syft SBOM generation primer](../syft/notes/0000-primer-syft.md)
- [Generate multi-format SBOMs](../syft/scripts/gen-multi-format-sboms.sh)
- [SBOM pipeline scaffold](../syft/templates/sbom-pipeline-scaffold/README.md)
- [Grype vulnerability scanner primer](../grype/notes/0000-primer-grype.md)
- [Grype end-to-end scan pipeline](../grype/scripts/grype-end-to-end-scan-pipeline.sh)
- [Grype + Syft integration guide](../grype/docs/grype-syft-integration-guide.md)
- [Trivy universal scanner primer](../trivy/notes/0000-primer-trivy.md)
- [Trivy container vulnerability scan](../trivy/scripts/container-vuln-scan.sh)
- [Trivy Kubernetes workload scanning scaffold](../trivy/templates/trivy-k8s-workload-scanning/README.md)

### Scan infrastructure as code

- [Checkov IaC scanner primer](../checkov/notes/0000-primer-checkov.md)
- [Checkov deep Terraform plan scan](../checkov/scripts/deep-terraform-plan-scan.sh)
- [Checkov validate custom policies](../checkov/scripts/validate-policies.sh)
- [tfsec Terraform security scanner primer](../tfsec/notes/0000-primer-tfsec.md)
- [Terrascan IaC scanner primer](../terrascan/notes/0000-primer-terrascan.md)
- [OPA policy engine primer](../opa/notes/0000-primer-opa.md)
- [Semgrep SAST primer](../semgrep/notes/0000-primer-semgrep.md)
- [OPA first policy evaluation](../opa/notes/2026-10-24-install-opa-first-policy-eval.md)

### Detect secrets in code and git history

- [TruffleHog secret scanner primer](../trufflehog/notes/0000-primer-trufflehog.md)
- [TruffleHog first secret scan](../trufflehog/snippets/2026-10-14-first-secret-scan.sh)
- [Gitleaks secret scanner primer](../gitleaks/notes/0000-primer-gitleaks.md)
- [Gitleaks first scan script](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh)
- [GitGuardian secrets platform primer](../gitguardian/notes/0000-primer-gitguardian.md)
- [GitGuardian pre-commit hook](../gitguardian/scripts/pre-commit-hook-ggshield.sh)

### Set up CI/CD pipelines

- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md)
- [Minimal starter workflow](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml)
- [Run first workflow](../github-actions/notes/2026-10-14-run-first-workflow.md)
- [Trigger workflow with gh CLI](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh)
- [ArgoCD GitOps primer](../argocd/notes/0000-primer-argocd.md)
- [ArgoCD Helm guestbook application](../argocd/manifests/helm-guestbook-application.yaml)
- [Dependabot automated updates primer](../dependabot/notes/0000-primer-dependabot.md)
- [Dependabot configuration template](../dependabot/configs/dependabot-configuration-template.yaml)

### Manage Kubernetes clusters

- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md)
- [First pod and service manifest](../kubernetes/manifests/2026-07-15-first-pod-service.yaml)
- [Minimal namespace config](../kubernetes/configs/2026-10-14-minimal-namespace.yaml)
- [Cluster workflow wiring](../kubernetes/docs/cluster-workflow-wiring.md)
- [Helm package manager primer](../helm/notes/0000-primer-helm.md)
- [Kustomize YAML customization primer](../kustomize/notes/0000-primer-kustomize.md)
- [Kubernetes bootstrap scaffold](../kubernetes/templates/cluster-bootstrap/README.md)
- [Cert Manager bootstrap](../kubernetes/templates/cluster-bootstrap/cert-manager/cert-manager-bootstrap.yaml)
- [Calico CNI installation](../kubernetes/templates/cluster-bootstrap/cni/calico-installation.yaml)

### Manage secrets and encryption

- [Vault secrets management primer](../vault/notes/0000-primer-vault.md)
- [Vault KV CRUD operations](../vault/scripts/vault-kv-crud.sh)
- [Vault PKI workflow](../vault/scripts/vault-pki-workflow.sh)
- [Vault secrets engine selection guide](../vault/docs/vault-secrets-engine-selection-guide.md)
- [Vault Agent auto-auth on Kubernetes](../vault/docs/vault-agent-auto-auth-kubernetes.md)
- [Cosign container signing primer](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md)
- [Vault secret access patterns](../docs/concepts/secrets-access-management/scripts/vault-secrets-access-patterns.sh)

### Monitor and observe systems

- [Prometheus metrics primer](../prometheus/notes/0000-primer-prometheus.md)
- [Prometheus first query log](../prometheus/notes/2026-10-14-first-query-log.md)
- [Grafana dashboard primer](../grafana/notes/0000-primer-grafana.md)
- [Grafana dashboard provisioning](../grafana/configs/2026-10-14-dashboard-provisioning.yaml)
- [Grafana first datasource query](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- [Falco runtime security primer](../falco/notes/0000-primer-falco.md)
- [Tetragon eBPF runtime primer](../tetragon/notes/0000-primer-tetragon.md)

### Write and test infrastructure code

- [Terraform primer](../terraform/notes/0000-primer-terraform.md)
- [Small Terraform module from scratch](../terraform/configs/small-module-from-scratch.hcl)
- [Terraform deploy script](../terraform/scripts/2026-07-18-deploy.sh)
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md)
- [OpenTofu vs Terraform migration decision matrix](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md)
- [Ansible quickstart trip-ups](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md)
- [Ansible bootstrap target node](../ansible/scripts/bootstrap-target-node.sh)
- [OpenTofu test quickstart followup](../opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md)
- [Terraform testing patterns](../terraform/docs/terraform-testing-patterns.md)
- [Module registry publish consume](../terraform/templates/module-registry-publish-consume/README.md)
- [Shell scripting foundations](../learn/01-foundations/02-shell-scripting.md)

### Manage environments and assets

- [Managing environments guide](../environments/docs/managing-environments.md)
- [Environment promotion script](../environments/scripts/promote-environment.sh)
- [Asset tracking config](../assets/configs/asset-tracking-config.yaml)
- [Assets CI/CD pipeline wiring](../assets/docs/how-i-wired-assets-into-ci-cd-pipeline.md)
- [Asset inventory collector](../assets/scripts/asset-inventory-collector.py)