# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## trufflehog · 37 files
- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (3): [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md), [2026-05-27-following-trufflehog-quickstart.md](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md), [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **docs** (2): [trufflehog-output-formats-json-sarif-csv.md](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md), [comparing-scan-modes-git-filesystem-s3.md](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md)
- **scripts** (3): [pre-commit-scan-pipeline.sh](../trufflehog/scripts/pre-commit-scan-pipeline.sh), [multi-repo-scan-pipeline.sh](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [analyze-trufflehog-results.py](../trufflehog/scripts/analyze-trufflehog-results.py)
- **configs** (2): [trufflehog-custom-regex-config.yaml](../trufflehog/configs/trufflehog-custom-regex-config.yaml), [custom-detector-rules.yaml](../trufflehog/configs/custom-detector-rules.yaml)
- **snippets** (2): [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh), [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh)
- **templates** (21): [trufflehog-config.yaml](../trufflehog/templates/secret-scanning-pipeline/trufflehog-config.yaml), [scan-all.sh](../trufflehog/templates/secret-scanning-pipeline/scripts/scan-all.sh), [README.md](../trufflehog/templates/secret-scanning-pipeline/README.md) — _…and 18 more under `trufflehog/templates/`._
- **manifests** (1): [trufflehog-pr-secret-scan-reusable.yaml](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- **dockerfiles** (1): [pre-commit-scanner.Dockerfile](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile)
- **notebooks** (2): [trufflehog-scan-modes-comparison.ipynb](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb), [analyzing-trufflehog-false-positives.ipynb](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)

## zap · 33 files
- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (5): [2026-07-20-install-zap-baseline-scan.md](../zap/notes/2026-07-20-install-zap-baseline-scan.md), [2026-06-13-spider-scan-test-app.md](../zap/notes/2026-06-13-spider-scan-test-app.md), [2026-06-06-zap-quickstart-ui-gotchas.md](../zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md) — _…and 2 more under `zap/notes/`._
- **docs** (3): [zap-integration-patterns.md](../zap/docs/zap-integration-patterns.md), [zap-automation-plan-structure.md](../zap/docs/zap-automation-plan-structure.md), [passive-vs-active-scanning-zap.md](../zap/docs/passive-vs-active-scanning-zap.md)
- **scripts** (2): [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh), [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh)
- **configs** (2): [zap-authenticated-scan-context.yaml](../zap/configs/zap-authenticated-scan-context.yaml), [ci-dast-automation-framework-plan.yaml](../zap/configs/ci-dast-automation-framework-plan.yaml)
- **snippets** (4): [my-first-zap-spider-scan.sh](../zap/snippets/my-first-zap-spider-scan.sh), [my-first-zap-baseline-scan.sh](../zap/snippets/my-first-zap-baseline-scan.sh), [authenticated-scan-with-context.sh](../zap/snippets/authenticated-scan-with-context.sh) — _…and 1 more under `zap/snippets/`._
- **templates** (16): [zap-automation-plan.yaml](../zap/templates/zap-dast-integration/zap-automation-plan.yaml), [run-zap-dast.sh](../zap/templates/zap-dast-integration/scripts/run-zap-dast.sh), [quick-scan.yaml](../zap/templates/zap-dast-integration/plans/quick-scan.yaml) — _…and 13 more under `zap/templates/`._
- **dockerfiles** (1): [custom-zap-automation.Dockerfile](../zap/dockerfiles/custom-zap-automation.Dockerfile)

## syft · 33 files
- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (4): [2026-05-30-sbom-format-comparison.md](../syft/notes/2026-05-30-sbom-format-comparison.md), [2026-05-29-syft-quickstart-trip-ups.md](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md), [2026-05-27-install-syft-first-sbom.md](../syft/notes/2026-05-27-install-syft-first-sbom.md) — _…and 1 more under `syft/notes/`._
- **docs** (5): [sbom-output-formats-reference.md](../syft/docs/sbom-output-formats-reference.md), [sbom-formats-comparison.md](../syft/docs/sbom-formats-comparison.md), [registry-auth-caching-patterns.md](../syft/docs/registry-auth-caching-patterns.md) — _…and 2 more under `syft/docs/`._
- **scripts** (3): [sbom-vuln-pipeline.sh](../syft/scripts/sbom-vuln-pipeline.sh), [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh), [gen-multi-format-sboms.sh](../syft/scripts/gen-multi-format-sboms.sh)
- **configs** (1): [.syft.yaml](../syft/configs/.syft.yaml)
- **snippets** (1): [tried-sbom-formats.sh](../syft/snippets/tried-sbom-formats.sh)
- **templates** (15): [k8s-workload-scan.yml](../syft/templates/syft-trivy-k8s-scan-scaffold/.github/workflows/k8s-workload-scan.yml), [scan-workload-images.sh](../syft/templates/syft-trivy-k8s-scan-scaffold/scripts/scan-workload-images.sh), [README.md](../syft/templates/syft-trivy-k8s-scan-scaffold/README.md) — _…and 12 more under `syft/templates/`._
- **manifests** (1): [syft-gha-multi-arch-sbom-registry-auth.yaml](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml)
- **dockerfiles** (1): [multi-stage-sbom.Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (2): [output-format-comparison.ipynb](../syft/notebooks/output-format-comparison.ipynb), [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb)

## checkov · 33 files
- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [2026-05-27-checkov-quickstart-trip-ups.md](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md), [2026-05-26-cli-vs-sdk-comparison.md](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [2026-05-25-scan-terraform-plan.md](../checkov/notes/2026-05-25-scan-terraform-plan.md) — _…and 1 more under `checkov/notes/`._
- **docs** (5): [pre-commit-hook-with-version-pinning.md](../checkov/docs/pre-commit-hook-with-version-pinning.md), [multi-cloud-policy-management.md](../checkov/docs/multi-cloud-policy-management.md), [checkov-v3-migration-guide.md](../checkov/docs/checkov-v3-migration-guide.md) — _…and 2 more under `checkov/docs/`._
- **scripts** (2): [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh), [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh)
- **configs** (2): [checkov-skip-severity-config.yaml](../checkov/configs/checkov-skip-severity-config.yaml), [checkov-ci-config.yaml](../checkov/configs/checkov-ci-config.yaml)
- **snippets** (4): [terraform-scan-custom-policies.py](../checkov/snippets/terraform-scan-custom-policies.py), [scan-terraform-dir.py](../checkov/snippets/scan-terraform-dir.py), [scan-kubernetes.sh](../checkov/snippets/scan-kubernetes.sh) — _…and 1 more under `checkov/snippets/`._
- **templates** (10): [example-caller-workflow.yml](../checkov/templates/reusable-workflow-custom-policies/example-caller-workflow.yml), [restrict_ec2_public_ip.yaml](../checkov/templates/reusable-workflow-custom-policies/custom-policies/restrict_ec2_public_ip.yaml), [no_public_s3_buckets.yaml](../checkov/templates/reusable-workflow-custom-policies/custom-policies/no_public_s3_buckets.yaml) — _…and 7 more under `checkov/templates/`._
- **manifests** (3): [checkov-gitlab-ci-multi-cloud-drift.yaml](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml), [layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml), [checkov-sarif-pr-blocking.yaml](../checkov/manifests/checkov-sarif-pr-blocking.yaml)
- **notebooks** (2): [compare-static-vs-plan-scanning.ipynb](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb), [compare-builtin-vs-custom-k8s.ipynb](../checkov/notebooks/compare-builtin-vs-custom-k8s.ipynb)
- **policies** (1): [no_public_s3_buckets.yaml](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)

## trivy · 28 files
- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (4): [scanning-performance-optimization.md](../trivy/notes/scanning-performance-optimization.md), [2026-05-26-trivy-quickstart.md](../trivy/notes/2026-05-26-trivy-quickstart.md), [2026-05-24-install-trivy.md](../trivy/notes/2026-05-24-install-trivy.md) — _…and 1 more under `trivy/notes/`._
- **docs** (4): [multi-arch-vulnerability-scanning.md](../trivy/docs/multi-arch-vulnerability-scanning.md), [sbom-scanning-reference-guide.md](../trivy/docs/sbom-scanning-reference-guide.md), [ci-pipeline-sarif-output.md](../trivy/docs/ci-pipeline-sarif-output.md) — _…and 1 more under `trivy/docs/`._
- **scripts** (6): [ignore-rules-pipeline.sh](../trivy/scripts/ignore-rules-pipeline.sh), [multi-target-scanner.sh](../trivy/scripts/multi-target-scanner.sh), [image-vuln-pipeline.sh](../trivy/scripts/image-vuln-pipeline.sh) — _…and 3 more under `trivy/scripts/`._
- **configs** (2): [trivy-scan-config.yaml](../trivy/configs/trivy-scan-config.yaml), [.trivy.yaml](../trivy/configs/.trivy.yaml)
- **snippets** (1): [scan-docker-image.sh](../trivy/snippets/scan-docker-image.sh)
- **templates** (6): [trivy.yaml](../trivy/templates/trivy-monorepo-scanner/trivy.yaml), [scan-all.sh](../trivy/templates/trivy-monorepo-scanner/scripts/scan-all.sh), [README.md](../trivy/templates/trivy-monorepo-scanner/README.md) — _…and 3 more under `trivy/templates/`._
- **manifests** (2): [trivy-sarif-code-scanning.yaml](../trivy/manifests/trivy-sarif-code-scanning.yaml), [trivy-operator-deployment.yaml](../trivy/manifests/trivy-operator-deployment.yaml)
- **dockerfiles** (1): [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy-scan-mode-comparison.ipynb](../trivy/notebooks/trivy-scan-mode-comparison.ipynb), [trivy-sarif-output-processing.ipynb](../trivy/notebooks/trivy-sarif-output-processing.ipynb)

## terraform · 20 files
- **primer:** [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **notes** (3): [2026-08-04-install-terraform-first-vm.md](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [2026-07-15-explore-terraform.md](../terraform/notes/2026-07-15-explore-terraform.md), [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **docs** (1): [terraform-module-composition.md](../terraform/docs/terraform-module-composition.md)
- **scripts** (4): [state-management-workflow.sh](../terraform/scripts/state-management-workflow.sh), [2026-07-18-deploy.sh](../terraform/scripts/2026-07-18-deploy.sh), [2026-07-18-cleanup.sh](../terraform/scripts/2026-07-18-cleanup.sh) — _…and 1 more under `terraform/scripts/`._
- **configs** (4): [workspace-variable-precedence.hcl](../terraform/configs/workspace-variable-precedence.hcl), [multi-environment-workspaces-variables.hcl](../terraform/configs/multi-environment-workspaces-variables.hcl), [2026-08-04-first-configuration.hcl](../terraform/configs/2026-08-04-first-configuration.hcl) — _…and 1 more under `terraform/configs/`._
- **snippets** (1): [2026-07-20-practice-terraform-variables-outputs-datasources.hcl](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)

## semgrep · 20 files
- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md), [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **docs** (5): [semgrep-rule-writing-reference.md](../semgrep/docs/semgrep-rule-writing-reference.md), [semgrep-rule-performance-optimization.md](../semgrep/docs/semgrep-rule-performance-optimization.md), [semgrep-ci-integration.md](../semgrep/docs/semgrep-ci-integration.md) — _…and 2 more under `semgrep/docs/`._
- **scripts** (3): [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh), [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py), [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py)
- **configs** (1): [multi-rule-pack.yaml](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [first-custom-rule.yaml](../semgrep/snippets/first-custom-rule.yaml), [catch-privileged-containers.yaml](../semgrep/snippets/catch-privileged-containers.yaml)
- **manifests** (2): [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml), [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml)
- **dockerfiles** (2): [custom-scanning-image.Dockerfile](../semgrep/dockerfiles/custom-scanning-image.Dockerfile), [ci-entrypoint.sh](../semgrep/dockerfiles/ci-entrypoint.sh)
- **notebooks** (2): [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb), [comparing-community-vs-custom-rules.ipynb](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb)

## grype · 20 files
- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **notes** (4): [2026-06-08-first-grype-scan.md](../grype/notes/2026-06-08-first-grype-scan.md), [2026-06-04-grype-quickstart-trip-ups.md](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md), [2026-05-31-install-grype.md](../grype/notes/2026-05-31-install-grype.md) — _…and 1 more under `grype/notes/`._
- **docs** (1): [grype-syft-integration-guide.md](../grype/docs/grype-syft-integration-guide.md)
- **scripts** (8): [vuln-diff-two-images.sh](../grype/scripts/vuln-diff-two-images.sh), [minimal-grype-scan.sh](../grype/scripts/minimal-grype-scan.sh), [grype-vuln-pipeline.sh](../grype/scripts/grype-vuln-pipeline.sh) — _…and 5 more under `grype/scripts/`._
- **configs** (1): [grype-ci-github-actions.yaml](../grype/configs/grype-ci-github-actions.yaml)
- **snippets** (2): [my-first-grype-commands.sh](../grype/snippets/my-first-grype-commands.sh), [minimal-grype-scan.go](../grype/snippets/minimal-grype-scan.go)
- **manifests** (2): [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml), [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml)
- **dockerfiles** (1): [multi-stage-grype-scan.Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (1): [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb)

## terrascan · 18 files
- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [2026-07-10-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md), [2026-06-29-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md), [2026-06-19-install-terrascan-tiny-tf.md](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md) — _…and 2 more under `terrascan/notes/`._
- **docs** (1): [terrascan-vs-checkov-terraform-iac-scanning.md](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md)
- **scripts** (2): [tried-terrascan-ci-scan.sh](../terrascan/scripts/tried-terrascan-ci-scan.sh), [policy-as-code-workflow.sh](../terrascan/scripts/policy-as-code-workflow.sh)
- **configs** (1): [tried-custom-s3-rule.yaml](../terrascan/configs/tried-custom-s3-rule.yaml)
- **snippets** (2): [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf), [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf)
- **templates** (6): [run-scan.sh](../terrascan/templates/scanning-pipeline-scaffold/scripts/run-scan.sh), [require-encryption.rego](../terrascan/templates/scanning-pipeline-scaffold/policies/require-encryption.rego), [block-public-s3-buckets.rego](../terrascan/templates/scanning-pipeline-scaffold/policies/block-public-s3-buckets.rego) — _…and 3 more under `terrascan/templates/`._
- **manifests** (1): [terrascan-gha-ci-multi-iac.yaml](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)

## falco · 13 files
- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (4): [2026-07-19-explore-falco-cli-rules-events-output.md](../falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md), [2026-06-15-falco-rules-macros-lists.md](../falco/notes/2026-06-15-falco-rules-macros-lists.md), [2026-06-10-install-falco-first-detection.md](../falco/notes/2026-06-10-install-falco-first-detection.md) — _…and 1 more under `falco/notes/`._
- **docs** (2): [tuned-falco-rules-noise-reduction.md](../falco/docs/tuned-falco-rules-noise-reduction.md), [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md)
- **scripts** (3): [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh), [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh)
- **configs** (3): [first-custom-rule-detect-shell-in-container.yaml](../falco/configs/first-custom-rule-detect-shell-in-container.yaml), [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml), [2026-06-10-first-custom-rule-detect-shell-in-container.yaml](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml)
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)

## codeql · 12 files
- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (3): [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md), [2026-06-05-install-codeql-first-analysis.md](../codeql/notes/2026-06-05-install-codeql-first-analysis.md), [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **docs** (1): [wired-custom-queries-into-ci.md](../codeql/docs/wired-custom-queries-into-ci.md)
- **scripts** (1): [first-codeql-analysis.sh](../codeql/scripts/first-codeql-analysis.sh)
- **configs** (1): [first-codeql-analysis.yml](../codeql/configs/first-codeql-analysis.yml)
- **snippets** (4): [my-first-codeql-commands.sh](../codeql/snippets/my-first-codeql-commands.sh), [hardcoded-secret-from-scratch.ql](../codeql/snippets/hardcoded-secret-from-scratch.ql), [hardcoded-creds-local-flow.ql](../codeql/snippets/hardcoded-creds-local-flow.ql) — _…and 1 more under `codeql/snippets/`._
- **manifests** (1): [multi-language-codeql-analysis.yaml](../codeql/manifests/multi-language-codeql-analysis.yaml)
- **dockerfiles** (1): [custom-codeql-analysis-image.Dockerfile](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)

## vault · 11 files
- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (3): [2026-06-15-vault-getting-started-trip-ups.md](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md), [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md), [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **docs** (2): [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md), [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md)
- **scripts** (2): [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh), [vault-db-dynamic-secrets.sh](../vault/scripts/vault-db-dynamic-secrets.sh)
- **configs** (2): [multi-environment-access-control.hcl](../vault/configs/multi-environment-access-control.hcl), [2026-06-26-dev-test-policies.hcl](../vault/configs/2026-06-26-dev-test-policies.hcl)
- **snippets** (1): [vault-read-write.go](../vault/snippets/vault-read-write.go)
- **dockerfiles** (1): [custom-vault-image-with-plugins-tls.Dockerfile](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)

## gitguardian · 11 files
- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (4): [2026-06-14-first-secrets-scan-repo.md](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md), [2026-06-13-ggshield-quickstart-trip-ups.md](../gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md), [2026-06-07-first-ggshield-scan.md](../gitguardian/notes/2026-06-07-first-ggshield-scan.md) — _…and 1 more under `gitguardian/notes/`._
- **docs** (1): [monorepo-ci-per-team-exclusions.md](../gitguardian/docs/monorepo-ci-per-team-exclusions.md)
- **scripts** (2): [pre-commit-hook-ggshield.sh](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh)
- **configs** (2): [monorepo-allowlists.yaml](../gitguardian/configs/monorepo-allowlists.yaml), [.ggshield.yaml](../gitguardian/configs/.ggshield.yaml)
- **snippets** (2): [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh), [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh)

## dependabot · 11 files
- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (7): [dependabot-alerts-security-updates.md](../dependabot/notes/dependabot-alerts-security-updates.md), [2026-08-08-dependabot-custom-registry-tutorial.md](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md), [2026-07-21-enabling-dependabot-alerts-security-updates.md](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md) — _…and 4 more under `dependabot/notes/`._
- **scripts** (1): [2026-08-04-dependabot-alert-triage.py](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py)
- **configs** (3): [tried-npm-dependabot.yaml](../dependabot/configs/tried-npm-dependabot.yaml), [2026-07-18-python-project-version-update.yaml](../dependabot/configs/2026-07-18-python-project-version-update.yaml), [2026-07-10-npm-version-strategy.yaml](../dependabot/configs/2026-07-10-npm-version-strategy.yaml)

## snyk · 10 files
- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (4): [2026-06-14-first-vulnerability-scan.md](../snyk/notes/2026-06-14-first-vulnerability-scan.md), [2026-06-08-install-snyk-first-test.md](../snyk/notes/2026-06-08-install-snyk-first-test.md), [2026-06-07-snyk-quickstart-walkthrough.md](../snyk/notes/2026-06-07-snyk-quickstart-walkthrough.md) — _…and 1 more under `snyk/notes/`._
- **docs** (1): [multi-project-ci-pipeline.md](../snyk/docs/multi-project-ci-pipeline.md)
- **scripts** (1): [snyk-vuln-scan-pipeline.sh](../snyk/scripts/snyk-vuln-scan-pipeline.sh)
- **configs** (2): [snyk-dependency-patch-ignore.yaml](../snyk/configs/snyk-dependency-patch-ignore.yaml), [snyk-ci-github-actions.yaml](../snyk/configs/snyk-ci-github-actions.yaml)
- **snippets** (1): [my-first-snyk-commands.sh](../snyk/snippets/my-first-snyk-commands.sh)
- **dockerfiles** (1): [custom-snyk-cli-air-gapped.Dockerfile](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)

## opa · 9 files
- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (3): [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md), [2026-06-06-install-opa-repl.md](../opa/notes/2026-06-06-install-opa-repl.md), [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **docs** (1): [wired-opa-admission-control.md](../opa/docs/wired-opa-admission-control.md)
- **scripts** (1): [how-i-test-policies-locally.sh](../opa/scripts/how-i-test-policies-locally.sh)
- **configs** (1): [tried-a-gatekeeper-constraint.yaml](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- **snippets** (3): [my-first-opa-policy-eval.sh](../opa/snippets/my-first-opa-policy-eval.sh), [enforce-image-registry-constraints.rego](../opa/snippets/enforce-image-registry-constraints.rego), [deny-privileged-hostnetwork.rego](../opa/snippets/deny-privileged-hostnetwork.rego)

## cosign · 9 files
- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (4): [2026-06-22-cosign-getting-started-trip-ups.md](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md), [2026-06-13-install-cosign-sign-first-image.md](../cosign/notes/2026-06-13-install-cosign-sign-first-image.md) — _…and 1 more under `cosign/notes/`._
- **scripts** (2): [verify-signed-image.sh](../cosign/scripts/verify-signed-image.sh), [minimal-sign-verify.sh](../cosign/scripts/minimal-sign-verify.sh)
- **configs** (1): [keyless-signing-github-actions.yaml](../cosign/configs/keyless-signing-github-actions.yaml)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (1): [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)

## docker · 8 files
- **primer:** [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **notes** (2): [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md), [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **docs** (1): [dockerfile-optimization-patterns.md](../docker/docs/dockerfile-optimization-patterns.md)
- **scripts** (2): [build-multi-service-compose-app.sh](../docker/scripts/build-multi-service-compose-app.sh), [2026-07-18-custom-network-volume-mounts.sh](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh)
- **configs** (1): [docker-compose-dev-environment.yaml](../docker/configs/docker-compose-dev-environment.yaml)
- **dockerfiles** (2): [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)

## argocd · 9 files
- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (6): [2026-08-12-quickstart-tripups.md](../argocd/notes/2026-08-12-quickstart-tripups.md), [2026-08-01-verify-readme-layout.md](../argocd/notes/2026-08-01-verify-readme-layout.md), [2026-07-31-verify-readme-layout.md](../argocd/notes/2026-07-31-verify-readme-layout.md) — _…and 3 more under `argocd/notes/`._
- **configs** (1): [private-repo-credentials-rbac.yaml](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- **manifests** (2): [2026-08-12-gitops-sync-sample-web-app.yaml](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml), [2026-07-06-sample-app-application.yaml](../argocd/manifests/2026-07-06-sample-app-application.yaml)

## GitHub Actions · 7 files
- **primer:** [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (3): [2026-08-04-explore-github-actions.md](../github-actions/notes/2026-08-04-explore-github-actions.md), [2026-07-14-explore-github-actions.md](../github-actions/notes/2026-07-14-explore-github-actions.md), [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **configs** (2): [2026-08-04-first-workflow.yaml](../github-actions/configs/2026-08-04-first-workflow.yaml), [2026-07-14-first-github-actions-workflow.yaml](../github-actions/configs/2026-07-14-first-github-actions-workflow.yaml)
- **manifests** (2): [2026-08-04-what-is-github-actions.yaml](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [2026-08-04-pr-validation.yml](../github-actions/manifests/2026-08-04-pr-validation.yml)

## tetragon · 6 files
- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (3): [2026-08-06-tetragon-observability-tutorial.md](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md), [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **scripts** (1): [2026-08-05-tetragon-event-collection-pipeline.sh](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- **configs** (2): [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml), [2026-08-05-minimal-network-tracing-policy.yaml](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml)

## git · 6 files
- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (3): [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md), [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md), [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **scripts** (2): [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh), [2026-07-10-local-ci-simulation.sh](../git/scripts/2026-07-10-local-ci-simulation.sh)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## sonarqube · 3 files
- **primer:** [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (2): [2026-07-19-explore-sonarqube-quality-gates-profiles.md](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md), [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **snippets** (1): [2026-07-16-first-sonarscanner-run.sh](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## opentofu · 3 files
- **primer:** [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (2): [2026-07-20-explore-open-tofu.md](../opentofu/notes/2026-07-20-explore-open-tofu.md), [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **configs** (1): [2026-07-20-first-open-tofu-config.hcl](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## kustomize · 3 files
- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (2): [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md), [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **configs** (1): [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml)

## kubernetes · 3 files
- **primer:** [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (2): [2026-07-15-explore-kubernetes.md](../kubernetes/notes/2026-07-15-explore-kubernetes.md), [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **manifests** (1): [2026-07-15-first-pod-service.yaml](../kubernetes/manifests/2026-07-15-first-pod-service.yaml)

## helm · 3 files
- **primer:** [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **notes** (2): [2026-07-19-explore-helm-charts-releases-values-repos.md](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md), [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **manifests** (1): [2026-07-15-first-chart-values.yaml](../helm/manifests/2026-07-15-first-chart-values.yaml)

## defectdojo · 3 files
- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (2): [2026-08-04-explore-defectdojo-ui.md](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md), [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **snippets** (1): [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)

## linux · 3 files
- **notes** (2): [2026-07-21-install-linux-vm-terminal-first-commands.md](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md), [2026-08-06-linux-shell-scripting-tutorial-confusions.md](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md)
- **configs** (1): [2026-08-06-cron-job-configuration.ini](../linux/configs/2026-08-06-cron-job-configuration.ini)

## ansible · 3 files
- **notes** (1): [2026-08-17-verify-ansible-cve-2026-33228-paths.md](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md)
- **scripts** (2): [bootstrap-target-node.sh](../ansible/scripts/bootstrap-target-node.sh), [2026-08-04-bootstrap-node.sh](../ansible/scripts/2026-08-04-bootstrap-node.sh)

## prometheus · 2 files
- **primer:** [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (2): [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md), [0000-primer-observability.md](../prometheus/notes/0000-primer-observability.md)

## grafana · 1 files
- **primer:** [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)
- **notes** (1): [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)

---

## Cross-cutting content

These directories cut across every tool above. Browse the folders for the full set.


## Docs · 195 files
- **concepts** (39): foundational primers — [application-security-testing](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md), [ci-cd-pipeline](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md), [configuration-management](../docs/concepts/configuration-management/0000-primer-configuration-management.md), [infrastructure-as-code](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md), [secrets-access-management](../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md), [linux-shell-fundamentals](../docs/concepts/linux-shell-fundamentals/0000-primer-linux-shell-fundamentals.md) … _and more under `docs/concepts/`._
- **how-to** — [kubernetes toolkit](../docs/how-to/k8s_toolkit.md), [linux toolkit](../docs/how-to/linux_toolkit.md), [jenkins toolkit](../docs/how-to/jenkins_toolkit.md), [ansible toolkit](../docs/how-to/ansible_toolkit.md), [vault toolkit](../docs/how-to/vault_toolkit.md) … _browse `docs/how-to/`._
- **reference**, **runbooks**, **security**, **troubleshooting**, **setup-guides** — _browse `docs/`._

## Scripts · 190 files
- **bash toolkits**: [ansible](../scripts/bash/ansible_toolkit/), [docker](../scripts/bash/docker_toolkit/), [k8s](../scripts/bash/k8s_toolkit/), [linux](../scripts/bash/linux_toolkit/), [terraform](../scripts/bash/terraform_toolkit/), [vault](../scripts/bash/vault_toolkit/), [jenkins](../scripts/bash/jenkins_toolkit/), [git](../scripts/bash/git/), [observability](../scripts/bash/observability_toolkit/), [helm](../scripts/bash/helm_toolkit/), [kafka](../scripts/bash/kafka_toolkit/), [oci-registry](../scripts/bash/oci_registry_toolkit/), [ci-cd](../scripts/bash/ci_cd_toolkit/), [harbor](../scripts/bash/harbor/), [argo](../scripts/bash/argo_toolkit/), [flux](../scripts/bash/flux_toolkit/), [azure](../scripts/bash/azure_toolkit/) … _browse `scripts/bash/`._

## Snippets · 17 files
- cheatsheets: [terraform-commands](../snippets/terraform-commands.md), [kubectl-cheatsheet](../snippets/kubectl-cheatsheet.md), [git-commands](../snippets/git-commands.md), [docker-commands](../snippets/docker-commands.md), [jenkins-cheatsheet](../snippets/jenkins-cheatsheet.md), [linux-cheatsheet](../snippets/linux-cheatsheet.md), [kafka-cheatsheet](../snippets/kafka-cheatsheet.md), [observability-cheatsheet](../snippets/observability-cheatsheet.md), [oci-registry-cheatsheet](../snippets/oci-registry-cheatsheet.md), [vault-commands](../snippets/vault-commands.md), [ci-cd-cheatsheet](../snippets/ci-cd-cheatsheet.md) … _browse `snippets/`._

## Templates · 34 files
- [k8s](../templates/k8s/), [terraform](../templates/terraform/), [jenkins](../templates/jenkins/), [linux-automation](../templates/linux-automation/), [logstash](../templates/logstash/), [syslog-ng](../templates/syslog-ng/) … _browse `templates/`._

## Environments · 12 files
- Terraform environment configs: [dev](../environments/dev/), [staging](../environments/staging/), [prod](../environments/prod/)

## Assets · 4 files
- Architecture diagrams: [architecture-overview](../assets/architecture-overview.png), [cicd-workflow](../assets/cicd-workflow.png), [devsecops-pipeline](../assets/devsecops-pipeline.png)

## Lab · 10 files
- Mini-projects: [terraform-project](../lab/mini-projects/terraform-project/README.md), [postgresql-database-server](../lab/mini-projects/postgresql-database-server/README.md), [samba-enterprise-file-sharing](../lab/mini-projects/samba-enterprise-file-sharing/README.md)