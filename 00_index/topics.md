# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## docs · 221 files
- **notes** (4): [2026-08-23-spurious-script-reference-cleanup.md](../docs/notes/2026-08-23-spurious-script-reference-cleanup.md), [2026-08-19-workflow-stubs-review.md](../docs/notes/2026-08-19-workflow-stubs-review.md), [2026-08-17-spurious-placeholder-cleanup.md](../docs/notes/2026-08-17-spurious-placeholder-cleanup.md)
- _…and 1 more under `docs/notes/` — browse the folder._
- **concepts** (5): [git-version-control-mental-model.md](../docs/concepts/git-version-control-mental-model.md), [git-005-configuration-aliases.md](../docs/concepts/git-005-configuration-aliases.md), [git-003-workflow.md](../docs/concepts/git-003-workflow.md)
- _…and 2 more under `docs/concepts/` — browse the folder._
- **how-to** (92): [vault_toolkit.md](../docs/how-to/vault_toolkit.md), [vault-troubleshooting-seal-unseal.md](../docs/how-to/vault-troubleshooting-seal-unseal.md), [vault-secure-deployment.md](../docs/how-to/vault-secure-deployment.md)
- _…and 89 more under `docs/how-to/` — browse the folder._
- **reference** (9): [jenkins-secret-masking-envinject.md](../docs/reference/jenkins-secret-masking-envinject.md), [jenkins-rest-api.md](../docs/reference/jenkins-rest-api.md), [jenkins-pipeline-retry-strategy.md](../docs/reference/jenkins-pipeline-retry-strategy.md)
- _…and 6 more under `docs/reference/` — browse the folder._
- **runbooks** (2): [linux-system-administration.md](../docs/runbooks/linux-system-administration.md), [cve-2026-33228-ansible-flatted.md](../docs/runbooks/cve-2026-33228-ansible-flatted.md)
- **security** (1): [git-security-access-control-authentication.md](../docs/security/git-security-access-control-authentication.md)
- **setup-guides** (4): [kafka-cluster-setup.md](../docs/setup-guides/kafka-cluster-setup.md), [git-github-actions-runner.md](../docs/setup-guides/git-github-actions-runner.md), [git-credential-helper-ci-cd.md](../docs/setup-guides/git-credential-helper-ci-cd.md)
- _…and 1 more under `docs/setup-guides/` — browse the folder._
- **troubleshooting** (6): [vault-seal-unseal.md](../docs/troubleshooting/vault-seal-unseal.md), [kubernetes-mcp-server-cve-2026-39884.md](../docs/troubleshooting/kubernetes-mcp-server-cve-2026-39884.md), [kafka-consumer-lag.md](../docs/troubleshooting/kafka-consumer-lag.md)
- _…and 3 more under `docs/troubleshooting/` — browse the folder._

## scripts · 196 files
- **notes** (4): [2026-10-15-shell-quickstart-trip-ups.md](../scripts/notes/2026-10-15-shell-quickstart-trip-ups.md), [2026-10-14-lib-claim-fix.md](../scripts/notes/2026-10-14-lib-claim-fix.md), [2026-09-20-explore-scripts-directory.md](../scripts/notes/2026-09-20-explore-scripts-directory.md)
- _…and 1 more under `scripts/notes/` — browse the folder._
- **configs** (1): [2026-10-18-shared-script-config.yaml](../scripts/configs/2026-10-18-shared-script-config.yaml)
- **snippets** (2): [2026-10-15-kit-helper-logging-retry.sh](../scripts/snippets/2026-10-15-kit-helper-logging-retry.sh), [2026-09-20-first-utility-script.sh](../scripts/snippets/2026-09-20-first-utility-script.sh)
- **pipeline** (2): [rollback.sh](../scripts/pipeline/rollback.sh), [deploy.sh](../scripts/pipeline/deploy.sh)

