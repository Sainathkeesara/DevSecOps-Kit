# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## ansible  ·  10 files

- **notes** (3): [quickstart trip-ups](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md), [CVE-2026-33228 path verification](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md), [roles vs tasks](../ansible/notes/roles-vs-tasks.md)
- **docs** (1): [wired-ansible-infrastructure-workflow.md](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **scripts** (3): [bootstrap-target-node.sh](../ansible/scripts/bootstrap-target-node.sh), [bootstrap.sh](../ansible/scripts/bootstrap.sh), [2026-08-04-bootstrap-node.sh](../ansible/scripts/2026-08-04-bootstrap-node.sh)
- **configs** (2): [2026-09-15-inventory-groups-host-vars.yaml](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml), [small-ansible-project.yaml](../ansible/configs/small-ansible-project.yaml)
- **snippets** (1): [2026-08-25-minimal-ansible-playbook-package-service.yaml](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)

## argocd  ·  13 files

- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (6): [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md), [2026-07-06-install-argocd-first-app.md](../argocd/notes/2026-07-06-install-argocd-first-app.md), [2026-08-12-quickstart-tripups.md](../argocd/notes/2026-08-12-quickstart-tripups.md) — _…and 3 more under `argocd/notes/`._
- **docs** (2): [gitops-workflow-wiring.md](../argocd/docs/gitops-workflow-wiring.md), [multi-environment-gitops-delivery.md](../argocd/docs/multi-environment-gitops-delivery.md)
- **configs** (2): [2026-08-17-private-repo-credentials-rbac.yaml](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml), [2026-09-20-values-dev.yaml](../argocd/configs/2026-09-20-values-dev.yaml)
- **manifests** (3): [helm-guestbook-application.yaml](../argocd/manifests/helm-guestbook-application.yaml), [2026-08-12-gitops-sync-sample-web-app.yaml](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml), [2026-07-06-sample-app-application.yaml](../argocd/manifests/2026-07-06-sample-app-application.yaml)

## checkov  ·  46 files

- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md), [2026-05-25-scan-terraform-plan.md](../checkov/notes/2026-05-25-scan-terraform-plan.md), [2026-05-26-cli-vs-sdk-comparison.md](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md) — _…and 1 more under `checkov/notes/`._
- **docs** (6): [checkov-v3-upgrade-checklist.md](../checkov/docs/checkov-v3-upgrade-checklist.md), [checkov-integration-patterns.md](../checkov/docs/checkov-integration-patterns.md), [multi-cloud-policy-management.md](../checkov/docs/multi-cloud-policy-management.md) — _…and 3 more under `checkov/docs/`._
- **scripts** (2): [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh), [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh)
- **configs** (3): [checkov-ci-config.yaml](../checkov/configs/checkov-ci-config.yaml), [platform-config.yaml](../checkov/configs/platform-config.yaml), [checkov-skip-severity-config.yaml](../checkov/configs/checkov-skip-severity-config.yaml)
- **snippets** (4): [scan-a-terraform-file.py](../checkov/snippets/scan-a-terraform-file.py), [scan-terraform-dir.py](../checkov/snippets/scan-terraform-dir.py), [scan-kubernetes.sh](../checkov/snippets/scan-kubernetes.sh) — _…and 1 more under `checkov/snippets/`._
- **templates** (20): [multi-iac scan project](../checkov/templates/multi-iac-scan-project/README.md), [multi-repo drift auto-PR remediation](../checkov/templates/multi-repo-drift-auto-pr-remediation/README.md), [reusable custom-policy workflow](../checkov/templates/reusable-workflow-custom-policies/README.md)
- **manifests** (3): [layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml), [checkov-sarif-pr-blocking.yaml](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [checkov-gitlab-ci-multi-cloud-drift.yaml](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml)
- **notebooks** (3): [compare-static-vs-plan-scanning.ipynb](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb), [compare-cross-module-scanning-limitations.ipynb](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb), [compare-builtin-vs-custom-k8s.ipynb](../checkov/notebooks/compare-builtin-vs-custom-k8s.ipynb)
- **policies** (1): [no_public_s3_buckets.yaml](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)
- _…and 2 more at `checkov/` root (`.checkov.yaml`, `.pre-commit-config.yaml`) — browse the folder._

## codeql  ·  25 files

- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (4): [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md), [2026-08-26-install-codeql-first-query.md](../codeql/notes/2026-08-26-install-codeql-first-query.md), [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md) — _…and 1 more under `codeql/notes/`._
- **docs** (2): [query-writing-patterns-dataflow-javascript-typescript.md](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md), [wired-custom-queries-into-ci.md](../codeql/docs/wired-custom-queries-into-ci.md)
- **scripts** (1): [first-codeql-analysis.sh](../codeql/scripts/first-codeql-analysis.sh)
- **configs** (1): [first-codeql-analysis.yml](../codeql/configs/first-codeql-analysis.yml)
- **snippets** (5): [find-hardcoded-creds.ql](../codeql/snippets/find-hardcoded-creds.ql), [hardcoded-creds-local-flow.ql](../codeql/snippets/hardcoded-creds-local-flow.ql), [2026-09-24-first-codeql-query.py](../codeql/snippets/2026-09-24-first-codeql-query.py) — _…and 2 more under `codeql/snippets/`._
- **templates** (8): [custom query-pack CI harness](../codeql/templates/custom-query-pack-ci-harness/README.md), [hardcoded-credential-check.ql](../codeql/templates/custom-query-pack-ci-harness/queries/hardcoded-credential-check.ql), [custom-suite.qls](../codeql/templates/custom-query-pack-ci-harness/suites/custom-suite.qls) — _…and 5 more under `codeql/templates/`._
- **manifests** (2): [codeql-multi-language-scan.yaml](../codeql/manifests/codeql-multi-language-scan.yaml), [multi-language-codeql-analysis.yaml](../codeql/manifests/multi-language-codeql-analysis.yaml)
- **dockerfiles** (1): [custom-codeql-analysis-image.Dockerfile](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **notebooks** (1): [compare-cli-vs-actions-scan-modes.ipynb](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb)

## cosign  ·  18 files

- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (4): [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md), [2026-06-13-install-cosign-sign-first-image.md](../cosign/notes/2026-06-13-install-cosign-sign-first-image.md), [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md) — _…and 1 more under `cosign/notes/`._
- **docs** (3): [container-signing-pipeline.md](../cosign/docs/container-signing-pipeline.md), [cosign-verification-patterns.md](../cosign/docs/cosign-verification-patterns.md), [key-rotation-and-migration-patterns.md](../cosign/docs/key-rotation-and-migration-patterns.md)
- **scripts** (3): [cosign-key-management-workflow.sh](../cosign/scripts/cosign-key-management-workflow.sh), [verify-signed-image.sh](../cosign/scripts/verify-signed-image.sh), [minimal-sign-verify.sh](../cosign/scripts/minimal-sign-verify.sh)
- **configs** (2): [keyless-signing-github-actions.yaml](../cosign/configs/keyless-signing-github-actions.yaml), [cosign-signature-configuration.yaml](../cosign/configs/cosign-signature-configuration.yaml)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (2): [signed-container-build-oidc.yaml](../cosign/manifests/signed-container-build-oidc.yaml), [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)
- **dockerfiles** (2): [custom-cosign-image.Dockerfile](../cosign/dockerfiles/custom-cosign-image.Dockerfile), [entrypoint.sh](../cosign/dockerfiles/entrypoint.sh)
- **notebooks** (1): [key-based-vs-keyless-signing.ipynb](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## defectdojo  ·  6 files

- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (3): [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md), [2026-08-04-explore-defectdojo-ui.md](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md), [2026-09-21-quickstart-tripups.md](../defectdojo/notes/2026-09-21-quickstart-tripups.md)
- **configs** (1): [2026-09-21-vulnerability-scanner-setup.yaml](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml)
- **scripts** (1): [2026-09-20-defectdojo-tutorial-check.sh](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh)
- **snippets** (1): [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)

## dependabot  ·  18 files

- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (7): [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md), [2026-06-15-dependabot-first-repo-bump-pr.md](../dependabot/notes/2026-06-15-dependabot-first-repo-bump-pr.md), [2026-06-22-first-time-dependabot-setup.md](../dependabot/notes/2026-06-22-first-time-dependabot-setup.md) — _…and 4 more under `dependabot/notes/`._
- **docs** (3): [dependabot-version-control-workflow-integration.md](../dependabot/docs/dependabot-version-control-workflow-integration.md), [dependabot-security-update-auto-merge.md](../dependabot/docs/dependabot-security-update-auto-merge.md), [dependabot-security-alert-migration-patterns.md](../dependabot/docs/dependabot-security-alert-migration-patterns.md)
- **scripts** (2): [dependabot-alert-aggregation.py](../dependabot/scripts/dependabot-alert-aggregation.py), [2026-08-04-dependabot-alert-triage.py](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py)
- **configs** (5): [dependabot-configuration-template.yaml](../dependabot/configs/dependabot-configuration-template.yaml), [monorepo-ecosystem-schedules-reviewers.yaml](../dependabot/configs/monorepo-ecosystem-schedules-reviewers.yaml), [2026-07-10-npm-version-strategy.yaml](../dependabot/configs/2026-07-10-npm-version-strategy.yaml) — _…and 2 more under `dependabot/configs/`._
- **notebooks** (1): [auto-merge-vs-manual-review.ipynb](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## docker  ·  18 files

- **primer:** [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **notes** (2): [0000-primer-docker.md](../docker/notes/0000-primer-docker.md), [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md)
- **docs** (2): [cicd-end-to-end.md](../docker/docs/cicd-end-to-end.md), [dockerfile-optimization-patterns.md](../docker/docs/dockerfile-optimization-patterns.md)
- **scripts** (3): [reusable-build.sh](../docker/scripts/reusable-build.sh), [build-multi-service-compose-app.sh](../docker/scripts/build-multi-service-compose-app.sh), [2026-07-18-custom-network-volume-mounts.sh](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh)
- **configs** (1): [docker-compose-dev-environment.yaml](../docker/configs/docker-compose-dev-environment.yaml)
- **manifests** (1): [docker-compose-production.yaml](../docker/manifests/docker-compose-production.yaml)
- **dockerfiles** (2): [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)
- **templates** (7): [multi-service setup scaffold](../docker/templates/multi-service-setup/README.md), [compose.yaml](../docker/templates/multi-service-setup/compose.yaml), [api/app.py](../docker/templates/multi-service-setup/api/app.py) — _…and 4 more under `docker/templates/`._

## environments  ·  15 files

- **primer:** [0000-primer-environments.md](../environments/notes/0000-primer-environments.md)
- **notes** (2): [0000-primer-environments.md](../environments/notes/0000-primer-environments.md), [2026-09-19-first-environment-comparison.md](../environments/notes/2026-09-19-first-environment-comparison.md)
- **configs** (1): [2026-09-19-first-variable-set.yaml](../environments/configs/2026-09-19-first-variable-set.yaml)
- _…and 12 Terraform files under `environments/dev/`, `environments/staging/`, `environments/prod/` — browse the folders._

## falco  ·  20 files

- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (4): [0000-primer-falco.md](../falco/notes/0000-primer-falco.md), [2026-06-10-install-falco-first-detection.md](../falco/notes/2026-06-10-install-falco-first-detection.md), [2026-06-15-falco-rules-macros-lists.md](../falco/notes/2026-06-15-falco-rules-macros-lists.md) — _…and 1 more under `falco/notes/`._
- **docs** (3): [rule-optimization-priority-filtering.md](../falco/docs/rule-optimization-priority-filtering.md), [tuned-falco-rules-noise-reduction.md](../falco/docs/tuned-falco-rules-noise-reduction.md), [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md)
- **scripts** (3): [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh), [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh)
- **configs** (3): [first-custom-rule-detect-shell-in-container.yaml](../falco/configs/first-custom-rule-detect-shell-in-container.yaml), [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml), [2026-06-10-first-custom-rule-detect-shell-in-container.yaml](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml)
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)
- **templates** (4): [custom rules library scaffold](../falco/templates/falco-custom-rules-library/README.md), [custom-rules.yaml](../falco/templates/falco-custom-rules-library/rules/custom-rules.yaml), [test-rules.sh](../falco/templates/falco-custom-rules-library/tests/test-rules.sh)
- **manifests** (1): [falco-k8s-admission-control.yaml](../falco/manifests/falco-k8s-admission-control.yaml)
- **notebooks** (1): [falco-event-output-formats.ipynb](../falco/notebooks/falco-event-output-formats.ipynb)

## git  ·  10 files

- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (3): [0000-primer-git.md](../git/notes/0000-primer-git.md), [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md), [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md)
- **docs** (1): [how-i-wired-git-into-my-version-control-workflow.md](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **scripts** (4): [2026-08-24-first-repo-stage-log.sh](../git/scripts/2026-08-24-first-repo-stage-log.sh), [2026-07-10-local-ci-simulation.sh](../git/scripts/2026-07-10-local-ci-simulation.sh), [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh), [git-automation.sh](../git/scripts/git-automation.sh)
- **configs** (1): [config-strategy-layered-vs-conditional.yaml](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## gitguardian  ·  22 files

- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (4): [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md), [2026-06-07-first-ggshield-scan.md](../gitguardian/notes/2026-06-07-first-ggshield-scan.md), [2026-06-14-first-secrets-scan-repo.md](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md) — _…and 1 more under `gitguardian/notes/`._
- **docs** (2): [gitguardian-incident-response-workflow.md](../gitguardian/docs/gitguardian-incident-response-workflow.md), [monorepo-ci-per-team-exclusions.md](../gitguardian/docs/monorepo-ci-per-team-exclusions.md)
- **scripts** (3): [pre-commit-hook-ggshield.sh](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh), [gitguardian-api-integration.py](../gitguardian/scripts/gitguardian-api-integration.py)
- **configs** (2): [monorepo-allowlists.yaml](../gitguardian/configs/monorepo-allowlists.yaml), [.ggshield.yaml](../gitguardian/configs/.ggshield.yaml)
- **snippets** (2): [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh), [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- **templates** (9): [multi-repo scanning scaffold](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/README.md), [org-secret-scan.yml](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.github/workflows/org-secret-scan.yml), [allowlist.yaml](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.ggshield/allowlist.yaml) — _…and 6 more under `gitguardian/templates/`._

## github-actions  ·  13 files

- **primer:** [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (5): [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md), [2026-09-21-quickstart-tripped-me-up.md](../github-actions/notes/2026-09-21-quickstart-tripped-me-up.md), [2026-08-26-install-gh-cli-first-command.md](../github-actions/notes/2026-08-26-install-gh-cli-first-command.md) — _…and 2 more under `github-actions/notes/`._
- **configs** (4): [2026-09-21-minimal-starter-workflow.yaml](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml), [2026-09-10-minimal-ci-workflow.yaml](../github-actions/configs/2026-09-10-minimal-ci-workflow.yaml), [2026-08-04-first-workflow.yaml](../github-actions/configs/2026-08-04-first-workflow.yaml), [2026-07-14-first-github-actions-workflow.yaml](../github-actions/configs/2026-07-14-first-github-actions-workflow.yaml)
- **snippets** (2): [2026-08-26-composite-action-input-reuse.yaml](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml), [2026-08-26-first-workflow.yaml](../github-actions/snippets/2026-08-26-first-workflow.yaml)
- **manifests** (2): [2026-08-04-what-is-github-actions.yaml](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [2026-08-04-pr-validation.yml](../github-actions/manifests/2026-08-04-pr-validation.yml)

## gitleaks  ·  3 files

- **primer:** [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md)
- **notes** (2): [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md), [2026-09-19-first-secret-scan.md](../gitleaks/notes/2026-09-19-first-secret-scan.md)
- **scripts** (1): [2026-09-26-run-first-gitleaks-scan.sh](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh)

## grafana  ·  4 files

- **primer:** [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)
- **notes** (3): [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md), [2026-09-26-explore-grafana-dashboard-ui.md](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md), [2026-09-19-first-dashboard-browser.md](../grafana/notes/2026-09-19-first-dashboard-browser.md)
- **configs** (1): [2026-09-19-first-datasource.yaml](../grafana/configs/2026-09-19-first-datasource.yaml)

## grype  ·  20 files

- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **notes** (4): [0000-primer-grype.md](../grype/notes/0000-primer-grype.md), [2026-05-31-install-grype.md](../grype/notes/2026-05-31-install-grype.md), [2026-06-08-first-grype-scan.md](../grype/notes/2026-06-08-first-grype-scan.md) — _…and 1 more under `grype/notes/`._
- **docs** (1): [grype-syft-integration-guide.md](../grype/docs/grype-syft-integration-guide.md)
- **scripts** (8): [ci-ready-grype-scan.sh](../grype/scripts/ci-ready-grype-scan.sh), [minimal-grype-scan.sh](../grype/scripts/minimal-grype-scan.sh), [grype-end-to-end-scan-pipeline.sh](../grype/scripts/grype-end-to-end-scan-pipeline.sh) — _…and 5 more under `grype/scripts/`._
- **configs** (1): [grype-ci-github-actions.yaml](../grype/configs/grype-ci-github-actions.yaml)
- **snippets** (2): [my-first-grype-commands.sh](../grype/snippets/my-first-grype-commands.sh), [minimal-grype-scan.go](../grype/snippets/minimal-grype-scan.go)
- **manifests** (2): [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml), [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml)
- **dockerfiles** (1): [multi-stage-grype-scan.Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (1): [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb)

## helm  ·  5 files

- **primer:** [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **notes** (3): [0000-primer-helm.md](../helm/notes/0000-primer-helm.md), [2026-07-19-explore-helm-charts-releases-values-repos.md](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md), [2026-09-21-quickstart-tripped-me-up.md](../helm/notes/2026-09-21-quickstart-tripped-me-up.md)
- **manifests** (2): [2026-09-21-minimal-service-chart.yaml](../helm/manifests/2026-09-21-minimal-service-chart.yaml), [2026-07-15-first-chart-values.yaml](../helm/manifests/2026-07-15-first-chart-values.yaml)

## kubernetes  ·  7 files

- **primer:** [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (2): [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md), [2026-07-15-explore-kubernetes.md](../kubernetes/notes/2026-07-15-explore-kubernetes.md)
- **docs** (1): [cluster-workflow-wiring.md](../kubernetes/docs/cluster-workflow-wiring.md)
- **configs** (1): [namespace-strategy-environment-vs-team.yaml](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml)
- **manifests** (3): [small-deployment-from-scratch.yaml](../kubernetes/manifests/small-deployment-from-scratch.yaml), [2026-07-15-first-pod-service.yaml](../kubernetes/manifests/2026-07-15-first-pod-service.yaml), [2026-09-10-first-pod.yaml](../kubernetes/manifests/2026-09-10-first-pod.yaml)

## kustomize  ·  6 files

- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (3): [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md), [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md), [2026-09-21-kustomize-quickstart-tripped-me-up.md](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md)
- **configs** (2): [2026-09-22-minimal-kustomization-with-overlay.yaml](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml), [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml)
- **manifests** (1): [2026-09-21-kustomize-tutorial.yaml](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## lab  ·  13 files

- **primer:** [0000-primer-lab.md](../lab/notes/0000-primer-lab.md)
- **notes** (2): [0000-primer-lab.md](../lab/notes/0000-primer-lab.md), [2026-09-20-setting-up-the-lab-directory.md](../lab/notes/2026-09-20-setting-up-the-lab-directory.md)
- **configs** (1): [2026-09-19-first-lab-env.yaml](../lab/configs/2026-09-19-first-lab-env.yaml)
- _…and 10 more files under `lab/mini-projects/` (postgres, samba, and Terraform practice setups) — browse the folder._

## linux  ·  3 files

- **notes** (2): [2026-07-21-install-linux-vm-terminal-first-commands.md](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md), [2026-08-06-linux-shell-scripting-tutorial-confusions.md](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md)
- **configs** (1): [2026-08-06-cron-job-configuration.ini](../linux/configs/2026-08-06-cron-job-configuration.ini)

## nuclei  ·  2 files

- **primer:** [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md)
- **notes** (2): [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md), [2026-09-20-first-template-scan-attempt.md](../nuclei/notes/2026-09-20-first-template-scan-attempt.md)

## opa  ·  24 files

- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (3): [0000-primer-opa.md](../opa/notes/0000-primer-opa.md), [2026-06-06-install-opa-repl.md](../opa/notes/2026-06-06-install-opa-repl.md), [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)
- **docs** (2): [constraint-template-design-patterns.md](../opa/docs/constraint-template-design-patterns.md), [wired-opa-admission-control.md](../opa/docs/wired-opa-admission-control.md)
- **scripts** (2): [export-audit-results.sh](../opa/scripts/export-audit-results.sh), [how-i-test-policies-locally.sh](../opa/scripts/how-i-test-policies-locally.sh)
- **configs** (1): [tried-a-gatekeeper-constraint.yaml](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- **snippets** (3): [my-first-opa-policy-eval.sh](../opa/snippets/my-first-opa-policy-eval.sh), [deny-privileged-hostnetwork.rego](../opa/snippets/deny-privileged-hostnetwork.rego), [enforce-image-registry-constraints.rego](../opa/snippets/enforce-image-registry-constraints.rego)
- **templates** (9): [Gatekeeper policy library scaffold](../opa/templates/gatekeeper-policy-library-scaffold/README.md), [k8sallowedregistries.yaml](../opa/templates/gatekeeper-policy-library-scaffold/constraint-templates/k8sallowedregistries.yaml), [ci-test.yml](../opa/templates/gatekeeper-policy-library-scaffold/.github/workflows/ci-test.yml) — _…and 6 more under `opa/templates/`._
- **manifests** (4): [gatekeeper-production-deployment.yaml](../opa/manifests/gatekeeper-production-deployment.yaml), [constraint-templates.yaml](../opa/manifests/constraint-templates.yaml), [constraints.yaml](../opa/manifests/constraints.yaml) — _…and 1 more under `opa/manifests/`._

## opentofu  ·  6 files

- **primer:** [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (3): [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md), [2026-07-20-explore-open-tofu.md](../opentofu/notes/2026-07-20-explore-open-tofu.md), [2026-09-21-follow-open-tofu-quickstart.md](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md)
- **configs** (3): [2026-09-21-minimal-opentofu-config-with-vars.hcl](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl), [2026-07-20-first-open-tofu-config.hcl](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl), [2026-09-10-minimal-opentofu-config.hcl](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl)

## prometheus  ·  3 files

- **primer:** [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (3): [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md), [0000-primer-observability.md](../prometheus/notes/0000-primer-observability.md), [2026-09-20-checking-the-metrics-interface.md](../prometheus/notes/2026-09-20-checking-the-metrics-interface.md)

## semgrep  ·  21 files

- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md), [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md), [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md)
- **docs** (5): [semgrep-rule-writing-reference.md](../semgrep/docs/semgrep-rule-writing-reference.md), [comparing-rule-writing-approaches.md](../semgrep/docs/comparing-rule-writing-approaches.md), [semgrep-rule-performance-optimization.md](../semgrep/docs/semgrep-rule-performance-optimization.md) — _…and 2 more under `semgrep/docs/`._
- **scripts** (3): [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh), [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py), [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py)
- **configs** (1): [multi-rule-pack.yaml](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [first-custom-rule.yaml](../semgrep/snippets/first-custom-rule.yaml), [catch-privileged-containers.yaml](../semgrep/snippets/catch-privileged-containers.yaml)
- **manifests** (2): [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml), [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml)
- **dockerfiles** (2): [custom-scanning-image.Dockerfile](../semgrep/dockerfiles/custom-scanning-image.Dockerfile), [ci-entrypoint.sh](../semgrep/dockerfiles/ci-entrypoint.sh)
- **notebooks** (3): [rule-matching-mode-comparison.ipynb](../semgrep/notebooks/rule-matching-mode-comparison.ipynb), [comparing-community-vs-custom-rules.ipynb](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb), [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## snyk  ·  23 files

- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (4): [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md), [2026-06-08-install-snyk-first-test.md](../snyk/notes/2026-06-08-install-snyk-first-test.md), [2026-06-14-first-vulnerability-scan.md](../snyk/notes/2026-06-14-first-vulnerability-scan.md) — _…and 1 more under `snyk/notes/`._
- **docs** (2): [vulnerability-prioritization-reachability-fix-prs-license-compliance.md](../snyk/docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md), [multi-project-ci-pipeline.md](../snyk/docs/multi-project-ci-pipeline.md)
- **scripts** (1): [snyk-vuln-scan-pipeline.sh](../snyk/scripts/snyk-vuln-scan-pipeline.sh)
- **configs** (2): [snyk-ci-github-actions.yaml](../snyk/configs/snyk-ci-github-actions.yaml), [snyk-dependency-patch-ignore.yaml](../snyk/configs/snyk-dependency-patch-ignore.yaml)
- **snippets** (1): [my-first-snyk-commands.sh](../snyk/snippets/my-first-snyk-commands.sh)
- **templates** (11): [multi-language scan scaffold](../snyk/templates/snyk-multilang-scan-scaffold/README.md), [snyk-multilang-ci.yml](../snyk/templates/snyk-multilang-scan-scaffold/.github/workflows/snyk-multilang-ci.yml), [Makefile](../snyk/templates/snyk-multilang-scan-scaffold/Makefile) — _…and 8 more under `snyk/templates/`._
- **manifests** (1): [snyk-github-actions-cicd-workflow.yaml](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **dockerfiles** (1): [custom-snyk-cli-air-gapped.Dockerfile](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)

## sonarqube  ·  6 files

- **primer:** [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (3): [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md), [2026-07-19-explore-sonarqube-quality-gates-profiles.md](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md), [2026-09-21-follow-sonarqube-quickstart.md](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md)
- **configs** (1): [2026-09-21-minimal-quality-gate.yaml](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml)
- **scripts** (1): [2026-09-21-sonarqube-scan-setup.sh](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **snippets** (1): [2026-07-16-first-sonarscanner-run.sh](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## syft  ·  37 files

- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (4): [0000-primer-syft.md](../syft/notes/0000-primer-syft.md), [2026-05-27-install-syft-first-sbom.md](../syft/notes/2026-05-27-install-syft-first-sbom.md), [2026-05-30-sbom-format-comparison.md](../syft/notes/2026-05-30-sbom-format-comparison.md) — _…and 1 more under `syft/notes/`._
- **docs** (6): [output-format-selection-guide.md](../syft/docs/output-format-selection-guide.md), [sbom-formats-comparison.md](../syft/docs/sbom-formats-comparison.md), [enterprise-registry-auth-caching-patterns.md](../syft/docs/enterprise-registry-auth-caching-patterns.md) — _…and 3 more under `syft/docs/`._
- **scripts** (4): [gen-multi-format-sboms.sh](../syft/scripts/gen-multi-format-sboms.sh), [syft-sbom-generation.py](../syft/scripts/syft-sbom-generation.py), [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh) — _…and 1 more under `syft/scripts/`._
- **configs** (1): [.syft.yaml](../syft/configs/.syft.yaml)
- **snippets** (1): [tried-sbom-formats.sh](../syft/snippets/tried-sbom-formats.sh)
- **templates** (15): [SBOM pipeline scaffold](../syft/templates/sbom-pipeline-scaffold/README.md), [Syft + Trivy Kubernetes scan scaffold](../syft/templates/syft-trivy-k8s-scan-scaffold/README.md), [sbom-scan.yml](../syft/templates/sbom-pipeline-scaffold/.github/workflows/sbom-scan.yml) — _…and 12 more under `syft/templates/`._
- **manifests** (2): [syft-gha-multi-arch-sbom-registry-auth.yaml](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml), [syft-gha-sbom-oci-push-attestation.yaml](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml)
- **dockerfiles** (1): [multi-stage-sbom.Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (3): [output-format-comparison.ipynb](../syft/notebooks/output-format-comparison.ipynb), [source-vs-library-multiarch.ipynb](../syft/notebooks/source-vs-library-multiarch.ipynb), [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb)

## terraform  ·  21 files

- **primer:** [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **notes** (3): [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md), [2026-07-15-explore-terraform.md](../terraform/notes/2026-07-15-explore-terraform.md), [2026-08-04-install-terraform-first-vm.md](../terraform/notes/2026-08-04-install-terraform-first-vm.md)
- **docs** (1): [terraform-module-composition.md](../terraform/docs/terraform-module-composition.md)
- **scripts** (4): [2026-07-18-deploy.sh](../terraform/scripts/2026-07-18-deploy.sh), [state-management-workflow.sh](../terraform/scripts/state-management-workflow.sh), [2026-07-18-cleanup.sh](../terraform/scripts/2026-07-18-cleanup.sh) — _…and 1 more under `terraform/scripts/`._
- **configs** (5): [small-module-from-scratch.hcl](../terraform/configs/small-module-from-scratch.hcl), [2026-07-15-first-config.tf](../terraform/configs/2026-07-15-first-config.tf), [multi-environment-workspaces-variables.hcl](../terraform/configs/multi-environment-workspaces-variables.hcl) — _…and 2 more under `terraform/configs/`._
- **snippets** (1): [2026-07-20-practice-terraform-variables-outputs-datasources.hcl](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- _…and 7 more files under `terraform/eventbridge-lambda/` (EventBridge plus Lambda sample project) — browse the folder._

## terrascan  ·  21 files

- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md), [2026-06-13-first-scan.md](../terrascan/notes/2026-06-13-first-scan.md), [2026-06-29-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md) — _…and 2 more under `terrascan/notes/`._
- **docs** (2): [iac-pipeline-integration.md](../terrascan/docs/iac-pipeline-integration.md), [terrascan-vs-checkov-terraform-iac-scanning.md](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md)
- **scripts** (2): [policy-as-code-workflow.sh](../terrascan/scripts/policy-as-code-workflow.sh), [tried-terrascan-ci-scan.sh](../terrascan/scripts/tried-terrascan-ci-scan.sh)
- **configs** (2): [terrascan-config-template.yaml](../terrascan/configs/terrascan-config-template.yaml), [tried-custom-s3-rule.yaml](../terrascan/configs/tried-custom-s3-rule.yaml)
- **snippets** (2): [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf), [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf)
- **templates** (6): [scanning pipeline scaffold](../terrascan/templates/scanning-pipeline-scaffold/README.md), [config.yaml](../terrascan/templates/scanning-pipeline-scaffold/config.yaml) — _…and 4 more under `terrascan/templates/`._
- **manifests** (1): [terrascan-gha-ci-multi-iac.yaml](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **notebooks** (1): [rego-vs-yaml-rule-authoring.ipynb](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)

## tetragon  ·  11 files

- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (3): [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md), [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md), [2026-08-06-tetragon-observability-tutorial.md](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md)
- **docs** (1): [runtime-security-workflow.md](../tetragon/docs/runtime-security-workflow.md)
- **scripts** (3): [build-tetragon-policy.sh](../tetragon/scripts/build-tetragon-policy.sh), [build-tetragon-file-access-tracing-policy.sh](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh), [2026-08-05-tetragon-event-collection-pipeline.sh](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- **configs** (4): [policy-approaches-comparison.yaml](../tetragon/configs/policy-approaches-comparison.yaml), [tetragon-policy-config-for-k8s-runtime-monitoring.yaml](../tetragon/configs/tetragon-policy-config-for-k8s-runtime-monitoring.yaml), [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml) — _…and 1 more under `tetragon/configs/`._

## tfsec  ·  2 files

- **primer:** [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md)
- **notes** (2): [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md), [2026-09-20-first-tfsec-scan.md](../tfsec/notes/2026-09-20-first-tfsec-scan.md)

## trivy  ·  35 files

- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (6): [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md), [2026-05-24-install-trivy.md](../trivy/notes/2026-05-24-install-trivy.md), [2026-07-27-first-container-scan.md](../trivy/notes/2026-07-27-first-container-scan.md) — _…and 3 more under `trivy/notes/`._
- **docs** (4): [ci-cd-pipeline-recipes.md](../trivy/docs/ci-cd-pipeline-recipes.md), [ci-pipeline-sarif-output.md](../trivy/docs/ci-pipeline-sarif-output.md), [multi-arch-vulnerability-scanning.md](../trivy/docs/multi-arch-vulnerability-scanning.md) — _…and 1 more under `trivy/docs/`._
- **scripts** (6): [container-vuln-scan.sh](../trivy/scripts/container-vuln-scan.sh), [compose-multi-scan.sh](../trivy/scripts/compose-multi-scan.sh), [image-vuln-pipeline.sh](../trivy/scripts/image-vuln-pipeline.sh) — _…and 3 more under `trivy/scripts/`._
- **configs** (2): [trivy-scan-config.yaml](../trivy/configs/trivy-scan-config.yaml), [.trivy.yaml](../trivy/configs/.trivy.yaml)
- **snippets** (1): [scan-docker-image.sh](../trivy/snippets/scan-docker-image.sh)
- **templates** (11): [Kubernetes workload scanning scaffold](../trivy/templates/trivy-k8s-workload-scanning/README.md), [monorepo scanner](../trivy/templates/trivy-monorepo-scanner/README.md), [k8s-scan-job.yaml](../trivy/templates/trivy-k8s-workload-scanning/k8s-scan-job.yaml) — _…and 8 more under `trivy/templates/`._
- **manifests** (2): [trivy-operator-deployment.yaml](../trivy/manifests/trivy-operator-deployment.yaml), [trivy-sarif-code-scanning.yaml](../trivy/manifests/trivy-sarif-code-scanning.yaml)
- **dockerfiles** (1): [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy-scan-mode-comparison.ipynb](../trivy/notebooks/trivy-scan-mode-comparison.ipynb), [trivy-sarif-output-processing.ipynb](../trivy/notebooks/trivy-sarif-output-processing.ipynb)

## trufflehog  ·  38 files

- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (4): [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md), [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md), [2026-07-27-explore-cli.md](../trufflehog/notes/2026-07-27-explore-cli.md) — _…and 1 more under `trufflehog/notes/`._
- **docs** (2): [comparing-scan-modes-git-filesystem-s3.md](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md), [trufflehog-output-formats-json-sarif-csv.md](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md)
- **scripts** (3): [multi-repo-scan-pipeline.sh](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [pre-commit-scan-pipeline.sh](../trufflehog/scripts/pre-commit-scan-pipeline.sh), [analyze-trufflehog-results.py](../trufflehog/scripts/analyze-trufflehog-results.py)
- **configs** (2): [custom-detector-rules.yaml](../trufflehog/configs/custom-detector-rules.yaml), [trufflehog-custom-regex-config.yaml](../trufflehog/configs/trufflehog-custom-regex-config.yaml)
- **snippets** (2): [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh), [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh)
- **templates** (21): [GitHub secret-scanning integration](../trufflehog/templates/github-secret-scanning-integration/README.md), [multi-repo secret scan](../trufflehog/templates/multi-repo-secret-scan/README.md), [secret-scanning pipeline](../trufflehog/templates/secret-scanning-pipeline/README.md) — _…and 18 more under `trufflehog/templates/`._
- **manifests** (1): [trufflehog-pr-secret-scan-reusable.yaml](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- **dockerfiles** (1): [pre-commit-scanner.Dockerfile](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile)
- **notebooks** (2): [trufflehog-scan-modes-comparison.ipynb](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb), [analyzing-trufflehog-false-positives.ipynb](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)

## vault  ·  19 files

- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (4): [0000-primer-vault.md](../vault/notes/0000-primer-vault.md), [2026-08-26-install-vault-first-command.md](../vault/notes/2026-08-26-install-vault-first-command.md), [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md) — _…and 1 more under `vault/notes/`._
- **docs** (3): [vault-secrets-engine-selection-guide.md](../vault/docs/vault-secrets-engine-selection-guide.md), [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md), [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md)
- **scripts** (4): [vault-pki-workflow.sh](../vault/scripts/vault-pki-workflow.sh), [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh), [cloud-iam-dynamic-secrets.sh](../vault/scripts/cloud-iam-dynamic-secrets.sh) — _…and 1 more under `vault/scripts/`._
- **configs** (3): [2026-09-04-aws-secrets-engine-policy.hcl](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl), [multi-environment-access-control.hcl](../vault/configs/multi-environment-access-control.hcl), [2026-06-26-dev-test-policies.hcl](../vault/configs/2026-06-26-dev-test-policies.hcl)
- **snippets** (2): [2026-08-30-first-vault-secret.sh](../vault/snippets/2026-08-30-first-vault-secret.sh), [vault-read-write.go](../vault/snippets/vault-read-write.go)
- **manifests** (1): [vault-sidecar-secrets-refresh.yaml](../vault/manifests/vault-sidecar-secrets-refresh.yaml)
- **dockerfiles** (1): [custom-vault-image-with-plugins-tls.Dockerfile](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **notebooks** (1): [static-vs-dynamic-secrets.ipynb](../vault/notebooks/static-vs-dynamic-secrets.ipynb)

## zap  ·  27 files

- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (6): [0000-primer-zap.md](../zap/notes/0000-primer-zap.md), [2026-06-06-install-zap-desktop-ui.md](../zap/notes/2026-06-06-install-zap-desktop-ui.md), [2026-06-06-zap-quickstart-ui-gotchas.md](../zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md) — _…and 3 more under `zap/notes/`._
- **docs** (3): [zap-automation-plan-structure.md](../zap/docs/zap-automation-plan-structure.md), [zap-integration-patterns.md](../zap/docs/zap-integration-patterns.md), [passive-vs-active-scanning-zap.md](../zap/docs/passive-vs-active-scanning-zap.md)
- **scripts** (3): [zap-baseline-scan.sh](../zap/scripts/zap-baseline-scan.sh), [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh), [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh)
- **configs** (2): [ci-dast-automation-framework-plan.yaml](../zap/configs/ci-dast-automation-framework-plan.yaml), [zap-authenticated-scan-context.yaml](../zap/configs/zap-authenticated-scan-context.yaml)
- **snippets** (4): [my-first-zap-baseline-scan.sh](../zap/snippets/my-first-zap-baseline-scan.sh), [authenticated-scan-with-context.sh](../zap/snippets/authenticated-scan-with-context.sh), [2026-07-16-zap-docker-quickstart-json-export.sh](../zap/snippets/2026-07-16-zap-docker-quickstart-json-export.sh) — _…and 1 more under `zap/snippets/`._
- **templates** (8): [DAST integration scaffold](../zap/templates/zap-dast-integration-scaffold/README.md), [zap-dast.yml](../zap/templates/zap-dast-integration-scaffold/.github/workflows/zap-dast.yml), [Makefile](../zap/templates/zap-dast-integration-scaffold/Makefile) — _…and 5 more under `zap/templates/`._
- **dockerfiles** (1): [custom-zap-automation.Dockerfile](../zap/dockerfiles/custom-zap-automation.Dockerfile)

## Cross-cutting folders

These sit alongside the per-tool folders and are indexed here rather than given their own section.

- **`docs/`** (212 files) — concept primers under `docs/concepts/`, plus `how-to/`, `reference/`, `runbooks/`, `security/`, `setup-guides/`, and `troubleshooting/`. Start at [the concept primers](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md) and [the how-to index](../docs/how-to/ci_cd_toolkit.md).
- **`scripts/`** (192 files) — shell toolkits by domain under `scripts/bash/`, `scripts/pipeline/` deployment and rollback wrappers, and a few repository utilities at the root ([triage-vulnerabilities.sh](../scripts/triage-vulnerabilities.sh), [patch-report.sh](../scripts/patch-report.sh)).
- **`snippets/`** (20 files) — copy-paste cheatsheets, one per tool family. [linux-cheatsheet.md](../snippets/linux-cheatsheet.md), [ci-cd-cheatsheet.md](../snippets/ci-cd-cheatsheet.md), [vault-commands.md](../snippets/vault-commands.md).
- **`templates/`** (39 files) — starter configs for Kubernetes, Terraform, Linux automation, Jenkins, Logstash, and syslog-ng.
- **`environments/`** and **`lab/`** are covered in their own sections above; `assets/` holds the architecture diagrams referenced from the how-to guides.
