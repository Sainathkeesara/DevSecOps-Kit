# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible  ·  34 files
- **notes** (3): [2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md), [2026-08-17-verify-ansible-cve-2026-33228-paths.md](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md), [roles-vs-tasks.md](../ansible/notes/roles-vs-tasks.md)
- **docs** (1): [wired-ansible-infrastructure-workflow.md](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **scripts** (5): [2026-10-27-first-ad-hoc-command.sh](../ansible/scripts/2026-10-27-first-ad-hoc-command.sh), [2026-08-04-bootstrap-node.sh](../ansible/scripts/2026-08-04-bootstrap-node.sh), [bootstrap-target-node.sh](../ansible/scripts/bootstrap-target-node.sh)
- _…and 2 under `ansible/scripts/` — browse the folder._
- **configs** (3): [2026-09-15-inventory-groups-host-vars.yaml](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml), [small-ansible-project.yaml](../ansible/configs/small-ansible-project.yaml), [terraform-nginx-integration.yaml](../ansible/configs/terraform-nginx-integration.yaml)
- **snippets** (1): [2026-08-25-minimal-ansible-playbook-package-service.yaml](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- **templates** (21): [.gitignore](../ansible/templates/ansible-roles-staging-production/.gitignore), [README.md](../ansible/templates/ansible-roles-staging-production/README.md), [ansible.cfg](../ansible/templates/ansible-roles-staging-production/ansible.cfg)
- _…and 18 under `ansible/templates/` — browse the folder._

## Argocd  ·  28 files
- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (5): [2026-08-12-quickstart-tripups.md](../argocd/notes/2026-08-12-quickstart-tripups.md), [2026-08-01-verify-readme-layout.md](../argocd/notes/2026-08-01-verify-readme-layout.md), [2026-07-31-verify-readme-layout.md](../argocd/notes/2026-07-31-verify-readme-layout.md)
- _…and 2 more under `argocd/notes/` — browse the folder._
- **docs** (3): [gitops-workflow-wiring.md](../argocd/docs/gitops-workflow-wiring.md), [helm-kustomize-composition.md](../argocd/docs/helm-kustomize-composition.md), [multi-environment-gitops-delivery.md](../argocd/docs/multi-environment-gitops-delivery.md)
- **scripts** (1): [argocd-api-automation.sh](../argocd/scripts/argocd-api-automation.sh)
- **configs** (2): [2026-09-20-values-dev.yaml](../argocd/configs/2026-09-20-values-dev.yaml), [2026-08-17-private-repo-credentials-rbac.yaml](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- **templates** (11): [README.md](../argocd/templates/app-of-apps-multienv/README.md), [app.yaml](../argocd/templates/app-of-apps-multienv/apps/environments/development/app.yaml), [app.yaml](../argocd/templates/app-of-apps-multienv/apps/environments/production/app.yaml)
- _…and 8 under `argocd/templates/` — browse the folder._
- **manifests** (5): [2026-10-28-install.yaml](../argocd/manifests/2026-10-28-install.yaml), [2026-08-12-gitops-sync-sample-web-app.yaml](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml), [2026-07-06-sample-app-application.yaml](../argocd/manifests/2026-07-06-sample-app-application.yaml)
- _…and 2 under `argocd/manifests/` — browse the folder._

## Checkov  ·  47 files
- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (3): [2026-05-27-checkov-quickstart-trip-ups.md](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md), [2026-05-26-cli-vs-sdk-comparison.md](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [2026-05-25-scan-terraform-plan.md](../checkov/notes/2026-05-25-scan-terraform-plan.md)
- **docs** (6): [checkov-ai-infrastructure-checks.md](../checkov/docs/checkov-ai-infrastructure-checks.md), [checkov-integration-patterns.md](../checkov/docs/checkov-integration-patterns.md), [checkov-v3-migration-guide.md](../checkov/docs/checkov-v3-migration-guide.md)
- _…and 3 under `checkov/docs/` — browse the folder._
- **scripts** (4): [checkov-health-check-and-rollback.sh](../checkov/scripts/checkov-health-check-and-rollback.sh), [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh), [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh)
- _…and 1 under `checkov/scripts/` — browse the folder._
- **configs** (4): [checkov-ci-config.yaml](../checkov/configs/checkov-ci-config.yaml), [checkov-skip-severity-config.yaml](../checkov/configs/checkov-skip-severity-config.yaml), [platform-config.yaml](../checkov/configs/platform-config.yaml)
- _…and 1 under `checkov/configs/` — browse the folder._
- **snippets** (4): [scan-a-terraform-file.py](../checkov/snippets/scan-a-terraform-file.py), [scan-kubernetes.sh](../checkov/snippets/scan-kubernetes.sh), [scan-terraform-dir.py](../checkov/snippets/scan-terraform-dir.py)
- _…and 1 under `checkov/snippets/` — browse the folder._
- **templates** (16): [Makefile](../checkov/templates/multi-iac-scan-project/Makefile), [README.md](../checkov/templates/multi-iac-scan-project/README.md), [checkov-config.yaml](../checkov/templates/multi-iac-scan-project/checkov-config.yaml)
- _…and 13 under `checkov/templates/` — browse the folder._
- **manifests** (3): [checkov-gitlab-ci-multi-cloud-drift.yaml](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml), [checkov-sarif-pr-blocking.yaml](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml)
- **notebooks** (4): [compare-builtin-vs-custom-k8s.ipynb](../checkov/notebooks/compare-builtin-vs-custom-k8s.ipynb), [compare-cross-module-scanning-limitations.ipynb](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb), [compare-custom-policy-expressiveness.ipynb](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb)
- _…and 1 under `checkov/notebooks/` — browse the folder._
- **policies** (2): [no_public_bucket.yaml](../checkov/policies/ckv2-no-public-bucket/no_public_bucket.yaml), [no_public_s3_buckets.yaml](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)

## Codeql  ·  32 files
- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (4): [2026-10-27-install-codeql-first-query.md](../codeql/notes/2026-10-27-install-codeql-first-query.md), [2026-08-26-install-codeql-first-query.md](../codeql/notes/2026-08-26-install-codeql-first-query.md), [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md)
- _…and 1 more under `codeql/notes/` — browse the folder._
- **docs** (4): [codeql-database-migration-guide.md](../codeql/docs/codeql-database-migration-guide.md), [codeql-integration-reference.md](../codeql/docs/codeql-integration-reference.md), [query-writing-patterns-dataflow-javascript-typescript.md](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md)
- _…and 1 under `codeql/docs/` — browse the folder._
- **scripts** (2): [codeql-security-issue-detector.py](../codeql/scripts/codeql-security-issue-detector.py), [first-codeql-analysis.sh](../codeql/scripts/first-codeql-analysis.sh)
- **configs** (2): [codeql-analysis-workflow.yaml](../codeql/configs/codeql-analysis-workflow.yaml), [first-codeql-analysis.yml](../codeql/configs/first-codeql-analysis.yml)
- **snippets** (6): [2026-10-27-hardcoded-secrets.ql](../codeql/snippets/2026-10-27-hardcoded-secrets.ql), [2026-09-24-first-codeql-query.py](../codeql/snippets/2026-09-24-first-codeql-query.py), [find-hardcoded-creds.ql](../codeql/snippets/find-hardcoded-creds.ql)
- _…and 3 under `codeql/snippets/` — browse the folder._
- **templates** (7): [README.md](../codeql/templates/custom-query-pack-ci-harness/README.md), [known-bad.py](../codeql/templates/custom-query-pack-ci-harness/fixtures/basic/known-bad.py), [known-good.py](../codeql/templates/custom-query-pack-ci-harness/fixtures/basic/known-good.py)
- _…and 4 under `codeql/templates/` — browse the folder._
- **manifests** (3): [codeql-cicd-pipeline.yaml](../codeql/manifests/codeql-cicd-pipeline.yaml), [codeql-multi-language-scan.yaml](../codeql/manifests/codeql-multi-language-scan.yaml), [multi-language-codeql-analysis.yaml](../codeql/manifests/multi-language-codeql-analysis.yaml)
- **dockerfiles** (1): [custom-codeql-analysis-image.Dockerfile](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **notebooks** (2): [codeql-query-comparison-patterns.ipynb](../codeql/notebooks/codeql-query-comparison-patterns.ipynb), [compare-cli-vs-actions-scan-modes.ipynb](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb)

## Cosign  ·  20 files
- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (4): [2026-10-14-install-cosign-first-signing-command.md](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md), [2026-06-22-cosign-getting-started-trip-ups.md](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md)
- _…and 1 more under `cosign/notes/` — browse the folder._
- **docs** (4): [container-signing-pipeline.md](../cosign/docs/container-signing-pipeline.md), [cosign-verification-patterns.md](../cosign/docs/cosign-verification-patterns.md), [key-rotation-and-migration-patterns.md](../cosign/docs/key-rotation-and-migration-patterns.md)
- _…and 1 under `cosign/docs/` — browse the folder._
- **scripts** (3): [cosign-key-management-workflow.sh](../cosign/scripts/cosign-key-management-workflow.sh), [minimal-sign-verify.sh](../cosign/scripts/minimal-sign-verify.sh), [verify-signed-image.sh](../cosign/scripts/verify-signed-image.sh)
- **configs** (2): [cosign-signature-configuration.yaml](../cosign/configs/cosign-signature-configuration.yaml), [keyless-signing-github-actions.yaml](../cosign/configs/keyless-signing-github-actions.yaml)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (2): [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml), [signed-container-build-oidc.yaml](../cosign/manifests/signed-container-build-oidc.yaml)
- **dockerfiles** (2): [custom-cosign-image.Dockerfile](../cosign/dockerfiles/custom-cosign-image.Dockerfile), [entrypoint.sh](../cosign/dockerfiles/entrypoint.sh)
- **notebooks** (1): [key-based-vs-keyless-signing.ipynb](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## Defectdojo  ·  19 files
- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (3): [2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md](../defectdojo/notes/2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md), [2026-09-21-quickstart-tripups.md](../defectdojo/notes/2026-09-21-quickstart-tripups.md), [2026-08-04-explore-defectdojo-ui.md](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md)
- **docs** (2): [defectdojo-scan-tool-ingestion-end-to-end.md](../defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md), [how-i-wired-defectdojo-into-my-triage-workflow.md](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md)
- **scripts** (3): [2026-09-20-defectdojo-tutorial-check.sh](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh), [product-engagement-setup.py](../defectdojo/scripts/product-engagement-setup.py), [product-scan-import.py](../defectdojo/scripts/product-scan-import.py)
- **configs** (2): [2026-09-21-vulnerability-scanner-setup.yaml](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml), [api-vs-ui-ingestion.yaml](../defectdojo/configs/api-vs-ui-ingestion.yaml)
- **snippets** (2): [2026-10-19-minimal-product-setup-api.py](../defectdojo/snippets/2026-10-19-minimal-product-setup-api.py), [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)
- **templates** (6): [.env.example](../defectdojo/templates/defectdojo-scan-ingestion-starter/.env.example), [README.md](../defectdojo/templates/defectdojo-scan-ingestion-starter/README.md), [scanner-configs.yaml](../defectdojo/templates/defectdojo-scan-ingestion-starter/configs/scanner-configs.yaml)
- _…and 3 under `defectdojo/templates/` — browse the folder._

## Dependabot  ·  19 files
- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (6): [2026-08-08-dependabot-custom-registry-tutorial.md](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md), [2026-07-21-enabling-dependabot-alerts-security-updates.md](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md), [2026-07-10-enabling-dependabot-alerts.md](../dependabot/notes/2026-07-10-enabling-dependabot-alerts.md)
- _…and 3 more under `dependabot/notes/` — browse the folder._
- **docs** (4): [dependabot-security-alert-migration-patterns.md](../dependabot/docs/dependabot-security-alert-migration-patterns.md), [dependabot-security-update-auto-merge.md](../dependabot/docs/dependabot-security-update-auto-merge.md), [dependabot-version-control-workflow-integration.md](../dependabot/docs/dependabot-version-control-workflow-integration.md)
- _…and 1 under `dependabot/docs/` — browse the folder._
- **scripts** (2): [2026-08-04-dependabot-alert-triage.py](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py), [dependabot-alert-aggregation.py](../dependabot/scripts/dependabot-alert-aggregation.py)
- **configs** (5): [2026-07-18-python-project-version-update.yaml](../dependabot/configs/2026-07-18-python-project-version-update.yaml), [2026-07-10-npm-version-strategy.yaml](../dependabot/configs/2026-07-10-npm-version-strategy.yaml), [dependabot-configuration-template.yaml](../dependabot/configs/dependabot-configuration-template.yaml)
- _…and 2 under `dependabot/configs/` — browse the folder._
- **notebooks** (1): [auto-merge-vs-manual-review.ipynb](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## Docker  ·  19 files
- **primer:** [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **notes** (1): [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md)
- **docs** (2): [cicd-end-to-end.md](../docker/docs/cicd-end-to-end.md), [dockerfile-optimization-patterns.md](../docker/docs/dockerfile-optimization-patterns.md)
- **scripts** (3): [2026-07-18-custom-network-volume-mounts.sh](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh), [build-multi-service-compose-app.sh](../docker/scripts/build-multi-service-compose-app.sh), [reusable-build.sh](../docker/scripts/reusable-build.sh)
- **configs** (1): [docker-compose-dev-environment.yaml](../docker/configs/docker-compose-dev-environment.yaml)
- **templates** (7): [.env.example](../docker/templates/multi-service-setup/.env.example), [README.md](../docker/templates/multi-service-setup/README.md), [Dockerfile](../docker/templates/multi-service-setup/api/Dockerfile)
- _…and 4 under `docker/templates/` — browse the folder._
- **manifests** (1): [docker-compose-production.yaml](../docker/manifests/docker-compose-production.yaml)
- **dockerfiles** (3): [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile), [small-app.Dockerfile](../docker/dockerfiles/small-app.Dockerfile)

## Falco  ·  25 files
- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (5): [2026-10-27-follow-official-falco-quickstart.md](../falco/notes/2026-10-27-follow-official-falco-quickstart.md), [2026-10-15-install-falco-first-event.md](../falco/notes/2026-10-15-install-falco-first-event.md), [2026-07-19-explore-falco-cli-rules-events-output.md](../falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md)
- _…and 2 more under `falco/notes/` — browse the folder._
- **docs** (4): [rule-optimization-priority-filtering.md](../falco/docs/rule-optimization-priority-filtering.md), [runtime-security-monitoring-integration.md](../falco/docs/runtime-security-monitoring-integration.md), [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md)
- _…and 1 under `falco/docs/` — browse the folder._
- **scripts** (3): [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh), [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh)
- **configs** (4): [2026-10-03-minimal-runtime-config.yaml](../falco/configs/2026-10-03-minimal-runtime-config.yaml), [2026-06-10-first-custom-rule-detect-shell-in-container.yaml](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml), [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml)
- _…and 1 under `falco/configs/` — browse the folder._
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)
- **templates** (4): [README.md](../falco/templates/falco-custom-rules-library/README.md), [override-example.yaml](../falco/templates/falco-custom-rules-library/examples/override-example.yaml), [custom-rules.yaml](../falco/templates/falco-custom-rules-library/rules/custom-rules.yaml)
- _…and 1 under `falco/templates/` — browse the folder._
- **manifests** (1): [falco-k8s-admission-control.yaml](../falco/manifests/falco-k8s-admission-control.yaml)
- **notebooks** (2): [falco-event-output-formats.ipynb](../falco/notebooks/falco-event-output-formats.ipynb), [rule-engine-vs-ebpf-probes.ipynb](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb)

## Git  ·  10 files
- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (2): [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md), [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md)
- **docs** (1): [how-i-wired-git-into-my-version-control-workflow.md](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **scripts** (4): [2026-08-24-first-repo-stage-log.sh](../git/scripts/2026-08-24-first-repo-stage-log.sh), [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh), [2026-07-10-local-ci-simulation.sh](../git/scripts/2026-07-10-local-ci-simulation.sh)
- _…and 1 under `git/scripts/` — browse the folder._
- **configs** (1): [config-strategy-layered-vs-conditional.yaml](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## Gitguardian  ·  28 files
- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (5): [2026-10-27-quickstart-trip-ups.md](../gitguardian/notes/2026-10-27-quickstart-trip-ups.md), [2026-10-14-explore-interface.md](../gitguardian/notes/2026-10-14-explore-interface.md), [2026-06-14-first-secrets-scan-repo.md](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md)
- _…and 2 more under `gitguardian/notes/` — browse the folder._
- **docs** (4): [cicd-secret-scanning-integration.md](../gitguardian/docs/cicd-secret-scanning-integration.md), [gitguardian-incident-response-workflow.md](../gitguardian/docs/gitguardian-incident-response-workflow.md), [gitguardian-secret-scanning-migration-patterns.md](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md)
- _…and 1 under `gitguardian/docs/` — browse the folder._
- **scripts** (4): [2026-10-20-first-ggshield-scan.sh](../gitguardian/scripts/2026-10-20-first-ggshield-scan.sh), [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh), [gitguardian-api-integration.py](../gitguardian/scripts/gitguardian-api-integration.py)
- _…and 1 under `gitguardian/scripts/` — browse the folder._
- **configs** (3): [.ggshield.yaml](../gitguardian/configs/.ggshield.yaml), [monorepo-allowlists.yaml](../gitguardian/configs/monorepo-allowlists.yaml), [policy-configuration.yaml](../gitguardian/configs/policy-configuration.yaml)
- **snippets** (2): [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh), [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh)
- **templates** (8): [allowlist.yaml](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.ggshield/allowlist.yaml), [.gitignore](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.gitignore), [Makefile](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/Makefile)
- _…and 5 under `gitguardian/templates/` — browse the folder._
- **notebooks** (1): [choosing-between-on-premise-and-cloud-modes.ipynb](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb)

## Github-Actions  ·  22 files
- **primer:** [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (6): [2026-10-20-followed-quickstart.md](../github-actions/notes/2026-10-20-followed-quickstart.md), [2026-10-14-run-first-workflow.md](../github-actions/notes/2026-10-14-run-first-workflow.md), [2026-09-21-quickstart-tripped-me-up.md](../github-actions/notes/2026-09-21-quickstart-tripped-me-up.md)
- _…and 3 more under `github-actions/notes/` — browse the folder._
- **docs** (1): [how-i-wired-github-actions-into-my-ci-workflow.md](../github-actions/docs/how-i-wired-github-actions-into-my-ci-workflow.md)
- **scripts** (1): [triage-latest-failed-run.sh](../github-actions/scripts/triage-latest-failed-run.sh)
- **configs** (8): [2026-10-20-minimal-ci.yaml](../github-actions/configs/2026-10-20-minimal-ci.yaml), [2026-10-14-first-scheduled-workflow.yaml](../github-actions/configs/2026-10-14-first-scheduled-workflow.yaml), [2026-09-21-minimal-starter-workflow.yaml](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml)
- _…and 5 under `github-actions/configs/` — browse the folder._
- **snippets** (3): [2026-10-14-trigger-first-workflow-gh.sh](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh), [2026-08-26-first-workflow.yaml](../github-actions/snippets/2026-08-26-first-workflow.yaml), [2026-08-26-composite-action-input-reuse.yaml](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- **manifests** (2): [2026-08-04-what-is-github-actions.yaml](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [2026-08-04-pr-validation.yml](../github-actions/manifests/2026-08-04-pr-validation.yml)

## Gitleaks  ·  9 files
- **primer:** [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md)
- **notes** (2): [2026-10-07-quickstart-trip-ups.md](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md), [2026-09-19-first-secret-scan.md](../gitleaks/notes/2026-09-19-first-secret-scan.md)
- **docs** (1): [integrating-gitleaks-pre-commit-ci.md](../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md)
- **scripts** (3): [2026-10-13-auditing-git-secrets.sh](../gitleaks/scripts/2026-10-13-auditing-git-secrets.sh), [2026-09-26-run-first-gitleaks-scan.sh](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh), [build-custom-gitleaks-ruleset.sh](../gitleaks/scripts/build-custom-gitleaks-ruleset.sh)
- **configs** (2): [2026-10-07-detection-rules.yaml](../gitleaks/configs/2026-10-07-detection-rules.yaml), [gitleaks-config.toml](../gitleaks/configs/gitleaks-config.toml)

## Grafana  ·  10 files
- **primer:** [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)
- **notes** (3): [2026-10-14-grafana-quickstart-trip-ups.md](../grafana/notes/2026-10-14-grafana-quickstart-trip-ups.md), [2026-09-26-explore-grafana-dashboard-ui.md](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md), [2026-09-19-first-dashboard-browser.md](../grafana/notes/2026-09-19-first-dashboard-browser.md)
- **docs** (1): [grafana-alerting-routing-templates.md](../grafana/docs/grafana-alerting-routing-templates.md)
- **scripts** (1): [build-dashboard-provisioning.py](../grafana/scripts/build-dashboard-provisioning.py)
- **configs** (2): [2026-10-14-dashboard-provisioning.yaml](../grafana/configs/2026-10-14-dashboard-provisioning.yaml), [2026-09-19-first-datasource.yaml](../grafana/configs/2026-09-19-first-datasource.yaml)
- **snippets** (1): [2026-10-14-first-grafana-datasource-query.py](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- **manifests** (1): [grafana-datasource-dashboard.yaml](../grafana/manifests/grafana-datasource-dashboard.yaml)

## Grype  ·  27 files
- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **notes** (4): [2026-10-14-explore-vulnerability-database.md](../grype/notes/2026-10-14-explore-vulnerability-database.md), [2026-06-08-first-grype-scan.md](../grype/notes/2026-06-08-first-grype-scan.md), [2026-06-04-grype-quickstart-trip-ups.md](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md)
- _…and 1 more under `grype/notes/` — browse the folder._
- **docs** (3): [grype-syft-integration-guide.md](../grype/docs/grype-syft-integration-guide.md), [grype-vulnerability-reporting-migration-patterns.md](../grype/docs/grype-vulnerability-reporting-migration-patterns.md), [vulnerability-management-pipeline-integration.md](../grype/docs/vulnerability-management-pipeline-integration.md)
- **scripts** (9): [ci-ready-grype-scan.sh](../grype/scripts/ci-ready-grype-scan.sh), [grype-end-to-end-scan-pipeline.sh](../grype/scripts/grype-end-to-end-scan-pipeline.sh), [grype-pipeline-ci-scan.sh](../grype/scripts/grype-pipeline-ci-scan.sh)
- _…and 6 under `grype/scripts/` — browse the folder._
- **configs** (2): [grype-ci-github-actions.yaml](../grype/configs/grype-ci-github-actions.yaml), [grype-filtering-configuration-template.yaml](../grype/configs/grype-filtering-configuration-template.yaml)
- **snippets** (3): [2026-10-27-grype-filter-severity-formats.sh](../grype/snippets/2026-10-27-grype-filter-severity-formats.sh), [minimal-grype-scan.go](../grype/snippets/minimal-grype-scan.go), [my-first-grype-commands.sh](../grype/snippets/my-first-grype-commands.sh)
- **manifests** (2): [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml), [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml)
- **dockerfiles** (1): [multi-stage-grype-scan.Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (2): [grype-db-vs-registry-sources.ipynb](../grype/notebooks/grype-db-vs-registry-sources.ipynb), [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb)

## Helm  ·  9 files
- **primer:** [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **notes** (3): [2026-10-20-followed-quickstart.md](../helm/notes/2026-10-20-followed-quickstart.md), [2026-09-21-quickstart-tripped-me-up.md](../helm/notes/2026-09-21-quickstart-tripped-me-up.md), [2026-07-19-explore-helm-charts-releases-values-repos.md](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md)
- **docs** (1): [how-i-wired-helm-into-my-release-workflow.md](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- **scripts** (1): [build-and-deploy-chart.sh](../helm/scripts/build-and-deploy-chart.sh)
- **configs** (1): [values-file-vs-set-flags.yaml](../helm/configs/values-file-vs-set-flags.yaml)
- **manifests** (2): [2026-09-21-minimal-service-chart.yaml](../helm/manifests/2026-09-21-minimal-service-chart.yaml), [2026-07-15-first-chart-values.yaml](../helm/manifests/2026-07-15-first-chart-values.yaml)

## Kubernetes  ·  20 files
- **primer:** [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (3): [2026-10-20-quickstart-followup.md](../kubernetes/notes/2026-10-20-quickstart-followup.md), [2026-10-14-cluster-resources.md](../kubernetes/notes/2026-10-14-cluster-resources.md), [2026-07-15-explore-kubernetes.md](../kubernetes/notes/2026-07-15-explore-kubernetes.md)
- **docs** (2): [cluster-workflow-wiring.md](../kubernetes/docs/cluster-workflow-wiring.md), [rbac-design-patterns-for-multi-tenant-clusters.md](../kubernetes/docs/rbac-design-patterns-for-multi-tenant-clusters.md)
- **scripts** (2): [2026-10-20-quickstart-repro.sh](../kubernetes/scripts/2026-10-20-quickstart-repro.sh), [cluster-health-check-and-conformance-validation.sh](../kubernetes/scripts/cluster-health-check-and-conformance-validation.sh)
- **configs** (3): [2026-10-20-minimal-deployment.yaml](../kubernetes/configs/2026-10-20-minimal-deployment.yaml), [2026-10-14-minimal-namespace.yaml](../kubernetes/configs/2026-10-14-minimal-namespace.yaml), [namespace-strategy-environment-vs-team.yaml](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml)
- **templates** (5): [README.md](../kubernetes/templates/cluster-bootstrap/README.md), [cert-manager-bootstrap.yaml](../kubernetes/templates/cluster-bootstrap/cert-manager/cert-manager-bootstrap.yaml), [calico-installation.yaml](../kubernetes/templates/cluster-bootstrap/cni/calico-installation.yaml)
- _…and 2 under `kubernetes/templates/` — browse the folder._
- **manifests** (4): [2026-09-10-first-pod.yaml](../kubernetes/manifests/2026-09-10-first-pod.yaml), [2026-07-15-first-pod-service.yaml](../kubernetes/manifests/2026-07-15-first-pod-service.yaml), [kustomize-overlays.yaml](../kubernetes/manifests/kustomize-overlays.yaml)
- _…and 1 under `kubernetes/manifests/` — browse the folder._

## Kustomize  ·  17 files
- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (2): [2026-09-21-kustomize-quickstart-tripped-me-up.md](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md), [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md)
- **docs** (1): [how-i-wired-kustomize-into-my-manifest-workflow.md](../kustomize/docs/how-i-wired-kustomize-into-my-manifest-workflow.md)
- **scripts** (2): [2026-10-20-kustomize-tutorial.sh](../kustomize/scripts/2026-10-20-kustomize-tutorial.sh), [bases-vs-remote-resources.sh](../kustomize/scripts/bases-vs-remote-resources.sh)
- **configs** (10): [2026-09-22-minimal-kustomization-with-overlay.yaml](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml), [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml), [configmap.yaml](../kustomize/configs/environment-overlays/base/configmap.yaml)
- _…and 7 under `kustomize/configs/` — browse the folder._
- **manifests** (1): [2026-09-21-kustomize-tutorial.yaml](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## Linux  ·  7 files
- **notes** (3): [2026-10-02-explore-linux-environment.md](../linux/notes/2026-10-02-explore-linux-environment.md), [2026-08-06-linux-shell-scripting-tutorial-confusions.md](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md), [2026-07-21-install-linux-vm-terminal-first-commands.md](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- **docs** (1): [system-administration-runbook.md](../linux/docs/system-administration-runbook.md)
- **scripts** (2): [find-large-logs.sh](../linux/scripts/find-large-logs.sh), [health-check-and-rollback.sh](../linux/scripts/health-check-and-rollback.sh)
- **configs** (1): [2026-08-06-cron-job-configuration.ini](../linux/configs/2026-08-06-cron-job-configuration.ini)

## Nuclei  ·  5 files
- **primer:** [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md)
- **notes** (2): [2026-10-15-nuclei-quickstart-trip-ups.md](../nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md), [2026-09-20-first-template-scan-attempt.md](../nuclei/notes/2026-09-20-first-template-scan-attempt.md)
- **scripts** (1): [2026-10-15-first-nuclei-scan.sh](../nuclei/scripts/2026-10-15-first-nuclei-scan.sh)
- **configs** (1): [2026-10-15-minimal-scan-template.yaml](../nuclei/configs/2026-10-15-minimal-scan-template.yaml)

## Opa  ·  30 files
- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (4): [2026-10-27-opa-install-first-policy.md](../opa/notes/2026-10-27-opa-install-first-policy.md), [2026-10-24-install-opa-first-policy-eval.md](../opa/notes/2026-10-24-install-opa-first-policy-eval.md), [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)
- _…and 1 more under `opa/notes/` — browse the folder._
- **docs** (4): [constraint-template-design-patterns.md](../opa/docs/constraint-template-design-patterns.md), [integrating-opa-with-policy-as-code-governance.md](../opa/docs/integrating-opa-with-policy-as-code-governance.md), [opa-policy-version-migration-patterns.md](../opa/docs/opa-policy-version-migration-patterns.md)
- _…and 1 under `opa/docs/` — browse the folder._
- **scripts** (2): [export-audit-results.sh](../opa/scripts/export-audit-results.sh), [how-i-test-policies-locally.sh](../opa/scripts/how-i-test-policies-locally.sh)
- **configs** (2): [opa-policy-configuration-template.yaml](../opa/configs/opa-policy-configuration-template.yaml), [tried-a-gatekeeper-constraint.yaml](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- **snippets** (4): [2026-10-14-first-rego-policy.py](../opa/snippets/2026-10-14-first-rego-policy.py), [deny-privileged-hostnetwork.rego](../opa/snippets/deny-privileged-hostnetwork.rego), [enforce-image-registry-constraints.rego](../opa/snippets/enforce-image-registry-constraints.rego)
- _…and 1 under `opa/snippets/` — browse the folder._
- **templates** (8): [README.md](../opa/templates/gatekeeper-policy-library-scaffold/README.md), [k8sallowedregistries.yaml](../opa/templates/gatekeeper-policy-library-scaffold/constraint-templates/k8sallowedregistries.yaml), [k8ssecuritybaseline.yaml](../opa/templates/gatekeeper-policy-library-scaffold/constraint-templates/k8ssecuritybaseline.yaml)
- _…and 5 under `opa/templates/` — browse the folder._
- **manifests** (4): [README.md](../opa/manifests/README.md), [constraint-templates.yaml](../opa/manifests/constraint-templates.yaml), [constraints.yaml](../opa/manifests/constraints.yaml)
- _…and 1 under `opa/manifests/` — browse the folder._
- **notebooks** (1): [rego-vs-builtin-policies.ipynb](../opa/notebooks/rego-vs-builtin-policies.ipynb)

## Opentofu  ·  10 files
- **primer:** [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (3): [2026-10-20-follow-opentofu-test-quickstart.md](../opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md), [2026-09-21-follow-open-tofu-quickstart.md](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md), [2026-07-20-explore-open-tofu.md](../opentofu/notes/2026-07-20-explore-open-tofu.md)
- **docs** (2): [how-i-wired-opentofu-into-my-iac-workflow.md](../opentofu/docs/how-i-wired-opentofu-into-my-iac-workflow.md), [open-tofu-vs-terraform-migration-decision-matrix.md](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md)
- **scripts** (1): [module-registry-publisher.sh](../opentofu/scripts/module-registry-publisher.sh)
- **configs** (3): [2026-09-21-minimal-opentofu-config-with-vars.hcl](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl), [2026-09-10-minimal-opentofu-config.hcl](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl), [2026-07-20-first-open-tofu-config.hcl](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## Prometheus  ·  7 files
- **primer:** [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (4): [2026-10-25-followed-quickstart.md](../prometheus/notes/2026-10-25-followed-quickstart.md), [2026-10-14-observability-primer-dedup.md](../prometheus/notes/2026-10-14-observability-primer-dedup.md), [2026-10-14-first-query-log.md](../prometheus/notes/2026-10-14-first-query-log.md)
- _…and 1 more under `prometheus/notes/` — browse the folder._
- **scripts** (1): [2026-10-25-query-api-python.py](../prometheus/scripts/2026-10-25-query-api-python.py)
- **snippets** (1): [2026-10-25-minimal-scrape-config.yaml](../prometheus/snippets/2026-10-25-minimal-scrape-config.yaml)

## Semgrep  ·  25 files
- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (2): [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md)
- **docs** (8): [comparing-rule-writing-approaches.md](../semgrep/docs/comparing-rule-writing-approaches.md), [github-actions-ci-from-scratch.md](../semgrep/docs/github-actions-ci-from-scratch.md), [semgrep-ci-integration.md](../semgrep/docs/semgrep-ci-integration.md)
- _…and 5 under `semgrep/docs/` — browse the folder._
- **scripts** (3): [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py), [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py), [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh)
- **configs** (1): [multi-rule-pack.yaml](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [catch-privileged-containers.yaml](../semgrep/snippets/catch-privileged-containers.yaml), [first-custom-rule.yaml](../semgrep/snippets/first-custom-rule.yaml)
- **manifests** (3): [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml), [semgrep-ci-cd-pipeline.yaml](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml), [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml)
- **dockerfiles** (2): [ci-entrypoint.sh](../semgrep/dockerfiles/ci-entrypoint.sh), [custom-scanning-image.Dockerfile](../semgrep/dockerfiles/custom-scanning-image.Dockerfile)
- **notebooks** (3): [comparing-community-vs-custom-rules.ipynb](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb), [rule-matching-mode-comparison.ipynb](../semgrep/notebooks/rule-matching-mode-comparison.ipynb), [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## Snyk  ·  29 files
- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (5): [2026-10-27-snyk-quickstart-tripped.md](../snyk/notes/2026-10-27-snyk-quickstart-tripped.md), [2026-10-07-explore-snyk-cli-commands.md](../snyk/notes/2026-10-07-explore-snyk-cli-commands.md), [2026-06-14-first-vulnerability-scan.md](../snyk/notes/2026-06-14-first-vulnerability-scan.md)
- _…and 2 more under `snyk/notes/` — browse the folder._
- **docs** (4): [integrating-snyk-with-cicd-security-scanning.md](../snyk/docs/integrating-snyk-with-cicd-security-scanning.md), [multi-project-ci-pipeline.md](../snyk/docs/multi-project-ci-pipeline.md), [snyk-security-policy-migration-patterns.md](../snyk/docs/snyk-security-policy-migration-patterns.md)
- _…and 1 under `snyk/docs/` — browse the folder._
- **scripts** (2): [2026-10-20-first-snyk-test.sh](../snyk/scripts/2026-10-20-first-snyk-test.sh), [snyk-vuln-scan-pipeline.sh](../snyk/scripts/snyk-vuln-scan-pipeline.sh)
- **configs** (3): [snyk-ci-github-actions.yaml](../snyk/configs/snyk-ci-github-actions.yaml), [snyk-dependency-patch-ignore.yaml](../snyk/configs/snyk-dependency-patch-ignore.yaml), [snyk-project-configuration-template.yaml](../snyk/configs/snyk-project-configuration-template.yaml)
- **snippets** (1): [my-first-snyk-commands.sh](../snyk/snippets/my-first-snyk-commands.sh)
- **templates** (10): [.snyk](../snyk/templates/snyk-multilang-scan-scaffold/.snyk), [Makefile](../snyk/templates/snyk-multilang-scan-scaffold/Makefile), [README.md](../snyk/templates/snyk-multilang-scan-scaffold/README.md)
- _…and 7 under `snyk/templates/` — browse the folder._
- **manifests** (1): [snyk-github-actions-cicd-workflow.yaml](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **dockerfiles** (1): [custom-snyk-cli-air-gapped.Dockerfile](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- **notebooks** (1): [cli-vs-api-modes.ipynb](../snyk/notebooks/cli-vs-api-modes.ipynb)

## Sonarqube  ·  7 files
- **primer:** [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (2): [2026-09-21-follow-sonarqube-quickstart.md](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md), [2026-07-19-explore-sonarqube-quality-gates-profiles.md](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md)
- **scripts** (1): [2026-09-21-sonarqube-scan-setup.sh](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **configs** (2): [2026-09-21-minimal-quality-gate.yaml](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml), [minimal-project-quality-gate.yaml](../sonarqube/configs/minimal-project-quality-gate.yaml)
- **snippets** (1): [2026-07-16-first-sonarscanner-run.sh](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## Syft  ·  44 files
- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (4): [2026-10-27-first-image-sbom.md](../syft/notes/2026-10-27-first-image-sbom.md), [2026-05-30-sbom-format-comparison.md](../syft/notes/2026-05-30-sbom-format-comparison.md), [2026-05-29-syft-quickstart-trip-ups.md](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)
- _…and 1 more under `syft/notes/` — browse the folder._
- **docs** (8): [enterprise-registry-auth-caching-patterns.md](../syft/docs/enterprise-registry-auth-caching-patterns.md), [enterprise-registry-auth-caching.md](../syft/docs/enterprise-registry-auth-caching.md), [output-format-selection-guide.md](../syft/docs/output-format-selection-guide.md)
- _…and 5 under `syft/docs/` — browse the folder._
- **scripts** (5): [2026-10-27-scan-docker-images-aggregate-sboms.sh](../syft/scripts/2026-10-27-scan-docker-images-aggregate-sboms.sh), [gen-multi-format-sboms.sh](../syft/scripts/gen-multi-format-sboms.sh), [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh)
- _…and 2 under `syft/scripts/` — browse the folder._
- **configs** (1): [.syft.yaml](../syft/configs/.syft.yaml)
- **snippets** (3): [2026-10-27-syft-cli-output-formats.sh](../syft/snippets/2026-10-27-syft-cli-output-formats.sh), [2026-10-14-first-sbom.sh](../syft/snippets/2026-10-14-first-sbom.sh), [tried-sbom-formats.sh](../syft/snippets/tried-sbom-formats.sh)
- **templates** (13): [.gitignore](../syft/templates/sbom-pipeline-scaffold/.gitignore), [Makefile](../syft/templates/sbom-pipeline-scaffold/Makefile), [README.md](../syft/templates/sbom-pipeline-scaffold/README.md)
- _…and 10 under `syft/templates/` — browse the folder._
- **manifests** (4): [syft-cicd-pipeline.yaml](../syft/manifests/syft-cicd-pipeline.yaml), [syft-gha-multi-arch-sbom-registry-auth.yaml](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml), [syft-gha-sbom-oci-push-attestation.yaml](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml)
- _…and 1 under `syft/manifests/` — browse the folder._
- **dockerfiles** (1): [multi-stage-sbom.Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (4): [output-format-comparison.ipynb](../syft/notebooks/output-format-comparison.ipynb), [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb), [source-vs-library-multiarch.ipynb](../syft/notebooks/source-vs-library-multiarch.ipynb)
- _…and 1 under `syft/notebooks/` — browse the folder._

## Terraform  ·  35 files
- **primer:** [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **notes** (2): [2026-08-04-install-terraform-first-vm.md](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [2026-07-15-explore-terraform.md](../terraform/notes/2026-07-15-explore-terraform.md)
- **docs** (2): [terraform-module-composition.md](../terraform/docs/terraform-module-composition.md), [terraform-testing-patterns.md](../terraform/docs/terraform-testing-patterns.md)
- **scripts** (4): [2026-07-18-deploy.sh](../terraform/scripts/2026-07-18-deploy.sh), [2026-07-18-cleanup.sh](../terraform/scripts/2026-07-18-cleanup.sh), [2026-07-13-zip-build.sh](../terraform/scripts/2026-07-13-zip-build.sh)
- _…and 1 under `terraform/scripts/` — browse the folder._
- **configs** (12): [2026-10-19-minimal-quickstart-config.hcl](../terraform/configs/2026-10-19-minimal-quickstart-config.hcl), [2026-08-04-first-configuration.hcl](../terraform/configs/2026-08-04-first-configuration.hcl), [2026-07-15-first-config.tf](../terraform/configs/2026-07-15-first-config.tf)
- _…and 9 under `terraform/configs/` — browse the folder._
- **snippets** (1): [2026-07-20-practice-terraform-variables-outputs-datasources.hcl](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- **templates** (5): [README.md](../terraform/templates/module-registry-publish-consume/README.md), [main.tf](../terraform/templates/module-registry-publish-consume/main.tf), [outputs.tf](../terraform/templates/module-registry-publish-consume/outputs.tf)
- _…and 2 under `terraform/templates/` — browse the folder._
- **manifests** (1): [terraform-cloud-workspace-automation.hcl](../terraform/manifests/terraform-cloud-workspace-automation.hcl)
- **eventbridge-lambda** (7): [dev.tfvars](../terraform/eventbridge-lambda/environments/dev.tfvars), [main.tf](../terraform/eventbridge-lambda/main.tf), [outputs.tf](../terraform/eventbridge-lambda/modules/eventbridge/outputs.tf)
- _…and 4 under `terraform/eventbridge-lambda/` — browse the folder._

## Terrascan  ·  22 files
- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (4): [2026-07-10-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md), [2026-06-29-terrascan-getting-started-trip-ups.md](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md), [2026-06-19-install-terrascan-tiny-tf.md](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md)
- _…and 1 more under `terrascan/notes/` — browse the folder._
- **docs** (3): [iac-pipeline-integration.md](../terrascan/docs/iac-pipeline-integration.md), [terrascan-scan-configuration-migration-patterns.md](../terrascan/docs/terrascan-scan-configuration-migration-patterns.md), [terrascan-vs-checkov-terraform-iac-scanning.md](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md)
- **scripts** (2): [policy-as-code-workflow.sh](../terrascan/scripts/policy-as-code-workflow.sh), [tried-terrascan-ci-scan.sh](../terrascan/scripts/tried-terrascan-ci-scan.sh)
- **configs** (2): [terrascan-config-template.yaml](../terrascan/configs/terrascan-config-template.yaml), [tried-custom-s3-rule.yaml](../terrascan/configs/tried-custom-s3-rule.yaml)
- **snippets** (2): [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf), [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf)
- **templates** (6): [.gitignore](../terrascan/templates/scanning-pipeline-scaffold/.gitignore), [README.md](../terrascan/templates/scanning-pipeline-scaffold/README.md), [config.yaml](../terrascan/templates/scanning-pipeline-scaffold/config.yaml)
- _…and 3 under `terrascan/templates/` — browse the folder._
- **manifests** (1): [terrascan-gha-ci-multi-iac.yaml](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **notebooks** (1): [rego-vs-yaml-rule-authoring.ipynb](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)

## Tetragon  ·  11 files
- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (2): [2026-08-06-tetragon-observability-tutorial.md](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md)
- **docs** (1): [runtime-security-workflow.md](../tetragon/docs/runtime-security-workflow.md)
- **scripts** (3): [2026-08-05-tetragon-event-collection-pipeline.sh](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh), [build-tetragon-file-access-tracing-policy.sh](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh), [build-tetragon-policy.sh](../tetragon/scripts/build-tetragon-policy.sh)
- **configs** (4): [2026-08-05-minimal-network-tracing-policy.yaml](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml), [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml), [policy-approaches-comparison.yaml](../tetragon/configs/policy-approaches-comparison.yaml)
- _…and 1 under `tetragon/configs/` — browse the folder._

## Tfsec  ·  6 files
- **primer:** [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md)
- **notes** (2): [2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md](../tfsec/notes/2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md), [2026-09-20-first-tfsec-scan.md](../tfsec/notes/2026-09-20-first-tfsec-scan.md)
- **scripts** (1): [2026-10-19-ran-my-first-tfsec-scan.sh](../tfsec/scripts/2026-10-19-ran-my-first-tfsec-scan.sh)
- **configs** (1): [2026-10-19-minimal-tfsec-scan-config.yaml](../tfsec/configs/2026-10-19-minimal-tfsec-scan-config.yaml)
- **snippets** (1): [enforce-s3-bucket-encryption.rego](../tfsec/snippets/enforce-s3-bucket-encryption.rego)

## Trivy  ·  40 files
- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (7): [2026-10-19-trivy-first-image-scan.md](../trivy/notes/2026-10-19-trivy-first-image-scan.md), [2026-10-14-quickstart-trip-ups.md](../trivy/notes/2026-10-14-quickstart-trip-ups.md), [2026-09-05-install-trivy-first-container-scan.md](../trivy/notes/2026-09-05-install-trivy-first-container-scan.md)
- _…and 4 more under `trivy/notes/` — browse the folder._
- **docs** (6): [ci-cd-pipeline-recipes.md](../trivy/docs/ci-cd-pipeline-recipes.md), [ci-pipeline-sarif-output.md](../trivy/docs/ci-pipeline-sarif-output.md), [multi-arch-vulnerability-scanning.md](../trivy/docs/multi-arch-vulnerability-scanning.md)
- _…and 3 under `trivy/docs/` — browse the folder._
- **scripts** (6): [compose-multi-scan.sh](../trivy/scripts/compose-multi-scan.sh), [container-vuln-scan.sh](../trivy/scripts/container-vuln-scan.sh), [custom-trivy-check-conftest.sh](../trivy/scripts/custom-trivy-check-conftest.sh)
- _…and 3 under `trivy/scripts/` — browse the folder._
- **configs** (4): [2026-10-19-minimal-trivy-config.yaml](../trivy/configs/2026-10-19-minimal-trivy-config.yaml), [.trivy.yaml](../trivy/configs/.trivy.yaml), [trivy-ci-gate.yml](../trivy/configs/trivy-ci-gate.yml)
- _…and 1 under `trivy/configs/` — browse the folder._
- **snippets** (1): [scan-docker-image.sh](../trivy/snippets/scan-docker-image.sh)
- **templates** (10): [README.md](../trivy/templates/trivy-k8s-workload-scanning/README.md), [k8s-scan-cronjob.yaml](../trivy/templates/trivy-k8s-workload-scanning/k8s-scan-cronjob.yaml), [k8s-scan-job.yaml](../trivy/templates/trivy-k8s-workload-scanning/k8s-scan-job.yaml)
- _…and 7 under `trivy/templates/` — browse the folder._
- **manifests** (2): [trivy-operator-deployment.yaml](../trivy/manifests/trivy-operator-deployment.yaml), [trivy-sarif-code-scanning.yaml](../trivy/manifests/trivy-sarif-code-scanning.yaml)
- **dockerfiles** (1): [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy-sarif-output-processing.ipynb](../trivy/notebooks/trivy-sarif-output-processing.ipynb), [trivy-scan-mode-comparison.ipynb](../trivy/notebooks/trivy-scan-mode-comparison.ipynb)

## Trufflehog  ·  51 files
- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (3): [2026-07-27-explore-cli.md](../trufflehog/notes/2026-07-27-explore-cli.md), [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md), [2026-05-27-following-trufflehog-quickstart.md](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md)
- **docs** (4): [comparing-scan-modes-git-filesystem-s3.md](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md), [trufflehog-integration-reference-secret-detection.md](../trufflehog/docs/trufflehog-integration-reference-secret-detection.md), [trufflehog-output-formats-json-sarif-csv.md](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md)
- _…and 1 under `trufflehog/docs/` — browse the folder._
- **scripts** (3): [analyze-trufflehog-results.py](../trufflehog/scripts/analyze-trufflehog-results.py), [multi-repo-scan-pipeline.sh](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [pre-commit-scan-pipeline.sh](../trufflehog/scripts/pre-commit-scan-pipeline.sh)
- **configs** (2): [custom-detector-rules.yaml](../trufflehog/configs/custom-detector-rules.yaml), [trufflehog-custom-regex-config.yaml](../trufflehog/configs/trufflehog-custom-regex-config.yaml)
- **snippets** (3): [2026-10-14-first-secret-scan.sh](../trufflehog/snippets/2026-10-14-first-secret-scan.sh), [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh), [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- **templates** (28): [.gitignore](../trufflehog/templates/github-secret-scanning-integration/.gitignore), [Makefile](../trufflehog/templates/github-secret-scanning-integration/Makefile), [README.md](../trufflehog/templates/github-secret-scanning-integration/README.md)
- _…and 25 under `trufflehog/templates/` — browse the folder._
- **manifests** (2): [trufflehog-cicd-pipeline.yaml](../trufflehog/manifests/trufflehog-cicd-pipeline.yaml), [trufflehog-pr-secret-scan-reusable.yaml](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- **dockerfiles** (2): [pipeline-scanner.Dockerfile](../trufflehog/dockerfiles/pipeline-scanner.Dockerfile), [pre-commit-scanner.Dockerfile](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile)
- **notebooks** (3): [analyzing-trufflehog-false-positives.ipynb](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb), [detector-comparison-patterns.ipynb](../trufflehog/notebooks/detector-comparison-patterns.ipynb), [trufflehog-scan-modes-comparison.ipynb](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb)

## Vault  ·  21 files
- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (3): [2026-08-26-install-vault-first-command.md](../vault/notes/2026-08-26-install-vault-first-command.md), [2026-06-15-vault-getting-started-trip-ups.md](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md), [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
- **docs** (3): [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md), [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md), [vault-secrets-engine-selection-guide.md](../vault/docs/vault-secrets-engine-selection-guide.md)
- **scripts** (4): [cloud-iam-dynamic-secrets.sh](../vault/scripts/cloud-iam-dynamic-secrets.sh), [vault-db-dynamic-secrets.sh](../vault/scripts/vault-db-dynamic-secrets.sh), [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh)
- _…and 1 under `vault/scripts/` — browse the folder._
- **configs** (3): [2026-09-04-aws-secrets-engine-policy.hcl](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl), [2026-06-26-dev-test-policies.hcl](../vault/configs/2026-06-26-dev-test-policies.hcl), [multi-environment-access-control.hcl](../vault/configs/multi-environment-access-control.hcl)
- **snippets** (2): [2026-08-30-first-vault-secret.sh](../vault/snippets/2026-08-30-first-vault-secret.sh), [vault-read-write.go](../vault/snippets/vault-read-write.go)
- **manifests** (2): [vault-cluster-deployment.yaml](../vault/manifests/vault-cluster-deployment.yaml), [vault-sidecar-secrets-refresh.yaml](../vault/manifests/vault-sidecar-secrets-refresh.yaml)
- **dockerfiles** (1): [custom-vault-image-with-plugins-tls.Dockerfile](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **notebooks** (2): [static-vs-dynamic-secrets.ipynb](../vault/notebooks/static-vs-dynamic-secrets.ipynb), [vault-secrets-backend-comparison-patterns.ipynb](../vault/notebooks/vault-secrets-backend-comparison-patterns.ipynb)

## Zap  ·  31 files
- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (5): [2026-09-05-install-zap-first-baseline-scan.md](../zap/notes/2026-09-05-install-zap-first-baseline-scan.md), [2026-07-20-install-zap-baseline-scan.md](../zap/notes/2026-07-20-install-zap-baseline-scan.md), [2026-06-13-spider-scan-test-app.md](../zap/notes/2026-06-13-spider-scan-test-app.md)
- _…and 2 more under `zap/notes/` — browse the folder._
- **docs** (5): [passive-vs-active-scanning-zap.md](../zap/docs/passive-vs-active-scanning-zap.md), [zap-automation-plan-structure.md](../zap/docs/zap-automation-plan-structure.md), [zap-integration-patterns.md](../zap/docs/zap-integration-patterns.md)
- _…and 2 under `zap/docs/` — browse the folder._
- **scripts** (3): [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh), [zap-baseline-scan.sh](../zap/scripts/zap-baseline-scan.sh), [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh)
- **configs** (3): [ci-dast-automation-framework-plan.yaml](../zap/configs/ci-dast-automation-framework-plan.yaml), [zap-authenticated-scan-context.yaml](../zap/configs/zap-authenticated-scan-context.yaml), [zap-dast-github-actions-workflow.yaml](../zap/configs/zap-dast-github-actions-workflow.yaml)
- **snippets** (4): [2026-07-16-zap-docker-quickstart-json-export.sh](../zap/snippets/2026-07-16-zap-docker-quickstart-json-export.sh), [authenticated-scan-with-context.sh](../zap/snippets/authenticated-scan-with-context.sh), [my-first-zap-baseline-scan.sh](../zap/snippets/my-first-zap-baseline-scan.sh)
- _…and 1 under `zap/snippets/` — browse the folder._
- **templates** (7): [.gitignore](../zap/templates/zap-dast-integration-scaffold/.gitignore), [Makefile](../zap/templates/zap-dast-integration-scaffold/Makefile), [README.md](../zap/templates/zap-dast-integration-scaffold/README.md)
- _…and 4 under `zap/templates/` — browse the folder._
- **manifests** (1): [zap-cicd-pipeline.yaml](../zap/manifests/zap-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom-zap-automation.Dockerfile](../zap/dockerfiles/custom-zap-automation.Dockerfile)
- **notebooks** (1): [scan-strategy-comparison-patterns.ipynb](../zap/notebooks/scan-strategy-comparison-patterns.ipynb)