## trufflehog · 51 files
- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (4): [2026-07-27-explore-cli.md](../trufflehog/notes/2026-07-27-explore-cli.md), [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md), [2026-05-27-following-trufflehog-quickstart.md](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md)
- _…and 1 more under `trufflehog/notes/` — browse the folder._
- **docs** (4): [trufflehog-secrets-database-migration-guide.md](../trufflehog/docs/trufflehog-secrets-database-migration-guide.md), [trufflehog-output-formats-json-sarif-csv.md](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md), [trufflehog-integration-reference-secret-detection.md](../trufflehog/docs/trufflehog-integration-reference-secret-detection.md)
- _…and 1 more under `trufflehog/docs/` — browse the folder._
- **scripts** (3): [pre-commit-scan-pipeline.sh](../trufflehog/scripts/pre-commit-scan-pipeline.sh), [multi-repo-scan-pipeline.sh](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [analyze-trufflehog-results.py](../trufflehog/scripts/analyze-trufflehog-results.py)
- **configs** (2): [trufflehog-custom-regex-config.yaml](../trufflehog/configs/trufflehog-custom-regex-config.yaml), [custom-detector-rules.yaml](../trufflehog/configs/custom-detector-rules.yaml)
- **snippets** (3): [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh), [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh), [2026-10-14-first-secret-scan.sh](../trufflehog/snippets/2026-10-14-first-secret-scan.sh)
- **manifests** (2): [trufflehog-pr-secret-scan-reusable.yaml](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml), [trufflehog-cicd-pipeline.yaml](../trufflehog/manifests/trufflehog-cicd-pipeline.yaml)
- **dockerfiles** (2): [pre-commit-scanner.Dockerfile](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile), [pipeline-scanner.Dockerfile](../trufflehog/dockerfiles/pipeline-scanner.Dockerfile)
- **notebooks** (3): [trufflehog-scan-modes-comparison.ipynb](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb), [detector-comparison-patterns.ipynb](../trufflehog/notebooks/detector-comparison-patterns.ipynb), [analyzing-trufflehog-false-positives.ipynb](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)

## checkov · 45 files
- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [2026-05-27-checkov-quickstart-trip-ups.md](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md), [2026-05-26-cli-vs-sdk-comparison.md](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [2026-05-25-scan-terraform-plan.md](../checkov/notes/2026-05-25-scan-terraform-plan.md)
- _…and 1 more under `checkov/notes/` — browse the folder._
- **docs** (6): [pre-commit-hook-with-version-pinning.md](../checkov/docs/pre-commit-hook-with-version-pinning.md), [multi-cloud-policy-management.md](../checkov/docs/multi-cloud-policy-management.md), [checkov-v3-upgrade-checklist.md](../checkov/docs/checkov-v3-upgrade-checklist.md)
- _…and 3 more under `checkov/docs/` — browse the folder._
- **scripts** (4): [validate-policies.sh](../checkov/scripts/validate-policies.sh), [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh), [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh)
- _…and 1 more under `checkov/scripts/` — browse the folder._
- **configs** (3): [platform-config.yaml](../checkov/configs/platform-config.yaml), [checkov-skip-severity-config.yaml](../checkov/configs/checkov-skip-severity-config.yaml), [checkov-ci-config.yaml](../checkov/configs/checkov-ci-config.yaml)
- **snippets** (4): [terraform-scan-custom-policies.py](../checkov/snippets/terraform-scan-custom-policies.py), [scan-terraform-dir.py](../checkov/snippets/scan-terraform-dir.py), [scan-kubernetes.sh](../checkov/snippets/scan-kubernetes.sh)
- _…and 1 more under `checkov/snippets/` — browse the folder._
- **manifests** (3): [layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml), [checkov-sarif-pr-blocking.yaml](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [checkov-gitlab-ci-multi-cloud-drift.yaml](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml)
- **notebooks** (4): [compare-static-vs-plan-scanning.ipynb](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb), [compare-custom-policy-expressiveness.ipynb](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb), [compare-cross-module-scanning-limitations.ipynb](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb)
- _…and 1 more under `checkov/notebooks/` — browse the folder._

## templates · 45 files
- **primer:** [0000-primer-templates.md](../templates/notes/0000-primer-templates.md)
- **notes** (2): [2026-10-19-templates-quickstart.md](../templates/notes/2026-10-19-templates-quickstart.md)
- _…and 1 more under `templates/notes/` — browse the folder._
- **docs** (1): [2026-10-19-linux-automation-deploy-path.md](../templates/docs/2026-10-19-linux-automation-deploy-path.md)
- **scripts** (1): [template-catalog-validator.py](../templates/scripts/template-catalog-validator.py)
- **configs** (3): [flat-vs-cookiecutter-variable-profiles.yaml](../templates/configs/flat-vs-cookiecutter-variable-profiles.yaml), [2026-10-19-template-index-config.yaml](../templates/configs/2026-10-19-template-index-config.yaml), [2026-09-20-first-template-variables.yaml](../templates/configs/2026-09-20-first-template-variables.yaml)
- **snippets** (1): [2026-10-19-minimal-template-snippet.py](../templates/snippets/2026-10-19-minimal-template-snippet.py)
- **jenkins** (1): [Jenkinsfile-maven-gradle-template.md](../templates/jenkins/Jenkinsfile-maven-gradle-template.md)
- **k8s** (3): [production-deployment.yaml](../templates/k8s/production-deployment.yaml), [deployment-monitor.sh](../templates/k8s/deployment-monitor.sh), [deploy-prod-app.sh](../templates/k8s/deploy-prod-app.sh)
- **linux-automation** (5): [systemd-service.j2](../templates/linux-automation/systemd-service.j2), [inventory.yml](../templates/linux-automation/inventory.yml), [group_vars.yml](../templates/linux-automation/group_vars.yml)
- _…and 2 more under `templates/linux-automation/` — browse the folder._
- **logstash** (1): [logstash.conf](../templates/logstash/logstash.conf)
- **syslog-ng** (1): [syslog-ng.conf](../templates/syslog-ng/syslog-ng.conf)
- **terraform** (1): [production-module-template.md](../templates/terraform/production-module-template.md)

## syft · 44 files
- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (5): [2026-10-27-first-image-sbom.md](../syft/notes/2026-10-27-first-image-sbom.md), [2026-05-30-sbom-format-comparison.md](../syft/notes/2026-05-30-sbom-format-comparison.md), [2026-05-29-syft-quickstart-trip-ups.md](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)
- _…and 2 more under `syft/notes/` — browse the folder._
- **docs** (8): [syft-integration-reference.md](../syft/docs/syft-integration-reference.md), [syft-format-migration-guide.md](../syft/docs/syft-format-migration-guide.md), [sbom-output-formats-reference.md](../syft/docs/sbom-output-formats-reference.md)
- _…and 5 more under `syft/docs/` — browse the folder._
- **scripts** (5): [syft-sbom-generation.py](../syft/scripts/syft-sbom-generation.py), [sbom-vuln-pipeline.sh](../syft/scripts/sbom-vuln-pipeline.sh), [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh)
- _…and 2 more under `syft/scripts/` — browse the folder._
- **configs** (1): [.syft.yaml](../syft/configs/.syft.yaml)
- **snippets** (3): [tried-sbom-formats.sh](../syft/snippets/tried-sbom-formats.sh), [2026-10-27-syft-cli-output-formats.sh](../syft/snippets/2026-10-27-syft-cli-output-formats.sh), [2026-10-14-first-sbom.sh](../syft/snippets/2026-10-14-first-sbom.sh)
- **manifests** (4): [syft-remote-state-backend-deployment.yaml](../syft/manifests/syft-remote-state-backend-deployment.yaml), [syft-gha-sbom-oci-push-attestation.yaml](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml), [syft-gha-multi-arch-sbom-registry-auth.yaml](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml)
- _…and 1 more under `syft/manifests/` — browse the folder._
- **dockerfiles** (1): [multi-stage-sbom.Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (4): [syft-format-comparison-patterns.ipynb](../syft/notebooks/syft-format-comparison-patterns.ipynb), [source-vs-library-multiarch.ipynb](../syft/notebooks/source-vs-library-multiarch.ipynb), [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb)
- _…and 1 more under `syft/notebooks/` — browse the folder._

## trivy · 40 files
- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (8): [scanning-performance-optimization.md](../trivy/notes/scanning-performance-optimization.md), [2026-10-19-trivy-first-image-scan.md](../trivy/notes/2026-10-19-trivy-first-image-scan.md), [2026-10-14-quickstart-trip-ups.md](../trivy/notes/2026-10-14-quickstart-trip-ups.md)
- _…and 5 more under `trivy/notes/` — browse the folder._
- **docs** (6): [trivy-integration-reference-container-scanning.md](../trivy/docs/trivy-integration-reference-container-scanning.md), [trivy-database-migration-guide.md](../trivy/docs/trivy-database-migration-guide.md), [sbom-scanning-reference-guide.md](../trivy/docs/sbom-scanning-reference-guide.md)
- _…and 3 more under `trivy/docs/` — browse the folder._
- **scripts** (6): [multi-target-scanner.sh](../trivy/scripts/multi-target-scanner.sh), [image-vuln-pipeline.sh](../trivy/scripts/image-vuln-pipeline.sh), [ignore-rules-pipeline.sh](../trivy/scripts/ignore-rules-pipeline.sh)
- _…and 3 more under `trivy/scripts/` — browse the folder._
- **configs** (4): [trivy-scan-config.yaml](../trivy/configs/trivy-scan-config.yaml), [trivy-ci-gate.yml](../trivy/configs/trivy-ci-gate.yml), [2026-10-19-minimal-trivy-config.yaml](../trivy/configs/2026-10-19-minimal-trivy-config.yaml)
- _…and 1 more under `trivy/configs/` — browse the folder._
- **snippets** (1): [scan-docker-image.sh](../trivy/snippets/scan-docker-image.sh)
- **manifests** (2): [trivy-sarif-code-scanning.yaml](../trivy/manifests/trivy-sarif-code-scanning.yaml), [trivy-operator-deployment.yaml](../trivy/manifests/trivy-operator-deployment.yaml)
- **dockerfiles** (1): [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy-scan-mode-comparison.ipynb](../trivy/notebooks/trivy-scan-mode-comparison.ipynb), [trivy-sarif-output-processing.ipynb](../trivy/notebooks/trivy-sarif-output-processing.ipynb)

## ansible · 34 files
- **notes** (3): [roles-vs-tasks.md](../ansible/notes/roles-vs-tasks.md), [2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md), [2026-08-17-verify-ansible-cve-2026-33228-paths.md](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md)
- **docs** (1): [wired-ansible-infrastructure-workflow.md](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **scripts** (5): [reusable-inventory-generator-from-terraform-outputs-for-ansible.py](../ansible/scripts/reusable-inventory-generator-from-terraform-outputs-for-ansible.py), [bootstrap.sh](../ansible/scripts/bootstrap.sh), [bootstrap-target-node.sh](../ansible/scripts/bootstrap-target-node.sh)
- _…and 2 more under `ansible/scripts/` — browse the folder._
- **configs** (3): [terraform-nginx-integration.yaml](../ansible/configs/terraform-nginx-integration.yaml), [small-ansible-project.yaml](../ansible/configs/small-ansible-project.yaml), [2026-09-15-inventory-groups-host-vars.yaml](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml)
- **snippets** (1): [2026-08-25-minimal-ansible-playbook-package-service.yaml](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)

## codeql · 32 files
- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (5): [2026-10-27-install-codeql-first-query.md](../codeql/notes/2026-10-27-install-codeql-first-query.md), [2026-08-26-install-codeql-first-query.md](../codeql/notes/2026-08-26-install-codeql-first-query.md), [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md)
- _…and 2 more under `codeql/notes/` — browse the folder._
- **docs** (4): [wired-custom-queries-into-ci.md](../codeql/docs/wired-custom-queries-into-ci.md), [query-writing-patterns-dataflow-javascript-typescript.md](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md), [codeql-integration-reference.md](../codeql/docs/codeql-integration-reference.md)
- _…and 1 more under `codeql/docs/` — browse the folder._
- **scripts** (2): [first-codeql-analysis.sh](../codeql/scripts/first-codeql-analysis.sh), [codeql-security-issue-detector.py](../codeql/scripts/codeql-security-issue-detector.py)
- **configs** (2): [first-codeql-analysis.yml](../codeql/configs/first-codeql-analysis.yml), [codeql-analysis-workflow.yaml](../codeql/configs/codeql-analysis-workflow.yaml)
- **snippets** (6): [my-first-codeql-commands.sh](../codeql/snippets/my-first-codeql-commands.sh), [hardcoded-secret-from-scratch.ql](../codeql/snippets/hardcoded-secret-from-scratch.ql), [hardcoded-creds-local-flow.ql](../codeql/snippets/hardcoded-creds-local-flow.ql)
- _…and 3 more under `codeql/snippets/` — browse the folder._
- **manifests** (3): [multi-language-codeql-analysis.yaml](../codeql/manifests/multi-language-codeql-analysis.yaml), [codeql-multi-language-scan.yaml](../codeql/manifests/codeql-multi-language-scan.yaml), [codeql-cicd-pipeline.yaml](../codeql/manifests/codeql-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom-codeql-analysis-image.Dockerfile](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **notebooks** (2): [compare-cli-vs-actions-scan-modes.ipynb](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb), [codeql-query-comparison-patterns.ipynb](../codeql/notebooks/codeql-query-comparison-patterns.ipynb)

## zap · 31 files
- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (6): [2026-09-05-install-zap-first-baseline-scan.md](../zap/notes/2026-09-05-install-zap-first-baseline-scan.md), [2026-07-20-install-zap-baseline-scan.md](../zap/notes/2026-07-20-install-zap-baseline-scan.md), [2026-06-13-spider-scan-test-app.md](../zap/notes/2026-06-13-spider-scan-test-app.md)
- _…and 3 more under `zap/notes/` — browse the folder._
- **docs** (5): [zap-scan-configuration-migration-guide.md](../zap/docs/zap-scan-configuration-migration-guide.md), [zap-integration-reference.md](../zap/docs/zap-integration-reference.md), [zap-integration-patterns.md](../zap/docs/zap-integration-patterns.md)
- _…and 2 more under `zap/docs/` — browse the folder._
- **scripts** (3): [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh), [zap-baseline-scan.sh](../zap/scripts/zap-baseline-scan.sh), [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh)
- **configs** (3): [zap-dast-github-actions-workflow.yaml](../zap/configs/zap-dast-github-actions-workflow.yaml), [zap-authenticated-scan-context.yaml](../zap/configs/zap-authenticated-scan-context.yaml), [ci-dast-automation-framework-plan.yaml](../zap/configs/ci-dast-automation-framework-plan.yaml)
- **snippets** (4): [my-first-zap-spider-scan.sh](../zap/snippets/my-first-zap-spider-scan.sh), [my-first-zap-baseline-scan.sh](../zap/snippets/my-first-zap-baseline-scan.sh), [authenticated-scan-with-context.sh](../zap/snippets/authenticated-scan-with-context.sh)
- _…and 1 more under `zap/snippets/` — browse the folder._
- **manifests** (1): [zap-cicd-pipeline.yaml](../zap/manifests/zap-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom-zap-automation.Dockerfile](../zap/dockerfiles/custom-zap-automation.Dockerfile)
- **notebooks** (1): [scan-strategy-comparison-patterns.ipynb](../zap/notebooks/scan-strategy-comparison-patterns.ipynb)

## opa · 30 files
- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (5): [2026-10-27-opa-install-first-policy.md](../opa/notes/2026-10-27-opa-install-first-policy.md), [2026-10-24-install-opa-first-policy-eval.md](../opa/notes/2026-10-24-install-opa-first-policy-eval.md), [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)
- _…and 2 more under `opa/notes/` — browse the folder._
- **docs** (4): [wired-opa-admission-control.md](../opa/docs/wired-opa-admission-control.md), [opa-policy-version-migration-patterns.md](../opa/docs/opa-policy-version-migration-patterns.md), [integrating-opa-with-policy-as-code-governance.md](../opa/docs/integrating-opa-with-policy-as-code-governance.md)
- _…and 1 more under `opa/docs/` — browse the folder._
- **scripts** (2): [how-i-test-policies-locally.sh](../opa/scripts/how-i-test-policies-locally.sh), [export-audit-results.sh](../opa/scripts/export-audit-results.sh)
- **configs** (2): [tried-a-gatekeeper-constraint.yaml](../opa/configs/tried-a-gatekeeper-constraint.yaml), [opa-policy-configuration-template.yaml](../opa/configs/opa-policy-configuration-template.yaml)
- **snippets** (4): [my-first-opa-policy-eval.sh](../opa/snippets/my-first-opa-policy-eval.sh), [enforce-image-registry-constraints.rego](../opa/snippets/enforce-image-registry-constraints.rego), [deny-privileged-hostnetwork.rego](../opa/snippets/deny-privileged-hostnetwork.rego)
- _…and 1 more under `opa/snippets/` — browse the folder._
- **manifests** (4): [gatekeeper-production-deployment.yaml](../opa/manifests/gatekeeper-production-deployment.yaml), [constraints.yaml](../opa/manifests/constraints.yaml), [constraint-templates.yaml](../opa/manifests/constraint-templates.yaml)
- _…and 1 more under `opa/manifests/` — browse the folder._
- **notebooks** (1): [rego-vs-builtin-policies.ipynb](../opa/notebooks/rego-vs-builtin-policies.ipynb)

## snyk · 29 files
- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (6): [2026-10-27-snyk-quickstart-tripped.md](../snyk/notes/2026-10-27-snyk-quickstart-tripped.md), [2026-10-07-explore-snyk-cli-commands.md](../snyk/notes/2026-10-07-explore-snyk-cli-commands.md), [2026-06-14-first-vulnerability-scan.md](../snyk/notes/2026-06-14-first-vulnerability-scan.md)
- _…and 3 more under `snyk/notes/` — browse the folder._
- **docs** (4): [vulnerability-prioritization-reachability-fix-prs-license-compliance.md](../snyk/docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md), [snyk-security-policy-migration-patterns.md](../snyk/docs/snyk-security-policy-migration-patterns.md), [multi-project-ci-pipeline.md](../snyk/docs/multi-project-ci-pipeline.md)
- _…and 1 more under `snyk/docs/` — browse the folder._
- **scripts** (2): [snyk-vuln-scan-pipeline.sh](../snyk/scripts/snyk-vuln-scan-pipeline.sh), [2026-10-20-first-snyk-test.sh](../snyk/scripts/2026-10-20-first-snyk-test.sh)
- **configs** (3): [snyk-project-configuration-template.yaml](../snyk/configs/snyk-project-configuration-template.yaml), [snyk-dependency-patch-ignore.yaml](../snyk/configs/snyk-dependency-patch-ignore.yaml), [snyk-ci-github-actions.yaml](../snyk/configs/snyk-ci-github-actions.yaml)
- **snippets** (1): [my-first-snyk-commands.sh](../snyk/snippets/my-first-snyk-commands.sh)
- **manifests** (1): [snyk-github-actions-cicd-workflow.yaml](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **dockerfiles** (1): [custom-snyk-cli-air-gapped.Dockerfile](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- **notebooks** (1): [cli-vs-api-modes.ipynb](../snyk/notebooks/cli-vs-api-modes.ipynb)

## terraform · 29 files
- **primer:** [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **notes** (3): [2026-08-04-install-terraform-first-vm.md](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [2026-07-15-explore-terraform.md](../terraform/notes/2026-07-15-explore-terraform.md)
- _…and 1 more under `terraform/notes/` — browse the folder._
- **docs** (2): [terraform-testing-patterns.md](../terraform/docs/terraform-testing-patterns.md), [terraform-module-composition.md](../terraform/docs/terraform-module-composition.md)
- **scripts** (4): [state-management-workflow.sh](../terraform/scripts/state-management-workflow.sh), [2026-07-18-deploy.sh](../terraform/scripts/2026-07-18-deploy.sh), [2026-07-18-cleanup.sh](../terraform/scripts/2026-07-18-cleanup.sh)
- _…and 1 more under `terraform/scripts/` — browse the folder._
- **configs** (6): [workspace-variable-precedence.hcl](../terraform/configs/workspace-variable-precedence.hcl), [small-module-from-scratch.hcl](../terraform/configs/small-module-from-scratch.hcl), [multi-environment-workspaces-variables.hcl](../terraform/configs/multi-environment-workspaces-variables.hcl)
- _…and 3 more under `terraform/configs/` — browse the folder._
- **snippets** (1): [2026-07-20-practice-terraform-variables-outputs-datasources.hcl](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- **manifests** (1): [terraform-cloud-workspace-automation.hcl](../terraform/manifests/terraform-cloud-workspace-automation.hcl)
- **eventbridge-lambda** (2): [variables.tf](../terraform/eventbridge-lambda/variables.tf), [main.tf](../terraform/eventbridge-lambda/main.tf)

## argocd · 28 files
- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (6): [2026-08-12-quickstart-tripups.md](../argocd/notes/2026-08-12-quickstart-tripups.md), [2026-08-01-verify-readme-layout.md](../argocd/notes/2026-08-01-verify-readme-layout.md), [2026-07-31-verify-readme-layout.md](../argocd/notes/2026-07-31-verify-readme-layout.md)
- _…and 3 more under `argocd/notes/` — browse the folder._
- **docs** (3): [multi-environment-gitops-delivery.md](../argocd/docs/multi-environment-gitops-delivery.md), [helm-kustomize-composition.md](../argocd/docs/helm-kustomize-composition.md), [gitops-workflow-wiring.md](../argocd/docs/gitops-workflow-wiring.md)
- **scripts** (1): [argocd-api-automation.sh](../argocd/scripts/argocd-api-automation.sh)
- **configs** (2): [2026-09-20-values-dev.yaml](../argocd/configs/2026-09-20-values-dev.yaml), [2026-08-17-private-repo-credentials-rbac.yaml](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- **manifests** (5): [helm-guestbook-application.yaml](../argocd/manifests/helm-guestbook-application.yaml), [application-set-with-matrix-generator.yaml](../argocd/manifests/application-set-with-matrix-generator.yaml), [2026-10-28-install.yaml](../argocd/manifests/2026-10-28-install.yaml)
- _…and 2 more under `argocd/manifests/` — browse the folder._

## gitguardian · 28 files
- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (6): [2026-10-27-quickstart-trip-ups.md](../gitguardian/notes/2026-10-27-quickstart-trip-ups.md), [2026-10-14-explore-interface.md](../gitguardian/notes/2026-10-14-explore-interface.md), [2026-06-14-first-secrets-scan-repo.md](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md)
- _…and 3 more under `gitguardian/notes/` — browse the folder._
- **docs** (4): [monorepo-ci-per-team-exclusions.md](../gitguardian/docs/monorepo-ci-per-team-exclusions.md), [gitguardian-secret-scanning-migration-patterns.md](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md), [gitguardian-incident-response-workflow.md](../gitguardian/docs/gitguardian-incident-response-workflow.md)
- _…and 1 more under `gitguardian/docs/` — browse the folder._
- **scripts** (4): [pre-commit-hook-ggshield.sh](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [gitguardian-api-integration.py](../gitguardian/scripts/gitguardian-api-integration.py), [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh)
- _…and 1 more under `gitguardian/scripts/` — browse the folder._
- **configs** (3): [policy-configuration.yaml](../gitguardian/configs/policy-configuration.yaml), [monorepo-allowlists.yaml](../gitguardian/configs/monorepo-allowlists.yaml), [.ggshield.yaml](../gitguardian/configs/.ggshield.yaml)
- **snippets** (2): [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh), [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- **notebooks** (1): [choosing-between-on-premise-and-cloud-modes.ipynb](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb)

## grype · 27 files
- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **notes** (5): [2026-10-14-explore-vulnerability-database.md](../grype/notes/2026-10-14-explore-vulnerability-database.md), [2026-06-08-first-grype-scan.md](../grype/notes/2026-06-08-first-grype-scan.md), [2026-06-04-grype-quickstart-trip-ups.md](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md)
- _…and 2 more under `grype/notes/` — browse the folder._
- **docs** (3): [vulnerability-management-pipeline-integration.md](../grype/docs/vulnerability-management-pipeline-integration.md), [grype-vulnerability-reporting-migration-patterns.md](../grype/docs/grype-vulnerability-reporting-migration-patterns.md), [grype-syft-integration-guide.md](../grype/docs/grype-syft-integration-guide.md)
- **scripts** (9): [vuln-diff-two-images.sh](../grype/scripts/vuln-diff-two-images.sh), [minimal-grype-scan.sh](../grype/scripts/minimal-grype-scan.sh), [grype-vuln-pipeline.sh](../grype/scripts/grype-vuln-pipeline.sh)
- _…and 6 more under `grype/scripts/` — browse the folder._
- **configs** (2): [grype-filtering-configuration-template.yaml](../grype/configs/grype-filtering-configuration-template.yaml), [grype-ci-github-actions.yaml](../grype/configs/grype-ci-github-actions.yaml)
- **snippets** (3): [my-first-grype-commands.sh](../grype/snippets/my-first-grype-commands.sh), [minimal-grype-scan.go](../grype/snippets/minimal-grype-scan.go), [2026-10-27-grype-filter-severity-formats.sh](../grype/snippets/2026-10-27-grype-filter-severity-formats.sh)
- **manifests** (2): [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml), [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml)
- **dockerfiles** (1): [multi-stage-grype-scan.Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (2): [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb), [grype-db-vs-registry-sources.ipynb](../grype/notebooks/grype-db-vs-registry-sources.ipynb)

## falco · 25 files
- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (6): [2026-10-27-follow-official-falco-quickstart.md](../falco/notes/2026-10-27-follow-official-falco-quickstart.md), [2026-10-15-install-falco-first-event.md](../falco/notes/2026-10-15-install-falco-first-event.md), [2026-07-19-explore-falco-cli-rules-events-output.md](../falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md)
- _…and 3 more under `falco/notes/` — browse the folder._
- **docs** (4): [tuned-falco-rules-noise-reduction.md](../falco/docs/tuned-falco-rules-noise-reduction.md), [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md), [runtime-security-monitoring-integration.md](../falco/docs/runtime-security-monitoring-integration.md)
- _…and 1 more under `falco/docs/` — browse the folder._
- **scripts** (3): [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh), [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh)
- **configs** (4): [first-custom-rule-detect-shell-in-container.yaml](../falco/configs/first-custom-rule-detect-shell-in-container.yaml), [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml), [2026-10-03-minimal-runtime-config.yaml](../falco/configs/2026-10-03-minimal-runtime-config.yaml)
- _…and 1 more under `falco/configs/` — browse the folder._
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)
- **manifests** (1): [falco-k8s-admission-control.yaml](../falco/manifests/falco-k8s-admission-control.yaml)
- **notebooks** (2): [rule-engine-vs-ebpf-probes.ipynb](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb), [falco-event-output-formats.ipynb](../falco/notebooks/falco-event-output-formats.ipynb)

## semgrep · 25 files
- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md)
- _…and 1 more under `semgrep/notes/` — browse the folder._
- **docs** (8): [semgrep-rules-migration-guide.md](../semgrep/docs/semgrep-rules-migration-guide.md), [semgrep-rule-writing-reference.md](../semgrep/docs/semgrep-rule-writing-reference.md), [semgrep-rule-performance-optimization.md](../semgrep/docs/semgrep-rule-performance-optimization.md)
- _…and 5 more under `semgrep/docs/` — browse the folder._
- **scripts** (3): [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh), [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py), [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py)
- **configs** (1): [multi-rule-pack.yaml](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [first-custom-rule.yaml](../semgrep/snippets/first-custom-rule.yaml), [catch-privileged-containers.yaml](../semgrep/snippets/catch-privileged-containers.yaml)
- **manifests** (3): [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml), [semgrep-ci-cd-pipeline.yaml](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml), [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml)
- **dockerfiles** (2): [custom-scanning-image.Dockerfile](../semgrep/dockerfiles/custom-scanning-image.Dockerfile), [ci-entrypoint.sh](../semgrep/dockerfiles/ci-entrypoint.sh)
- **notebooks** (3): [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb), [rule-matching-mode-comparison.ipynb](../semgrep/notebooks/rule-matching-mode-comparison.ipynb), [comparing-community-vs-custom-rules.ipynb](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb)

## environments · 23 files
- **primer:** [0000-primer-environments.md](../environments/notes/0000-primer-environments.md)
- **notes** (5): [2026-10-14-architecture-overview-claim-fix.md](../environments/notes/2026-10-14-architecture-overview-claim-fix.md), [2026-09-30-environments-quickstart-trip-ups.md](../environments/notes/2026-09-30-environments-quickstart-trip-ups.md), [2026-09-29-explore-environments-directory.md](../environments/notes/2026-09-29-explore-environments-directory.md)
- _…and 2 more under `environments/notes/` — browse the folder._
- **docs** (1): [managing-environments.md](../environments/docs/managing-environments.md)
- **scripts** (2): [promote-environment.sh](../environments/scripts/promote-environment.sh), [2026-10-01-validate-deploy-config.sh](../environments/scripts/2026-10-01-validate-deploy-config.sh)
- **configs** (2): [2026-09-30-minimal-environments-config.yaml](../environments/configs/2026-09-30-minimal-environments-config.yaml), [2026-09-19-first-variable-set.yaml](../environments/configs/2026-09-19-first-variable-set.yaml)
- **manifests** (1): [kubernetes-namespaces.yaml](../environments/manifests/kubernetes-namespaces.yaml)
- **dev** (4): [variables.tf](../environments/dev/variables.tf), [terraform.tfvars](../environments/dev/terraform.tfvars), [outputs.tf](../environments/dev/outputs.tf)
- _…and 1 more under `environments/dev/` — browse the folder._
- **prod** (4): [variables.tf](../environments/prod/variables.tf), [terraform.tfvars](../environments/prod/terraform.tfvars), [outputs.tf](../environments/prod/outputs.tf)
- _…and 1 more under `environments/prod/` — browse the folder._
- **staging** (4): [variables.tf](../environments/staging/variables.tf), [terraform.tfvars](../environments/staging/terraform.tfvars), [outputs.tf](../environments/staging/outputs.tf)
- _…and 1 more under `environments/staging/` — browse the folder._

## snippets · 23 files
- **primer:** [0000-primer-snippets.md](../snippets/notes/0000-primer-snippets.md)
- **notes** (2): [2026-10-19-snippets-quickstart-trip-ups.md](../snippets/notes/2026-10-19-snippets-quickstart-trip-ups.md)
- _…and 1 more under `snippets/notes/` — browse the folder._
- **configs** (2): [2026-10-19-shared-index-config.yaml](../snippets/configs/2026-10-19-shared-index-config.yaml), [2026-09-20-first-category.yaml](../snippets/configs/2026-09-20-first-category.yaml)
- **snippets** (2): [2026-10-19-minimal-python-snippet.py](../snippets/snippets/2026-10-19-minimal-python-snippet.py), [2026-09-20-first-snippet.sh](../snippets/snippets/2026-09-20-first-snippet.sh)

## github-actions · 22 files
- **primer:** [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (7): [2026-10-20-followed-quickstart.md](../github-actions/notes/2026-10-20-followed-quickstart.md), [2026-10-14-run-first-workflow.md](../github-actions/notes/2026-10-14-run-first-workflow.md), [2026-09-21-quickstart-tripped-me-up.md](../github-actions/notes/2026-09-21-quickstart-tripped-me-up.md)
- _…and 4 more under `github-actions/notes/` — browse the folder._
- **docs** (1): [how-i-wired-github-actions-into-my-ci-workflow.md](../github-actions/docs/how-i-wired-github-actions-into-my-ci-workflow.md)
- **scripts** (1): [triage-latest-failed-run.sh](../github-actions/scripts/triage-latest-failed-run.sh)
- **configs** (8): [sample-app-ci.yml](../github-actions/configs/sample-app-ci.yml), [reusable-deployment-workflow.yaml](../github-actions/configs/reusable-deployment-workflow.yaml), [2026-10-20-minimal-ci.yaml](../github-actions/configs/2026-10-20-minimal-ci.yaml)
- _…and 5 more under `github-actions/configs/` — browse the folder._
- **snippets** (3): [2026-10-14-trigger-first-workflow-gh.sh](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh), [2026-08-26-first-workflow.yaml](../github-actions/snippets/2026-08-26-first-workflow.yaml), [2026-08-26-composite-action-input-reuse.yaml](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- **manifests** (2): [2026-08-04-what-is-github-actions.yaml](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [2026-08-04-pr-validation.yml](../github-actions/manifests/2026-08-04-pr-validation.yml)

## terrascan · 22 files
- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [2026-07-10-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md), [2026-06-29-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md), [2026-06-19-install-terrascan-tiny-tf.md](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md)
- _…and 2 more under `terrascan/notes/` — browse the folder._
- **docs** (3): [terrascan-vs-checkov-terraform-iac-scanning.md](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md), [terrascan-scan-configuration-migration-patterns.md](../terrascan/docs/terrascan-scan-configuration-migration-patterns.md), [iac-pipeline-integration.md](../terrascan/docs/iac-pipeline-integration.md)
- **scripts** (2): [tried-terrascan-ci-scan.sh](../terrascan/scripts/tried-terrascan-ci-scan.sh), [policy-as-code-workflow.sh](../terrascan/scripts/policy-as-code-workflow.sh)
- **configs** (2): [tried-custom-s3-rule.yaml](../terrascan/configs/tried-custom-s3-rule.yaml), [terrascan-config-template.yaml](../terrascan/configs/terrascan-config-template.yaml)
- **snippets** (2): [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf), [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf)
- **manifests** (1): [terrascan-gha-ci-multi-iac.yaml](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **notebooks** (1): [rego-vs-yaml-rule-authoring.ipynb](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)

## vault · 21 files
- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (4): [2026-08-26-install-vault-first-command.md](../vault/notes/2026-08-26-install-vault-first-command.md), [2026-06-15-vault-getting-started-trip-ups.md](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md), [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
- _…and 1 more under `vault/notes/` — browse the folder._
- **docs** (3): [vault-secrets-engine-selection-guide.md](../vault/docs/vault-secrets-engine-selection-guide.md), [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md), [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md)
- **scripts** (4): [vault-pki-workflow.sh](../vault/scripts/vault-pki-workflow.sh), [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh), [vault-db-dynamic-secrets.sh](../vault/scripts/vault-db-dynamic-secrets.sh)
- _…and 1 more under `vault/scripts/` — browse the folder._
- **configs** (3): [multi-environment-access-control.hcl](../vault/configs/multi-environment-access-control.hcl), [2026-09-04-aws-secrets-engine-policy.hcl](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl), [2026-06-26-dev-test-policies.hcl](../vault/configs/2026-06-26-dev-test-policies.hcl)
- **snippets** (2): [vault-read-write.go](../vault/snippets/vault-read-write.go), [2026-08-30-first-vault-secret.sh](../vault/snippets/2026-08-30-first-vault-secret.sh)
- **manifests** (2): [vault-sidecar-secrets-refresh.yaml](../vault/manifests/vault-sidecar-secrets-refresh.yaml), [vault-cluster-deployment.yaml](../vault/manifests/vault-cluster-deployment.yaml)
- **dockerfiles** (1): [custom-vault-image-with-plugins-tls.Dockerfile](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **notebooks** (2): [vault-secrets-backend-comparison-patterns.ipynb](../vault/notebooks/vault-secrets-backend-comparison-patterns.ipynb), [static-vs-dynamic-secrets.ipynb](../vault/notebooks/static-vs-dynamic-secrets.ipynb)

## cosign · 20 files
- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (5): [2026-10-14-install-cosign-first-signing-command.md](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md), [2026-06-22-cosign-getting-started-trip-ups.md](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md)
- _…and 2 more under `cosign/notes/` — browse the folder._
- **docs** (4): [keyless-signing-patterns.md](../cosign/docs/keyless-signing-patterns.md), [key-rotation-and-migration-patterns.md](../cosign/docs/key-rotation-and-migration-patterns.md), [cosign-verification-patterns.md](../cosign/docs/cosign-verification-patterns.md)
- _…and 1 more under `cosign/docs/` — browse the folder._
- **scripts** (3): [verify-signed-image.sh](../cosign/scripts/verify-signed-image.sh), [minimal-sign-verify.sh](../cosign/scripts/minimal-sign-verify.sh), [cosign-key-management-workflow.sh](../cosign/scripts/cosign-key-management-workflow.sh)
- **configs** (2): [keyless-signing-github-actions.yaml](../cosign/configs/keyless-signing-github-actions.yaml), [cosign-signature-configuration.yaml](../cosign/configs/cosign-signature-configuration.yaml)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (2): [signed-container-build-oidc.yaml](../cosign/manifests/signed-container-build-oidc.yaml), [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)
- **dockerfiles** (2): [entrypoint.sh](../cosign/dockerfiles/entrypoint.sh), [custom-cosign-image.Dockerfile](../cosign/dockerfiles/custom-cosign-image.Dockerfile)
- **notebooks** (1): [key-based-vs-keyless-signing.ipynb](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## kubernetes · 20 files
- **primer:** [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (4): [2026-10-20-quickstart-followup.md](../kubernetes/notes/2026-10-20-quickstart-followup.md), [2026-10-14-cluster-resources.md](../kubernetes/notes/2026-10-14-cluster-resources.md), [2026-07-15-explore-kubernetes.md](../kubernetes/notes/2026-07-15-explore-kubernetes.md)
- _…and 1 more under `kubernetes/notes/` — browse the folder._
- **docs** (2): [rbac-design-patterns-for-multi-tenant-clusters.md](../kubernetes/docs/rbac-design-patterns-for-multi-tenant-clusters.md), [cluster-workflow-wiring.md](../kubernetes/docs/cluster-workflow-wiring.md)
- **scripts** (2): [cluster-health-check-and-conformance-validation.sh](../kubernetes/scripts/cluster-health-check-and-conformance-validation.sh), [2026-10-20-quickstart-repro.sh](../kubernetes/scripts/2026-10-20-quickstart-repro.sh)
- **configs** (3): [namespace-strategy-environment-vs-team.yaml](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml), [2026-10-20-minimal-deployment.yaml](../kubernetes/configs/2026-10-20-minimal-deployment.yaml), [2026-10-14-minimal-namespace.yaml](../kubernetes/configs/2026-10-14-minimal-namespace.yaml)
- **manifests** (4): [small-deployment-from-scratch.yaml](../kubernetes/manifests/small-deployment-from-scratch.yaml), [kustomize-overlays.yaml](../kubernetes/manifests/kustomize-overlays.yaml), [2026-09-10-first-pod.yaml](../kubernetes/manifests/2026-09-10-first-pod.yaml)
- _…and 1 more under `kubernetes/manifests/` — browse the folder._

## learn · 20 files
- **01-foundations** (6): [08-first-scan.md](../learn/01-foundations/08-first-scan.md), [07-lab-setup.md](../learn/01-foundations/07-lab-setup.md), [06-yaml-json-jq-regex.md](../learn/01-foundations/06-yaml-json-jq-regex.md)
- _…and 3 more under `learn/01-foundations/` — browse the folder._
- **02-build-and-ship** (2): [06-gha-sample-app-ci.md](../learn/02-build-and-ship/06-gha-sample-app-ci.md), [03-docker-sample-app-image.md](../learn/02-build-and-ship/03-docker-sample-app-image.md)
- **03-shift-left** (11): [14-defectdojo-findings.md](../learn/03-shift-left/14-defectdojo-findings.md), [13-zap-baseline.md](../learn/03-shift-left/13-zap-baseline.md), [12-cosign-sign.md](../learn/03-shift-left/12-cosign-sign.md)
- _…and 8 more under `learn/03-shift-left/` — browse the folder._
- **04-iac** (1): [03-terraform-plan-apply-destroy.md](../learn/04-iac/03-terraform-plan-apply-destroy.md)

## defectdojo · 19 files
- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (4): [2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md](../defectdojo/notes/2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md), [2026-09-21-quickstart-tripups.md](../defectdojo/notes/2026-09-21-quickstart-tripups.md), [2026-08-04-explore-defectdojo-ui.md](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md)
- _…and 1 more under `defectdojo/notes/` — browse the folder._
- **docs** (2): [how-i-wired-defectdojo-into-my-triage-workflow.md](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md), [defectdojo-scan-tool-ingestion-end-to-end.md](../defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md)
- **scripts** (3): [product-scan-import.py](../defectdojo/scripts/product-scan-import.py), [product-engagement-setup.py](../defectdojo/scripts/product-engagement-setup.py), [2026-09-20-defectdojo-tutorial-check.sh](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh)
- **configs** (2): [api-vs-ui-ingestion.yaml](../defectdojo/configs/api-vs-ui-ingestion.yaml), [2026-09-21-vulnerability-scanner-setup.yaml](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml)
- **snippets** (2): [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh), [2026-10-19-minimal-product-setup-api.py](../defectdojo/snippets/2026-10-19-minimal-product-setup-api.py)

## dependabot · 19 files
- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (7): [dependabot-alerts-security-updates.md](../dependabot/notes/dependabot-alerts-security-updates.md), [2026-08-08-dependabot-custom-registry-tutorial.md](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md), [2026-07-21-enabling-dependabot-alerts-security-updates.md](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md)
- _…and 4 more under `dependabot/notes/` — browse the folder._
- **docs** (4): [wired-dependabot-version-control-workflow.md](../dependabot/docs/wired-dependabot-version-control-workflow.md), [dependabot-version-control-workflow-integration.md](../dependabot/docs/dependabot-version-control-workflow-integration.md), [dependabot-security-update-auto-merge.md](../dependabot/docs/dependabot-security-update-auto-merge.md)
- _…and 1 more under `dependabot/docs/` — browse the folder._
- **scripts** (2): [dependabot-alert-aggregation.py](../dependabot/scripts/dependabot-alert-aggregation.py), [2026-08-04-dependabot-alert-triage.py](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py)
- **configs** (5): [tried-npm-dependabot.yaml](../dependabot/configs/tried-npm-dependabot.yaml), [monorepo-ecosystem-schedules-reviewers.yaml](../dependabot/configs/monorepo-ecosystem-schedules-reviewers.yaml), [dependabot-configuration-template.yaml](../dependabot/configs/dependabot-configuration-template.yaml)
- _…and 2 more under `dependabot/configs/` — browse the folder._
- **notebooks** (1): [auto-merge-vs-manual-review.ipynb](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## docker · 19 files
- **primer:** [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **notes** (2): [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md)
- _…and 1 more under `docker/notes/` — browse the folder._
- **docs** (2): [dockerfile-optimization-patterns.md](../docker/docs/dockerfile-optimization-patterns.md), [cicd-end-to-end.md](../docker/docs/cicd-end-to-end.md)
- **scripts** (3): [reusable-build.sh](../docker/scripts/reusable-build.sh), [build-multi-service-compose-app.sh](../docker/scripts/build-multi-service-compose-app.sh), [2026-07-18-custom-network-volume-mounts.sh](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh)
- **configs** (1): [docker-compose-dev-environment.yaml](../docker/configs/docker-compose-dev-environment.yaml)
- **manifests** (1): [docker-compose-production.yaml](../docker/manifests/docker-compose-production.yaml)
- **dockerfiles** (3): [small-app.Dockerfile](../docker/dockerfiles/small-app.Dockerfile), [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)

## lab · 17 files
- **primer:** [0000-primer-lab.md](../lab/notes/0000-primer-lab.md)
- **notes** (3): [2026-10-25-lab-quickstart-trips.md](../lab/notes/2026-10-25-lab-quickstart-trips.md), [2026-09-20-setting-up-the-lab-directory.md](../lab/notes/2026-09-20-setting-up-the-lab-directory.md)
- _…and 1 more under `lab/notes/` — browse the folder._
- **configs** (2): [2026-10-25-multi-node-demo.yaml](../lab/configs/2026-10-25-multi-node-demo.yaml), [2026-09-19-first-lab-env.yaml](../lab/configs/2026-09-19-first-lab-env.yaml)
- **snippets** (2): [2026-10-25-minimal-lab-env.py](../lab/snippets/2026-10-25-minimal-lab-env.py), [2026-10-14-first-lab-command.sh](../lab/snippets/2026-10-14-first-lab-command.sh)

## assets · 14 files
- **notes** (5): [2026-10-11-embedding-architecture-diagrams.md](../assets/notes/2026-10-11-embedding-architecture-diagrams.md), [2026-10-10-checking-where-the-diagrams-are-used.md](../assets/notes/2026-10-10-checking-where-the-diagrams-are-used.md), [2026-09-30-explore-assets-directory.md](../assets/notes/2026-09-30-explore-assets-directory.md)
- _…and 2 more under `assets/notes/` — browse the folder._
- **docs** (1): [how-i-wired-assets-into-ci-cd-pipeline.md](../assets/docs/how-i-wired-assets-into-ci-cd-pipeline.md)
- **scripts** (2): [asset-inventory-collector.py](../assets/scripts/asset-inventory-collector.py), [2026-10-01-audit-asset-references.sh](../assets/scripts/2026-10-01-audit-asset-references.sh)
- **configs** (2): [asset-tracking-config.yaml](../assets/configs/asset-tracking-config.yaml), [2026-09-29-asset-index.yaml](../assets/configs/2026-09-29-asset-index.yaml)

## tetragon · 11 files
- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (3): [2026-08-06-tetragon-observability-tutorial.md](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md)
- _…and 1 more under `tetragon/notes/` — browse the folder._
- **docs** (1): [runtime-security-workflow.md](../tetragon/docs/runtime-security-workflow.md)
- **scripts** (3): [build-tetragon-policy.sh](../tetragon/scripts/build-tetragon-policy.sh), [build-tetragon-file-access-tracing-policy.sh](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh), [2026-08-05-tetragon-event-collection-pipeline.sh](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- **configs** (4): [tetragon-policy-config-for-k8s-runtime-monitoring.yaml](../tetragon/configs/tetragon-policy-config-for-k8s-runtime-monitoring.yaml), [policy-approaches-comparison.yaml](../tetragon/configs/policy-approaches-comparison.yaml), [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml)
- _…and 1 more under `tetragon/configs/` — browse the folder._

## git · 10 files
- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (3): [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md), [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md)
- _…and 1 more under `git/notes/` — browse the folder._
- **docs** (1): [how-i-wired-git-into-my-version-control-workflow.md](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **scripts** (4): [git-automation.sh](../git/scripts/git-automation.sh), [2026-08-24-first-repo-stage-log.sh](../git/scripts/2026-08-24-first-repo-stage-log.sh), [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh)
- _…and 1 more under `git/scripts/` — browse the folder._
- **configs** (1): [config-strategy-layered-vs-conditional.yaml](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## grafana · 10 files
- **primer:** [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)
- **notes** (4): [2026-10-14-grafana-quickstart-trip-ups.md](../grafana/notes/2026-10-14-grafana-quickstart-trip-ups.md), [2026-09-26-explore-grafana-dashboard-ui.md](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md), [2026-09-19-first-dashboard-browser.md](../grafana/notes/2026-09-19-first-dashboard-browser.md)
- _…and 1 more under `grafana/notes/` — browse the folder._
- **docs** (1): [grafana-alerting-routing-templates.md](../grafana/docs/grafana-alerting-routing-templates.md)
- **scripts** (1): [build-dashboard-provisioning.py](../grafana/scripts/build-dashboard-provisioning.py)
- **configs** (2): [2026-10-14-dashboard-provisioning.yaml](../grafana/configs/2026-10-14-dashboard-provisioning.yaml), [2026-09-19-first-datasource.yaml](../grafana/configs/2026-09-19-first-datasource.yaml)
- **snippets** (1): [2026-10-14-first-grafana-datasource-query.py](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- **manifests** (1): [grafana-datasource-dashboard.yaml](../grafana/manifests/grafana-datasource-dashboard.yaml)

## kustomize · 10 files
- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (3): [2026-09-21-kustomize-quickstart-tripped-me-up.md](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md), [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md)
- _…and 1 more under `kustomize/notes/` — browse the folder._
- **docs** (1): [how-i-wired-kustomize-into-my-manifest-workflow.md](../kustomize/docs/how-i-wired-kustomize-into-my-manifest-workflow.md)
- **scripts** (2): [bases-vs-remote-resources.sh](../kustomize/scripts/bases-vs-remote-resources.sh), [2026-10-20-kustomize-tutorial.sh](../kustomize/scripts/2026-10-20-kustomize-tutorial.sh)
- **configs** (3): [small-overlay.yaml](../kustomize/configs/small-overlay.yaml), [2026-09-22-minimal-kustomization-with-overlay.yaml](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml), [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml)
- **manifests** (1): [2026-09-21-kustomize-tutorial.yaml](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## opentofu · 10 files
- **primer:** [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (4): [2026-10-20-follow-opentofu-test-quickstart.md](../opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md), [2026-09-21-follow-open-tofu-quickstart.md](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md), [2026-07-20-explore-open-tofu.md](../opentofu/notes/2026-07-20-explore-open-tofu.md)
- _…and 1 more under `opentofu/notes/` — browse the folder._
- **docs** (2): [open-tofu-vs-terraform-migration-decision-matrix.md](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md), [how-i-wired-opentofu-into-my-iac-workflow.md](../opentofu/docs/how-i-wired-opentofu-into-my-iac-workflow.md)
- **scripts** (1): [module-registry-publisher.sh](../opentofu/scripts/module-registry-publisher.sh)
- **configs** (3): [2026-09-21-minimal-opentofu-config-with-vars.hcl](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl), [2026-09-10-minimal-opentofu-config.hcl](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl), [2026-07-20-first-open-tofu-config.hcl](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## gitleaks · 9 files
- **primer:** [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md)
- **notes** (3): [2026-10-07-quickstart-trip-ups.md](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md), [2026-09-19-first-secret-scan.md](../gitleaks/notes/2026-09-19-first-secret-scan.md)
- _…and 1 more under `gitleaks/notes/` — browse the folder._
- **docs** (1): [integrating-gitleaks-pre-commit-ci.md](../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md)
- **scripts** (3): [build-custom-gitleaks-ruleset.sh](../gitleaks/scripts/build-custom-gitleaks-ruleset.sh), [2026-10-13-auditing-git-secrets.sh](../gitleaks/scripts/2026-10-13-auditing-git-secrets.sh), [2026-09-26-run-first-gitleaks-scan.sh](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh)
- **configs** (2): [gitleaks-config.toml](../gitleaks/configs/gitleaks-config.toml), [2026-10-07-detection-rules.yaml](../gitleaks/configs/2026-10-07-detection-rules.yaml)

## helm · 9 files
- **primer:** [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **notes** (4): [2026-10-20-followed-quickstart.md](../helm/notes/2026-10-20-followed-quickstart.md), [2026-09-21-quickstart-tripped-me-up.md](../helm/notes/2026-09-21-quickstart-tripped-me-up.md), [2026-07-19-explore-helm-charts-releases-values-repos.md](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md)
- _…and 1 more under `helm/notes/` — browse the folder._
- **docs** (1): [how-i-wired-helm-into-my-release-workflow.md](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- **scripts** (1): [build-and-deploy-chart.sh](../helm/scripts/build-and-deploy-chart.sh)
- **configs** (1): [values-file-vs-set-flags.yaml](../helm/configs/values-file-vs-set-flags.yaml)
- **manifests** (2): [2026-09-21-minimal-service-chart.yaml](../helm/manifests/2026-09-21-minimal-service-chart.yaml), [2026-07-15-first-chart-values.yaml](../helm/manifests/2026-07-15-first-chart-values.yaml)

## linux · 7 files
- **notes** (3): [2026-10-02-explore-linux-environment.md](../linux/notes/2026-10-02-explore-linux-environment.md), [2026-08-06-linux-shell-scripting-tutorial-confusions.md](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md), [2026-07-21-install-linux-vm-terminal-first-commands.md](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- **docs** (1): [system-administration-runbook.md](../linux/docs/system-administration-runbook.md)
- **scripts** (2): [health-check-and-rollback.sh](../linux/scripts/health-check-and-rollback.sh), [find-large-logs.sh](../linux/scripts/find-large-logs.sh)
- **configs** (1): [2026-08-06-cron-job-configuration.ini](../linux/configs/2026-08-06-cron-job-configuration.ini)

## prometheus · 7 files
- **primer:** [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (5): [2026-10-25-followed-quickstart.md](../prometheus/notes/2026-10-25-followed-quickstart.md), [2026-10-14-observability-primer-dedup.md](../prometheus/notes/2026-10-14-observability-primer-dedup.md), [2026-10-14-first-query-log.md](../prometheus/notes/2026-10-14-first-query-log.md)
- _…and 2 more under `prometheus/notes/` — browse the folder._
- **scripts** (1): [2026-10-25-query-api-python.py](../prometheus/scripts/2026-10-25-query-api-python.py)
- **snippets** (1): [2026-10-25-minimal-scrape-config.yaml](../prometheus/snippets/2026-10-25-minimal-scrape-config.yaml)

## sonarqube · 7 files
- **primer:** [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (3): [2026-09-21-follow-sonarqube-quickstart.md](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md), [2026-07-19-explore-sonarqube-quality-gates-profiles.md](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md)
- _…and 1 more under `sonarqube/notes/` — browse the folder._
- **scripts** (1): [2026-09-21-sonarqube-scan-setup.sh](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **configs** (2): [minimal-project-quality-gate.yaml](../sonarqube/configs/minimal-project-quality-gate.yaml), [2026-09-21-minimal-quality-gate.yaml](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml)
- **snippets** (1): [2026-07-16-first-sonarscanner-run.sh](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## tfsec · 6 files
- **primer:** [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md)
- **notes** (3): [2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md](../tfsec/notes/2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md), [2026-09-20-first-tfsec-scan.md](../tfsec/notes/2026-09-20-first-tfsec-scan.md)
- _…and 1 more under `tfsec/notes/` — browse the folder._
- **scripts** (1): [2026-10-19-ran-my-first-tfsec-scan.sh](../tfsec/scripts/2026-10-19-ran-my-first-tfsec-scan.sh)
- **configs** (1): [2026-10-19-minimal-tfsec-scan-config.yaml](../tfsec/configs/2026-10-19-minimal-tfsec-scan-config.yaml)
- **snippets** (1): [enforce-s3-bucket-encryption.rego](../tfsec/snippets/enforce-s3-bucket-encryption.rego)

## nuclei · 5 files
- **primer:** [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md)
- **notes** (3): [2026-10-15-nuclei-quickstart-trip-ups.md](../nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md), [2026-09-20-first-template-scan-attempt.md](../nuclei/notes/2026-09-20-first-template-scan-attempt.md)
- _…and 1 more under `nuclei/notes/` — browse the folder._
- **scripts** (1): [2026-10-15-first-nuclei-scan.sh](../nuclei/scripts/2026-10-15-first-nuclei-scan.sh)
- **configs** (1): [2026-10-15-minimal-scan-template.yaml](../nuclei/configs/2026-10-15-minimal-scan-template.yaml)

