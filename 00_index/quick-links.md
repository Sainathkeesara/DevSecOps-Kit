# Quick Links

## I need to...

### Scan infrastructure as code

- [Checkov IaC scanner primer](../checkov/notes/0000-primer-checkov.md)
- [Checkov deep Terraform plan scan](../checkov/scripts/deep-terraform-plan-scan.sh)
- [Checkov custom policy validation](../checkov/scripts/validate-policies.sh)
- [tfsec Terraform security scanner primer](../tfsec/notes/0000-primer-tfsec.md)
- [Terrascan IaC scanner primer](../terrascan/notes/0000-primer-terrascan.md)
- [OPA policy engine primer](../opa/notes/0000-primer-opa.md)
- [Semgrep SAST primer](../semgrep/notes/0000-primer-semgrep.md)

### Detect secrets in code and git history

- [TruffleHog secret scanner primer](../trufflehog/notes/0000-primer-trufflehog.md)
- [TruffleHog first secret scan](../trufflehog/snippets/2026-10-14-first-secret-scan.sh)
- [Search git history and verify secrets with TruffleHog](../learn/03-shift-left/04-trufflehog-history.md)
- [Gitleaks secret scanner primer](../gitleaks/notes/0000-primer-gitleaks.md)
- [Gitleaks first scan script](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh)
- [Catch secrets before they land with Gitleaks](../learn/03-shift-left/03-gitleaks-in-ci.md)
- [GitGuardian secrets platform primer](../gitguardian/notes/0000-primer-gitguardian.md)
- [GitGuardian pre-commit hook](../gitguardian/scripts/pre-commit-hook-ggshield.sh)

### Generate SBOMs and scan for vulnerabilities

- [Syft SBOM generation primer](../syft/notes/0000-primer-syft.md)
- [Produce and read an SBOM with Syft (lesson)](../learn/03-shift-left/10-syft-sbom.md)
- [Generate multi-format SBOMs](../syft/scripts/gen-multi-format-sboms.sh)
- [Syft SBOM pipeline scaffold](../syft/templates/sbom-pipeline-scaffold/README.md)
- [Grype vulnerability scanner primer](../grype/notes/0000-primer-grype.md)
- [Grype end-to-end scan pipeline](../grype/scripts/grype-end-to-end-scan-pipeline.sh)
- [Grype + Syft integration guide](../grype/docs/grype-syft-integration-guide.md)
- [Trivy scanner primer](../trivy/notes/0000-primer-trivy.md)
- [Trivy container vulnerability scan](../trivy/scripts/container-vuln-scan.sh)
- [Gate container images on Trivy findings in CI (lesson)](../learn/03-shift-left/09-trivy-ci-gate.md)
- [Trivy Kubernetes workload scanning scaffold](../trivy/templates/trivy-k8s-workload-scanning/README.md)

### Scan applications (SAST/DAST)

- [Semgrep SAST primer](../semgrep/notes/0000-primer-semgrep.md)
- [Find SQL injection patterns with Semgrep (lesson)](../learn/03-shift-left/05-semgrep-sast.md)
- [Follow tainted data with CodeQL (lesson)](../learn/03-shift-left/06-codeql-dataflow.md)
- [CodeQL semantic analysis primer](../codeql/notes/0000-primer-codeql.md)
- [SonarQube quality and security primer](../sonarqube/notes/0000-primer-sonarqube.md)
- [OWASP ZAP DAST primer](../zap/notes/0000-primer-zap.md)
- [Nuclei template scanner primer](../nuclei/notes/0000-primer-nuclei.md)
- [Snyk dependency and container security primer](../snyk/notes/0000-primer-snyk.md)

### Build and sign container images

- [Docker primer](../docker/notes/0000-primer-docker.md)
- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)
- [Multi-service Docker Compose app](../docker/scripts/build-multi-service-compose-app.sh)
- [Docker Compose production manifest](../docker/manifests/docker-compose-production.yaml)
- [Cosign container signing primer](../cosign/notes/0000-primer-cosign.md)
- [Sign the image and attach the SBOM with Cosign (lesson)](../learn/03-shift-left/12-cosign-sign.md)
- [Install Cosign and run a first signing command](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md)
- [Sign and verify an image (snippet)](../cosign/snippets/first-cosign-sign-verify-image.sh)
- [Cosign verification patterns](../cosign/docs/cosign-verification-patterns.md)
- [Cosign key management workflow](../cosign/scripts/cosign-key-management-workflow.sh)
- [Container signing pipeline integration](../cosign/docs/container-signing-pipeline.md)

