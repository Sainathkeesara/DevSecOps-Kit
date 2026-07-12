# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Trivy · 25 files
- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (3): [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md), [2026-05-24-install-trivy.md](../trivy/notes/2026-05-24-install-trivy.md), [2026-05-26-trivy-quickstart.md](../trivy/notes/2026-05-26-trivy-quickstart.md)
- **scripts** (5): [container-vuln-scan.sh](../trivy/scripts/container-vuln-scan.sh), [image-vuln-pipeline.sh](../trivy/scripts/image-vuln-pipeline.sh), [multi-target-scanner.sh](../trivy/scripts/multi-target-scanner.sh)
- **configs** (2): [.trivy.yaml](../trivy/configs/.trivy.yaml), [trivy-scan-config.yaml](../trivy/configs/trivy-scan-config.yaml)
- **snippets** (1): [scan-docker-image.sh](../trivy/snippets/scan-docker-image.sh)
- **docs** (3): [ci-pipeline-sarif-output.md](../trivy/docs/ci-pipeline-sarif-output.md), [ci-cd-pipeline-recipes.md](../trivy/docs/ci-cd-pipeline-recipes.md), [sbom-scanning-reference-guide.md](../trivy/docs/sbom-scanning-reference-guide.md)
- **manifests** (2): [trivy-operator-deployment.yaml](../trivy/manifests/trivy-operator-deployment.yaml), [trivy-sarif-code-scanning.yaml](../trivy/manifests/trivy-sarif-code-scanning.yaml)
- **templates** (6): [trivy-monorepo-scanner](../trivy/templates/trivy-monorepo-scanner/), [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy-scan-mode-comparison.ipynb](../trivy/notebooks/trivy-scan-mode-comparison.ipynb), [trivy-sarif-output-processing.ipynb](../trivy/notebooks/trivy-sarif-output-processing.ipynb)
- **dockerfiles** (1): [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)

