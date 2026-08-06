# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Trivy · 25 files
- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (3): most recent → [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md), [2026-05-26-trivy-quickstart.md](../trivy/notes/2026-05-26-trivy-quickstart.md), [2026-05-24-install-trivy.md](../trivy/notes/2026-05-24-install-trivy.md)
- **scripts** (5): [container-vuln-scan.sh](../trivy/scripts/container-vuln-scan.sh), [image-vuln-pipeline.sh](../trivy/scripts/image-vuln-pipeline.sh), [multi-target-scanner.sh](../trivy/scripts/multi-target-scanner.sh), [compose-multi-scan.sh](../trivy/scripts/compose-multi-scan.sh), [custom-trivy-check-conftest.sh](../trivy/scripts/custom-trivy-check-conftest.sh)
- **docs** (3): [ci-pipeline-sarif-output.md](../trivy/docs/ci-pipeline-sarif-output.md), [sbom-scanning-reference-guide.md](../trivy/docs/sbom-scanning-reference-guide.md)
- _…and more under `trivy/` — browse the folder._

## TruffleHog · 37 files
- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (3): most recent → [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md), [2026-05-27-following-trufflehog-quickstart.md](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md), [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md)
- **snippets** (2): [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh), [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- **templates** (21): [secret-scanning-pipeline](../trufflehog/templates/secret-scanning-pipeline/), [multi-repo-secret-scan](../trufflehog/templates/multi-repo-secret-scan/), [github-secret-scanning-integration](../trufflehog/templates/github-secret-scanning-integration/)
- _…and more under `trufflehog/` — browse the folder._

## ZAP · 33 files
- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (5): most recent → [0000-primer-zap.md](../zap/notes/0000-primer-zap.md), [2026-07-20-install-zap-baseline-scan.md](../zap/notes/2026-07-20-install-zap-baseline-scan.md), [2026-06-13-spider-scan-test-app.md](../zap/notes/2026-06-13-spider-scan-test-app.md)
- **scripts** (2): [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh), [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh)
- **templates** (16): [zap-dast-integration-scaffold](../zap/templates/zap-dast-integration-scaffold/), [zap-dast-integration](../zap/templates/zap-dast-integration/)
- _…and more under `zap/` — browse the folder._

## Checkov · 32 files
- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md), [2026-05-27-checkov-quickstart-trip-ups.md](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md)
- **scripts** (2): [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh), [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh)
- **templates** (10): [multi-iac-scan-project](../checkov/templates/multi-iac-scan-project/), [reusable-workflow-custom-policies](../checkov/templates/reusable-workflow-custom-policies/)
- _…and more under `checkov/` — browse the folder._

## Syft · 24 files
- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (4): most recent → [0000-primer-syft.md](../syft/notes/0000-primer-syft.md), [2026-05-30-sbom-format-comparison.md](../syft/notes/2026-05-30-sbom-format-comparison.md), [2026-05-29-syft-quickstart-trip-ups.md](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)
- **scripts** (3): [gen-multi-format-sboms.sh](../syft/scripts/gen-multi-format-sboms.sh), [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh), [sbom-vuln-pipeline.sh](../syft/scripts/sbom-vuln-pipeline.sh)
- **templates** (7): [sbom-pipeline-scaffold](../syft/templates/sbom-pipeline-scaffold/)
- **notebooks** (1): [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb)
- _…and more under `syft/` — browse the folder._

## Grype · 20 files
- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **scripts** (8): [minimal-grype-scan.sh](../grype/scripts/minimal-grype-scan.sh), [ci-ready-grype-scan.sh](../grype/scripts/ci-ready-grype-scan.sh), [grype-end-to-end-scan-pipeline.sh](../grype/scripts/grype-end-to-end-scan-pipeline.sh), [grype-scan-pipeline-end-to-end.sh](../grype/scripts/grype-scan-pipeline-end-to-end.sh)
- **manifests** (2): [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml), [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml)
- **notebooks** (1): [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb)
- _…and more under `grype/` — browse the folder._

## Semgrep · 18 files
- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md), [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md)
- **scripts** (3): [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh), [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py), [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py)
- **manifests** (2): [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml), [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml)
- **notebooks** (1): [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)
- _…and more under `semgrep/` — browse the folder._

