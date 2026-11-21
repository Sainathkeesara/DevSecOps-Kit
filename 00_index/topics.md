# Topics

> A map of what is here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible  ·  34 files

- **notes** (3): [2026-08-17-verify-ansible-cve-2026-33228-paths.md](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md) [2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md) [roles-vs-tasks.md](../ansible/notes/roles-vs-tasks.md)
- **docs** (1): [wired-ansible-infrastructure-workflow.md](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **scripts** (5): [2026-08-04-bootstrap-node.sh](../ansible/scripts/2026-08-04-bootstrap-node.sh) [2026-10-27-first-ad-hoc-command.sh](../ansible/scripts/2026-10-27-first-ad-hoc-command.sh) [bootstrap-target-node.sh](../ansible/scripts/bootstrap-target-node.sh)  _…and 2 more under `ansible/` — browse the folder._
- **configs** (3): [2026-09-15-inventory-groups-host-vars.yaml](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml) [small-ansible-project.yaml](../ansible/configs/small-ansible-project.yaml) [terraform-nginx-integration.yaml](../ansible/configs/terraform-nginx-integration.yaml)
- **snippets** (1): [2026-08-25-minimal-ansible-playbook-package-service.yaml](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- **templates** (21): [.gitignore](../ansible/templates/ansible-roles-staging-production/.gitignore) [README.md](../ansible/templates/ansible-roles-staging-production/README.md) [ansible.cfg](../ansible/templates/ansible-roles-staging-production/ansible.cfg)  _…and 18 more under `ansible/` — browse the folder._

## Argo CD  ·  28 files

- **primer:** [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md)
- **notes** (6): [0000-primer-argocd.md](../argocd/notes/0000-primer-argocd.md) [2026-07-06-install-argocd-first-app.md](../argocd/notes/2026-07-06-install-argocd-first-app.md) [2026-07-25-readme-layout.md](../argocd/notes/2026-07-25-readme-layout.md)  _…and 3 more under `argocd/` — browse the folder._
- **docs** (3): [gitops-workflow-wiring.md](../argocd/docs/gitops-workflow-wiring.md) [helm-kustomize-composition.md](../argocd/docs/helm-kustomize-composition.md) [multi-environment-gitops-delivery.md](../argocd/docs/multi-environment-gitops-delivery.md)
- **scripts** (1): [argocd-api-automation.sh](../argocd/scripts/argocd-api-automation.sh)
- **configs** (2): [2026-08-17-private-repo-credentials-rbac.yaml](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml) [2026-09-20-values-dev.yaml](../argocd/configs/2026-09-20-values-dev.yaml)
- **templates** (11): [README.md](../argocd/templates/app-of-apps-multienv/README.md) [root-application.yaml](../argocd/templates/app-of-apps-multienv/apps/root-application.yaml) [app.yaml](../argocd/templates/app-of-apps-multienv/apps/environments/development/app.yaml)  _…and 8 more under `argocd/` — browse the folder._
- **manifests** (5): [2026-07-06-sample-app-application.yaml](../argocd/manifests/2026-07-06-sample-app-application.yaml) [2026-08-12-gitops-sync-sample-web-app.yaml](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml) [2026-10-28-install.yaml](../argocd/manifests/2026-10-28-install.yaml)  _…and 2 more under `argocd/` — browse the folder._

## assets  ·  14 files

- **notes** (5): [2026-09-19-explore-assets-directory.md](../assets/notes/2026-09-19-explore-assets-directory.md) [2026-09-29-image-optimization-tripped-me-up.md](../assets/notes/2026-09-29-image-optimization-tripped-me-up.md) [2026-09-30-explore-assets-directory.md](../assets/notes/2026-09-30-explore-assets-directory.md)  _…and 2 more under `assets/` — browse the folder._
- **docs** (1): [how-i-wired-assets-into-ci-cd-pipeline.md](../assets/docs/how-i-wired-assets-into-ci-cd-pipeline.md)
- **scripts** (2): [2026-10-01-audit-asset-references.sh](../assets/scripts/2026-10-01-audit-asset-references.sh) [asset-inventory-collector.py](../assets/scripts/asset-inventory-collector.py)
- **configs** (2): [2026-09-29-asset-index.yaml](../assets/configs/2026-09-29-asset-index.yaml) [asset-tracking-config.yaml](../assets/configs/asset-tracking-config.yaml)
- **README.md** (1): [README.md](../assets/README.md)
- **architecture-overview.png** (1): [architecture-overview.png](../assets/architecture-overview.png)
- **cicd-workflow.png** (1): [cicd-workflow.png](../assets/cicd-workflow.png)
- **devsecops-pipeline.png** (1): [devsecops-pipeline.png](../assets/devsecops-pipeline.png)

## Checkov  ·  47 files

- **primer:** [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [0000-primer-checkov.md](../checkov/notes/0000-primer-checkov.md) [2026-05-25-scan-terraform-plan.md](../checkov/notes/2026-05-25-scan-terraform-plan.md) [2026-05-26-cli-vs-sdk-comparison.md](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md)  _…and 1 more under `checkov/` — browse the folder._
- **docs** (6): [checkov-ai-infrastructure-checks.md](../checkov/docs/checkov-ai-infrastructure-checks.md) [checkov-integration-patterns.md](../checkov/docs/checkov-integration-patterns.md) [checkov-v3-migration-guide.md](../checkov/docs/checkov-v3-migration-guide.md)  _…and 3 more under `checkov/` — browse the folder._
- **scripts** (4): [checkov-health-check-and-rollback.sh](../checkov/scripts/checkov-health-check-and-rollback.sh) [deep-terraform-plan-scan.sh](../checkov/scripts/deep-terraform-plan-scan.sh) [scan-terraform-plan.sh](../checkov/scripts/scan-terraform-plan.sh)  _…and 1 more under `checkov/` — browse the folder._
- **configs** (4): [checkov-ci-config.yaml](../checkov/configs/checkov-ci-config.yaml) [checkov-skip-severity-config.yaml](../checkov/configs/checkov-skip-severity-config.yaml) [platform-config.yaml](../checkov/configs/platform-config.yaml)  _…and 1 more under `checkov/` — browse the folder._
- **snippets** (4): [scan-a-terraform-file.py](../checkov/snippets/scan-a-terraform-file.py) [scan-kubernetes.sh](../checkov/snippets/scan-kubernetes.sh) [scan-terraform-dir.py](../checkov/snippets/scan-terraform-dir.py)  _…and 1 more under `checkov/` — browse the folder._
- **templates** (16): [Makefile](../checkov/templates/multi-iac-scan-project/Makefile) [README.md](../checkov/templates/multi-iac-scan-project/README.md) [checkov-config.yaml](../checkov/templates/multi-iac-scan-project/checkov-config.yaml)  _…and 13 more under `checkov/` — browse the folder._
- **manifests** (3): [checkov-gitlab-ci-multi-cloud-drift.yaml](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml) [checkov-sarif-pr-blocking.yaml](../checkov/manifests/checkov-sarif-pr-blocking.yaml) [layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml)
- **notebooks** (4): [compare-builtin-vs-custom-k8s.ipynb](../checkov/notebooks/compare-builtin-vs-custom-k8s.ipynb) [compare-cross-module-scanning-limitations.ipynb](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb) [compare-custom-policy-expressiveness.ipynb](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb)  _…and 1 more under `checkov/` — browse the folder._
- **policies** (2): [no_public_bucket.yaml](../checkov/policies/ckv2-no-public-bucket/no_public_bucket.yaml) [no_public_s3_buckets.yaml](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)

## CodeQL  ·  32 files

- **primer:** [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md)
- **notes** (5): [0000-primer-codeql.md](../codeql/notes/0000-primer-codeql.md) [2026-06-05-install-codeql-first-analysis.md](../codeql/notes/2026-06-05-install-codeql-first-analysis.md) [2026-06-14-codeql-datalog-gotchas.md](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md)  _…and 2 more under `codeql/` — browse the folder._
- **docs** (4): [codeql-database-migration-guide.md](../codeql/docs/codeql-database-migration-guide.md) [codeql-integration-reference.md](../codeql/docs/codeql-integration-reference.md) [query-writing-patterns-dataflow-javascript-typescript.md](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md)  _…and 1 more under `codeql/` — browse the folder._
- **scripts** (2): [codeql-security-issue-detector.py](../codeql/scripts/codeql-security-issue-detector.py) [first-codeql-analysis.sh](../codeql/scripts/first-codeql-analysis.sh)
- **configs** (2): [codeql-analysis-workflow.yaml](../codeql/configs/codeql-analysis-workflow.yaml) [first-codeql-analysis.yml](../codeql/configs/first-codeql-analysis.yml)
- **snippets** (6): [2026-09-24-first-codeql-query.py](../codeql/snippets/2026-09-24-first-codeql-query.py) [2026-10-27-hardcoded-secrets.ql](../codeql/snippets/2026-10-27-hardcoded-secrets.ql) [find-hardcoded-creds.ql](../codeql/snippets/find-hardcoded-creds.ql)  _…and 3 more under `codeql/` — browse the folder._
- **templates** (7): [README.md](../codeql/templates/custom-query-pack-ci-harness/README.md) [qlpack.yml](../codeql/templates/custom-query-pack-ci-harness/qlpack.yml) [known-bad.py](../codeql/templates/custom-query-pack-ci-harness/fixtures/basic/known-bad.py)  _…and 4 more under `codeql/` — browse the folder._
- **manifests** (3): [codeql-cicd-pipeline.yaml](../codeql/manifests/codeql-cicd-pipeline.yaml) [codeql-multi-language-scan.yaml](../codeql/manifests/codeql-multi-language-scan.yaml) [multi-language-codeql-analysis.yaml](../codeql/manifests/multi-language-codeql-analysis.yaml)
- **dockerfiles** (1): [custom-codeql-analysis-image.Dockerfile](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **notebooks** (2): [codeql-query-comparison-patterns.ipynb](../codeql/notebooks/codeql-query-comparison-patterns.ipynb) [compare-cli-vs-actions-scan-modes.ipynb](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb)

## Cosign  ·  20 files

- **primer:** [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md)
- **notes** (5): [0000-primer-cosign.md](../cosign/notes/0000-primer-cosign.md) [2026-06-13-install-cosign-sign-first-image.md](../cosign/notes/2026-06-13-install-cosign-sign-first-image.md) [2026-06-14-install-cosign-generate-first-keypair.md](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md)  _…and 2 more under `cosign/` — browse the folder._
- **docs** (4): [container-signing-pipeline.md](../cosign/docs/container-signing-pipeline.md) [cosign-verification-patterns.md](../cosign/docs/cosign-verification-patterns.md) [key-rotation-and-migration-patterns.md](../cosign/docs/key-rotation-and-migration-patterns.md)  _…and 1 more under `cosign/` — browse the folder._
- **scripts** (3): [cosign-key-management-workflow.sh](../cosign/scripts/cosign-key-management-workflow.sh) [minimal-sign-verify.sh](../cosign/scripts/minimal-sign-verify.sh) [verify-signed-image.sh](../cosign/scripts/verify-signed-image.sh)
- **configs** (2): [cosign-signature-configuration.yaml](../cosign/configs/cosign-signature-configuration.yaml) [keyless-signing-github-actions.yaml](../cosign/configs/keyless-signing-github-actions.yaml)
- **snippets** (1): [first-cosign-sign-verify-image.sh](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (2): [2026-07-10-keyless-oidc-ci.yaml](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml) [signed-container-build-oidc.yaml](../cosign/manifests/signed-container-build-oidc.yaml)
- **dockerfiles** (2): [custom-cosign-image.Dockerfile](../cosign/dockerfiles/custom-cosign-image.Dockerfile) [entrypoint.sh](../cosign/dockerfiles/entrypoint.sh)
- **notebooks** (1): [key-based-vs-keyless-signing.ipynb](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## DefectDojo  ·  19 files

- **primer:** [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (4): [0000-primer-defectdojo.md](../defectdojo/notes/0000-primer-defectdojo.md) [2026-08-04-explore-defectdojo-ui.md](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md) [2026-09-21-quickstart-tripups.md](../defectdojo/notes/2026-09-21-quickstart-tripups.md)  _…and 1 more under `defectdojo/` — browse the folder._
- **docs** (2): [defectdojo-scan-tool-ingestion-end-to-end.md](../defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md) [how-i-wired-defectdojo-into-my-triage-workflow.md](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md)
- **scripts** (3): [2026-09-20-defectdojo-tutorial-check.sh](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh) [product-engagement-setup.py](../defectdojo/scripts/product-engagement-setup.py) [product-scan-import.py](../defectdojo/scripts/product-scan-import.py)
- **configs** (2): [2026-09-21-vulnerability-scanner-setup.yaml](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml) [api-vs-ui-ingestion.yaml](../defectdojo/configs/api-vs-ui-ingestion.yaml)
- **snippets** (2): [2026-10-19-minimal-product-setup-api.py](../defectdojo/snippets/2026-10-19-minimal-product-setup-api.py) [install-defectdojo-first-scan-report.sh](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)
- **templates** (6): [.env.example](../defectdojo/templates/defectdojo-scan-ingestion-starter/.env.example) [README.md](../defectdojo/templates/defectdojo-scan-ingestion-starter/README.md) [docker-compose.yaml](../defectdojo/templates/defectdojo-scan-ingestion-starter/docker-compose.yaml)  _…and 3 more under `defectdojo/` — browse the folder._

## Dependabot  ·  19 files

- **primer:** [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (7): [0000-primer-dependabot.md](../dependabot/notes/0000-primer-dependabot.md) [2026-06-15-dependabot-first-repo-bump-pr.md](../dependabot/notes/2026-06-15-dependabot-first-repo-bump-pr.md) [2026-06-22-first-time-dependabot-setup.md](../dependabot/notes/2026-06-22-first-time-dependabot-setup.md)  _…and 4 more under `dependabot/` — browse the folder._
- **docs** (4): [dependabot-security-alert-migration-patterns.md](../dependabot/docs/dependabot-security-alert-migration-patterns.md) [dependabot-security-update-auto-merge.md](../dependabot/docs/dependabot-security-update-auto-merge.md) [dependabot-version-control-workflow-integration.md](../dependabot/docs/dependabot-version-control-workflow-integration.md)  _…and 1 more under `dependabot/` — browse the folder._
- **scripts** (2): [2026-08-04-dependabot-alert-triage.py](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py) [dependabot-alert-aggregation.py](../dependabot/scripts/dependabot-alert-aggregation.py)
- **configs** (5): [2026-07-10-npm-version-strategy.yaml](../dependabot/configs/2026-07-10-npm-version-strategy.yaml) [2026-07-18-python-project-version-update.yaml](../dependabot/configs/2026-07-18-python-project-version-update.yaml) [dependabot-configuration-template.yaml](../dependabot/configs/dependabot-configuration-template.yaml)  _…and 2 more under `dependabot/` — browse the folder._
- **notebooks** (1): [auto-merge-vs-manual-review.ipynb](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## Docker  ·  19 files

- **primer:** [0000-primer-docker.md](../docker/notes/0000-primer-docker.md)
- **notes** (2): [0000-primer-docker.md](../docker/notes/0000-primer-docker.md) [2026-07-12-explore-docker-cli.md](../docker/notes/2026-07-12-explore-docker-cli.md)
- **docs** (2): [cicd-end-to-end.md](../docker/docs/cicd-end-to-end.md) [dockerfile-optimization-patterns.md](../docker/docs/dockerfile-optimization-patterns.md)
- **scripts** (3): [2026-07-18-custom-network-volume-mounts.sh](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh) [build-multi-service-compose-app.sh](../docker/scripts/build-multi-service-compose-app.sh) [reusable-build.sh](../docker/scripts/reusable-build.sh)
- **configs** (1): [docker-compose-dev-environment.yaml](../docker/configs/docker-compose-dev-environment.yaml)
- **templates** (7): [.env.example](../docker/templates/multi-service-setup/.env.example) [README.md](../docker/templates/multi-service-setup/README.md) [compose.yaml](../docker/templates/multi-service-setup/compose.yaml)  _…and 4 more under `docker/` — browse the folder._
- **manifests** (1): [docker-compose-production.yaml](../docker/manifests/docker-compose-production.yaml)
- **dockerfiles** (3): [2026-07-10-first-custom-image.Dockerfile](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile) [2026-07-12-first-custom-docker-image.Dockerfile](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile) [small-app.Dockerfile](../docker/dockerfiles/small-app.Dockerfile)

## docs  ·  221 files

- **notes** (4): [2026-08-14-verify-trivy-paths.md](../docs/notes/2026-08-14-verify-trivy-paths.md) [2026-08-17-spurious-placeholder-cleanup.md](../docs/notes/2026-08-17-spurious-placeholder-cleanup.md) [2026-08-19-workflow-stubs-review.md](../docs/notes/2026-08-19-workflow-stubs-review.md)  _…and 1 more under `docs/` — browse the folder._
- **concepts** (63): [git-001-version-control-fundamentals.md](../docs/concepts/git-001-version-control-fundamentals.md) [git-002-basic-commands-setup.md](../docs/concepts/git-002-basic-commands-setup.md) [git-003-workflow.md](../docs/concepts/git-003-workflow.md)  _…and 60 more under `docs/` — browse the folder._
- **how-to** (127): [ansible-cve-2026-33228-flatted.md](../docs/how-to/ansible-cve-2026-33228-flatted.md) [ansible-lightspeed-cve-2026-0598.md](../docs/how-to/ansible-lightspeed-cve-2026-0598.md) [ansible-playbook-best-practices.md](../docs/how-to/ansible-playbook-best-practices.md)  _…and 124 more under `docs/` — browse the folder._
- **reference** (9): [git-advanced-commands.md](../docs/reference/git-advanced-commands.md) [git-commands.md](../docs/reference/git-commands.md) [jenkins-agent-connection-tuning.md](../docs/reference/jenkins-agent-connection-tuning.md)  _…and 6 more under `docs/` — browse the folder._
- **runbooks** (2): [cve-2026-33228-ansible-flatted.md](../docs/runbooks/cve-2026-33228-ansible-flatted.md) [linux-system-administration.md](../docs/runbooks/linux-system-administration.md)
- **security** (6): [git-security-access-control-authentication.md](../docs/security/git-security-access-control-authentication.md) [CVE-2026-33228.md](../docs/security/ansible/CVE-2026-33228.md) [AUTHZ-PLUGIN-HARDENING.md](../docs/security/docker/AUTHZ-PLUGIN-HARDENING.md)  _…and 3 more under `docs/` — browse the folder._
- **setup-guides** (4): [eks-cluster-setup.md](../docs/setup-guides/eks-cluster-setup.md) [git-credential-helper-ci-cd.md](../docs/setup-guides/git-credential-helper-ci-cd.md) [git-github-actions-runner.md](../docs/setup-guides/git-github-actions-runner.md)  _…and 1 more under `docs/` — browse the folder._
- **troubleshooting** (6): [jenkins-troubleshooting.md](../docs/troubleshooting/jenkins-troubleshooting.md) [k8s-cluster-autoscaler-cve-2026-33186.md](../docs/troubleshooting/k8s-cluster-autoscaler-cve-2026-33186.md) [k8s-crashloopbackoff.md](../docs/troubleshooting/k8s-crashloopbackoff.md)  _…and 3 more under `docs/` — browse the folder._

## Environments  ·  23 files

- **primer:** [0000-primer-environments.md](../environments/notes/0000-primer-environments.md)
- **notes** (5): [0000-primer-environments.md](../environments/notes/0000-primer-environments.md) [2026-09-19-first-environment-comparison.md](../environments/notes/2026-09-19-first-environment-comparison.md) [2026-09-29-explore-environments-directory.md](../environments/notes/2026-09-29-explore-environments-directory.md)  _…and 2 more under `environments/` — browse the folder._
- **docs** (1): [managing-environments.md](../environments/docs/managing-environments.md)
- **scripts** (2): [2026-10-01-validate-deploy-config.sh](../environments/scripts/2026-10-01-validate-deploy-config.sh) [promote-environment.sh](../environments/scripts/promote-environment.sh)
- **configs** (2): [2026-09-19-first-variable-set.yaml](../environments/configs/2026-09-19-first-variable-set.yaml) [2026-09-30-minimal-environments-config.yaml](../environments/configs/2026-09-30-minimal-environments-config.yaml)
- **manifests** (1): [kubernetes-namespaces.yaml](../environments/manifests/kubernetes-namespaces.yaml)
- **dev** (4): [main.tf](../environments/dev/main.tf) [outputs.tf](../environments/dev/outputs.tf) [terraform.tfvars](../environments/dev/terraform.tfvars)  _…and 1 more under `environments/` — browse the folder._
- **prod** (4): [main.tf](../environments/prod/main.tf) [outputs.tf](../environments/prod/outputs.tf) [terraform.tfvars](../environments/prod/terraform.tfvars)  _…and 1 more under `environments/` — browse the folder._
- **staging** (4): [main.tf](../environments/staging/main.tf) [outputs.tf](../environments/staging/outputs.tf) [terraform.tfvars](../environments/staging/terraform.tfvars)  _…and 1 more under `environments/` — browse the folder._

## Falco  ·  25 files

- **primer:** [0000-primer-falco.md](../falco/notes/0000-primer-falco.md)
- **notes** (6): [0000-primer-falco.md](../falco/notes/0000-primer-falco.md) [2026-06-10-install-falco-first-detection.md](../falco/notes/2026-06-10-install-falco-first-detection.md) [2026-06-15-falco-rules-macros-lists.md](../falco/notes/2026-06-15-falco-rules-macros-lists.md)  _…and 3 more under `falco/` — browse the folder._
- **docs** (4): [rule-optimization-priority-filtering.md](../falco/docs/rule-optimization-priority-filtering.md) [runtime-security-monitoring-integration.md](../falco/docs/runtime-security-monitoring-integration.md) [syscall-vs-tracepoint-rules.md](../falco/docs/syscall-vs-tracepoint-rules.md)  _…and 1 more under `falco/` — browse the folder._
- **scripts** (3): [deploy-falco-ruleset.sh](../falco/scripts/deploy-falco-ruleset.sh) [tried-falco-k8s-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-alert-forwarding.sh) [tried-falco-k8s-deploy-alert-forwarding.sh](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh)
- **configs** (4): [2026-06-10-first-custom-rule-detect-shell-in-container.yaml](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml) [2026-10-03-minimal-runtime-config.yaml](../falco/configs/2026-10-03-minimal-runtime-config.yaml) [container-drift-detection.yaml](../falco/configs/container-drift-detection.yaml)  _…and 1 more under `falco/` — browse the folder._
- **snippets** (1): [tried-file-access-detector.go](../falco/snippets/tried-file-access-detector.go)
- **templates** (4): [README.md](../falco/templates/falco-custom-rules-library/README.md) [override-example.yaml](../falco/templates/falco-custom-rules-library/examples/override-example.yaml) [custom-rules.yaml](../falco/templates/falco-custom-rules-library/rules/custom-rules.yaml)  _…and 1 more under `falco/` — browse the folder._
- **manifests** (1): [falco-k8s-admission-control.yaml](../falco/manifests/falco-k8s-admission-control.yaml)
- **notebooks** (2): [falco-event-output-formats.ipynb](../falco/notebooks/falco-event-output-formats.ipynb) [rule-engine-vs-ebpf-probes.ipynb](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb)

## Git  ·  10 files

- **primer:** [0000-primer-git.md](../git/notes/0000-primer-git.md)
- **notes** (3): [0000-primer-git.md](../git/notes/0000-primer-git.md) [2026-07-04-git-branching-merge-confusions.md](../git/notes/2026-07-04-git-branching-merge-confusions.md) [2026-07-12-install-git-identity-first-commit.md](../git/notes/2026-07-12-install-git-identity-first-commit.md)
- **docs** (1): [how-i-wired-git-into-my-version-control-workflow.md](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **scripts** (4): [2026-07-10-local-ci-simulation.sh](../git/scripts/2026-07-10-local-ci-simulation.sh) [2026-07-12-bump-version.sh](../git/scripts/2026-07-12-bump-version.sh) [2026-08-24-first-repo-stage-log.sh](../git/scripts/2026-08-24-first-repo-stage-log.sh)  _…and 1 more under `git/` — browse the folder._
- **configs** (1): [config-strategy-layered-vs-conditional.yaml](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **snippets** (1): [2026-07-04-git-rebase-vs-merge-conflict-patterns.sh](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## GitGuardian  ·  28 files

- **primer:** [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (6): [0000-primer-gitguardian.md](../gitguardian/notes/0000-primer-gitguardian.md) [2026-06-07-first-ggshield-scan.md](../gitguardian/notes/2026-06-07-first-ggshield-scan.md) [2026-06-13-ggshield-quickstart-trip-ups.md](../gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md)  _…and 3 more under `gitguardian/` — browse the folder._
- **docs** (4): [cicd-secret-scanning-integration.md](../gitguardian/docs/cicd-secret-scanning-integration.md) [gitguardian-incident-response-workflow.md](../gitguardian/docs/gitguardian-incident-response-workflow.md) [gitguardian-secret-scanning-migration-patterns.md](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md)  _…and 1 more under `gitguardian/` — browse the folder._
- **scripts** (4): [2026-10-20-first-ggshield-scan.sh](../gitguardian/scripts/2026-10-20-first-ggshield-scan.sh) [gg-incident-response-pipeline.sh](../gitguardian/scripts/gg-incident-response-pipeline.sh) [gitguardian-api-integration.py](../gitguardian/scripts/gitguardian-api-integration.py)  _…and 1 more under `gitguardian/` — browse the folder._
- **configs** (3): [.ggshield.yaml](../gitguardian/configs/.ggshield.yaml) [monorepo-allowlists.yaml](../gitguardian/configs/monorepo-allowlists.yaml) [policy-configuration.yaml](../gitguardian/configs/policy-configuration.yaml)
- **snippets** (2): [custom-policy-engine-ggshield.sh](../gitguardian/snippets/custom-policy-engine-ggshield.sh) [my-first-ggshield-commands.sh](../gitguardian/snippets/my-first-ggshield-commands.sh)
- **templates** (8): [.gitignore](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.gitignore) [Makefile](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/Makefile) [README.md](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/README.md)  _…and 5 more under `gitguardian/` — browse the folder._
- **notebooks** (1): [choosing-between-on-premise-and-cloud-modes.ipynb](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb)

## GitHub Actions  ·  22 files

- **primer:** [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (7): [0000-primer-github-actions.md](../github-actions/notes/0000-primer-github-actions.md) [2026-07-14-explore-github-actions.md](../github-actions/notes/2026-07-14-explore-github-actions.md) [2026-08-04-explore-github-actions.md](../github-actions/notes/2026-08-04-explore-github-actions.md)  _…and 4 more under `github-actions/` — browse the folder._
- **docs** (1): [how-i-wired-github-actions-into-my-ci-workflow.md](../github-actions/docs/how-i-wired-github-actions-into-my-ci-workflow.md)
- **scripts** (1): [triage-latest-failed-run.sh](../github-actions/scripts/triage-latest-failed-run.sh)
- **configs** (8): [2026-07-14-first-github-actions-workflow.yaml](../github-actions/configs/2026-07-14-first-github-actions-workflow.yaml) [2026-08-04-first-workflow.yaml](../github-actions/configs/2026-08-04-first-workflow.yaml) [2026-09-10-minimal-ci-workflow.yaml](../github-actions/configs/2026-09-10-minimal-ci-workflow.yaml)  _…and 5 more under `github-actions/` — browse the folder._
- **snippets** (3): [2026-08-26-composite-action-input-reuse.yaml](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml) [2026-08-26-first-workflow.yaml](../github-actions/snippets/2026-08-26-first-workflow.yaml) [2026-10-14-trigger-first-workflow-gh.sh](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh)
- **manifests** (2): [2026-08-04-pr-validation.yml](../github-actions/manifests/2026-08-04-pr-validation.yml) [2026-08-04-what-is-github-actions.yaml](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml)

## Gitleaks  ·  9 files

- **primer:** [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md)
- **notes** (3): [0000-primer-gitleaks.md](../gitleaks/notes/0000-primer-gitleaks.md) [2026-09-19-first-secret-scan.md](../gitleaks/notes/2026-09-19-first-secret-scan.md) [2026-10-07-quickstart-trip-ups.md](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md)
- **docs** (1): [integrating-gitleaks-pre-commit-ci.md](../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md)
- **scripts** (3): [2026-09-26-run-first-gitleaks-scan.sh](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh) [2026-10-13-auditing-git-secrets.sh](../gitleaks/scripts/2026-10-13-auditing-git-secrets.sh) [build-custom-gitleaks-ruleset.sh](../gitleaks/scripts/build-custom-gitleaks-ruleset.sh)
- **configs** (2): [2026-10-07-detection-rules.yaml](../gitleaks/configs/2026-10-07-detection-rules.yaml) [gitleaks-config.toml](../gitleaks/configs/gitleaks-config.toml)

## Grafana  ·  11 files

- **primer:** [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md)
- **notes** (4): [0000-primer-grafana.md](../grafana/notes/0000-primer-grafana.md) [2026-09-19-first-dashboard-browser.md](../grafana/notes/2026-09-19-first-dashboard-browser.md) [2026-09-26-explore-grafana-dashboard-ui.md](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md)  _…and 1 more under `grafana/` — browse the folder._
- **docs** (1): [grafana-alerting-routing-templates.md](../grafana/docs/grafana-alerting-routing-templates.md)
- **scripts** (1): [build-dashboard-provisioning.py](../grafana/scripts/build-dashboard-provisioning.py)
- **configs** (3): [2026-09-19-first-datasource.yaml](../grafana/configs/2026-09-19-first-datasource.yaml) [2026-10-14-dashboard-provisioning.yaml](../grafana/configs/2026-10-14-dashboard-provisioning.yaml) [security-slo-dashboard.json](../grafana/configs/security-slo-dashboard.json)
- **snippets** (1): [2026-10-14-first-grafana-datasource-query.py](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- **manifests** (1): [grafana-datasource-dashboard.yaml](../grafana/manifests/grafana-datasource-dashboard.yaml)

## Grype  ·  27 files

- **primer:** [0000-primer-grype.md](../grype/notes/0000-primer-grype.md)
- **notes** (5): [0000-primer-grype.md](../grype/notes/0000-primer-grype.md) [2026-05-31-install-grype.md](../grype/notes/2026-05-31-install-grype.md) [2026-06-04-grype-quickstart-trip-ups.md](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md)  _…and 2 more under `grype/` — browse the folder._
- **docs** (3): [grype-syft-integration-guide.md](../grype/docs/grype-syft-integration-guide.md) [grype-vulnerability-reporting-migration-patterns.md](../grype/docs/grype-vulnerability-reporting-migration-patterns.md) [vulnerability-management-pipeline-integration.md](../grype/docs/vulnerability-management-pipeline-integration.md)
- **scripts** (9): [ci-ready-grype-scan.sh](../grype/scripts/ci-ready-grype-scan.sh) [grype-end-to-end-scan-pipeline.sh](../grype/scripts/grype-end-to-end-scan-pipeline.sh) [grype-pipeline-ci-scan.sh](../grype/scripts/grype-pipeline-ci-scan.sh)  _…and 6 more under `grype/` — browse the folder._
- **configs** (2): [grype-ci-github-actions.yaml](../grype/configs/grype-ci-github-actions.yaml) [grype-filtering-configuration-template.yaml](../grype/configs/grype-filtering-configuration-template.yaml)
- **snippets** (3): [2026-10-27-grype-filter-severity-formats.sh](../grype/snippets/2026-10-27-grype-filter-severity-formats.sh) [minimal-grype-scan.go](../grype/snippets/minimal-grype-scan.go) [my-first-grype-commands.sh](../grype/snippets/my-first-grype-commands.sh)
- **manifests** (2): [grype-reusable-sarif-workflow.yaml](../grype/manifests/grype-reusable-sarif-workflow.yaml) [grype-sarif-reusable-workflow.yaml](../grype/manifests/grype-sarif-reusable-workflow.yaml)
- **dockerfiles** (1): [multi-stage-grype-scan.Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (2): [grype-db-vs-registry-sources.ipynb](../grype/notebooks/grype-db-vs-registry-sources.ipynb) [grype-sbom-output-explorer.ipynb](../grype/notebooks/grype-sbom-output-explorer.ipynb)

## Helm  ·  13 files

- **primer:** [0000-primer-helm.md](../helm/notes/0000-primer-helm.md)
- **notes** (4): [0000-primer-helm.md](../helm/notes/0000-primer-helm.md) [2026-07-19-explore-helm-charts-releases-values-repos.md](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md) [2026-09-21-quickstart-tripped-me-up.md](../helm/notes/2026-09-21-quickstart-tripped-me-up.md)  _…and 1 more under `helm/` — browse the folder._
- **docs** (1): [how-i-wired-helm-into-my-release-workflow.md](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- **scripts** (1): [build-and-deploy-chart.sh](../helm/scripts/build-and-deploy-chart.sh)
- **configs** (1): [values-file-vs-set-flags.yaml](../helm/configs/values-file-vs-set-flags.yaml)
- **manifests** (2): [2026-07-15-first-chart-values.yaml](../helm/manifests/2026-07-15-first-chart-values.yaml) [2026-09-21-minimal-service-chart.yaml](../helm/manifests/2026-09-21-minimal-service-chart.yaml)
- **charts** (4): [Chart.yaml](../helm/charts/sample-app/Chart.yaml) [values-dev.yaml](../helm/charts/sample-app/values-dev.yaml) [values-prod.yaml](../helm/charts/sample-app/values-prod.yaml)  _…and 1 more under `helm/` — browse the folder._

## Kubernetes  ·  20 files

- **primer:** [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (4): [0000-primer-kubernetes.md](../kubernetes/notes/0000-primer-kubernetes.md) [2026-07-15-explore-kubernetes.md](../kubernetes/notes/2026-07-15-explore-kubernetes.md) [2026-10-14-cluster-resources.md](../kubernetes/notes/2026-10-14-cluster-resources.md)  _…and 1 more under `kubernetes/` — browse the folder._
- **docs** (2): [cluster-workflow-wiring.md](../kubernetes/docs/cluster-workflow-wiring.md) [rbac-design-patterns-for-multi-tenant-clusters.md](../kubernetes/docs/rbac-design-patterns-for-multi-tenant-clusters.md)
- **scripts** (2): [2026-10-20-quickstart-repro.sh](../kubernetes/scripts/2026-10-20-quickstart-repro.sh) [cluster-health-check-and-conformance-validation.sh](../kubernetes/scripts/cluster-health-check-and-conformance-validation.sh)
- **configs** (3): [2026-10-14-minimal-namespace.yaml](../kubernetes/configs/2026-10-14-minimal-namespace.yaml) [2026-10-20-minimal-deployment.yaml](../kubernetes/configs/2026-10-20-minimal-deployment.yaml) [namespace-strategy-environment-vs-team.yaml](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml)
- **templates** (5): [README.md](../kubernetes/templates/cluster-bootstrap/README.md) [cert-manager-bootstrap.yaml](../kubernetes/templates/cluster-bootstrap/cert-manager/cert-manager-bootstrap.yaml) [calico-installation.yaml](../kubernetes/templates/cluster-bootstrap/cni/calico-installation.yaml)  _…and 2 more under `kubernetes/` — browse the folder._
- **manifests** (4): [2026-07-15-first-pod-service.yaml](../kubernetes/manifests/2026-07-15-first-pod-service.yaml) [2026-09-10-first-pod.yaml](../kubernetes/manifests/2026-09-10-first-pod.yaml) [kustomize-overlays.yaml](../kubernetes/manifests/kustomize-overlays.yaml)  _…and 1 more under `kubernetes/` — browse the folder._

## Kustomize  ·  17 files

- **primer:** [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (3): [0000-primer-kustomize.md](../kustomize/notes/0000-primer-kustomize.md) [2026-07-08-install-kustomize-first-overlay.md](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md) [2026-09-21-kustomize-quickstart-tripped-me-up.md](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md)
- **docs** (1): [how-i-wired-kustomize-into-my-manifest-workflow.md](../kustomize/docs/how-i-wired-kustomize-into-my-manifest-workflow.md)
- **scripts** (2): [2026-10-20-kustomize-tutorial.sh](../kustomize/scripts/2026-10-20-kustomize-tutorial.sh) [bases-vs-remote-resources.sh](../kustomize/scripts/bases-vs-remote-resources.sh)
- **configs** (10): [2026-07-08-minimal-kustomization.yaml](../kustomize/configs/2026-07-08-minimal-kustomization.yaml) [2026-09-22-minimal-kustomization-with-overlay.yaml](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml) [small-overlay.yaml](../kustomize/configs/small-overlay.yaml)  _…and 7 more under `kustomize/` — browse the folder._
- **manifests** (1): [2026-09-21-kustomize-tutorial.yaml](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## Lab  ·  17 files

- **primer:** [0000-primer-lab.md](../lab/notes/0000-primer-lab.md)
- **notes** (3): [0000-primer-lab.md](../lab/notes/0000-primer-lab.md) [2026-09-20-setting-up-the-lab-directory.md](../lab/notes/2026-09-20-setting-up-the-lab-directory.md) [2026-10-25-lab-quickstart-trips.md](../lab/notes/2026-10-25-lab-quickstart-trips.md)
- **configs** (2): [2026-09-19-first-lab-env.yaml](../lab/configs/2026-09-19-first-lab-env.yaml) [2026-10-25-multi-node-demo.yaml](../lab/configs/2026-10-25-multi-node-demo.yaml)
- **snippets** (2): [2026-10-14-first-lab-command.sh](../lab/snippets/2026-10-14-first-lab-command.sh) [2026-10-25-minimal-lab-env.py](../lab/snippets/2026-10-25-minimal-lab-env.py)
- **mini-projects** (10): [README.md](../lab/mini-projects/postgresql-database-server/README.md) [README.md](../lab/mini-projects/samba-enterprise-file-sharing/README.md) [README.md](../lab/mini-projects/terraform-project/README.md)  _…and 7 more under `lab/` — browse the folder._

## learn  ·  35 files

- **01-foundations** (6): [02-shell-scripting.md](../learn/01-foundations/02-shell-scripting.md) [04-git-branch-merge-rebase.md](../learn/01-foundations/04-git-branch-merge-rebase.md) [05-http-and-tls.md](../learn/01-foundations/05-http-and-tls.md)  _…and 3 more under `learn/` — browse the folder._
- **02-build-and-ship** (2): [03-docker-sample-app-image.md](../learn/02-build-and-ship/03-docker-sample-app-image.md) [06-gha-sample-app-ci.md](../learn/02-build-and-ship/06-gha-sample-app-ci.md)
- **03-shift-left** (11): [03-gitleaks-in-ci.md](../learn/03-shift-left/03-gitleaks-in-ci.md) [04-trufflehog-history.md](../learn/03-shift-left/04-trufflehog-history.md) [05-semgrep-sast.md](../learn/03-shift-left/05-semgrep-sast.md)  _…and 8 more under `learn/` — browse the folder._
- **04-iac** (5): [03-terraform-plan-apply-destroy.md](../learn/04-iac/03-terraform-plan-apply-destroy.md) [04-environments-promotion.md](../learn/04-iac/04-environments-promotion.md) [05-checkov-iac-scan.md](../learn/04-iac/05-checkov-iac-scan.md)  _…and 2 more under `learn/` — browse the folder._
- **05-kubernetes-gitops** (4): [02-k8s-deploy-sample-app.md](../learn/05-kubernetes-gitops/02-k8s-deploy-sample-app.md) [03-kustomize-overlays.md](../learn/05-kubernetes-gitops/03-kustomize-overlays.md) [05-helm-chart-sample-app.md](../learn/05-kubernetes-gitops/05-helm-chart-sample-app.md)  _…and 1 more under `learn/` — browse the folder._
- **06-policy-secrets-runtime** (5): [01-rego-basics.md](../learn/06-policy-secrets-runtime/01-rego-basics.md) [02-gatekeeper-admission.md](../learn/06-policy-secrets-runtime/02-gatekeeper-admission.md) [04-vault-k8s-injection.md](../learn/06-policy-secrets-runtime/04-vault-k8s-injection.md)  _…and 2 more under `learn/` — browse the folder._
- **07-observe-respond** (2): [03-prometheus-security-alerts.md](../learn/07-observe-respond/03-prometheus-security-alerts.md) [04-grafana-security-dashboard.md](../learn/07-observe-respond/04-grafana-security-dashboard.md)

## Linux  ·  7 files

- **notes** (3): [2026-07-21-install-linux-vm-terminal-first-commands.md](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md) [2026-08-06-linux-shell-scripting-tutorial-confusions.md](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md) [2026-10-02-explore-linux-environment.md](../linux/notes/2026-10-02-explore-linux-environment.md)
- **docs** (1): [system-administration-runbook.md](../linux/docs/system-administration-runbook.md)
- **scripts** (2): [find-large-logs.sh](../linux/scripts/find-large-logs.sh) [health-check-and-rollback.sh](../linux/scripts/health-check-and-rollback.sh)
- **configs** (1): [2026-08-06-cron-job-configuration.ini](../linux/configs/2026-08-06-cron-job-configuration.ini)

## Nuclei  ·  5 files

- **primer:** [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md)
- **notes** (3): [0000-primer-nuclei.md](../nuclei/notes/0000-primer-nuclei.md) [2026-09-20-first-template-scan-attempt.md](../nuclei/notes/2026-09-20-first-template-scan-attempt.md) [2026-10-15-nuclei-quickstart-trip-ups.md](../nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md)
- **scripts** (1): [2026-10-15-first-nuclei-scan.sh](../nuclei/scripts/2026-10-15-first-nuclei-scan.sh)
- **configs** (1): [2026-10-15-minimal-scan-template.yaml](../nuclei/configs/2026-10-15-minimal-scan-template.yaml)

## OPA / Gatekeeper  ·  35 files

- **primer:** [0000-primer-opa.md](../opa/notes/0000-primer-opa.md)
- **notes** (5): [0000-primer-opa.md](../opa/notes/0000-primer-opa.md) [2026-06-06-install-opa-repl.md](../opa/notes/2026-06-06-install-opa-repl.md) [2026-06-15-opa-getting-started-trip-ups.md](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)  _…and 2 more under `opa/` — browse the folder._
- **docs** (4): [constraint-template-design-patterns.md](../opa/docs/constraint-template-design-patterns.md) [integrating-opa-with-policy-as-code-governance.md](../opa/docs/integrating-opa-with-policy-as-code-governance.md) [opa-policy-version-migration-patterns.md](../opa/docs/opa-policy-version-migration-patterns.md)  _…and 1 more under `opa/` — browse the folder._
- **scripts** (2): [export-audit-results.sh](../opa/scripts/export-audit-results.sh) [how-i-test-policies-locally.sh](../opa/scripts/how-i-test-policies-locally.sh)
- **configs** (2): [opa-policy-configuration-template.yaml](../opa/configs/opa-policy-configuration-template.yaml) [tried-a-gatekeeper-constraint.yaml](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- **snippets** (8): [2026-10-14-first-rego-policy.py](../opa/snippets/2026-10-14-first-rego-policy.py) [contradictory-deny.rego](../opa/snippets/contradictory-deny.rego) [deny-privileged-containers.rego](../opa/snippets/deny-privileged-containers.rego)  _…and 5 more under `opa/` — browse the folder._
- **templates** (8): [README.md](../opa/templates/gatekeeper-policy-library-scaffold/README.md) [k8sallowedregistries.yaml](../opa/templates/gatekeeper-policy-library-scaffold/constraint-templates/k8sallowedregistries.yaml) [k8ssecuritybaseline.yaml](../opa/templates/gatekeeper-policy-library-scaffold/constraint-templates/k8ssecuritybaseline.yaml)  _…and 5 more under `opa/` — browse the folder._
- **manifests** (5): [README.md](../opa/manifests/README.md) [constraint-templates.yaml](../opa/manifests/constraint-templates.yaml) [constraints.yaml](../opa/manifests/constraints.yaml)  _…and 2 more under `opa/` — browse the folder._
- **notebooks** (1): [rego-vs-builtin-policies.ipynb](../opa/notebooks/rego-vs-builtin-policies.ipynb)

## OpenTofu  ·  10 files

- **primer:** [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (4): [0000-primer-opentofu.md](../opentofu/notes/0000-primer-opentofu.md) [2026-07-20-explore-open-tofu.md](../opentofu/notes/2026-07-20-explore-open-tofu.md) [2026-09-21-follow-open-tofu-quickstart.md](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md)  _…and 1 more under `opentofu/` — browse the folder._
- **docs** (2): [how-i-wired-opentofu-into-my-iac-workflow.md](../opentofu/docs/how-i-wired-opentofu-into-my-iac-workflow.md) [open-tofu-vs-terraform-migration-decision-matrix.md](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md)
- **scripts** (1): [module-registry-publisher.sh](../opentofu/scripts/module-registry-publisher.sh)
- **configs** (3): [2026-07-20-first-open-tofu-config.hcl](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl) [2026-09-10-minimal-opentofu-config.hcl](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl) [2026-09-21-minimal-opentofu-config-with-vars.hcl](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl)

## Prometheus  ·  7 files

- **primer:** [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (5): [0000-primer-prometheus.md](../prometheus/notes/0000-primer-prometheus.md) [2026-09-20-checking-the-metrics-interface.md](../prometheus/notes/2026-09-20-checking-the-metrics-interface.md) [2026-10-14-first-query-log.md](../prometheus/notes/2026-10-14-first-query-log.md)  _…and 2 more under `prometheus/` — browse the folder._
- **scripts** (1): [2026-10-25-query-api-python.py](../prometheus/scripts/2026-10-25-query-api-python.py)
- **snippets** (1): [2026-10-25-minimal-scrape-config.yaml](../prometheus/snippets/2026-10-25-minimal-scrape-config.yaml)

## Scripts  ·  196 files

- **notes** (4): [2026-08-24-reorganize-scripts.md](../scripts/notes/2026-08-24-reorganize-scripts.md) [2026-09-20-explore-scripts-directory.md](../scripts/notes/2026-09-20-explore-scripts-directory.md) [2026-10-14-lib-claim-fix.md](../scripts/notes/2026-10-14-lib-claim-fix.md)  _…and 1 more under `scripts/` — browse the folder._
- **configs** (1): [2026-10-18-shared-script-config.yaml](../scripts/configs/2026-10-18-shared-script-config.yaml)
- **snippets** (2): [2026-09-20-first-utility-script.sh](../scripts/snippets/2026-09-20-first-utility-script.sh) [2026-10-15-kit-helper-logging-retry.sh](../scripts/snippets/2026-10-15-kit-helper-logging-retry.sh)
- **README.md** (1): [README.md](../scripts/README.md)
- **bash** (183): [patch-management.yml](../scripts/bash/ansible_toolkit/patch-management.yml) [aap-cve-2026-0598-check.sh](../scripts/bash/ansible_toolkit/security/aap-cve-2026-0598-check.sh) [aap-cve-2026-24049-check.sh](../scripts/bash/ansible_toolkit/security/aap-cve-2026-24049-check.sh)  _…and 180 more under `scripts/` — browse the folder._
- **bump-version.sh** (1): [bump-version.sh](../scripts/bump-version.sh)
- **patch-report.sh** (1): [patch-report.sh](../scripts/patch-report.sh)
- **pipeline** (2): [deploy.sh](../scripts/pipeline/deploy.sh) [rollback.sh](../scripts/pipeline/rollback.sh)
- **triage-vulnerabilities.sh** (1): [triage-vulnerabilities.sh](../scripts/triage-vulnerabilities.sh)

## Semgrep  ·  25 files

- **primer:** [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [0000-primer-semgrep.md](../semgrep/notes/0000-primer-semgrep.md) [2026-05-25-install-semgrep.md](../semgrep/notes/2026-05-25-install-semgrep.md) [2026-05-26-install-semgrep-pitfalls.md](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md)
- **docs** (8): [comparing-rule-writing-approaches.md](../semgrep/docs/comparing-rule-writing-approaches.md) [github-actions-ci-from-scratch.md](../semgrep/docs/github-actions-ci-from-scratch.md) [semgrep-ci-integration.md](../semgrep/docs/semgrep-ci-integration.md)  _…and 5 more under `semgrep/` — browse the folder._
- **scripts** (3): [bulk-scan-helper.py](../semgrep/scripts/bulk-scan-helper.py) [detect-hardcoded-secrets.py](../semgrep/scripts/detect-hardcoded-secrets.py) [scan-python-codebase.sh](../semgrep/scripts/scan-python-codebase.sh)
- **configs** (1): [multi-rule-pack.yaml](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [catch-privileged-containers.yaml](../semgrep/snippets/catch-privileged-containers.yaml) [first-custom-rule.yaml](../semgrep/snippets/first-custom-rule.yaml)
- **manifests** (3): [diff-aware-semgrep-ci.yaml](../semgrep/manifests/diff-aware-semgrep-ci.yaml) [semgrep-ci-cd-pipeline.yaml](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml) [semgrep-gitlab-ci.yaml](../semgrep/manifests/semgrep-gitlab-ci.yaml)
- **dockerfiles** (2): [ci-entrypoint.sh](../semgrep/dockerfiles/ci-entrypoint.sh) [custom-scanning-image.Dockerfile](../semgrep/dockerfiles/custom-scanning-image.Dockerfile)
- **notebooks** (3): [comparing-community-vs-custom-rules.ipynb](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb) [rule-matching-mode-comparison.ipynb](../semgrep/notebooks/rule-matching-mode-comparison.ipynb) [semgrep-scan-vs-ci-comparison.ipynb](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## Snippets  ·  23 files

- **primer:** [0000-primer-snippets.md](../snippets/notes/0000-primer-snippets.md)
- **notes** (2): [0000-primer-snippets.md](../snippets/notes/0000-primer-snippets.md) [2026-10-19-snippets-quickstart-trip-ups.md](../snippets/notes/2026-10-19-snippets-quickstart-trip-ups.md)
- **configs** (2): [2026-09-20-first-category.yaml](../snippets/configs/2026-09-20-first-category.yaml) [2026-10-19-shared-index-config.yaml](../snippets/configs/2026-10-19-shared-index-config.yaml)
- **snippets** (2): [2026-09-20-first-snippet.sh](../snippets/snippets/2026-09-20-first-snippet.sh) [2026-10-19-minimal-python-snippet.py](../snippets/snippets/2026-10-19-minimal-python-snippet.py)
- **ansible-commands.md** (1): [ansible-commands.md](../snippets/ansible-commands.md)
- **ci-cd-cheatsheet.md** (1): [ci-cd-cheatsheet.md](../snippets/ci-cd-cheatsheet.md)
- **docker-commands.md** (1): [docker-commands.md](../snippets/docker-commands.md)
- **git-commands.md** (1): [git-commands.md](../snippets/git-commands.md)
- **jenkins-cheatsheet.md** (1): [jenkins-cheatsheet.md](../snippets/jenkins-cheatsheet.md)
- **jenkins-cli-commands.md** (1): [jenkins-cli-commands.md](../snippets/jenkins-cli-commands.md)
- **jenkins-commands-reference.md** (1): [jenkins-commands-reference.md](../snippets/jenkins-commands-reference.md)
- **jenkins-scripted-pipeline-groovy.md** (1): [jenkins-scripted-pipeline-groovy.md](../snippets/jenkins-scripted-pipeline-groovy.md)
- **kafka-cheatsheet.md** (1): [kafka-cheatsheet.md](../snippets/kafka-cheatsheet.md)
- **kafka-topics-commands.md** (1): [kafka-topics-commands.md](../snippets/kafka-topics-commands.md)
- **kubectl-cheatsheet.md** (1): [kubectl-cheatsheet.md](../snippets/kubectl-cheatsheet.md)
- **linux-cheatsheet.md** (1): [linux-cheatsheet.md](../snippets/linux-cheatsheet.md)
- **linux-commands.md** (1): [linux-commands.md](../snippets/linux-commands.md)
- **observability-cheatsheet.md** (1): [observability-cheatsheet.md](../snippets/observability-cheatsheet.md)
- **oci-registry-cheatsheet.md** (1): [oci-registry-cheatsheet.md](../snippets/oci-registry-cheatsheet.md)
- **terraform-commands.md** (1): [terraform-commands.md](../snippets/terraform-commands.md)
- **vault-commands.md** (1): [vault-commands.md](../snippets/vault-commands.md)

## Snyk  ·  29 files

- **primer:** [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md)
- **notes** (6): [0000-primer-snyk.md](../snyk/notes/0000-primer-snyk.md) [2026-06-07-snyk-quickstart-walkthrough.md](../snyk/notes/2026-06-07-snyk-quickstart-walkthrough.md) [2026-06-08-install-snyk-first-test.md](../snyk/notes/2026-06-08-install-snyk-first-test.md)  _…and 3 more under `snyk/` — browse the folder._
- **docs** (4): [integrating-snyk-with-cicd-security-scanning.md](../snyk/docs/integrating-snyk-with-cicd-security-scanning.md) [multi-project-ci-pipeline.md](../snyk/docs/multi-project-ci-pipeline.md) [snyk-security-policy-migration-patterns.md](../snyk/docs/snyk-security-policy-migration-patterns.md)  _…and 1 more under `snyk/` — browse the folder._
- **scripts** (2): [2026-10-20-first-snyk-test.sh](../snyk/scripts/2026-10-20-first-snyk-test.sh) [snyk-vuln-scan-pipeline.sh](../snyk/scripts/snyk-vuln-scan-pipeline.sh)
- **configs** (3): [snyk-ci-github-actions.yaml](../snyk/configs/snyk-ci-github-actions.yaml) [snyk-dependency-patch-ignore.yaml](../snyk/configs/snyk-dependency-patch-ignore.yaml) [snyk-project-configuration-template.yaml](../snyk/configs/snyk-project-configuration-template.yaml)
- **snippets** (1): [my-first-snyk-commands.sh](../snyk/snippets/my-first-snyk-commands.sh)
- **templates** (10): [.snyk](../snyk/templates/snyk-multilang-scan-scaffold/.snyk) [Makefile](../snyk/templates/snyk-multilang-scan-scaffold/Makefile) [README.md](../snyk/templates/snyk-multilang-scan-scaffold/README.md)  _…and 7 more under `snyk/` — browse the folder._
- **manifests** (1): [snyk-github-actions-cicd-workflow.yaml](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **dockerfiles** (1): [custom-snyk-cli-air-gapped.Dockerfile](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- **notebooks** (1): [cli-vs-api-modes.ipynb](../snyk/notebooks/cli-vs-api-modes.ipynb)

## SonarQube  ·  7 files

- **primer:** [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (3): [0000-primer-sonarqube.md](../sonarqube/notes/0000-primer-sonarqube.md) [2026-07-19-explore-sonarqube-quality-gates-profiles.md](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md) [2026-09-21-follow-sonarqube-quickstart.md](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md)
- **scripts** (1): [2026-09-21-sonarqube-scan-setup.sh](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **configs** (2): [2026-09-21-minimal-quality-gate.yaml](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml) [minimal-project-quality-gate.yaml](../sonarqube/configs/minimal-project-quality-gate.yaml)
- **snippets** (1): [2026-07-16-first-sonarscanner-run.sh](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## Syft  ·  44 files

- **primer:** [0000-primer-syft.md](../syft/notes/0000-primer-syft.md)
- **notes** (5): [0000-primer-syft.md](../syft/notes/0000-primer-syft.md) [2026-05-27-install-syft-first-sbom.md](../syft/notes/2026-05-27-install-syft-first-sbom.md) [2026-05-29-syft-quickstart-trip-ups.md](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)  _…and 2 more under `syft/` — browse the folder._
- **docs** (8): [enterprise-registry-auth-caching-patterns.md](../syft/docs/enterprise-registry-auth-caching-patterns.md) [enterprise-registry-auth-caching.md](../syft/docs/enterprise-registry-auth-caching.md) [output-format-selection-guide.md](../syft/docs/output-format-selection-guide.md)  _…and 5 more under `syft/` — browse the folder._
- **scripts** (5): [2026-10-27-scan-docker-images-aggregate-sboms.sh](../syft/scripts/2026-10-27-scan-docker-images-aggregate-sboms.sh) [gen-multi-format-sboms.sh](../syft/scripts/gen-multi-format-sboms.sh) [multi-image-sbom-pipeline.sh](../syft/scripts/multi-image-sbom-pipeline.sh)  _…and 2 more under `syft/` — browse the folder._
- **configs** (1): [.syft.yaml](../syft/configs/.syft.yaml)
- **snippets** (3): [2026-10-14-first-sbom.sh](../syft/snippets/2026-10-14-first-sbom.sh) [2026-10-27-syft-cli-output-formats.sh](../syft/snippets/2026-10-27-syft-cli-output-formats.sh) [tried-sbom-formats.sh](../syft/snippets/tried-sbom-formats.sh)
- **templates** (13): [.gitignore](../syft/templates/sbom-pipeline-scaffold/.gitignore) [Makefile](../syft/templates/sbom-pipeline-scaffold/Makefile) [README.md](../syft/templates/sbom-pipeline-scaffold/README.md)  _…and 10 more under `syft/` — browse the folder._
- **manifests** (4): [syft-cicd-pipeline.yaml](../syft/manifests/syft-cicd-pipeline.yaml) [syft-gha-multi-arch-sbom-registry-auth.yaml](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml) [syft-gha-sbom-oci-push-attestation.yaml](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml)  _…and 1 more under `syft/` — browse the folder._
- **dockerfiles** (1): [multi-stage-sbom.Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (4): [output-format-comparison.ipynb](../syft/notebooks/output-format-comparison.ipynb) [sbom-layer-package-analysis.ipynb](../syft/notebooks/sbom-layer-package-analysis.ipynb) [source-vs-library-multiarch.ipynb](../syft/notebooks/source-vs-library-multiarch.ipynb)  _…and 1 more under `syft/` — browse the folder._

## templates  ·  45 files

- **primer:** [0000-primer-templates.md](../templates/notes/0000-primer-templates.md)
- **notes** (2): [0000-primer-templates.md](../templates/notes/0000-primer-templates.md) [2026-10-19-templates-quickstart.md](../templates/notes/2026-10-19-templates-quickstart.md)
- **docs** (1): [2026-10-19-linux-automation-deploy-path.md](../templates/docs/2026-10-19-linux-automation-deploy-path.md)
- **scripts** (1): [template-catalog-validator.py](../templates/scripts/template-catalog-validator.py)
- **configs** (3): [2026-09-20-first-template-variables.yaml](../templates/configs/2026-09-20-first-template-variables.yaml) [2026-10-19-template-index-config.yaml](../templates/configs/2026-10-19-template-index-config.yaml) [flat-vs-cookiecutter-variable-profiles.yaml](../templates/configs/flat-vs-cookiecutter-variable-profiles.yaml)
- **snippets** (1): [2026-10-19-minimal-template-snippet.py](../templates/snippets/2026-10-19-minimal-template-snippet.py)
- **templates** (3): [README.md](../templates/templates/2026-09-20-first-project-template/README.md) [cookiecutter.json](../templates/templates/2026-09-20-first-project-template/cookiecutter.json) [app.py](../templates/templates/2026-09-20-first-project-template/{{cookiecutter.project_slug}}/app.py)
- **jenkins** (1): [Jenkinsfile-maven-gradle-template.md](../templates/jenkins/Jenkinsfile-maven-gradle-template.md)
- **k8s** (3): [deploy-prod-app.sh](../templates/k8s/deploy-prod-app.sh) [deployment-monitor.sh](../templates/k8s/deployment-monitor.sh) [production-deployment.yaml](../templates/k8s/production-deployment.yaml)
- **linux-automation** (15): [README.md](../templates/linux-automation/README.md) [deploy.sh](../templates/linux-automation/deploy.sh) [group_vars.yml](../templates/linux-automation/group_vars.yml)  _…and 12 more under `templates/` — browse the folder._
- **logstash** (1): [logstash.conf](../templates/logstash/logstash.conf)
- **syslog-ng** (1): [syslog-ng.conf](../templates/syslog-ng/syslog-ng.conf)
- **terraform** (13): [production-module-template.md](../templates/terraform/production-module-template.md) [main.tf](../templates/terraform/examples/simple/main.tf) [main.tf](../templates/terraform/lambda-api-gateway/main.tf)  _…and 10 more under `templates/` — browse the folder._

## Terraform  ·  35 files

- **primer:** [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md)
- **notes** (3): [0000-primer-terraform.md](../terraform/notes/0000-primer-terraform.md) [2026-07-15-explore-terraform.md](../terraform/notes/2026-07-15-explore-terraform.md) [2026-08-04-install-terraform-first-vm.md](../terraform/notes/2026-08-04-install-terraform-first-vm.md)
- **docs** (2): [terraform-module-composition.md](../terraform/docs/terraform-module-composition.md) [terraform-testing-patterns.md](../terraform/docs/terraform-testing-patterns.md)
- **scripts** (4): [2026-07-13-zip-build.sh](../terraform/scripts/2026-07-13-zip-build.sh) [2026-07-18-cleanup.sh](../terraform/scripts/2026-07-18-cleanup.sh) [2026-07-18-deploy.sh](../terraform/scripts/2026-07-18-deploy.sh)  _…and 1 more under `terraform/` — browse the folder._
- **configs** (12): [2026-07-15-first-config.tf](../terraform/configs/2026-07-15-first-config.tf) [2026-08-04-first-configuration.hcl](../terraform/configs/2026-08-04-first-configuration.hcl) [2026-10-19-minimal-quickstart-config.hcl](../terraform/configs/2026-10-19-minimal-quickstart-config.hcl)  _…and 9 more under `terraform/` — browse the folder._
- **snippets** (1): [2026-07-20-practice-terraform-variables-outputs-datasources.hcl](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- **templates** (5): [README.md](../terraform/templates/module-registry-publish-consume/README.md) [main.tf](../terraform/templates/module-registry-publish-consume/main.tf) [outputs.tf](../terraform/templates/module-registry-publish-consume/outputs.tf)  _…and 2 more under `terraform/` — browse the folder._
- **manifests** (1): [terraform-cloud-workspace-automation.hcl](../terraform/manifests/terraform-cloud-workspace-automation.hcl)
- **eventbridge-lambda** (7): [main.tf](../terraform/eventbridge-lambda/main.tf) [variables.tf](../terraform/eventbridge-lambda/variables.tf) [dev.tfvars](../terraform/eventbridge-lambda/environments/dev.tfvars)  _…and 4 more under `terraform/` — browse the folder._

## Terrascan  ·  22 files

- **primer:** [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [0000-primer-terrascan.md](../terrascan/notes/0000-primer-terrascan.md) [2026-06-13-first-scan.md](../terrascan/notes/2026-06-13-first-scan.md) [2026-06-19-install-terrascan-tiny-tf.md](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md)  _…and 2 more under `terrascan/` — browse the folder._
- **docs** (3): [iac-pipeline-integration.md](../terrascan/docs/iac-pipeline-integration.md) [terrascan-scan-configuration-migration-patterns.md](../terrascan/docs/terrascan-scan-configuration-migration-patterns.md) [terrascan-vs-checkov-terraform-iac-scanning.md](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md)
- **scripts** (2): [policy-as-code-workflow.sh](../terrascan/scripts/policy-as-code-workflow.sh) [tried-terrascan-ci-scan.sh](../terrascan/scripts/tried-terrascan-ci-scan.sh)
- **configs** (2): [terrascan-config-template.yaml](../terrascan/configs/terrascan-config-template.yaml) [tried-custom-s3-rule.yaml](../terrascan/configs/tried-custom-s3-rule.yaml)
- **snippets** (2): [insecure-terraform.tf](../terrascan/snippets/insecure-terraform.tf) [tiny-tf-with-findings.tf](../terrascan/snippets/tiny-tf-with-findings.tf)
- **templates** (6): [.gitignore](../terrascan/templates/scanning-pipeline-scaffold/.gitignore) [README.md](../terrascan/templates/scanning-pipeline-scaffold/README.md) [config.yaml](../terrascan/templates/scanning-pipeline-scaffold/config.yaml)  _…and 3 more under `terrascan/` — browse the folder._
- **manifests** (1): [terrascan-gha-ci-multi-iac.yaml](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **notebooks** (1): [rego-vs-yaml-rule-authoring.ipynb](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)

## Tetragon  ·  11 files

- **primer:** [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (3): [0000-primer-tetragon.md](../tetragon/notes/0000-primer-tetragon.md) [2026-06-23-install-tetragon-docker-first-events.md](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md) [2026-08-06-tetragon-observability-tutorial.md](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md)
- **docs** (1): [runtime-security-workflow.md](../tetragon/docs/runtime-security-workflow.md)
- **scripts** (3): [2026-08-05-tetragon-event-collection-pipeline.sh](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh) [build-tetragon-file-access-tracing-policy.sh](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh) [build-tetragon-policy.sh](../tetragon/scripts/build-tetragon-policy.sh)
- **configs** (4): [2026-08-05-minimal-network-tracing-policy.yaml](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml) [first-tracing-policy-exec-file.yaml](../tetragon/configs/first-tracing-policy-exec-file.yaml) [policy-approaches-comparison.yaml](../tetragon/configs/policy-approaches-comparison.yaml)  _…and 1 more under `tetragon/` — browse the folder._

## tfsec  ·  6 files

- **primer:** [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md)
- **notes** (3): [0000-primer-tfsec.md](../tfsec/notes/0000-primer-tfsec.md) [2026-09-20-first-tfsec-scan.md](../tfsec/notes/2026-09-20-first-tfsec-scan.md) [2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md](../tfsec/notes/2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md)
- **scripts** (1): [2026-10-19-ran-my-first-tfsec-scan.sh](../tfsec/scripts/2026-10-19-ran-my-first-tfsec-scan.sh)
- **configs** (1): [2026-10-19-minimal-tfsec-scan-config.yaml](../tfsec/configs/2026-10-19-minimal-tfsec-scan-config.yaml)
- **snippets** (1): [enforce-s3-bucket-encryption.rego](../tfsec/snippets/enforce-s3-bucket-encryption.rego)

## Trivy  ·  40 files

- **primer:** [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md)
- **notes** (8): [0000-primer-trivy.md](../trivy/notes/0000-primer-trivy.md) [2026-05-24-install-trivy.md](../trivy/notes/2026-05-24-install-trivy.md) [2026-05-26-trivy-quickstart.md](../trivy/notes/2026-05-26-trivy-quickstart.md)  _…and 5 more under `trivy/` — browse the folder._
- **docs** (6): [ci-cd-pipeline-recipes.md](../trivy/docs/ci-cd-pipeline-recipes.md) [ci-pipeline-sarif-output.md](../trivy/docs/ci-pipeline-sarif-output.md) [multi-arch-vulnerability-scanning.md](../trivy/docs/multi-arch-vulnerability-scanning.md)  _…and 3 more under `trivy/` — browse the folder._
- **scripts** (6): [compose-multi-scan.sh](../trivy/scripts/compose-multi-scan.sh) [container-vuln-scan.sh](../trivy/scripts/container-vuln-scan.sh) [custom-trivy-check-conftest.sh](../trivy/scripts/custom-trivy-check-conftest.sh)  _…and 3 more under `trivy/` — browse the folder._
- **configs** (4): [.trivy.yaml](../trivy/configs/.trivy.yaml) [2026-10-19-minimal-trivy-config.yaml](../trivy/configs/2026-10-19-minimal-trivy-config.yaml) [trivy-ci-gate.yml](../trivy/configs/trivy-ci-gate.yml)  _…and 1 more under `trivy/` — browse the folder._
- **snippets** (1): [scan-docker-image.sh](../trivy/snippets/scan-docker-image.sh)
- **templates** (10): [README.md](../trivy/templates/trivy-k8s-workload-scanning/README.md) [k8s-scan-cronjob.yaml](../trivy/templates/trivy-k8s-workload-scanning/k8s-scan-cronjob.yaml) [k8s-scan-job.yaml](../trivy/templates/trivy-k8s-workload-scanning/k8s-scan-job.yaml)  _…and 7 more under `trivy/` — browse the folder._
- **manifests** (2): [trivy-operator-deployment.yaml](../trivy/manifests/trivy-operator-deployment.yaml) [trivy-sarif-code-scanning.yaml](../trivy/manifests/trivy-sarif-code-scanning.yaml)
- **dockerfiles** (1): [custom-policies.Dockerfile](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy-sarif-output-processing.ipynb](../trivy/notebooks/trivy-sarif-output-processing.ipynb) [trivy-scan-mode-comparison.ipynb](../trivy/notebooks/trivy-scan-mode-comparison.ipynb)

## TruffleHog  ·  51 files

- **primer:** [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (4): [0000-primer-trufflehog.md](../trufflehog/notes/0000-primer-trufflehog.md) [2026-05-27-following-trufflehog-quickstart.md](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md) [2026-05-27-install-trufflehog.md](../trufflehog/notes/2026-05-27-install-trufflehog.md)  _…and 1 more under `trufflehog/` — browse the folder._
- **docs** (4): [comparing-scan-modes-git-filesystem-s3.md](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md) [trufflehog-integration-reference-secret-detection.md](../trufflehog/docs/trufflehog-integration-reference-secret-detection.md) [trufflehog-output-formats-json-sarif-csv.md](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md)  _…and 1 more under `trufflehog/` — browse the folder._
- **scripts** (3): [analyze-trufflehog-results.py](../trufflehog/scripts/analyze-trufflehog-results.py) [multi-repo-scan-pipeline.sh](../trufflehog/scripts/multi-repo-scan-pipeline.sh) [pre-commit-scan-pipeline.sh](../trufflehog/scripts/pre-commit-scan-pipeline.sh)
- **configs** (2): [custom-detector-rules.yaml](../trufflehog/configs/custom-detector-rules.yaml) [trufflehog-custom-regex-config.yaml](../trufflehog/configs/trufflehog-custom-regex-config.yaml)
- **snippets** (3): [2026-10-14-first-secret-scan.sh](../trufflehog/snippets/2026-10-14-first-secret-scan.sh) [fake-secrets-test.sh](../trufflehog/snippets/fake-secrets-test.sh) [scan-github-repo-for-secrets.sh](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- **templates** (28): [.gitignore](../trufflehog/templates/github-secret-scanning-integration/.gitignore) [Makefile](../trufflehog/templates/github-secret-scanning-integration/Makefile) [README.md](../trufflehog/templates/github-secret-scanning-integration/README.md)  _…and 25 more under `trufflehog/` — browse the folder._
- **manifests** (2): [trufflehog-cicd-pipeline.yaml](../trufflehog/manifests/trufflehog-cicd-pipeline.yaml) [trufflehog-pr-secret-scan-reusable.yaml](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- **dockerfiles** (2): [pipeline-scanner.Dockerfile](../trufflehog/dockerfiles/pipeline-scanner.Dockerfile) [pre-commit-scanner.Dockerfile](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile)
- **notebooks** (3): [analyzing-trufflehog-false-positives.ipynb](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb) [detector-comparison-patterns.ipynb](../trufflehog/notebooks/detector-comparison-patterns.ipynb) [trufflehog-scan-modes-comparison.ipynb](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb)

## HashiCorp Vault  ·  21 files

- **primer:** [0000-primer-vault.md](../vault/notes/0000-primer-vault.md)
- **notes** (4): [0000-primer-vault.md](../vault/notes/0000-primer-vault.md) [2026-06-05-install-vault-and-explore-cli.md](../vault/notes/2026-06-05-install-vault-and-explore-cli.md) [2026-06-15-vault-getting-started-trip-ups.md](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md)  _…and 1 more under `vault/` — browse the folder._
- **docs** (3): [configuring-vault-dev-server.md](../vault/docs/configuring-vault-dev-server.md) [vault-agent-auto-auth-kubernetes.md](../vault/docs/vault-agent-auto-auth-kubernetes.md) [vault-secrets-engine-selection-guide.md](../vault/docs/vault-secrets-engine-selection-guide.md)
- **scripts** (4): [cloud-iam-dynamic-secrets.sh](../vault/scripts/cloud-iam-dynamic-secrets.sh) [vault-db-dynamic-secrets.sh](../vault/scripts/vault-db-dynamic-secrets.sh) [vault-kv-crud.sh](../vault/scripts/vault-kv-crud.sh)  _…and 1 more under `vault/` — browse the folder._
- **configs** (3): [2026-06-26-dev-test-policies.hcl](../vault/configs/2026-06-26-dev-test-policies.hcl) [2026-09-04-aws-secrets-engine-policy.hcl](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl) [multi-environment-access-control.hcl](../vault/configs/multi-environment-access-control.hcl)
- **snippets** (2): [2026-08-30-first-vault-secret.sh](../vault/snippets/2026-08-30-first-vault-secret.sh) [vault-read-write.go](../vault/snippets/vault-read-write.go)
- **manifests** (2): [vault-cluster-deployment.yaml](../vault/manifests/vault-cluster-deployment.yaml) [vault-sidecar-secrets-refresh.yaml](../vault/manifests/vault-sidecar-secrets-refresh.yaml)
- **dockerfiles** (1): [custom-vault-image-with-plugins-tls.Dockerfile](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **notebooks** (2): [static-vs-dynamic-secrets.ipynb](../vault/notebooks/static-vs-dynamic-secrets.ipynb) [vault-secrets-backend-comparison-patterns.ipynb](../vault/notebooks/vault-secrets-backend-comparison-patterns.ipynb)

## OWASP ZAP  ·  31 files

- **primer:** [0000-primer-zap.md](../zap/notes/0000-primer-zap.md)
- **notes** (6): [0000-primer-zap.md](../zap/notes/0000-primer-zap.md) [2026-06-06-install-zap-desktop-ui.md](../zap/notes/2026-06-06-install-zap-desktop-ui.md) [2026-06-06-zap-quickstart-ui-gotchas.md](../zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md)  _…and 3 more under `zap/` — browse the folder._
- **docs** (5): [passive-vs-active-scanning-zap.md](../zap/docs/passive-vs-active-scanning-zap.md) [zap-automation-plan-structure.md](../zap/docs/zap-automation-plan-structure.md) [zap-integration-patterns.md](../zap/docs/zap-integration-patterns.md)  _…and 2 more under `zap/` — browse the folder._
- **scripts** (3): [dast-workflow-from-scratch.sh](../zap/scripts/dast-workflow-from-scratch.sh) [zap-baseline-scan.sh](../zap/scripts/zap-baseline-scan.sh) [zap-dast-sarif-code-scanning.sh](../zap/scripts/zap-dast-sarif-code-scanning.sh)
- **configs** (3): [ci-dast-automation-framework-plan.yaml](../zap/configs/ci-dast-automation-framework-plan.yaml) [zap-authenticated-scan-context.yaml](../zap/configs/zap-authenticated-scan-context.yaml) [zap-dast-github-actions-workflow.yaml](../zap/configs/zap-dast-github-actions-workflow.yaml)
- **snippets** (4): [2026-07-16-zap-docker-quickstart-json-export.sh](../zap/snippets/2026-07-16-zap-docker-quickstart-json-export.sh) [authenticated-scan-with-context.sh](../zap/snippets/authenticated-scan-with-context.sh) [my-first-zap-baseline-scan.sh](../zap/snippets/my-first-zap-baseline-scan.sh)  _…and 1 more under `zap/` — browse the folder._
- **templates** (7): [.gitignore](../zap/templates/zap-dast-integration-scaffold/.gitignore) [Makefile](../zap/templates/zap-dast-integration-scaffold/Makefile) [README.md](../zap/templates/zap-dast-integration-scaffold/README.md)  _…and 4 more under `zap/` — browse the folder._
- **manifests** (1): [zap-cicd-pipeline.yaml](../zap/manifests/zap-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom-zap-automation.Dockerfile](../zap/dockerfiles/custom-zap-automation.Dockerfile)
- **notebooks** (1): [scan-strategy-comparison-patterns.ipynb](../zap/notebooks/scan-strategy-comparison-patterns.ipynb)