## TruffleHog · 37 files
- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (3): [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md), [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md), [2026-05-27-following-trufflehog-quickstart.md](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md)
- **scripts** (3): [pre-commit-scan-pipeline.sh](../trufflehog/scripts/pre-commit-scan-pipeline.sh), [multi-repo-scan-pipeline.sh](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [analyze-trufflehog-results.py](../trufflehog/scripts/analyze-trufflehog-results.py)
- **configs** (2): [trufflehog-custom-regex-config.yaml](../trufflehog/configs/trufflehog-custom-regex-config.yaml), [custom-detector-rules.yaml](../trufflehog/configs/custom-detector-rules.yaml)
- **snippets** (2): [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh), [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- **docs** (2): [comparing-scan-modes-git-filesystem-s3.md](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md), [trufflehog-output-formats-json-sarif-csv.md](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md)
- **manifests** (1): [trufflehog-pr-secret-scan-reusable.yaml](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- **templates** (19): [secret-scanning-pipeline](../trufflehog/templates/secret-scanning-pipeline/), [multi-repo-secret-scan](../trufflehog/templates/multi-repo-secret-scan/), [github-secret-scanning-integration](../trufflehog/templates/github-secret-scanning-integration/)
- **notebooks** (2): [analyzing-trufflehog-false-positives.ipynb](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb), [trufflehog-scan-modes-comparison.ipynb](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb)
- **dockerfiles** (1): [pre-commit-scanner.Dockerfile](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile)

## ZAP · 31 files
- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (4): [0000-primer-zap.md](../zap/notes/0000-primer-zap.md), [2026-06-06-install-zap-desktop-ui.md](../zap/notes/2026-06-06-install-zap-desktop-ui.md), [2026-06-06-zap-quickstart-ui-gotchas.md](../zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md), [2026-06-13-spider-scan-test-app.md](../zap/notes/2026-06-13-spider-scan-test-app.md)
- **scripts** (3): [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh), [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh)
- **configs** (2): [zap-authenticated-scan-context.yaml](../zap/configs/zap-authenticated-scan-context.yaml), [ci-dast-automation-framework-plan.yaml](../zap/configs/ci-dast-automation-framework-plan.yaml)
- **snippets** (3): [my-first-zap-baseline-scan.sh](../zap/snippets/my-first-zap-baseline-scan.sh), [my-first-zap-spider-scan.sh](../zap/snippets/my-first-zap-spider-scan.sh), [authenticated-scan-with-context.sh](../zap/snippets/authenticated-scan-with-context.sh)
- **docs** (3): [zap-integration-patterns.md](../zap/docs/zap-integration-patterns.md), [passive-vs-active-scanning-zap.md](../zap/docs/passive-vs-active-scanning-zap.md), [zap-automation-plan-structure.md](../zap/docs/zap-automation-plan-structure.md)
- **templates** (16): [zap-dast-integration-scaffold](../zap/templates/zap-dast-integration-scaffold/), [zap-dast-integration](../zap/templates/zap-dast-integration/)
- **dockerfiles** (1): [custom-zap-automation.Dockerfile](../zap/dockerfiles/custom-zap-automation.Dockerfile)

## Syft · 23 files
- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (4): [0000-primer-syft.md](../syft/notes/0000-primer-syft.md), [2026-05-27-install-syft-first-sbom.md](../syft/notes/2026-05-27-install-syft-first-sbom.md), [2026-05-29-syft-quickstart-trip-ups.md](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md), [2026-05-30-sbom-format-comparison.md](../syft/notes/2026-05-30-sbom-format-comparison.md)
- **scripts** (3): [gen-multi-format-sboms.sh](../syft/scripts/gen-multi-format-sboms.sh), [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh), [sbom-vuln-pipeline.sh](../syft/scripts/sbom-vuln-pipeline.sh)
- **configs** (1): [.syft.yaml](../syft/configs/.syft.yaml)
- **snippets** (1): [tried-sbom-formats.sh](../syft/snippets/tried-sbom-formats.sh)
- **docs** (5): [sbom-formats-comparison.md](../syft/docs/sbom-formats-comparison.md), [sbom-output-formats-reference.md](../syft/docs/sbom-output-formats-reference.md), [enterprise-registry-auth-caching-patterns.md](../syft/docs/enterprise-registry-auth-caching-patterns.md), [enterprise-registry-auth-caching.md](../syft/docs/enterprise-registry-auth-caching.md), [registry-auth-caching-patterns.md](../syft/docs/registry-auth-caching-patterns.md)
- **templates** (7): [sbom-pipeline-scaffold](../syft/templates/sbom-pipeline-scaffold/)
- **notebooks** (1): [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb)
- **dockerfiles** (1): [multi-stage-sbom.Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)

## Checkov · 29 files
- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md), [2026-05-25-scan-terraform-plan.md](../checkov/notes/2026-05-25-scan-terraform-plan.md), [2026-05-26-cli-vs-sdk-comparison.md](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [2026-05-27-checkov-quickstart-trip-ups.md](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md)
- **scripts** (2): [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh), [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh)
- **configs** (2): [checkov-ci-config.yaml](../checkov/configs/checkov-ci-config.yaml), [checkov-skip-severity-config.yaml](../checkov/configs/checkov-skip-severity-config.yaml)
- **snippets** (4): [scan-kubernetes.sh](../checkov/snippets/scan-kubernetes.sh), [scan-terraform-dir.py](../checkov/snippets/scan-terraform-dir.py), [scan-a-terraform-file.py](../checkov/snippets/scan-a-terraform-file.py), [terraform-scan-custom-policies.py](../checkov/snippets/terraform-scan-custom-policies.py)
- **docs** (3): [checkov-integration-patterns.md](../checkov/docs/checkov-integration-patterns.md), [checkov-ai-infrastructure-checks.md](../checkov/docs/checkov-ai-infrastructure-checks.md), [pre-commit-hook-with-version-pinning.md](../checkov/docs/pre-commit-hook-with-version-pinning.md)
- **manifests** (2): [checkov-sarif-pr-blocking.yaml](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml)
- **templates** (10): [multi-iac-scan-project](../checkov/templates/multi-iac-scan-project/), [reusable-workflow-custom-policies](../checkov/templates/reusable-workflow-custom-policies/)
- **notebooks** (1): [compare-static-vs-plan-scanning.ipynb](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb)
- **policies** (1): [no-public-s3-buckets.yaml](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)

## Semgrep · 18 files
- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md), [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md), [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md)
- **scripts** (3): [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh), [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py), [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py)
- **configs** (1): [multi-rule-pack.yaml](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [first-custom-rule.yaml](../semgrep/snippets/first-custom-rule.yaml), [catch-privileged-containers.yaml](../semgrep/snippets/catch-privileged-containers.yaml)
- **docs** (4): [github-actions-ci-from-scratch.md](../semgrep/docs/github-actions-ci-from-scratch.md), [semgrep-ci-integration.md](../semgrep/docs/semgrep-ci-integration.md), [comparing-rule-writing-approaches.md](../semgrep/docs/comparing-rule-writing-approaches.md), [semgrep-rule-writing-reference.md](../semgrep/docs/semgrep-rule-writing-reference.md)
- **manifests** (2): [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml), [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml)
- **notebooks** (1): [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)
- **dockerfiles** (2): [ci-entrypoint.sh](../semgrep/dockerfiles/ci-entrypoint.sh), [custom-scanning-image.Dockerfile](../semgrep/dockerfiles/custom-scanning-image.Dockerfile)

## Grype · 18 files
- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **notes** (4): [0000-primer-grype.md](../grype/notes/0000-primer-grype.md), [2026-05-31-install-grype.md](../grype/notes/2026-05-31-install-grype.md), [2026-06-04-grype-quickstart-trip-ups.md](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md), [2026-06-08-first-grype-scan.md](../grype/notes/2026-06-08-first-grype-scan.md)
- **scripts** (6): [minimal-grype-scan.sh](../grype/scripts/minimal-grype-scan.sh), [ci-ready-grype-scan.sh](../grype/scripts/ci-ready-grype-scan.sh), [vuln-diff-two-images.sh](../grype/scripts/vuln-diff-two-images.sh), [grype-vuln-pipeline.sh](../grype/scripts/grype-vuln-pipeline.sh), [grype-results-to-sarif.py](../grype/scripts/grype-results-to-sarif.py), [grype-end-to-end-scan-pipeline.sh](../grype/scripts/grype-end-to-end-scan-pipeline.sh)
- **configs** (1): [grype-ci-github-actions.yaml](../grype/configs/grype-ci-github-actions.yaml)
- **snippets** (2): [my-first-grype-commands.sh](../grype/snippets/my-first-grype-commands.sh), [minimal-grype-scan.go](../grype/snippets/minimal-grype-scan.go)
- **docs** (1): [grype-syft-integration-guide.md](../grype/docs/grype-syft-integration-guide.md)
- **manifests** (2): [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml), [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml)
- **dockerfiles** (1): [multi-stage-grype-scan.Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (1): [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb)

## Snyk · 9 files
- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (4): [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md), [2026-06-07-snyk-quickstart-walkthrough.md](../snyk/notes/2026-06-07-snyk-quickstart-walkthrough.md), [2026-06-08-install-snyk-first-test.md](../snyk/notes/2026-06-08-install-snyk-first-test.md), [2026-06-14-first-vulnerability-scan.md](../snyk/notes/2026-06-14-first-vulnerability-scan.md)
- **scripts** (1): [snyk-vuln-scan-pipeline.sh](../snyk/scripts/snyk-vuln-scan-pipeline.sh)
- **configs** (2): [snyk-ci-github-actions.yaml](../snyk/configs/snyk-ci-github-actions.yaml), [snyk-dependency-patch-ignore.yaml](../snyk/configs/snyk-dependency-patch-ignore.yaml)
- **docs** (1): [multi-project-ci-pipeline.md](../snyk/docs/multi-project-ci-pipeline.md)
- **snippets** (1): [my-first-snyk-commands.sh](../snyk/snippets/my-first-snyk-commands.sh)

## GitGuardian · 11 files
- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (4): [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md), [2026-06-07-first-ggshield-scan.md](../gitguardian/notes/2026-06-07-first-ggshield-scan.md), [2026-06-13-ggshield-quickstart-trip-ups.md](../gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md), [2026-06-14-first-secrets-scan-repo.md](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md)
- **scripts** (2): [pre-commit-hook-ggshield.sh](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh)
- **configs** (2): [.ggshield.yaml](../gitguardian/configs/.ggshield.yaml), [monorepo-allowlists.yaml](../gitguardian/configs/monorepo-allowlists.yaml)
- **snippets** (2): [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh), [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- **docs** (1): [monorepo-ci-per-team-exclusions.md](../gitguardian/docs/monorepo-ci-per-team-exclusions.md)

## Falco · 12 files
- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (3): [0000-primer-falco.md](../falco/notes/0000-primer-falco.md), [2026-06-10-install-falco-first-detection.md](../falco/notes/2026-06-10-install-falco-first-detection.md), [2026-06-15-falco-rules-macros-lists.md](../falco/notes/2026-06-15-falco-rules-macros-lists.md)
- **scripts** (3): [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh), [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh)
- **configs** (3): [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml), [first-custom-rule-detect-shell-in-container.yaml](../falco/configs/first-custom-rule-detect-shell-in-container.yaml), [2026-06-10-first-custom-rule-detect-shell-in-container.yaml](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml)
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)
- **docs** (2): [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md), [tuned-falco-rules-noise-reduction.md](../falco/docs/tuned-falco-rules-noise-reduction.md)

## Cosign · 9 files
- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (4): [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md), [2026-06-13-install-cosign-sign-first-image.md](../cosign/notes/2026-06-13-install-cosign-sign-first-image.md), [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md), [2026-06-22-cosign-getting-started-trip-ups.md](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md)
- **scripts** (2): [minimal-sign-verify.sh](../cosign/scripts/minimal-sign-verify.sh), [verify-signed-image.sh](../cosign/scripts/verify-signed-image.sh)
- **configs** (1): [keyless-signing-github-actions.yaml](../cosign/configs/keyless-signing-github-actions.yaml)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (1): [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)

## OPA · 9 files
- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (3): [0000-primer-opa.md](../opa/notes/0000-primer-opa.md), [2026-06-06-install-opa-repl.md](../opa/notes/2026-06-06-install-opa-repl.md), [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)
- **scripts** (1): [how-i-test-policies-locally.sh](../opa/scripts/how-i-test-policies-locally.sh)
- **configs** (1): [tried-a-gatekeeper-constraint.yaml](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- **snippets** (3): [my-first-opa-policy-eval.sh](../opa/snippets/my-first-opa-policy-eval.sh), [enforce-image-registry-constraints.rego](../opa/snippets/enforce-image-registry-constraints.rego), [deny-privileged-hostnetwork.rego](../opa/snippets/deny-privileged-hostnetwork.rego)
- **docs** (1): [wired-opa-admission-control.md](../opa/docs/wired-opa-admission-control.md)

## Terrascan · 9 files
- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md), [2026-06-13-first-scan.md](../terrascan/notes/2026-06-13-first-scan.md), [2026-06-19-install-terrascan-tiny-tf.md](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md), [2026-06-29-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md), [2026-07-10-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md)
- **scripts** (1): [tried-terrascan-ci-scan.sh](../terrascan/scripts/tried-terrascan-ci-scan.sh)
- **configs** (1): [tried-custom-s3-rule.yaml](../terrascan/configs/tried-custom-s3-rule.yaml)
- **snippets** (2): [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf), [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf)

## Tetragon · 3 files
- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (1): [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md)
- **configs** (1): [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml)

## Dependabot · 7 files
- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (5): [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md), [2026-06-22-first-time-dependabot-setup.md](../dependabot/notes/2026-06-22-first-time-dependabot-setup.md), [2026-06-15-dependabot-first-repo-bump-pr.md](../dependabot/notes/2026-06-15-dependabot-first-repo-bump-pr.md), [2026-07-10-enabling-dependabot-alerts.md](../dependabot/notes/2026-07-10-enabling-dependabot-alerts.md), [dependabot-alerts-security-updates.md](../dependabot/notes/dependabot-alerts-security-updates.md)
- **configs** (2): [tried-npm-dependabot.yaml](../dependabot/configs/tried-npm-dependabot.yaml), [2026-07-10-npm-version-strategy.yaml](../dependabot/configs/2026-07-10-npm-version-strategy.yaml)

## DefectDojo · 2 files
- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **snippets** (1): [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)

## Vault · 10 files
- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (3): [0000-primer-vault.md](../vault/notes/0000-primer-vault.md), [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md), [2026-06-15-vault-getting-started-trip-ups.md](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md)
- **scripts** (2): [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh), [vault-db-dynamic-secrets.sh](../vault/scripts/vault-db-dynamic-secrets.sh)
- **configs** (2): [2026-06-26-dev-test-policies.hcl](../vault/configs/2026-06-26-dev-test-policies.hcl), [multi-environment-access-control.hcl](../vault/configs/multi-environment-access-control.hcl)
- **snippets** (1): [vault-read-write.go](../vault/snippets/vault-read-write.go)
- **docs** (2): [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md), [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md)

## Git · 6 files
- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (3): [0000-primer-git.md](../git/notes/0000-primer-git.md), [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md), [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md)
- **scripts** (2): [2026-07-10-local-ci-simulation.sh](../git/scripts/2026-07-10-local-ci-simulation.sh), [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## ArgoCD · 3 files
- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (2): [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md), [2026-07-06-install-argocd-first-app.md](../argocd/notes/2026-07-06-install-argocd-first-app.md)
- **manifests** (1): [2026-07-06-sample-app-application.yaml](../argocd/manifests/2026-07-06-sample-app-application.yaml)

## Docker · 4 files
- **notes** (2): [0000-primer-docker.md](../docker/notes/0000-primer-docker.md), [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md)
- **dockerfiles** (2): [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile), [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile)

## Helm · 1 file
- **notes** (1): [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)

## Kubernetes · 1 file
- **notes** (1): [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)

## Kustomize · 3 files
- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (2): [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md), [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md)
- **configs** (1): [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml)

## GitHub Actions · 1 file
- **notes** (1): [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)

## SonarQube · 1 file
- **notes** (1): [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)

## OpenTofu · 1 file
- **notes** (1): [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)

## CodeQL · 10 files
- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (3): [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md), [2026-06-05-install-codeql-first-analysis.md](../codeql/notes/2026-06-05-install-codeql-first-analysis.md), [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md)
- **scripts** (1): [first-codeql-analysis.sh](../codeql/scripts/first-codeql-analysis.sh)
- **configs** (1): [first-codeql-analysis.yml](../codeql/configs/first-codeql-analysis.yml)
- **snippets** (3): [find-hardcoded-creds.ql](../codeql/snippets/find-hardcoded-creds.ql), [my-first-codeql-commands.sh](../codeql/snippets/my-first-codeql-commands.sh), [hardcoded-creds-local-flow.ql](../codeql/snippets/hardcoded-creds-local-flow.ql)
- **docs** (1): [wired-custom-queries-into-ci.md](../codeql/docs/wired-custom-queries-into-ci.md)
- **manifests** (1): [multi-language-codeql-analysis.yaml](../codeql/manifests/multi-language-codeql-analysis.yaml)