## Terraform · 17 files
- **primer:** [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **notes** (3): most recent → [2026-08-04-install-terraform-first-vm.md](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md), [2026-07-15-explore-terraform.md](../terraform/notes/2026-07-15-explore-terraform.md)
- **scripts** (4): [2026-07-13-zip-build.sh](../terraform/scripts/2026-07-13-zip-build.sh), [2026-07-18-cleanup.sh](../terraform/scripts/2026-07-18-cleanup.sh), [2026-07-18-deploy.sh](../terraform/scripts/2026-07-18-deploy.sh), [state-management-workflow.sh](../terraform/scripts/state-management-workflow.sh)
- **configs** (2): [2026-08-04-first-configuration.hcl](../terraform/configs/2026-08-04-first-configuration.hcl), [2026-07-15-first-config.tf](../terraform/configs/2026-07-15-first-config.tf)
- **snippets** (1): [2026-07-20-practice-terraform-variables-outputs-datasources.hcl](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- _…and eventbridge-lambda module content under `terraform/` — browse the folder._

## CodeQL · 12 files
- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (3): [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md), [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md)
- **snippets** (4): [find-hardcoded-creds.ql](../codeql/snippets/find-hardcoded-creds.ql), [my-first-codeql-commands.sh](../codeql/snippets/my-first-codeql-commands.sh), [hardcoded-creds-local-flow.ql](../codeql/snippets/hardcoded-creds-local-flow.ql), [hardcoded-secret-from-scratch.ql](../codeql/snippets/hardcoded-secret-from-scratch.ql)
- _…and more under `codeql/` — browse the folder._

## GitGuardian · 11 files
- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (4): [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md), [2026-06-14-first-secrets-scan-repo.md](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md), [2026-06-13-ggshield-quickstart-trip-ups.md](../gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md)
- **scripts** (2): [pre-commit-hook-ggshield.sh](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh)
- **snippets** (2): [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh), [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- _…and more under `gitguardian/` — browse the folder._

## Vault · 11 files
- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (3): [0000-primer-vault.md](../vault/notes/0000-primer-vault.md), [2026-06-15-vault-getting-started-trip-ups.md](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md), [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
- **scripts** (2): [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh), [vault-db-dynamic-secrets.sh](../vault/scripts/vault-db-dynamic-secrets.sh)
- **docs** (2): [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md), [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md)
- _…and more under `vault/` — browse the folder._

## Snyk · 10 files
- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (4): [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md), [2026-06-14-first-vulnerability-scan.md](../snyk/notes/2026-06-14-first-vulnerability-scan.md), [2026-06-08-install-snyk-first-test.md](../snyk/notes/2026-06-08-install-snyk-first-test.md), [2026-06-07-snyk-quickstart-walkthrough.md](../snyk/notes/2026-06-07-snyk-quickstart-walkthrough.md)
- **dockerfiles** (1): [custom-snyk-cli-air-gapped.Dockerfile](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- _…and more under `snyk/` — browse the folder._

## OPA · 9 files
- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (3): [0000-primer-opa.md](../opa/notes/0000-primer-opa.md), [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md), [2026-06-06-install-opa-repl.md](../opa/notes/2026-06-06-install-opa-repl.md)
- **snippets** (3): [my-first-opa-policy-eval.sh](../opa/snippets/my-first-opa-policy-eval.sh), [enforce-image-registry-constraints.rego](../opa/snippets/enforce-image-registry-constraints.rego), [deny-privileged-hostnetwork.rego](../opa/snippets/deny-privileged-hostnetwork.rego)
- _…and more under `opa/` — browse the folder._

## Cosign · 9 files
- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (4): [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md), [2026-06-22-cosign-getting-started-trip-ups.md](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md), [2026-06-13-install-cosign-sign-first-image.md](../cosign/notes/2026-06-13-install-cosign-sign-first-image.md)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (1): [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)
- _…and more under `cosign/` — browse the folder._

## Terrascan · 9 files
- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **snippets** (2): [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf), [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf)
- _…and more under `terrascan/` — browse the folder._

## Dependabot · 10 files
- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (6): most recent → [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md), [dependabot-alerts-security-updates.md](../dependabot/notes/dependabot-alerts-security-updates.md), [2026-07-21-enabling-dependabot-alerts-security-updates.md](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md)
- **configs** (3): [tried-npm-dependabot.yaml](../dependabot/configs/tried-npm-dependabot.yaml), [2026-07-18-python-project-version-update.yaml](../dependabot/configs/2026-07-18-python-project-version-update.yaml), [2026-07-10-npm-version-strategy.yaml](../dependabot/configs/2026-07-10-npm-version-strategy.yaml)

## DefectDojo · 3 files
- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (2): [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md), [2026-08-04-explore-defectdojo-ui.md](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md)
- **snippets** (1): [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)

## Docker · 8 files
- **notes** (2): [0000-primer-docker.md](../docker/notes/0000-primer-docker.md), [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md)
- **scripts** (2): [build-multi-service-compose-app.sh](../docker/scripts/build-multi-service-compose-app.sh), [2026-07-18-custom-network-volume-mounts.sh](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh)
- **dockerfiles** (2): [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile), [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile)
- **configs** (1): [docker-compose-dev-environment.yaml](../docker/configs/docker-compose-dev-environment.yaml)
- **docs** (1): [dockerfile-optimization-patterns.md](../docker/docs/dockerfile-optimization-patterns.md)

## Falco · 13 files
- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (4): [0000-primer-falco.md](../falco/notes/0000-primer-falco.md), [2026-06-10-install-falco-first-detection.md](../falco/notes/2026-06-10-install-falco-first-detection.md), [2026-06-15-falco-rules-macros-lists.md](../falco/notes/2026-06-15-falco-rules-macros-lists.md)
- **scripts** (3): [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh), [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh)
- **configs** (3): [first-custom-rule-detect-shell-in-container.yaml](../falco/configs/first-custom-rule-detect-shell-in-container.yaml), [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml), [2026-06-10-first-custom-rule-detect-shell-in-container.yaml](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml)
- **docs** (2): [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md), [tuned-falco-rules-noise-reduction.md](../falco/docs/tuned-falco-rules-noise-reduction.md)
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)

## Git · 6 files
- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (3): [0000-primer-git.md](../git/notes/0000-primer-git.md), [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md), [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md)
- **scripts** (2): [2026-07-10-local-ci-simulation.sh](../git/scripts/2026-07-10-local-ci-simulation.sh), [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## ArgoCD · 6 files
- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (5): [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md), [2026-07-25-readme-layout.md](../argocd/notes/2026-07-25-readme-layout.md)
- **manifests** (1): [2026-07-06-sample-app-application.yaml](../argocd/manifests/2026-07-06-sample-app-application.yaml)

## GitHub Actions · 7 files
- **primer:** [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (3): [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md), [2026-07-14-explore-github-actions.md](../github-actions/notes/2026-07-14-explore-github-actions.md), [2026-08-04-explore-github-actions.md](../github-actions/notes/2026-08-04-explore-github-actions.md)
- **configs** (2): [2026-07-14-first-github-actions-workflow.yaml](../github-actions/configs/2026-07-14-first-github-actions-workflow.yaml), [2026-08-04-first-workflow.yaml](../github-actions/configs/2026-08-04-first-workflow.yaml)
- **manifests** (2): [2026-08-04-pr-validation.yml](../github-actions/manifests/2026-08-04-pr-validation.yml), [2026-08-04-what-is-github-actions.yaml](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml)

## Helm · 3 files
- **primer:** [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **notes** (2): [0000-primer-helm.md](../helm/notes/0000-primer-helm.md), [2026-07-19-explore-helm-charts-releases-values-repos.md](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md)
- **manifests** (1): [2026-07-15-first-chart-values.yaml](../helm/manifests/2026-07-15-first-chart-values.yaml)

## Kubernetes · 3 files
- **primer:** [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (2): [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md), [2026-07-15-explore-kubernetes.md](../kubernetes/notes/2026-07-15-explore-kubernetes.md)
- **manifests** (1): [2026-07-15-first-pod-service.yaml](../kubernetes/manifests/2026-07-15-first-pod-service.yaml)

## Kustomize · 3 files
- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (2): [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md), [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md)
- **configs** (1): [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml)

## Ansible · 2 files
- **scripts** (2): [2026-08-04-bootstrap-node.sh](../ansible/scripts/2026-08-04-bootstrap-node.sh), [bootstrap-target-node.sh](../ansible/scripts/bootstrap-target-node.sh)
- _browse `ansible/` for more._

## Linux · 1 file
- **notes** (1): [2026-07-21-install-linux-vm-terminal-first-commands.md](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)

## lin · 2 files
- **notes** (1): [2026-08-06-linux-shell-scripting-tutorial-confusions.md](../lin/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md)
- **configs** (1): [2026-08-06-cron-job-configuration.ini](../lin/configs/2026-08-06-cron-job-configuration.ini)

## Grafana · 1 file
- **notes** (1): [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)

## Observability · 1 file
- **notes** (1): [0000-primer-observability.md](../observability/notes/0000-primer-observability.md)

## Prometheus · 1 file
- **notes** (1): [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md)

## SonarQube · 3 files
- **primer:** [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (2): [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md), [2026-07-19-explore-sonarqube-quality-gates-profiles.md](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md)
- **snippets** (1): [2026-07-16-first-sonarscanner-run.sh](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## OpenTofu · 3 files
- **primer:** [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (2): [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md), [2026-07-20-explore-open-tofu.md](../opentofu/notes/2026-07-20-explore-open-tofu.md)
- **configs** (1): [2026-07-20-first-open-tofu-config.hcl](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## Tetragon · 6 files
- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (3): most recent → [2026-08-06-tetragon-observability-tutorial.md](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md), [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md)
- **configs** (2): [2026-08-05-minimal-network-tracing-policy.yaml](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml), [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml)
- **scripts** (1): [2026-08-05-tetragon-event-collection-pipeline.sh](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- _…and more under `tetragon/` — browse the folder._

## Lab · 10 files
- **mini-projects**: [terraform-project](../lab/mini-projects/terraform-project/README.md), [postgresql-database-server](../lab/mini-projects/postgresql-database-server/README.md), [samba-enterprise-file-sharing](../lab/mini-projects/samba-enterprise-file-sharing/README.md)
- _browse `lab/` for more._

---

## Cross-cutting content

These directories cut across every tool above. Browse the folders for the full set.

## Docs · 182 files
- **concepts** (32): foundational primers — [application-security-testing](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md), [ci-cd-pipeline](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md), [configuration-management](../docs/concepts/configuration-management/0000-primer-configuration-management.md), [infrastructure-as-code](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md), [secrets-access-management](../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md), [linux-shell-fundamentals](../docs/concepts/linux-shell-fundamentals/0000-primer-linux-shell-fundamentals.md) … _and more under `docs/concepts/`._
- **how-to** — [kubernetes toolkit](../docs/how-to/k8s_toolkit.md), [linux toolkit](../docs/how-to/linux_toolkit.md), [jenkins toolkit](../docs/how-to/jenkins_toolkit.md), [ansible toolkit](../docs/how-to/ansible_toolkit.md), [vault toolkit](../docs/how-to/vault_toolkit.md) … _browse `docs/how-to/`._
- **reference** (git & jenkins commands), **runbooks**, **security**, **troubleshooting**, **setup-guides** — _browse `docs/`._

## Scripts · 190 files
- **bash toolkits**: [ansible](../scripts/bash/ansible_toolkit/), [docker](../scripts/bash/docker_toolkit/), [k8s](../scripts/bash/k8s_toolkit/), [linux](../scripts/bash/linux_toolkit/), [terraform](../scripts/bash/terraform_toolkit/), [vault](../scripts/bash/vault_toolkit/), [jenkins](../scripts/bash/jenkins_toolkit/), [git](../scripts/bash/git/), [observability](../scripts/bash/observability_toolkit/), [helm](../scripts/bash/helm_toolkit/), [kafka](../scripts/bash/kafka_toolkit/), [oci-registry](../scripts/bash/oci_registry_toolkit/), [ci-cd](../scripts/bash/ci_cd_toolkit/), [harbor](../scripts/bash/harbor/), [argo](../scripts/bash/argo_toolkit/), [flux](../scripts/bash/flux_toolkit/), [azure](../scripts/bash/azure_toolkit/) … _browse `scripts/bash/`._

## Snippets · 17 files
- cheatsheets: [terraform-commands](../snippets/terraform-commands.md), [kubectl-cheatsheet](../snippets/kubectl-cheatsheet.md), [git-commands](../snippets/git-commands.md), [docker-commands](../snippets/docker-commands.md), [jenkins-cheatsheet](../snippets/jenkins-cheatsheet.md), [linux-cheatsheet](../snippets/linux-cheatsheet.md), [kafka-cheatsheet](../snippets/kafka-cheatsheet.md), [observability-cheatsheet](../snippets/observability-cheatsheet.md), [oci-registry-cheatsheet](../snippets/oci-registry-cheatsheet.md), [vault-commands](../snippets/vault-commands.md), [ci-cd-cheatsheet](../snippets/ci-cd-cheatsheet.md) … _browse `snippets/`._

## Templates · 32 files
- [k8s](../templates/k8s/), [terraform](../templates/terraform/), [jenkins](../templates/jenkins/), [linux-automation](../templates/linux-automation/), [logstash](../templates/logstash/), [syslog-ng](../templates/syslog-ng/) … _browse `templates/`._

## Environments · 12 files
- Terraform environment configs: [dev](../environments/dev/), [staging](../environments/staging/), [prod](../environments/prod/)

## Assets · 4 files
- Architecture diagrams and workflow illustrations: [architecture-overview](../assets/architecture-overview.png), [cicd-workflow](../assets/cicd-workflow.png), [devsecops-pipeline](../assets/devsecops-pipeline.png)