### Set up CI/CD and GitOps

- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md)
- [Minimal starter workflow](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml)
- [Run your first workflow](../github-actions/notes/2026-10-14-run-first-workflow.md)
- [Trigger a workflow with the gh CLI](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh)
- [Sample app CI workflow (shift-left)](../github-actions/configs/sample-app-ci.yml)
- [Keep dependencies patched with Dependabot (lesson)](../learn/03-shift-left/08-dependabot-updates.md)
- [Dependabot automated updates primer](../dependabot/notes/0000-primer-dependabot.md)
- [Dependabot configuration template](../dependabot/configs/dependabot-configuration-template.yaml)
- [Argo CD GitOps primer](../argocd/notes/0000-primer-argocd.md)
- [Argo CD Helm guestbook application](../argocd/manifests/helm-guestbook-application.yaml)
- [Argo CD app-of-apps multi-env scaffold](../argocd/templates/app-of-apps-multienv/README.md)

### Manage Kubernetes clusters

- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md)
- [First pod and service manifest](../kubernetes/manifests/2026-07-15-first-pod-service.yaml)
- [Minimal namespace config](../kubernetes/configs/2026-10-14-minimal-namespace.yaml)
- [Cluster workflow wiring](../kubernetes/docs/cluster-workflow-wiring.md)
- [Kubernetes bootstrap scaffold](../kubernetes/templates/cluster-bootstrap/README.md)
- [Helm package manager primer](../helm/notes/0000-primer-helm.md)
- [Helm wired into a release workflow](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- [Kustomize YAML customization primer](../kustomize/notes/0000-primer-kustomize.md)

### Write and test infrastructure code

- [Terraform primer](../terraform/notes/0000-primer-terraform.md)
- [Small Terraform module from scratch](../terraform/configs/small-module-from-scratch.hcl)
- [Terraform module composition](../terraform/docs/terraform-module-composition.md)
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md)
- [OpenTofu vs Terraform migration decision matrix](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md)
- [Ansible primer context (trip-ups)](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md)
- [Ansible bootstrap target node](../ansible/scripts/bootstrap-target-node.sh)
- [Ansible infrastructure workflow](../ansible/docs/wired-ansible-infrastructure-workflow.md)

### Manage secrets and access

- [Vault secrets management primer](../vault/notes/0000-primer-vault.md)
- [Vault KV CRUD operations](../vault/scripts/vault-kv-crud.sh)
- [Vault PKI workflow](../vault/scripts/vault-pki-workflow.sh)
- [Vault secrets engine selection guide](../vault/docs/vault-secrets-engine-selection-guide.md)
- [Vault Agent auto-auth on Kubernetes](../vault/docs/vault-agent-auto-auth-kubernetes.md)
- [Secrets access patterns (concept)](../docs/concepts/secrets-access-management/scripts/vault-secrets-access-patterns.sh)

### Monitor and observe systems

- [Prometheus metrics primer](../prometheus/notes/0000-primer-prometheus.md)
- [Prometheus first query log](../prometheus/notes/2026-10-14-first-query-log.md)
- [Grafana dashboard primer](../grafana/notes/0000-primer-grafana.md)
- [Grafana dashboard provisioning](../grafana/configs/2026-10-14-dashboard-provisioning.yaml)
- [Grafana first datasource query](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- [Falco runtime security primer](../falco/notes/0000-primer-falco.md)
- [Tetragon eBPF runtime primer](../tetragon/notes/0000-primer-tetragon.md)

### Triage findings and respond

- [DefectDojo vulnerability management primer](../defectdojo/notes/0000-primer-defectdojo.md)
- [Bring all findings together in DefectDojo (lesson)](../learn/03-shift-left/14-defectdojo-findings.md)
- [Wired DefectDojo into triage workflow](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md)
- [Product and scan import script](../defectdojo/scripts/product-scan-import.py)
- [Flatted CVE-2026-33228 runbook](../docs/runbooks/cve-2026-33228-ansible-flatted.md)
- [Kaniko CVE-2026-28406 how-to](../docs/how-to/docker-kaniko-cve-2026-28406.md)

### Manage environments and assets

- [Managing environments guide](../environments/docs/managing-environments.md)
- [Environment promotion script](../environments/scripts/promote-environment.sh)
- [Asset tracking config](../assets/configs/asset-tracking-config.yaml)
- [Assets CI/CD pipeline wiring](../assets/docs/how-i-wired-assets-into-ci-cd-pipeline.md)
- [Asset inventory collector](../assets/scripts/asset-inventory-collector.py)
