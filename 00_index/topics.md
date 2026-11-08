# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## trufflehog  ·  51 files
- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (4): [2026-07-27-explore-cli.md](../trufflehog/notes/2026-07-27-explore-cli.md), [2026-05-27-following-trufflehog-quickstart.md](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md), [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md)
- _…and 1 more under `trufflehog/notes/` — browse the folder._
- **docs** (4): [trufflehog-output-formats-json-sarif-csv.md](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md), [trufflehog-integration-reference-secret-detection.md](../trufflehog/docs/trufflehog-integration-reference-secret-detection.md), [trufflehog-secrets-database-migration-guide.md](../trufflehog/docs/trufflehog-secrets-database-migration-guide.md)
- _…and 1 more under `trufflehog/docs/` — browse the folder._
- **scripts** (3): [multi-repo-scan-pipeline.sh](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [pre-commit-scan-pipeline.sh](../trufflehog/scripts/pre-commit-scan-pipeline.sh), [analyze-trufflehog-results.py](../trufflehog/scripts/analyze-trufflehog-results.py)
- **configs** (2): [trufflehog-custom-regex-config.yaml](../trufflehog/configs/trufflehog-custom-regex-config.yaml), [custom-detector-rules.yaml](../trufflehog/configs/custom-detector-rules.yaml)
- **snippets** (3): [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh), [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh), [2026-10-14-first-secret-scan.sh](../trufflehog/snippets/2026-10-14-first-secret-scan.sh)
- **templates** (28): [trufflehog-config.yaml](../trufflehog/templates/trufflehog-ci-integration/trufflehog-config.yaml), [scan.sh](../trufflehog/templates/trufflehog-ci-integration/scripts/scan.sh), [Makefile](../trufflehog/templates/trufflehog-ci-integration/Makefile)
- _…and 25 more under `trufflehog/templates/` — browse the folder._
- **manifests** (2): [trufflehog-pr-secret-scan-reusable.yaml](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml), [trufflehog-cicd-pipeline.yaml](../trufflehog/manifests/trufflehog-cicd-pipeline.yaml)
- **dockerfiles** (2): [pre-commit-scanner.Dockerfile](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile), [pipeline-scanner.Dockerfile](../trufflehog/dockerfiles/pipeline-scanner.Dockerfile)
- **notebooks** (3): [detector-comparison-patterns.ipynb](../trufflehog/notebooks/detector-comparison-patterns.ipynb), [trufflehog-scan-modes-comparison.ipynb](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb), [analyzing-trufflehog-false-positives.ipynb](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)

## checkov  ·  45 files
- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [2026-05-27-checkov-quickstart-trip-ups.md](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md), [2026-05-26-cli-vs-sdk-comparison.md](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [2026-05-25-scan-terraform-plan.md](../checkov/notes/2026-05-25-scan-terraform-plan.md)
- _…and 1 more under `checkov/notes/` — browse the folder._
- **docs** (6): [checkov-v3-migration-guide.md](../checkov/docs/checkov-v3-migration-guide.md), [checkov-integration-patterns.md](../checkov/docs/checkov-integration-patterns.md), [multi-cloud-policy-management.md](../checkov/docs/multi-cloud-policy-management.md)
- _…and 3 more under `checkov/docs/` — browse the folder._
- **scripts** (4): [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh), [validate-policies.sh](../checkov/scripts/validate-policies.sh), [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh)
- _…and 1 more under `checkov/scripts/` — browse the folder._
- **configs** (3): [platform-config.yaml](../checkov/configs/platform-config.yaml), [checkov-skip-severity-config.yaml](../checkov/configs/checkov-skip-severity-config.yaml), [checkov-ci-config.yaml](../checkov/configs/checkov-ci-config.yaml)
- **snippets** (4): [scan-kubernetes.sh](../checkov/snippets/scan-kubernetes.sh), [scan-terraform-dir.py](../checkov/snippets/scan-terraform-dir.py), [terraform-scan-custom-policies.py](../checkov/snippets/terraform-scan-custom-policies.py)
- _…and 1 more under `checkov/snippets/` — browse the folder._
- **templates** (16): [example-caller-workflow.yml](../checkov/templates/reusable-workflow-custom-policies/example-caller-workflow.yml), [restrict_ec2_public_ip.yaml](../checkov/templates/reusable-workflow-custom-policies/custom-policies/restrict_ec2_public_ip.yaml), [no_public_s3_buckets.yaml](../checkov/templates/reusable-workflow-custom-policies/custom-policies/no_public_s3_buckets.yaml)
- _…and 13 more under `checkov/templates/` — browse the folder._
- **manifests** (3): [checkov-sarif-pr-blocking.yaml](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml), [checkov-gitlab-ci-multi-cloud-drift.yaml](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml)
- **notebooks** (4): [compare-static-vs-plan-scanning.ipynb](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb), [compare-cross-module-scanning-limitations.ipynb](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb), [compare-custom-policy-expressiveness.ipynb](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb)
- _…and 1 more under `checkov/notebooks/` — browse the folder._
- **policies** (1): [no_public_s3_buckets.yaml](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)

## syft  ·  44 files
- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (5): [2026-05-30-sbom-format-comparison.md](../syft/notes/2026-05-30-sbom-format-comparison.md), [2026-05-27-install-syft-first-sbom.md](../syft/notes/2026-05-27-install-syft-first-sbom.md), [2026-05-29-syft-quickstart-trip-ups.md](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)
- _…and 2 more under `syft/notes/` — browse the folder._
- **docs** (8): [output-format-selection-guide.md](../syft/docs/output-format-selection-guide.md), [enterprise-registry-auth-caching.md](../syft/docs/enterprise-registry-auth-caching.md), [sbom-output-formats-reference.md](../syft/docs/sbom-output-formats-reference.md)
- _…and 5 more under `syft/docs/` — browse the folder._
- **scripts** (5): [gen-multi-format-sboms.sh](../syft/scripts/gen-multi-format-sboms.sh), [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh), [syft-sbom-generation.py](../syft/scripts/syft-sbom-generation.py)
- _…and 2 more under `syft/scripts/` — browse the folder._
- **configs** (1): [.syft.yaml](../syft/configs/.syft.yaml)
- **snippets** (3): [tried-sbom-formats.sh](../syft/snippets/tried-sbom-formats.sh), [2026-10-27-syft-cli-output-formats.sh](../syft/snippets/2026-10-27-syft-cli-output-formats.sh), [2026-10-14-first-sbom.sh](../syft/snippets/2026-10-14-first-sbom.sh)
- **templates** (13): [syft.yaml](../syft/templates/syft-trivy-k8s-scan-scaffold/syft.yaml), [trivy.yaml](../syft/templates/syft-trivy-k8s-scan-scaffold/trivy.yaml), [images.txt](../syft/templates/syft-trivy-k8s-scan-scaffold/images.txt)
- _…and 10 more under `syft/templates/` — browse the folder._
- **manifests** (4): [syft-remote-state-backend-deployment.yaml](../syft/manifests/syft-remote-state-backend-deployment.yaml), [syft-gha-multi-arch-sbom-registry-auth.yaml](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml), [syft-gha-sbom-oci-push-attestation.yaml](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml)
- _…and 1 more under `syft/manifests/` — browse the folder._
- **dockerfiles** (1): [multi-stage-sbom.Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (4): [source-vs-library-multiarch.ipynb](../syft/notebooks/source-vs-library-multiarch.ipynb), [syft-format-comparison-patterns.ipynb](../syft/notebooks/syft-format-comparison-patterns.ipynb), [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb)
- _…and 1 more under `syft/notebooks/` — browse the folder._

## trivy  ·  40 files
- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (8): [2026-05-26-trivy-quickstart.md](../trivy/notes/2026-05-26-trivy-quickstart.md), [2026-10-14-quickstart-trip-ups.md](../trivy/notes/2026-10-14-quickstart-trip-ups.md), [2026-09-05-install-trivy-first-container-scan.md](../trivy/notes/2026-09-05-install-trivy-first-container-scan.md)
- _…and 5 more under `trivy/notes/` — browse the folder._
- **docs** (6): [multi-arch-vulnerability-scanning.md](../trivy/docs/multi-arch-vulnerability-scanning.md), [trivy-integration-reference-container-scanning.md](../trivy/docs/trivy-integration-reference-container-scanning.md), [trivy-database-migration-guide.md](../trivy/docs/trivy-database-migration-guide.md)
- _…and 3 more under `trivy/docs/` — browse the folder._
- **scripts** (6): [multi-target-scanner.sh](../trivy/scripts/multi-target-scanner.sh), [container-vuln-scan.sh](../trivy/scripts/container-vuln-scan.sh), [image-vuln-pipeline.sh](../trivy/scripts/image-vuln-pipeline.sh)
- _…and 3 more under `trivy/scripts/` — browse the folder._
- **configs** (4): [2026-10-19-minimal-trivy-config.yaml](../trivy/configs/2026-10-19-minimal-trivy-config.yaml), [trivy-scan-config.yaml](../trivy/configs/trivy-scan-config.yaml), [trivy-ci-gate.yml](../trivy/configs/trivy-ci-gate.yml)
- _…and 1 more under `trivy/configs/` — browse the folder._
- **snippets** (1): [scan-docker-image.sh](../trivy/snippets/scan-docker-image.sh)
- **templates** (10): [trivy.yaml](../trivy/templates/trivy-monorepo-scanner/trivy.yaml), [scan-all.sh](../trivy/templates/trivy-monorepo-scanner/scripts/scan-all.sh), [Makefile](../trivy/templates/trivy-monorepo-scanner/Makefile)
- _…and 7 more under `trivy/templates/` — browse the folder._
- **manifests** (2): [trivy-sarif-code-scanning.yaml](../trivy/manifests/trivy-sarif-code-scanning.yaml), [trivy-operator-deployment.yaml](../trivy/manifests/trivy-operator-deployment.yaml)
- **dockerfiles** (1): [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy-scan-mode-comparison.ipynb](../trivy/notebooks/trivy-scan-mode-comparison.ipynb), [trivy-sarif-output-processing.ipynb](../trivy/notebooks/trivy-sarif-output-processing.ipynb)

## ansible  ·  34 files
- **notes** (3): [roles-vs-tasks.md](../ansible/notes/roles-vs-tasks.md), [2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md), [2026-08-17-verify-ansible-cve-2026-33228-paths.md](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md)
- **docs** (1): [wired-ansible-infrastructure-workflow.md](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **scripts** (5): [2026-10-27-first-ad-hoc-command.sh](../ansible/scripts/2026-10-27-first-ad-hoc-command.sh), [bootstrap-target-node.sh](../ansible/scripts/bootstrap-target-node.sh), [bootstrap.sh](../ansible/scripts/bootstrap.sh)
- _…and 2 more under `ansible/scripts/` — browse the folder._
- **configs** (3): [small-ansible-project.yaml](../ansible/configs/small-ansible-project.yaml), [terraform-nginx-integration.yaml](../ansible/configs/terraform-nginx-integration.yaml), [2026-09-15-inventory-groups-host-vars.yaml](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml)
- **snippets** (1): [2026-08-25-minimal-ansible-playbook-package-service.yaml](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- **templates** (21): [main.tf](../ansible/templates/project-scaffold-ansible-terraform-kubernetes/terraform/modules/vpc/main.tf), [main.tf](../ansible/templates/project-scaffold-ansible-terraform-kubernetes/terraform/main.tf), [kustomization.yaml](../ansible/templates/project-scaffold-ansible-terraform-kubernetes/kubernetes/overlays/dev/kustomization.yaml)
- _…and 18 more under `ansible/templates/` — browse the folder._

## codeql  ·  32 files
- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (5): [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md), [2026-08-26-install-codeql-first-query.md](../codeql/notes/2026-08-26-install-codeql-first-query.md), [2026-06-05-install-codeql-first-analysis.md](../codeql/notes/2026-06-05-install-codeql-first-analysis.md)
- _…and 2 more under `codeql/notes/` — browse the folder._
- **docs** (4): [query-writing-patterns-dataflow-javascript-typescript.md](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md), [codeql-integration-reference.md](../codeql/docs/codeql-integration-reference.md), [wired-custom-queries-into-ci.md](../codeql/docs/wired-custom-queries-into-ci.md)
- _…and 1 more under `codeql/docs/` — browse the folder._
- **scripts** (2): [first-codeql-analysis.sh](../codeql/scripts/first-codeql-analysis.sh), [codeql-security-issue-detector.py](../codeql/scripts/codeql-security-issue-detector.py)
- **configs** (2): [first-codeql-analysis.yml](../codeql/configs/first-codeql-analysis.yml), [codeql-analysis-workflow.yaml](../codeql/configs/codeql-analysis-workflow.yaml)
- **snippets** (6): [2026-10-27-hardcoded-secrets.ql](../codeql/snippets/2026-10-27-hardcoded-secrets.ql), [find-hardcoded-creds.ql](../codeql/snippets/find-hardcoded-creds.ql), [my-first-codeql-commands.sh](../codeql/snippets/my-first-codeql-commands.sh)
- _…and 3 more under `codeql/snippets/` — browse the folder._
- **templates** (7): [qlpack.yml](../codeql/templates/custom-query-pack-ci-harness/qlpack.yml), [hardcoded-credential-check.ql](../codeql/templates/custom-query-pack-ci-harness/queries/hardcoded-credential-check.ql), [test-pack.sh](../codeql/templates/custom-query-pack-ci-harness/scripts/test-pack.sh)
- _…and 4 more under `codeql/templates/` — browse the folder._
- **manifests** (3): [multi-language-codeql-analysis.yaml](../codeql/manifests/multi-language-codeql-analysis.yaml), [codeql-multi-language-scan.yaml](../codeql/manifests/codeql-multi-language-scan.yaml), [codeql-cicd-pipeline.yaml](../codeql/manifests/codeql-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom-codeql-analysis-image.Dockerfile](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **notebooks** (2): [compare-cli-vs-actions-scan-modes.ipynb](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb), [codeql-query-comparison-patterns.ipynb](../codeql/notebooks/codeql-query-comparison-patterns.ipynb)

## zap  ·  31 files
- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (6): [2026-06-06-install-zap-desktop-ui.md](../zap/notes/2026-06-06-install-zap-desktop-ui.md), [2026-06-13-spider-scan-test-app.md](../zap/notes/2026-06-13-spider-scan-test-app.md), [2026-06-06-zap-quickstart-ui-gotchas.md](../zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md)
- _…and 3 more under `zap/notes/` — browse the folder._
- **docs** (5): [zap-scan-configuration-migration-guide.md](../zap/docs/zap-scan-configuration-migration-guide.md), [zap-integration-patterns.md](../zap/docs/zap-integration-patterns.md), [zap-automation-plan-structure.md](../zap/docs/zap-automation-plan-structure.md)
- _…and 2 more under `zap/docs/` — browse the folder._
- **scripts** (3): [zap-baseline-scan.sh](../zap/scripts/zap-baseline-scan.sh), [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh), [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh)
- **configs** (3): [zap-authenticated-scan-context.yaml](../zap/configs/zap-authenticated-scan-context.yaml), [zap-dast-github-actions-workflow.yaml](../zap/configs/zap-dast-github-actions-workflow.yaml), [ci-dast-automation-framework-plan.yaml](../zap/configs/ci-dast-automation-framework-plan.yaml)
- **snippets** (4): [my-first-zap-baseline-scan.sh](../zap/snippets/my-first-zap-baseline-scan.sh), [my-first-zap-spider-scan.sh](../zap/snippets/my-first-zap-spider-scan.sh), [authenticated-scan-with-context.sh](../zap/snippets/authenticated-scan-with-context.sh)
- _…and 1 more under `zap/snippets/` — browse the folder._
- **templates** (7): [zap-automation-plan.yaml](../zap/templates/zap-dast-integration-scaffold/zap-automation-plan.yaml), [quick-scan.yaml](../zap/templates/zap-dast-integration-scaffold/plans/quick-scan.yaml), [run-zap-dast.sh](../zap/templates/zap-dast-integration-scaffold/scripts/run-zap-dast.sh)
- _…and 4 more under `zap/templates/` — browse the folder._
- **manifests** (1): [zap-cicd-pipeline.yaml](../zap/manifests/zap-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom-zap-automation.Dockerfile](../zap/dockerfiles/custom-zap-automation.Dockerfile)
- **notebooks** (1): [scan-strategy-comparison-patterns.ipynb](../zap/notebooks/scan-strategy-comparison-patterns.ipynb)

## opa  ·  30 files
- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (5): [2026-10-24-install-opa-first-policy-eval.md](../opa/notes/2026-10-24-install-opa-first-policy-eval.md), [2026-10-27-opa-install-first-policy.md](../opa/notes/2026-10-27-opa-install-first-policy.md), [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)
- _…and 2 more under `opa/notes/` — browse the folder._
- **docs** (4): [wired-opa-admission-control.md](../opa/docs/wired-opa-admission-control.md), [opa-policy-version-migration-patterns.md](../opa/docs/opa-policy-version-migration-patterns.md), [integrating-opa-with-policy-as-code-governance.md](../opa/docs/integrating-opa-with-policy-as-code-governance.md)
- _…and 1 more under `opa/docs/` — browse the folder._
- **scripts** (2): [how-i-test-policies-locally.sh](../opa/scripts/how-i-test-policies-locally.sh), [export-audit-results.sh](../opa/scripts/export-audit-results.sh)
- **configs** (2): [tried-a-gatekeeper-constraint.yaml](../opa/configs/tried-a-gatekeeper-constraint.yaml), [opa-policy-configuration-template.yaml](../opa/configs/opa-policy-configuration-template.yaml)
- **snippets** (4): [my-first-opa-policy-eval.sh](../opa/snippets/my-first-opa-policy-eval.sh), [enforce-image-registry-constraints.rego](../opa/snippets/enforce-image-registry-constraints.rego), [deny-privileged-hostnetwork.rego](../opa/snippets/deny-privileged-hostnetwork.rego)
- _…and 1 more under `opa/snippets/` — browse the folder._
- **templates** (8): [enforce-image-registry.rego](../opa/templates/gatekeeper-policy-library-scaffold/policies/enforce-image-registry.rego), [require-read-only-root-filesystem.rego](../opa/templates/gatekeeper-policy-library-scaffold/policies/require-read-only-root-filesystem.rego), [deny-privileged-containers.rego](../opa/templates/gatekeeper-policy-library-scaffold/policies/deny-privileged-containers.rego)
- _…and 5 more under `opa/templates/` — browse the folder._
- **manifests** (4): [constraint-templates.yaml](../opa/manifests/constraint-templates.yaml), [gatekeeper-production-deployment.yaml](../opa/manifests/gatekeeper-production-deployment.yaml), [constraints.yaml](../opa/manifests/constraints.yaml)
- _…and 1 more under `opa/manifests/` — browse the folder._
- **notebooks** (1): [rego-vs-builtin-policies.ipynb](../opa/notebooks/rego-vs-builtin-policies.ipynb)

## snyk  ·  29 files
- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (6): [2026-10-07-explore-snyk-cli-commands.md](../snyk/notes/2026-10-07-explore-snyk-cli-commands.md), [2026-10-27-snyk-quickstart-tripped.md](../snyk/notes/2026-10-27-snyk-quickstart-tripped.md), [2026-06-08-install-snyk-first-test.md](../snyk/notes/2026-06-08-install-snyk-first-test.md)
- _…and 3 more under `snyk/notes/` — browse the folder._
- **docs** (4): [multi-project-ci-pipeline.md](../snyk/docs/multi-project-ci-pipeline.md), [snyk-security-policy-migration-patterns.md](../snyk/docs/snyk-security-policy-migration-patterns.md), [vulnerability-prioritization-reachability-fix-prs-license-compliance.md](../snyk/docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md)
- _…and 1 more under `snyk/docs/` — browse the folder._
- **scripts** (2): [snyk-vuln-scan-pipeline.sh](../snyk/scripts/snyk-vuln-scan-pipeline.sh), [2026-10-20-first-snyk-test.sh](../snyk/scripts/2026-10-20-first-snyk-test.sh)
- **configs** (3): [snyk-dependency-patch-ignore.yaml](../snyk/configs/snyk-dependency-patch-ignore.yaml), [snyk-project-configuration-template.yaml](../snyk/configs/snyk-project-configuration-template.yaml), [snyk-ci-github-actions.yaml](../snyk/configs/snyk-ci-github-actions.yaml)
- **snippets** (1): [my-first-snyk-commands.sh](../snyk/snippets/my-first-snyk-commands.sh)
- **templates** (10): [scan-java.sh](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-java.sh), [scan-python.sh](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-python.sh), [scan-go.sh](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-go.sh)
- _…and 7 more under `snyk/templates/` — browse the folder._
- **manifests** (1): [snyk-github-actions-cicd-workflow.yaml](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **dockerfiles** (1): [custom-snyk-cli-air-gapped.Dockerfile](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- **notebooks** (1): [cli-vs-api-modes.ipynb](../snyk/notebooks/cli-vs-api-modes.ipynb)

## terraform  ·  29 files
- **primer:** [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **notes** (3): [2026-08-04-install-terraform-first-vm.md](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [2026-07-15-explore-terraform.md](../terraform/notes/2026-07-15-explore-terraform.md), [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **docs** (2): [terraform-testing-patterns.md](../terraform/docs/terraform-testing-patterns.md), [terraform-module-composition.md](../terraform/docs/terraform-module-composition.md)
- **scripts** (4): [2026-07-18-deploy.sh](../terraform/scripts/2026-07-18-deploy.sh), [state-management-workflow.sh](../terraform/scripts/state-management-workflow.sh), [2026-07-18-cleanup.sh](../terraform/scripts/2026-07-18-cleanup.sh)
- _…and 1 more under `terraform/scripts/` — browse the folder._
- **configs** (6): [small-module-from-scratch.hcl](../terraform/configs/small-module-from-scratch.hcl), [2026-10-19-minimal-quickstart-config.hcl](../terraform/configs/2026-10-19-minimal-quickstart-config.hcl), [2026-08-04-first-configuration.hcl](../terraform/configs/2026-08-04-first-configuration.hcl)
- _…and 3 more under `terraform/configs/` — browse the folder._
- **snippets** (1): [2026-07-20-practice-terraform-variables-outputs-datasources.hcl](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- **templates** (5): [main.tf](../terraform/templates/module-registry-publish-consume/main.tf), [versions.tf](../terraform/templates/module-registry-publish-consume/versions.tf), [variables.tf](../terraform/templates/module-registry-publish-consume/variables.tf)
- _…and 2 more under `terraform/templates/` — browse the folder._
- **manifests** (1): [terraform-cloud-workspace-automation.hcl](../terraform/manifests/terraform-cloud-workspace-automation.hcl)

## argocd  ·  28 files
- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (6): [2026-07-31-verify-readme-layout.md](../argocd/notes/2026-07-31-verify-readme-layout.md), [2026-07-06-install-argocd-first-app.md](../argocd/notes/2026-07-06-install-argocd-first-app.md), [2026-08-12-quickstart-tripups.md](../argocd/notes/2026-08-12-quickstart-tripups.md)
- _…and 3 more under `argocd/notes/` — browse the folder._
- **docs** (3): [multi-environment-gitops-delivery.md](../argocd/docs/multi-environment-gitops-delivery.md), [helm-kustomize-composition.md](../argocd/docs/helm-kustomize-composition.md), [gitops-workflow-wiring.md](../argocd/docs/gitops-workflow-wiring.md)
- **scripts** (1): [argocd-api-automation.sh](../argocd/scripts/argocd-api-automation.sh)
- **configs** (2): [2026-09-20-values-dev.yaml](../argocd/configs/2026-09-20-values-dev.yaml), [2026-08-17-private-repo-credentials-rbac.yaml](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- **templates** (11): [production.yaml](../argocd/templates/app-of-apps-multienv/values/environments/production.yaml), [staging.yaml](../argocd/templates/app-of-apps-multienv/values/environments/staging.yaml), [development.yaml](../argocd/templates/app-of-apps-multienv/values/environments/development.yaml)
- _…and 8 more under `argocd/templates/` — browse the folder._
- **manifests** (5): [application-set-with-matrix-generator.yaml](../argocd/manifests/application-set-with-matrix-generator.yaml), [2026-08-12-gitops-sync-sample-web-app.yaml](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml), [helm-guestbook-application.yaml](../argocd/manifests/helm-guestbook-application.yaml)
- _…and 2 more under `argocd/manifests/` — browse the folder._

## gitguardian  ·  28 files
- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (6): [2026-06-14-first-secrets-scan-repo.md](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md), [2026-06-07-first-ggshield-scan.md](../gitguardian/notes/2026-06-07-first-ggshield-scan.md), [2026-06-13-ggshield-quickstart-trip-ups.md](../gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md)
- _…and 3 more under `gitguardian/notes/` — browse the folder._
- **docs** (4): [gitguardian-secret-scanning-migration-patterns.md](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md), [monorepo-ci-per-team-exclusions.md](../gitguardian/docs/monorepo-ci-per-team-exclusions.md), [gitguardian-incident-response-workflow.md](../gitguardian/docs/gitguardian-incident-response-workflow.md)
- _…and 1 more under `gitguardian/docs/` — browse the folder._
- **scripts** (4): [gitguardian-api-integration.py](../gitguardian/scripts/gitguardian-api-integration.py), [pre-commit-hook-ggshield.sh](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh)
- _…and 1 more under `gitguardian/scripts/` — browse the folder._
- **configs** (3): [monorepo-allowlists.yaml](../gitguardian/configs/monorepo-allowlists.yaml), [policy-configuration.yaml](../gitguardian/configs/policy-configuration.yaml), [.ggshield.yaml](../gitguardian/configs/.ggshield.yaml)
- **snippets** (2): [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh), [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- **templates** (8): [scan-multi-repo.sh](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/scripts/scan-multi-repo.sh), [.gitignore](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.gitignore), [ggshield.yaml](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/ggshield.yaml)
- _…and 5 more under `gitguardian/templates/` — browse the folder._
- **notebooks** (1): [choosing-between-on-premise-and-cloud-modes.ipynb](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb)

## grype  ·  27 files
- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **notes** (5): [2026-10-14-explore-vulnerability-database.md](../grype/notes/2026-10-14-explore-vulnerability-database.md), [2026-06-08-first-grype-scan.md](../grype/notes/2026-06-08-first-grype-scan.md), [2026-05-31-install-grype.md](../grype/notes/2026-05-31-install-grype.md)
- _…and 2 more under `grype/notes/` — browse the folder._
- **docs** (3): [vulnerability-management-pipeline-integration.md](../grype/docs/vulnerability-management-pipeline-integration.md), [grype-vulnerability-reporting-migration-patterns.md](../grype/docs/grype-vulnerability-reporting-migration-patterns.md), [grype-syft-integration-guide.md](../grype/docs/grype-syft-integration-guide.md)
- **scripts** (9): [grype-scan-pipeline-end-to-end.sh](../grype/scripts/grype-scan-pipeline-end-to-end.sh), [grype-scan-from-scratch.sh](../grype/scripts/grype-scan-from-scratch.sh), [grype-pipeline-ci-scan.sh](../grype/scripts/grype-pipeline-ci-scan.sh)
- _…and 6 more under `grype/scripts/` — browse the folder._
- **configs** (2): [grype-filtering-configuration-template.yaml](../grype/configs/grype-filtering-configuration-template.yaml), [grype-ci-github-actions.yaml](../grype/configs/grype-ci-github-actions.yaml)
- **snippets** (3): [minimal-grype-scan.go](../grype/snippets/minimal-grype-scan.go), [my-first-grype-commands.sh](../grype/snippets/my-first-grype-commands.sh), [2026-10-27-grype-filter-severity-formats.sh](../grype/snippets/2026-10-27-grype-filter-severity-formats.sh)
- **manifests** (2): [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml), [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml)
- **dockerfiles** (1): [multi-stage-grype-scan.Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (2): [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb), [grype-db-vs-registry-sources.ipynb](../grype/notebooks/grype-db-vs-registry-sources.ipynb)

## falco  ·  25 files
- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (6): [2026-07-19-explore-falco-cli-rules-events-output.md](../falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md), [2026-06-10-install-falco-first-detection.md](../falco/notes/2026-06-10-install-falco-first-detection.md), [2026-10-27-follow-official-falco-quickstart.md](../falco/notes/2026-10-27-follow-official-falco-quickstart.md)
- _…and 3 more under `falco/notes/` — browse the folder._
- **docs** (4): [runtime-security-monitoring-integration.md](../falco/docs/runtime-security-monitoring-integration.md), [tuned-falco-rules-noise-reduction.md](../falco/docs/tuned-falco-rules-noise-reduction.md), [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md)
- _…and 1 more under `falco/docs/` — browse the folder._
- **scripts** (3): [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh), [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh)
- **configs** (4): [first-custom-rule-detect-shell-in-container.yaml](../falco/configs/first-custom-rule-detect-shell-in-container.yaml), [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml), [2026-10-03-minimal-runtime-config.yaml](../falco/configs/2026-10-03-minimal-runtime-config.yaml)
- _…and 1 more under `falco/configs/` — browse the folder._
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)
- **templates** (4): [custom-rules.yaml](../falco/templates/falco-custom-rules-library/rules/custom-rules.yaml), [override-example.yaml](../falco/templates/falco-custom-rules-library/examples/override-example.yaml), [test-rules.sh](../falco/templates/falco-custom-rules-library/tests/test-rules.sh)
- _…and 1 more under `falco/templates/` — browse the folder._
- **manifests** (1): [falco-k8s-admission-control.yaml](../falco/manifests/falco-k8s-admission-control.yaml)
- **notebooks** (2): [rule-engine-vs-ebpf-probes.ipynb](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb), [falco-event-output-formats.ipynb](../falco/notebooks/falco-event-output-formats.ipynb)

## semgrep  ·  25 files
- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md), [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **docs** (8): [github-actions-ci-from-scratch.md](../semgrep/docs/github-actions-ci-from-scratch.md), [semgrep-code-scanning-integration-reference.md](../semgrep/docs/semgrep-code-scanning-integration-reference.md), [semgrep-rules-migration-guide.md](../semgrep/docs/semgrep-rules-migration-guide.md)
- _…and 5 more under `semgrep/docs/` — browse the folder._
- **scripts** (3): [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py), [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh), [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py)
- **configs** (1): [multi-rule-pack.yaml](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [first-custom-rule.yaml](../semgrep/snippets/first-custom-rule.yaml), [catch-privileged-containers.yaml](../semgrep/snippets/catch-privileged-containers.yaml)
- **manifests** (3): [semgrep-ci-cd-pipeline.yaml](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml), [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml), [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml)
- **dockerfiles** (2): [custom-scanning-image.Dockerfile](../semgrep/dockerfiles/custom-scanning-image.Dockerfile), [ci-entrypoint.sh](../semgrep/dockerfiles/ci-entrypoint.sh)
- **notebooks** (3): [rule-matching-mode-comparison.ipynb](../semgrep/notebooks/rule-matching-mode-comparison.ipynb), [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb), [comparing-community-vs-custom-rules.ipynb](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb)

## github-actions  ·  22 files
- **primer:** [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (7): [2026-10-14-run-first-workflow.md](../github-actions/notes/2026-10-14-run-first-workflow.md), [2026-07-14-explore-github-actions.md](../github-actions/notes/2026-07-14-explore-github-actions.md), [2026-09-21-quickstart-tripped-me-up.md](../github-actions/notes/2026-09-21-quickstart-tripped-me-up.md)
- _…and 4 more under `github-actions/notes/` — browse the folder._
- **docs** (1): [how-i-wired-github-actions-into-my-ci-workflow.md](../github-actions/docs/how-i-wired-github-actions-into-my-ci-workflow.md)
- **scripts** (1): [triage-latest-failed-run.sh](../github-actions/scripts/triage-latest-failed-run.sh)
- **configs** (8): [2026-10-14-first-scheduled-workflow.yaml](../github-actions/configs/2026-10-14-first-scheduled-workflow.yaml), [sample-app-ci.yml](../github-actions/configs/sample-app-ci.yml), [2026-09-21-minimal-starter-workflow.yaml](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml)
- _…and 5 more under `github-actions/configs/` — browse the folder._
- **snippets** (3): [2026-08-26-first-workflow.yaml](../github-actions/snippets/2026-08-26-first-workflow.yaml), [2026-10-14-trigger-first-workflow-gh.sh](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh), [2026-08-26-composite-action-input-reuse.yaml](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- **manifests** (2): [2026-08-04-what-is-github-actions.yaml](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [2026-08-04-pr-validation.yml](../github-actions/manifests/2026-08-04-pr-validation.yml)

## terrascan  ·  22 files
- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [2026-06-19-install-terrascan-tiny-tf.md](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md), [2026-07-10-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md), [2026-06-13-first-scan.md](../terrascan/notes/2026-06-13-first-scan.md)
- _…and 2 more under `terrascan/notes/` — browse the folder._
- **docs** (3): [terrascan-vs-checkov-terraform-iac-scanning.md](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md), [terrascan-scan-configuration-migration-patterns.md](../terrascan/docs/terrascan-scan-configuration-migration-patterns.md), [iac-pipeline-integration.md](../terrascan/docs/iac-pipeline-integration.md)
- **scripts** (2): [tried-terrascan-ci-scan.sh](../terrascan/scripts/tried-terrascan-ci-scan.sh), [policy-as-code-workflow.sh](../terrascan/scripts/policy-as-code-workflow.sh)
- **configs** (2): [tried-custom-s3-rule.yaml](../terrascan/configs/tried-custom-s3-rule.yaml), [terrascan-config-template.yaml](../terrascan/configs/terrascan-config-template.yaml)
- **snippets** (2): [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf), [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf)
- **templates** (6): [require-encryption.rego](../terrascan/templates/scanning-pipeline-scaffold/policies/require-encryption.rego), [run-scan.sh](../terrascan/templates/scanning-pipeline-scaffold/scripts/run-scan.sh), [config.yaml](../terrascan/templates/scanning-pipeline-scaffold/config.yaml)
- _…and 3 more under `terrascan/templates/` — browse the folder._
- **manifests** (1): [terrascan-gha-ci-multi-iac.yaml](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **notebooks** (1): [rego-vs-yaml-rule-authoring.ipynb](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)

## vault  ·  21 files
- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (4): [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md), [2026-08-26-install-vault-first-command.md](../vault/notes/2026-08-26-install-vault-first-command.md), [2026-06-15-vault-getting-started-trip-ups.md](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md)
- _…and 1 more under `vault/notes/` — browse the folder._
- **docs** (3): [vault-secrets-engine-selection-guide.md](../vault/docs/vault-secrets-engine-selection-guide.md), [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md), [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md)
- **scripts** (4): [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh), [vault-pki-workflow.sh](../vault/scripts/vault-pki-workflow.sh), [vault-db-dynamic-secrets.sh](../vault/scripts/vault-db-dynamic-secrets.sh)
- _…and 1 more under `vault/scripts/` — browse the folder._
- **configs** (3): [2026-09-04-aws-secrets-engine-policy.hcl](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl), [multi-environment-access-control.hcl](../vault/configs/multi-environment-access-control.hcl), [2026-06-26-dev-test-policies.hcl](../vault/configs/2026-06-26-dev-test-policies.hcl)
- **snippets** (2): [vault-read-write.go](../vault/snippets/vault-read-write.go), [2026-08-30-first-vault-secret.sh](../vault/snippets/2026-08-30-first-vault-secret.sh)
- **manifests** (2): [vault-sidecar-secrets-refresh.yaml](../vault/manifests/vault-sidecar-secrets-refresh.yaml), [vault-cluster-deployment.yaml](../vault/manifests/vault-cluster-deployment.yaml)
- **dockerfiles** (1): [custom-vault-image-with-plugins-tls.Dockerfile](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **notebooks** (2): [vault-secrets-backend-comparison-patterns.ipynb](../vault/notebooks/vault-secrets-backend-comparison-patterns.ipynb), [static-vs-dynamic-secrets.ipynb](../vault/notebooks/static-vs-dynamic-secrets.ipynb)

## cosign  ·  20 files
- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (5): [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md), [2026-06-22-cosign-getting-started-trip-ups.md](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [2026-06-13-install-cosign-sign-first-image.md](../cosign/notes/2026-06-13-install-cosign-sign-first-image.md)
- _…and 2 more under `cosign/notes/` — browse the folder._
- **docs** (4): [keyless-signing-patterns.md](../cosign/docs/keyless-signing-patterns.md), [cosign-verification-patterns.md](../cosign/docs/cosign-verification-patterns.md), [key-rotation-and-migration-patterns.md](../cosign/docs/key-rotation-and-migration-patterns.md)
- _…and 1 more under `cosign/docs/` — browse the folder._
- **scripts** (3): [verify-signed-image.sh](../cosign/scripts/verify-signed-image.sh), [minimal-sign-verify.sh](../cosign/scripts/minimal-sign-verify.sh), [cosign-key-management-workflow.sh](../cosign/scripts/cosign-key-management-workflow.sh)
- **configs** (2): [keyless-signing-github-actions.yaml](../cosign/configs/keyless-signing-github-actions.yaml), [cosign-signature-configuration.yaml](../cosign/configs/cosign-signature-configuration.yaml)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (2): [signed-container-build-oidc.yaml](../cosign/manifests/signed-container-build-oidc.yaml), [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)
- **dockerfiles** (2): [entrypoint.sh](../cosign/dockerfiles/entrypoint.sh), [custom-cosign-image.Dockerfile](../cosign/dockerfiles/custom-cosign-image.Dockerfile)
- **notebooks** (1): [key-based-vs-keyless-signing.ipynb](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## kubernetes  ·  20 files
- **primer:** [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (4): [2026-07-15-explore-kubernetes.md](../kubernetes/notes/2026-07-15-explore-kubernetes.md), [2026-10-20-quickstart-followup.md](../kubernetes/notes/2026-10-20-quickstart-followup.md), [2026-10-14-cluster-resources.md](../kubernetes/notes/2026-10-14-cluster-resources.md)
- _…and 1 more under `kubernetes/notes/` — browse the folder._
- **docs** (2): [rbac-design-patterns-for-multi-tenant-clusters.md](../kubernetes/docs/rbac-design-patterns-for-multi-tenant-clusters.md), [cluster-workflow-wiring.md](../kubernetes/docs/cluster-workflow-wiring.md)
- **scripts** (2): [cluster-health-check-and-conformance-validation.sh](../kubernetes/scripts/cluster-health-check-and-conformance-validation.sh), [2026-10-20-quickstart-repro.sh](../kubernetes/scripts/2026-10-20-quickstart-repro.sh)
- **configs** (3): [namespace-strategy-environment-vs-team.yaml](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml), [2026-10-20-minimal-deployment.yaml](../kubernetes/configs/2026-10-20-minimal-deployment.yaml), [2026-10-14-minimal-namespace.yaml](../kubernetes/configs/2026-10-14-minimal-namespace.yaml)
- **templates** (5): [cert-manager-bootstrap.yaml](../kubernetes/templates/cluster-bootstrap/cert-manager/cert-manager-bootstrap.yaml), [storage-class.yaml](../kubernetes/templates/cluster-bootstrap/csi/storage-class.yaml), [calico-installation.yaml](../kubernetes/templates/cluster-bootstrap/cni/calico-installation.yaml)
- _…and 2 more under `kubernetes/templates/` — browse the folder._
- **manifests** (4): [kustomize-overlays.yaml](../kubernetes/manifests/kustomize-overlays.yaml), [2026-09-10-first-pod.yaml](../kubernetes/manifests/2026-09-10-first-pod.yaml), [small-deployment-from-scratch.yaml](../kubernetes/manifests/small-deployment-from-scratch.yaml)
- _…and 1 more under `kubernetes/manifests/` — browse the folder._

## defectdojo  ·  19 files
- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (4): [2026-08-04-explore-defectdojo-ui.md](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md), [2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md](../defectdojo/notes/2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md), [2026-09-21-quickstart-tripups.md](../defectdojo/notes/2026-09-21-quickstart-tripups.md)
- _…and 1 more under `defectdojo/notes/` — browse the folder._
- **docs** (2): [how-i-wired-defectdojo-into-my-triage-workflow.md](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md), [defectdojo-scan-tool-ingestion-end-to-end.md](../defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md)
- **scripts** (3): [product-scan-import.py](../defectdojo/scripts/product-scan-import.py), [product-engagement-setup.py](../defectdojo/scripts/product-engagement-setup.py), [2026-09-20-defectdojo-tutorial-check.sh](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh)
- **configs** (2): [api-vs-ui-ingestion.yaml](../defectdojo/configs/api-vs-ui-ingestion.yaml), [2026-09-21-vulnerability-scanner-setup.yaml](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml)
- **snippets** (2): [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh), [2026-10-19-minimal-product-setup-api.py](../defectdojo/snippets/2026-10-19-minimal-product-setup-api.py)
- **templates** (6): [setup-product-engagement.py](../defectdojo/templates/defectdojo-scan-ingestion-starter/scripts/setup-product-engagement.py), [docker-compose.yaml](../defectdojo/templates/defectdojo-scan-ingestion-starter/docker-compose.yaml), [README.md](../defectdojo/templates/defectdojo-scan-ingestion-starter/README.md)
- _…and 3 more under `defectdojo/templates/` — browse the folder._

## dependabot  ·  19 files
- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (7): [2026-07-21-enabling-dependabot-alerts-security-updates.md](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md), [dependabot-alerts-security-updates.md](../dependabot/notes/dependabot-alerts-security-updates.md), [2026-06-22-first-time-dependabot-setup.md](../dependabot/notes/2026-06-22-first-time-dependabot-setup.md)
- _…and 4 more under `dependabot/notes/` — browse the folder._
- **docs** (4): [dependabot-version-control-workflow-integration.md](../dependabot/docs/dependabot-version-control-workflow-integration.md), [wired-dependabot-version-control-workflow.md](../dependabot/docs/wired-dependabot-version-control-workflow.md), [dependabot-security-update-auto-merge.md](../dependabot/docs/dependabot-security-update-auto-merge.md)
- _…and 1 more under `dependabot/docs/` — browse the folder._
- **scripts** (2): [dependabot-alert-aggregation.py](../dependabot/scripts/dependabot-alert-aggregation.py), [2026-08-04-dependabot-alert-triage.py](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py)
- **configs** (5): [2026-07-18-python-project-version-update.yaml](../dependabot/configs/2026-07-18-python-project-version-update.yaml), [dependabot-configuration-template.yaml](../dependabot/configs/dependabot-configuration-template.yaml), [tried-npm-dependabot.yaml](../dependabot/configs/tried-npm-dependabot.yaml)
- _…and 2 more under `dependabot/configs/` — browse the folder._
- **notebooks** (1): [auto-merge-vs-manual-review.ipynb](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## docker  ·  19 files
- **primer:** [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **notes** (2): [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md), [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **docs** (2): [dockerfile-optimization-patterns.md](../docker/docs/dockerfile-optimization-patterns.md), [cicd-end-to-end.md](../docker/docs/cicd-end-to-end.md)
- **scripts** (3): [reusable-build.sh](../docker/scripts/reusable-build.sh), [build-multi-service-compose-app.sh](../docker/scripts/build-multi-service-compose-app.sh), [2026-07-18-custom-network-volume-mounts.sh](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh)
- **configs** (1): [docker-compose-dev-environment.yaml](../docker/configs/docker-compose-dev-environment.yaml)
- **templates** (7): [index.html](../docker/templates/multi-service-setup/web/index.html), [compose.yaml](../docker/templates/multi-service-setup/compose.yaml), [Dockerfile](../docker/templates/multi-service-setup/web/Dockerfile)
- _…and 4 more under `docker/templates/` — browse the folder._
- **manifests** (1): [docker-compose-production.yaml](../docker/manifests/docker-compose-production.yaml)
- **dockerfiles** (3): [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [small-app.Dockerfile](../docker/dockerfiles/small-app.Dockerfile), [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)

## tetragon  ·  11 files
- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (3): [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md), [2026-08-06-tetragon-observability-tutorial.md](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **docs** (1): [runtime-security-workflow.md](../tetragon/docs/runtime-security-workflow.md)
- **scripts** (3): [build-tetragon-file-access-tracing-policy.sh](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh), [build-tetragon-policy.sh](../tetragon/scripts/build-tetragon-policy.sh), [2026-08-05-tetragon-event-collection-pipeline.sh](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- **configs** (4): [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml), [tetragon-policy-config-for-k8s-runtime-monitoring.yaml](../tetragon/configs/tetragon-policy-config-for-k8s-runtime-monitoring.yaml), [policy-approaches-comparison.yaml](../tetragon/configs/policy-approaches-comparison.yaml)
- _…and 1 more under `tetragon/configs/` — browse the folder._

## git  ·  10 files
- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (3): [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md), [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md), [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **docs** (1): [how-i-wired-git-into-my-version-control-workflow.md](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **scripts** (4): [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh), [2026-08-24-first-repo-stage-log.sh](../git/scripts/2026-08-24-first-repo-stage-log.sh), [git-automation.sh](../git/scripts/git-automation.sh)
- _…and 1 more under `git/scripts/` — browse the folder._
- **configs** (1): [config-strategy-layered-vs-conditional.yaml](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## grafana  ·  10 files
- **primer:** [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)
- **notes** (4): [2026-09-26-explore-grafana-dashboard-ui.md](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md), [2026-09-19-first-dashboard-browser.md](../grafana/notes/2026-09-19-first-dashboard-browser.md), [2026-10-14-grafana-quickstart-trip-ups.md](../grafana/notes/2026-10-14-grafana-quickstart-trip-ups.md)
- _…and 1 more under `grafana/notes/` — browse the folder._
- **docs** (1): [grafana-alerting-routing-templates.md](../grafana/docs/grafana-alerting-routing-templates.md)
- **scripts** (1): [build-dashboard-provisioning.py](../grafana/scripts/build-dashboard-provisioning.py)
- **configs** (2): [2026-10-14-dashboard-provisioning.yaml](../grafana/configs/2026-10-14-dashboard-provisioning.yaml), [2026-09-19-first-datasource.yaml](../grafana/configs/2026-09-19-first-datasource.yaml)
- **snippets** (1): [2026-10-14-first-grafana-datasource-query.py](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- **manifests** (1): [grafana-datasource-dashboard.yaml](../grafana/manifests/grafana-datasource-dashboard.yaml)

## kustomize  ·  10 files
- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (3): [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md), [2026-09-21-kustomize-quickstart-tripped-me-up.md](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md), [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **docs** (1): [how-i-wired-kustomize-into-my-manifest-workflow.md](../kustomize/docs/how-i-wired-kustomize-into-my-manifest-workflow.md)
- **scripts** (2): [bases-vs-remote-resources.sh](../kustomize/scripts/bases-vs-remote-resources.sh), [2026-10-20-kustomize-tutorial.sh](../kustomize/scripts/2026-10-20-kustomize-tutorial.sh)
- **configs** (3): [2026-09-22-minimal-kustomization-with-overlay.yaml](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml), [small-overlay.yaml](../kustomize/configs/small-overlay.yaml), [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml)
- **manifests** (1): [2026-09-21-kustomize-tutorial.yaml](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## opentofu  ·  10 files
- **primer:** [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (4): [2026-10-20-follow-opentofu-test-quickstart.md](../opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md), [2026-09-21-follow-open-tofu-quickstart.md](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md), [2026-07-20-explore-open-tofu.md](../opentofu/notes/2026-07-20-explore-open-tofu.md)
- _…and 1 more under `opentofu/notes/` — browse the folder._
- **docs** (2): [open-tofu-vs-terraform-migration-decision-matrix.md](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md), [how-i-wired-opentofu-into-my-iac-workflow.md](../opentofu/docs/how-i-wired-opentofu-into-my-iac-workflow.md)
- **scripts** (1): [module-registry-publisher.sh](../opentofu/scripts/module-registry-publisher.sh)
- **configs** (3): [2026-09-21-minimal-opentofu-config-with-vars.hcl](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl), [2026-09-10-minimal-opentofu-config.hcl](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl), [2026-07-20-first-open-tofu-config.hcl](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## gitleaks  ·  9 files
- **primer:** [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md)
- **notes** (3): [2026-10-07-quickstart-trip-ups.md](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md), [2026-09-19-first-secret-scan.md](../gitleaks/notes/2026-09-19-first-secret-scan.md), [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md)
- **docs** (1): [integrating-gitleaks-pre-commit-ci.md](../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md)
- **scripts** (3): [2026-10-13-auditing-git-secrets.sh](../gitleaks/scripts/2026-10-13-auditing-git-secrets.sh), [build-custom-gitleaks-ruleset.sh](../gitleaks/scripts/build-custom-gitleaks-ruleset.sh), [2026-09-26-run-first-gitleaks-scan.sh](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh)
- **configs** (2): [gitleaks-config.toml](../gitleaks/configs/gitleaks-config.toml), [2026-10-07-detection-rules.yaml](../gitleaks/configs/2026-10-07-detection-rules.yaml)

## helm  ·  9 files
- **primer:** [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **notes** (4): [2026-09-21-quickstart-tripped-me-up.md](../helm/notes/2026-09-21-quickstart-tripped-me-up.md), [2026-10-20-followed-quickstart.md](../helm/notes/2026-10-20-followed-quickstart.md), [2026-07-19-explore-helm-charts-releases-values-repos.md](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md)
- _…and 1 more under `helm/notes/` — browse the folder._
- **docs** (1): [how-i-wired-helm-into-my-release-workflow.md](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- **scripts** (1): [build-and-deploy-chart.sh](../helm/scripts/build-and-deploy-chart.sh)
- **configs** (1): [values-file-vs-set-flags.yaml](../helm/configs/values-file-vs-set-flags.yaml)
- **manifests** (2): [2026-09-21-minimal-service-chart.yaml](../helm/manifests/2026-09-21-minimal-service-chart.yaml), [2026-07-15-first-chart-values.yaml](../helm/manifests/2026-07-15-first-chart-values.yaml)

## linux  ·  7 files
- **notes** (3): [2026-10-02-explore-linux-environment.md](../linux/notes/2026-10-02-explore-linux-environment.md), [2026-08-06-linux-shell-scripting-tutorial-confusions.md](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md), [2026-07-21-install-linux-vm-terminal-first-commands.md](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- **docs** (1): [system-administration-runbook.md](../linux/docs/system-administration-runbook.md)
- **scripts** (2): [health-check-and-rollback.sh](../linux/scripts/health-check-and-rollback.sh), [find-large-logs.sh](../linux/scripts/find-large-logs.sh)
- **configs** (1): [2026-08-06-cron-job-configuration.ini](../linux/configs/2026-08-06-cron-job-configuration.ini)

## prometheus  ·  7 files
- **primer:** [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (5): [2026-09-20-checking-the-metrics-interface.md](../prometheus/notes/2026-09-20-checking-the-metrics-interface.md), [2026-10-14-first-query-log.md](../prometheus/notes/2026-10-14-first-query-log.md), [2026-10-14-observability-primer-dedup.md](../prometheus/notes/2026-10-14-observability-primer-dedup.md)
- _…and 2 more under `prometheus/notes/` — browse the folder._
- **scripts** (1): [2026-10-25-query-api-python.py](../prometheus/scripts/2026-10-25-query-api-python.py)
- **snippets** (1): [2026-10-25-minimal-scrape-config.yaml](../prometheus/snippets/2026-10-25-minimal-scrape-config.yaml)

## sonarqube  ·  7 files
- **primer:** [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (3): [2026-09-21-follow-sonarqube-quickstart.md](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md), [2026-07-19-explore-sonarqube-quality-gates-profiles.md](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md), [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **scripts** (1): [2026-09-21-sonarqube-scan-setup.sh](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **configs** (2): [minimal-project-quality-gate.yaml](../sonarqube/configs/minimal-project-quality-gate.yaml), [2026-09-21-minimal-quality-gate.yaml](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml)
- **snippets** (1): [2026-07-16-first-sonarscanner-run.sh](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## tfsec  ·  6 files
- **primer:** [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md)
- **notes** (3): [2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md](../tfsec/notes/2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md), [2026-09-20-first-tfsec-scan.md](../tfsec/notes/2026-09-20-first-tfsec-scan.md), [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md)
- **scripts** (1): [2026-10-19-ran-my-first-tfsec-scan.sh](../tfsec/scripts/2026-10-19-ran-my-first-tfsec-scan.sh)
- **configs** (1): [2026-10-19-minimal-tfsec-scan-config.yaml](../tfsec/configs/2026-10-19-minimal-tfsec-scan-config.yaml)
- **snippets** (1): [enforce-s3-bucket-encryption.rego](../tfsec/snippets/enforce-s3-bucket-encryption.rego)

## nuclei  ·  5 files
- **primer:** [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md)
- **notes** (3): [2026-10-15-nuclei-quickstart-trip-ups.md](../nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md), [2026-09-20-first-template-scan-attempt.md](../nuclei/notes/2026-09-20-first-template-scan-attempt.md), [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md)
- **scripts** (1): [2026-10-15-first-nuclei-scan.sh](../nuclei/scripts/2026-10-15-first-nuclei-scan.sh)
- **configs** (1): [2026-10-15-minimal-scan-template.yaml](../nuclei/configs/2026-10-15-minimal-scan-template.yaml)

## .github  ·  3 files

## Cross-cutting folders

These sit alongside the per-tool folders and are indexed here rather than given their own section.

- **`docs/`** (221 files) — Concept primers, how-to guides, reference, runbooks, security, setup, and troubleshooting. Start at [concept primers](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md).
- **`scripts/`** (196 files) — Shell toolkits by domain under `scripts/bash/`, pipeline helpers, and reusable utilities.
- **`snippets/`** (23 files) — Copy-paste cheatsheets and one-liners. [linux-cheatsheet.md](../snippets/linux-cheatsheet.md), [ci-cd-cheatsheet.md](../snippets/ci-cd-cheatsheet.md), [vault-commands.md](../snippets/vault-commands.md).
- **`templates/`** (45 files) — Starter configs for Kubernetes, Terraform, and platform tooling.
- **`learn/`** (13 files) — Ordered lessons that follow the [learning path](learning-path.md).
- **`environments/`** (23 files) — Terraform configs (dev/staging/prod) and [promotion workflow](../environments/docs/managing-environments.md).
- **`lab/`** (17 files) — Mini-projects and learning sandboxes.
- **`assets/`** (14 files) — Architecture diagrams and workflow illustrations.
