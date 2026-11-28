# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible  ·  34 files

- **Notes** (3): [Followed Ansible Quickstart What Tripped Me Up](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md), [Verify Ansible Cve 2026 33228 Paths](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md), [Roles Vs Tasks](../ansible/notes/roles-vs-tasks.md)
- **Docs** (1): [Wired Ansible Infrastructure Workflow](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **Scripts** (5): [First Ad Hoc Command](../ansible/scripts/2026-10-27-first-ad-hoc-command.sh), [Bootstrap Node](../ansible/scripts/2026-08-04-bootstrap-node.sh), [Bootstrap Target Node](../ansible/scripts/bootstrap-target-node.sh) _…and 2 more under `ansible/` — browse the folder._
- **Configs** (3): [Inventory Groups Host Vars](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml), [Small Ansible Project](../ansible/configs/small-ansible-project.yaml), [Terraform Nginx Integration](../ansible/configs/terraform-nginx-integration.yaml)
- **Snippets** (1): [Minimal Ansible Playbook Package Service](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- **Templates** (21): [Gitignore](../ansible/templates/ansible-roles-staging-production/.gitignore), [Readme](../ansible/templates/ansible-roles-staging-production/README.md), [Ansible](../ansible/templates/ansible-roles-staging-production/ansible.cfg) _…and 18 more under `ansible/` — browse the folder._

## Argo CD  ·  28 files

- **primer:** [Primer Argocd](../argocd/notes/0000-primer-argocd.md)
- **Notes** (5): [Quickstart Tripups](../argocd/notes/2026-08-12-quickstart-tripups.md), [Verify Readme Layout](../argocd/notes/2026-08-01-verify-readme-layout.md), [Verify Readme Layout](../argocd/notes/2026-07-31-verify-readme-layout.md) _…and 2 more under `argocd/` — browse the folder._
- **Docs** (3): [Gitops Workflow Wiring](../argocd/docs/gitops-workflow-wiring.md), [Helm Kustomize Composition](../argocd/docs/helm-kustomize-composition.md), [Multi Environment Gitops Delivery](../argocd/docs/multi-environment-gitops-delivery.md)
- **Scripts** (1): [Argocd Api Automation](../argocd/scripts/argocd-api-automation.sh)
- **Configs** (2): [Values Dev](../argocd/configs/2026-09-20-values-dev.yaml), [Private Repo Credentials Rbac](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- **Templates** (11): [Readme](../argocd/templates/app-of-apps-multienv/README.md), [App](../argocd/templates/app-of-apps-multienv/apps/environments/development/app.yaml), [App](../argocd/templates/app-of-apps-multienv/apps/environments/production/app.yaml) _…and 8 more under `argocd/` — browse the folder._
- **Manifests** (5): [Install](../argocd/manifests/2026-10-28-install.yaml), [Gitops Sync Sample Web App](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml), [Sample App Application](../argocd/manifests/2026-07-06-sample-app-application.yaml) _…and 2 more under `argocd/` — browse the folder._

## Checkov  ·  47 files

- **primer:** [Primer Checkov](../checkov/notes/0000-primer-checkov.md)
- **Notes** (3): [Checkov Quickstart Trip Ups](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md), [Cli Vs Sdk Comparison](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [Scan Terraform Plan](../checkov/notes/2026-05-25-scan-terraform-plan.md)
- **Docs** (6): [Checkov Ai Infrastructure Checks](../checkov/docs/checkov-ai-infrastructure-checks.md), [Checkov Integration Patterns](../checkov/docs/checkov-integration-patterns.md), [Checkov V3 Migration Guide](../checkov/docs/checkov-v3-migration-guide.md) _…and 3 more under `checkov/` — browse the folder._
- **Scripts** (4): [Checkov Health Check And Rollback](../checkov/scripts/checkov-health-check-and-rollback.sh), [Deep Terraform Plan Scan](../checkov/scripts/deep-terraform-plan-scan.sh), [Scan Terraform Plan](../checkov/scripts/scan-terraform-plan.sh) _…and 1 more under `checkov/` — browse the folder._
- **Configs** (4): [Checkov Ci Config](../checkov/configs/checkov-ci-config.yaml), [Checkov Skip Severity Config](../checkov/configs/checkov-skip-severity-config.yaml), [Platform Config](../checkov/configs/platform-config.yaml) _…and 1 more under `checkov/` — browse the folder._
- **Snippets** (4): [Scan A Terraform File](../checkov/snippets/scan-a-terraform-file.py), [Scan Kubernetes](../checkov/snippets/scan-kubernetes.sh), [Scan Terraform Dir](../checkov/snippets/scan-terraform-dir.py) _…and 1 more under `checkov/` — browse the folder._
- **Templates** (16): [Makefile](../checkov/templates/multi-iac-scan-project/Makefile), [Readme](../checkov/templates/multi-iac-scan-project/README.md), [Checkov Config](../checkov/templates/multi-iac-scan-project/checkov-config.yaml) _…and 13 more under `checkov/` — browse the folder._
- **Manifests** (3): [Checkov Gitlab Ci Multi Cloud Drift](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml), [Checkov Sarif Pr Blocking](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [Layered Checkov Ci Pr Gate Deep Scan Merge Block](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml)
- **Notebooks** (4): [Compare Builtin Vs Custom K8S](../checkov/notebooks/compare-builtin-vs-custom-k8s.ipynb), [Compare Cross Module Scanning Limitations](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb), [Compare Custom Policy Expressiveness](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb) _…and 1 more under `checkov/` — browse the folder._
- **Policies** (2): [No Public Bucket](../checkov/policies/ckv2-no-public-bucket/no_public_bucket.yaml), [No Public S3 Buckets](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)

## CodeQL  ·  32 files

- **primer:** [Primer Codeql](../codeql/notes/0000-primer-codeql.md)
- **Notes** (4): [Install Codeql First Query](../codeql/notes/2026-10-27-install-codeql-first-query.md), [Install Codeql First Query](../codeql/notes/2026-08-26-install-codeql-first-query.md), [Codeql Datalog Gotchas](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md) _…and 1 more under `codeql/` — browse the folder._
- **Docs** (4): [Codeql Database Migration Guide](../codeql/docs/codeql-database-migration-guide.md), [Codeql Integration Reference](../codeql/docs/codeql-integration-reference.md), [Query Writing Patterns Dataflow Javascript Typescript](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md) _…and 1 more under `codeql/` — browse the folder._
- **Scripts** (2): [Codeql Security Issue Detector](../codeql/scripts/codeql-security-issue-detector.py), [First Codeql Analysis](../codeql/scripts/first-codeql-analysis.sh)
- **Configs** (2): [Codeql Analysis Workflow](../codeql/configs/codeql-analysis-workflow.yaml), [First Codeql Analysis](../codeql/configs/first-codeql-analysis.yml)
- **Snippets** (6): [Hardcoded Secrets](../codeql/snippets/2026-10-27-hardcoded-secrets.ql), [First Codeql Query](../codeql/snippets/2026-09-24-first-codeql-query.py), [Find Hardcoded Creds](../codeql/snippets/find-hardcoded-creds.ql) _…and 3 more under `codeql/` — browse the folder._
- **Templates** (7): [Readme](../codeql/templates/custom-query-pack-ci-harness/README.md), [Known Bad](../codeql/templates/custom-query-pack-ci-harness/fixtures/basic/known-bad.py), [Known Good](../codeql/templates/custom-query-pack-ci-harness/fixtures/basic/known-good.py) _…and 4 more under `codeql/` — browse the folder._
- **Manifests** (3): [Codeql Cicd Pipeline](../codeql/manifests/codeql-cicd-pipeline.yaml), [Codeql Multi Language Scan](../codeql/manifests/codeql-multi-language-scan.yaml), [Multi Language Codeql Analysis](../codeql/manifests/multi-language-codeql-analysis.yaml)
- **Dockerfiles** (1): [Custom Codeql Analysis Image](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **Notebooks** (2): [Codeql Query Comparison Patterns](../codeql/notebooks/codeql-query-comparison-patterns.ipynb), [Compare Cli Vs Actions Scan Modes](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb)

## Cosign  ·  20 files

- **primer:** [Primer Cosign](../cosign/notes/0000-primer-cosign.md)
- **Notes** (4): [Install Cosign First Signing Command](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md), [Cosign Getting Started Trip Ups](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [Install Cosign Generate First Keypair](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md) _…and 1 more under `cosign/` — browse the folder._
- **Docs** (4): [Container Signing Pipeline](../cosign/docs/container-signing-pipeline.md), [Cosign Verification Patterns](../cosign/docs/cosign-verification-patterns.md), [Key Rotation And Migration Patterns](../cosign/docs/key-rotation-and-migration-patterns.md) _…and 1 more under `cosign/` — browse the folder._
- **Scripts** (3): [Cosign Key Management Workflow](../cosign/scripts/cosign-key-management-workflow.sh), [Minimal Sign Verify](../cosign/scripts/minimal-sign-verify.sh), [Verify Signed Image](../cosign/scripts/verify-signed-image.sh)
- **Configs** (2): [Cosign Signature Configuration](../cosign/configs/cosign-signature-configuration.yaml), [Keyless Signing Github Actions](../cosign/configs/keyless-signing-github-actions.yaml)
- **Snippets** (1): [First Cosign Sign Verify Image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **Manifests** (2): [Keyless Oidc Ci](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml), [Signed Container Build Oidc](../cosign/manifests/signed-container-build-oidc.yaml)
- **Dockerfiles** (2): [Custom Cosign Image](../cosign/dockerfiles/custom-cosign-image.Dockerfile), [Entrypoint](../cosign/dockerfiles/entrypoint.sh)
- **Notebooks** (1): [Key Based Vs Keyless Signing](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## DefectDojo  ·  19 files

- **primer:** [Primer Defectdojo](../defectdojo/notes/0000-primer-defectdojo.md)
- **Notes** (3): [Followed Defectdojo Quickstart What Tripped Me Up](../defectdojo/notes/2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md), [Quickstart Tripups](../defectdojo/notes/2026-09-21-quickstart-tripups.md), [Explore Defectdojo Ui](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md)
- **Docs** (2): [Defectdojo Scan Tool Ingestion End To End](../defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md), [How I Wired Defectdojo Into My Triage Workflow](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md)
- **Scripts** (3): [Defectdojo Tutorial Check](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh), [Product Engagement Setup](../defectdojo/scripts/product-engagement-setup.py), [Product Scan Import](../defectdojo/scripts/product-scan-import.py)
- **Configs** (2): [Vulnerability Scanner Setup](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml), [Api Vs Ui Ingestion](../defectdojo/configs/api-vs-ui-ingestion.yaml)
- **Snippets** (2): [Minimal Product Setup Api](../defectdojo/snippets/2026-10-19-minimal-product-setup-api.py), [Install Defectdojo First Scan Report](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)
- **Templates** (6): [.Env](../defectdojo/templates/defectdojo-scan-ingestion-starter/.env.example), [Readme](../defectdojo/templates/defectdojo-scan-ingestion-starter/README.md), [Scanner Configs](../defectdojo/templates/defectdojo-scan-ingestion-starter/configs/scanner-configs.yaml) _…and 3 more under `defectdojo/` — browse the folder._

## Dependabot  ·  19 files

- **primer:** [Primer Dependabot](../dependabot/notes/0000-primer-dependabot.md)
- **Notes** (6): [Dependabot Custom Registry Tutorial](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md), [Enabling Dependabot Alerts Security Updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md), [Enabling Dependabot Alerts](../dependabot/notes/2026-07-10-enabling-dependabot-alerts.md) _…and 3 more under `dependabot/` — browse the folder._
- **Docs** (4): [Dependabot Security Alert Migration Patterns](../dependabot/docs/dependabot-security-alert-migration-patterns.md), [Dependabot Security Update Auto Merge](../dependabot/docs/dependabot-security-update-auto-merge.md), [Dependabot Version Control Workflow Integration](../dependabot/docs/dependabot-version-control-workflow-integration.md) _…and 1 more under `dependabot/` — browse the folder._
- **Scripts** (2): [Dependabot Alert Triage](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py), [Dependabot Alert Aggregation](../dependabot/scripts/dependabot-alert-aggregation.py)
- **Configs** (5): [Python Project Version Update](../dependabot/configs/2026-07-18-python-project-version-update.yaml), [Npm Version Strategy](../dependabot/configs/2026-07-10-npm-version-strategy.yaml), [Dependabot Configuration Template](../dependabot/configs/dependabot-configuration-template.yaml) _…and 2 more under `dependabot/` — browse the folder._
- **Notebooks** (1): [Auto Merge Vs Manual Review](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## Docker  ·  19 files

- **primer:** [Primer Docker](../docker/notes/0000-primer-docker.md)
- **Notes** (1): [Explore Docker Cli](../docker/notes/2026-07-12-explore-docker-cli.md)
- **Docs** (2): [Cicd End To End](../docker/docs/cicd-end-to-end.md), [Dockerfile Optimization Patterns](../docker/docs/dockerfile-optimization-patterns.md)
- **Scripts** (3): [Custom Network Volume Mounts](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh), [Build Multi Service Compose App](../docker/scripts/build-multi-service-compose-app.sh), [Reusable Build](../docker/scripts/reusable-build.sh)
- **Configs** (1): [Docker Compose Dev Environment](../docker/configs/docker-compose-dev-environment.yaml)
- **Templates** (7): [.Env](../docker/templates/multi-service-setup/.env.example), [Readme](../docker/templates/multi-service-setup/README.md), [Dockerfile](../docker/templates/multi-service-setup/api/Dockerfile) _…and 4 more under `docker/` — browse the folder._
- **Manifests** (1): [Docker Compose Production](../docker/manifests/docker-compose-production.yaml)
- **Dockerfiles** (3): [First Custom Docker Image](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [First Custom Image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile), [Small App](../docker/dockerfiles/small-app.Dockerfile)

## Falco  ·  25 files

- **primer:** [Primer Falco](../falco/notes/0000-primer-falco.md)
- **Notes** (5): [Follow Official Falco Quickstart](../falco/notes/2026-10-27-follow-official-falco-quickstart.md), [Install Falco First Event](../falco/notes/2026-10-15-install-falco-first-event.md), [Explore Falco Cli Rules Events Output](../falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md) _…and 2 more under `falco/` — browse the folder._
- **Docs** (4): [Rule Optimization Priority Filtering](../falco/docs/rule-optimization-priority-filtering.md), [Runtime Security Monitoring Integration](../falco/docs/runtime-security-monitoring-integration.md), [Syscall Vs Tracepoint Rules](../falco/docs/syscall-vs-tracepoint-rules.md) _…and 1 more under `falco/` — browse the folder._
- **Scripts** (3): [Deploy Falco Ruleset](../falco/scripts/deploy-falco-ruleset.sh), [Tried Falco K8S Alert Forwarding](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [Tried Falco K8S Deploy Alert Forwarding](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh)
- **Configs** (4): [Minimal Runtime Config](../falco/configs/2026-10-03-minimal-runtime-config.yaml), [First Custom Rule Detect Shell In Container](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml), [Container Drift Detection](../falco/configs/container-drift-detection.yaml) _…and 1 more under `falco/` — browse the folder._
- **Snippets** (1): [Tried File Access Detector](../falco/snippets/tried-file-access-detector.go)
- **Templates** (4): [Readme](../falco/templates/falco-custom-rules-library/README.md), [Override Example](../falco/templates/falco-custom-rules-library/examples/override-example.yaml), [Custom Rules](../falco/templates/falco-custom-rules-library/rules/custom-rules.yaml) _…and 1 more under `falco/` — browse the folder._
- **Manifests** (1): [Falco K8S Admission Control](../falco/manifests/falco-k8s-admission-control.yaml)
- **Notebooks** (2): [Falco Event Output Formats](../falco/notebooks/falco-event-output-formats.ipynb), [Rule Engine Vs Ebpf Probes](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb)

## Git  ·  10 files

- **primer:** [Primer Git](../git/notes/0000-primer-git.md)
- **Notes** (2): [Install Git Identity First Commit](../git/notes/2026-07-12-install-git-identity-first-commit.md), [Git Branching Merge Confusions](../git/notes/2026-07-04-git-branching-merge-confusions.md)
- **Docs** (1): [How I Wired Git Into My Version Control Workflow](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **Scripts** (4): [First Repo Stage Log](../git/scripts/2026-08-24-first-repo-stage-log.sh), [Bump Version](../git/scripts/2026-07-12-bump-version.sh), [Local Ci Simulation](../git/scripts/2026-07-10-local-ci-simulation.sh) _…and 1 more under `git/` — browse the folder._
- **Configs** (1): [Config Strategy Layered Vs Conditional](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **Snippets** (1): [Git Rebase Vs Merge Conflict Patterns](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## GitGuardian  ·  28 files

- **primer:** [Primer Gitguardian](../gitguardian/notes/0000-primer-gitguardian.md)
- **Notes** (5): [Quickstart Trip Ups](../gitguardian/notes/2026-10-27-quickstart-trip-ups.md), [Explore Interface](../gitguardian/notes/2026-10-14-explore-interface.md), [First Secrets Scan Repo](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md) _…and 2 more under `gitguardian/` — browse the folder._
- **Docs** (4): [Cicd Secret Scanning Integration](../gitguardian/docs/cicd-secret-scanning-integration.md), [Gitguardian Incident Response Workflow](../gitguardian/docs/gitguardian-incident-response-workflow.md), [Gitguardian Secret Scanning Migration Patterns](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md) _…and 1 more under `gitguardian/` — browse the folder._
- **Scripts** (4): [First Ggshield Scan](../gitguardian/scripts/2026-10-20-first-ggshield-scan.sh), [Gg Incident Response Pipeline](../gitguardian/scripts/gg-incident-response-pipeline.sh), [Gitguardian Api Integration](../gitguardian/scripts/gitguardian-api-integration.py) _…and 1 more under `gitguardian/` — browse the folder._
- **Configs** (3): [.Ggshield](../gitguardian/configs/.ggshield.yaml), [Monorepo Allowlists](../gitguardian/configs/monorepo-allowlists.yaml), [Policy Configuration](../gitguardian/configs/policy-configuration.yaml)
- **Snippets** (2): [Custom Policy Engine Ggshield](../gitguardian/snippets/custom-policy-engine-ggshield.sh), [My First Ggshield Commands](../gitguardian/snippets/my-first-ggshield-commands.sh)
- **Templates** (8): [Allowlist](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.ggshield/allowlist.yaml), [Gitignore](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/.gitignore), [Makefile](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/Makefile) _…and 5 more under `gitguardian/` — browse the folder._
- **Notebooks** (1): [Choosing Between On Premise And Cloud Modes](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb)

## GitHub Actions  ·  22 files

- **primer:** [Primer Github Actions](../github-actions/notes/0000-primer-github-actions.md)
- **Notes** (6): [Followed Quickstart](../github-actions/notes/2026-10-20-followed-quickstart.md), [Run First Workflow](../github-actions/notes/2026-10-14-run-first-workflow.md), [Quickstart Tripped Me Up](../github-actions/notes/2026-09-21-quickstart-tripped-me-up.md) _…and 3 more under `github-actions/` — browse the folder._
- **Docs** (1): [How I Wired Github Actions Into My Ci Workflow](../github-actions/docs/how-i-wired-github-actions-into-my-ci-workflow.md)
- **Scripts** (1): [Triage Latest Failed Run](../github-actions/scripts/triage-latest-failed-run.sh)
- **Configs** (8): [Minimal Ci](../github-actions/configs/2026-10-20-minimal-ci.yaml), [First Scheduled Workflow](../github-actions/configs/2026-10-14-first-scheduled-workflow.yaml), [Minimal Starter Workflow](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml) _…and 5 more under `github-actions/` — browse the folder._
- **Snippets** (3): [Trigger First Workflow Gh](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh), [First Workflow](../github-actions/snippets/2026-08-26-first-workflow.yaml), [Composite Action Input Reuse](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- **Manifests** (2): [What Is Github Actions](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [Pr Validation](../github-actions/manifests/2026-08-04-pr-validation.yml)

## Gitleaks  ·  9 files

- **primer:** [Primer Gitleaks](../gitleaks/notes/0000-primer-gitleaks.md)
- **Notes** (2): [Quickstart Trip Ups](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md), [First Secret Scan](../gitleaks/notes/2026-09-19-first-secret-scan.md)
- **Docs** (1): [Integrating Gitleaks Pre Commit Ci](../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md)
- **Scripts** (3): [Auditing Git Secrets](../gitleaks/scripts/2026-10-13-auditing-git-secrets.sh), [Run First Gitleaks Scan](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh), [Build Custom Gitleaks Ruleset](../gitleaks/scripts/build-custom-gitleaks-ruleset.sh)
- **Configs** (2): [Detection Rules](../gitleaks/configs/2026-10-07-detection-rules.yaml), [Gitleaks Config](../gitleaks/configs/gitleaks-config.toml)

## Grafana  ·  11 files

- **primer:** [Primer Grafana](../grafana/notes/0000-primer-grafana.md)
- **Notes** (3): [Grafana Quickstart Trip Ups](../grafana/notes/2026-10-14-grafana-quickstart-trip-ups.md), [Explore Grafana Dashboard Ui](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md), [First Dashboard Browser](../grafana/notes/2026-09-19-first-dashboard-browser.md)
- **Docs** (1): [Grafana Alerting Routing Templates](../grafana/docs/grafana-alerting-routing-templates.md)
- **Scripts** (1): [Build Dashboard Provisioning](../grafana/scripts/build-dashboard-provisioning.py)
- **Configs** (3): [Dashboard Provisioning](../grafana/configs/2026-10-14-dashboard-provisioning.yaml), [First Datasource](../grafana/configs/2026-09-19-first-datasource.yaml), [Security Slo Dashboard](../grafana/configs/security-slo-dashboard.json)
- **Snippets** (1): [First Grafana Datasource Query](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- **Manifests** (1): [Grafana Datasource Dashboard](../grafana/manifests/grafana-datasource-dashboard.yaml)

## Grype  ·  27 files

- **primer:** [Primer Grype](../grype/notes/0000-primer-grype.md)
- **Notes** (4): [Explore Vulnerability Database](../grype/notes/2026-10-14-explore-vulnerability-database.md), [First Grype Scan](../grype/notes/2026-06-08-first-grype-scan.md), [Grype Quickstart Trip Ups](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md) _…and 1 more under `grype/` — browse the folder._
- **Docs** (3): [Grype Syft Integration Guide](../grype/docs/grype-syft-integration-guide.md), [Grype Vulnerability Reporting Migration Patterns](../grype/docs/grype-vulnerability-reporting-migration-patterns.md), [Vulnerability Management Pipeline Integration](../grype/docs/vulnerability-management-pipeline-integration.md)
- **Scripts** (9): [Ci Ready Grype Scan](../grype/scripts/ci-ready-grype-scan.sh), [Grype End To End Scan Pipeline](../grype/scripts/grype-end-to-end-scan-pipeline.sh), [Grype Pipeline Ci Scan](../grype/scripts/grype-pipeline-ci-scan.sh) _…and 6 more under `grype/` — browse the folder._
- **Configs** (2): [Grype Ci Github Actions](../grype/configs/grype-ci-github-actions.yaml), [Grype Filtering Configuration Template](../grype/configs/grype-filtering-configuration-template.yaml)
- **Snippets** (3): [Grype Filter Severity Formats](../grype/snippets/2026-10-27-grype-filter-severity-formats.sh), [Minimal Grype Scan](../grype/snippets/minimal-grype-scan.go), [My First Grype Commands](../grype/snippets/my-first-grype-commands.sh)
- **Manifests** (2): [Grype Reusable Sarif Workflow](../grype/manifests/grype-reusable-sarif-workflow.yaml), [Grype Sarif Reusable Workflow](../grype/manifests/grype-sarif-reusable-workflow.yaml)
- **Dockerfiles** (1): [Multi Stage Grype Scan](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **Notebooks** (2): [Grype Db Vs Registry Sources](../grype/notebooks/grype-db-vs-registry-sources.ipynb), [Grype Sbom Output Explorer](../grype/notebooks/grype-sbom-output-explorer.ipynb)

## Helm  ·  13 files

- **primer:** [Primer Helm](../helm/notes/0000-primer-helm.md)
- **Notes** (3): [Followed Quickstart](../helm/notes/2026-10-20-followed-quickstart.md), [Quickstart Tripped Me Up](../helm/notes/2026-09-21-quickstart-tripped-me-up.md), [Explore Helm Charts Releases Values Repos](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md)
- **Docs** (1): [How I Wired Helm Into My Release Workflow](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- **Scripts** (1): [Build And Deploy Chart](../helm/scripts/build-and-deploy-chart.sh)
- **Configs** (1): [Values File Vs Set Flags](../helm/configs/values-file-vs-set-flags.yaml)
- **Manifests** (2): [Minimal Service Chart](../helm/manifests/2026-09-21-minimal-service-chart.yaml), [First Chart Values](../helm/manifests/2026-07-15-first-chart-values.yaml)
- **Charts** (4): [Chart](../helm/charts/sample-app/Chart.yaml), [Values Dev](../helm/charts/sample-app/values-dev.yaml), [Values Prod](../helm/charts/sample-app/values-prod.yaml) _…and 1 more under `helm/` — browse the folder._

## Kubernetes  ·  20 files

- **primer:** [Primer Kubernetes](../kubernetes/notes/0000-primer-kubernetes.md)
- **Notes** (3): [Quickstart Followup](../kubernetes/notes/2026-10-20-quickstart-followup.md), [Cluster Resources](../kubernetes/notes/2026-10-14-cluster-resources.md), [Explore Kubernetes](../kubernetes/notes/2026-07-15-explore-kubernetes.md)
- **Docs** (2): [Cluster Workflow Wiring](../kubernetes/docs/cluster-workflow-wiring.md), [Rbac Design Patterns For Multi Tenant Clusters](../kubernetes/docs/rbac-design-patterns-for-multi-tenant-clusters.md)
- **Scripts** (2): [Quickstart Repro](../kubernetes/scripts/2026-10-20-quickstart-repro.sh), [Cluster Health Check And Conformance Validation](../kubernetes/scripts/cluster-health-check-and-conformance-validation.sh)
- **Configs** (3): [Minimal Deployment](../kubernetes/configs/2026-10-20-minimal-deployment.yaml), [Minimal Namespace](../kubernetes/configs/2026-10-14-minimal-namespace.yaml), [Namespace Strategy Environment Vs Team](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml)
- **Templates** (5): [Readme](../kubernetes/templates/cluster-bootstrap/README.md), [Cert Manager Bootstrap](../kubernetes/templates/cluster-bootstrap/cert-manager/cert-manager-bootstrap.yaml), [Calico Installation](../kubernetes/templates/cluster-bootstrap/cni/calico-installation.yaml) _…and 2 more under `kubernetes/` — browse the folder._
- **Manifests** (4): [First Pod](../kubernetes/manifests/2026-09-10-first-pod.yaml), [First Pod Service](../kubernetes/manifests/2026-07-15-first-pod-service.yaml), [Kustomize Overlays](../kubernetes/manifests/kustomize-overlays.yaml) _…and 1 more under `kubernetes/` — browse the folder._

## Kustomize  ·  17 files

- **primer:** [Primer Kustomize](../kustomize/notes/0000-primer-kustomize.md)
- **Notes** (2): [Kustomize Quickstart Tripped Me Up](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md), [Install Kustomize First Overlay](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md)
- **Docs** (1): [How I Wired Kustomize Into My Manifest Workflow](../kustomize/docs/how-i-wired-kustomize-into-my-manifest-workflow.md)
- **Scripts** (2): [Kustomize Tutorial](../kustomize/scripts/2026-10-20-kustomize-tutorial.sh), [Bases Vs Remote Resources](../kustomize/scripts/bases-vs-remote-resources.sh)
- **Configs** (10): [Minimal Kustomization With Overlay](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml), [Minimal Kustomization](../kustomize/configs/2026-07-08-minimal-kustomization.yaml), [Configmap](../kustomize/configs/environment-overlays/base/configmap.yaml) _…and 7 more under `kustomize/` — browse the folder._
- **Manifests** (1): [Kustomize Tutorial](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## Linux  ·  7 files

- **Notes** (3): [Explore Linux Environment](../linux/notes/2026-10-02-explore-linux-environment.md), [Linux Shell Scripting Tutorial Confusions](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md), [Install Linux Vm Terminal First Commands](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- **Docs** (1): [System Administration Runbook](../linux/docs/system-administration-runbook.md)
- **Scripts** (2): [Find Large Logs](../linux/scripts/find-large-logs.sh), [Health Check And Rollback](../linux/scripts/health-check-and-rollback.sh)
- **Configs** (1): [Cron Job Configuration](../linux/configs/2026-08-06-cron-job-configuration.ini)

## Nuclei  ·  5 files

- **primer:** [Primer Nuclei](../nuclei/notes/0000-primer-nuclei.md)
- **Notes** (2): [Nuclei Quickstart Trip Ups](../nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md), [First Template Scan Attempt](../nuclei/notes/2026-09-20-first-template-scan-attempt.md)
- **Scripts** (1): [First Nuclei Scan](../nuclei/scripts/2026-10-15-first-nuclei-scan.sh)
- **Configs** (1): [Minimal Scan Template](../nuclei/configs/2026-10-15-minimal-scan-template.yaml)

## OPA / Gatekeeper  ·  35 files

- **primer:** [Primer Opa](../opa/notes/0000-primer-opa.md)
- **Notes** (4): [Opa Install First Policy](../opa/notes/2026-10-27-opa-install-first-policy.md), [Install Opa First Policy Eval](../opa/notes/2026-10-24-install-opa-first-policy-eval.md), [Opa Getting Started Trip Ups](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md) _…and 1 more under `opa/` — browse the folder._
- **Docs** (4): [Constraint Template Design Patterns](../opa/docs/constraint-template-design-patterns.md), [Integrating Opa With Policy As Code Governance](../opa/docs/integrating-opa-with-policy-as-code-governance.md), [Opa Policy Version Migration Patterns](../opa/docs/opa-policy-version-migration-patterns.md) _…and 1 more under `opa/` — browse the folder._
- **Scripts** (2): [Export Audit Results](../opa/scripts/export-audit-results.sh), [How I Test Policies Locally](../opa/scripts/how-i-test-policies-locally.sh)
- **Configs** (2): [Opa Policy Configuration Template](../opa/configs/opa-policy-configuration-template.yaml), [Tried A Gatekeeper Constraint](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- **Snippets** (8): [First Rego Policy](../opa/snippets/2026-10-14-first-rego-policy.py), [Contradictory Deny](../opa/snippets/contradictory-deny.rego), [Deny Privileged Containers](../opa/snippets/deny-privileged-containers.rego) _…and 5 more under `opa/` — browse the folder._
- **Templates** (8): [Readme](../opa/templates/gatekeeper-policy-library-scaffold/README.md), [K8Sallowedregistries](../opa/templates/gatekeeper-policy-library-scaffold/constraint-templates/k8sallowedregistries.yaml), [K8Ssecuritybaseline](../opa/templates/gatekeeper-policy-library-scaffold/constraint-templates/k8ssecuritybaseline.yaml) _…and 5 more under `opa/` — browse the folder._
- **Manifests** (5): [Readme](../opa/manifests/README.md), [Constraint Templates](../opa/manifests/constraint-templates.yaml), [Constraints](../opa/manifests/constraints.yaml) _…and 2 more under `opa/` — browse the folder._
- **Notebooks** (1): [Rego Vs Builtin Policies](../opa/notebooks/rego-vs-builtin-policies.ipynb)

## OpenTofu  ·  10 files

- **primer:** [Primer Opentofu](../opentofu/notes/0000-primer-opentofu.md)
- **Notes** (3): [Follow Opentofu Test Quickstart](../opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md), [Follow Open Tofu Quickstart](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md), [Explore Open Tofu](../opentofu/notes/2026-07-20-explore-open-tofu.md)
- **Docs** (2): [How I Wired Opentofu Into My Iac Workflow](../opentofu/docs/how-i-wired-opentofu-into-my-iac-workflow.md), [Open Tofu Vs Terraform Migration Decision Matrix](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md)
- **Scripts** (1): [Module Registry Publisher](../opentofu/scripts/module-registry-publisher.sh)
- **Configs** (3): [Minimal Opentofu Config With Vars](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl), [Minimal Opentofu Config](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl), [First Open Tofu Config](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## Prometheus  ·  7 files

- **primer:** [Primer Prometheus](../prometheus/notes/0000-primer-prometheus.md)
- **Notes** (4): [Followed Quickstart](../prometheus/notes/2026-10-25-followed-quickstart.md), [First Query Log](../prometheus/notes/2026-10-14-first-query-log.md), [Observability Primer Dedup](../prometheus/notes/2026-10-14-observability-primer-dedup.md) _…and 1 more under `prometheus/` — browse the folder._
- **Scripts** (1): [Query Api Python](../prometheus/scripts/2026-10-25-query-api-python.py)
- **Snippets** (1): [Minimal Scrape Config](../prometheus/snippets/2026-10-25-minimal-scrape-config.yaml)

## Semgrep  ·  25 files

- **primer:** [Primer Semgrep](../semgrep/notes/0000-primer-semgrep.md)
- **Notes** (2): [Install Semgrep Pitfalls](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [Install Semgrep](../semgrep/notes/2026-05-25-install-semgrep.md)
- **Docs** (8): [Comparing Rule Writing Approaches](../semgrep/docs/comparing-rule-writing-approaches.md), [Github Actions Ci From Scratch](../semgrep/docs/github-actions-ci-from-scratch.md), [Semgrep Ci Integration](../semgrep/docs/semgrep-ci-integration.md) _…and 5 more under `semgrep/` — browse the folder._
- **Scripts** (3): [Bulk Scan Helper](../semgrep/scripts/bulk-scan-helper.py), [Detect Hardcoded Secrets](../semgrep/scripts/detect-hardcoded-secrets.py), [Scan Python Codebase](../semgrep/scripts/scan-python-codebase.sh)
- **Configs** (1): [Multi Rule Pack](../semgrep/configs/multi-rule-pack.yaml)
- **Snippets** (2): [Catch Privileged Containers](../semgrep/snippets/catch-privileged-containers.yaml), [First Custom Rule](../semgrep/snippets/first-custom-rule.yaml)
- **Manifests** (3): [Diff Aware Semgrep Ci](../semgrep/manifests/diff-aware-semgrep-ci.yaml), [Semgrep Ci Cd Pipeline](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml), [Semgrep Gitlab Ci](../semgrep/manifests/semgrep-gitlab-ci.yaml)
- **Dockerfiles** (2): [Ci Entrypoint](../semgrep/dockerfiles/ci-entrypoint.sh), [Custom Scanning Image](../semgrep/dockerfiles/custom-scanning-image.Dockerfile)
- **Notebooks** (3): [Comparing Community Vs Custom Rules](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb), [Rule Matching Mode Comparison](../semgrep/notebooks/rule-matching-mode-comparison.ipynb), [Semgrep Scan Vs Ci Comparison](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## Snyk  ·  29 files

- **primer:** [Primer Snyk](../snyk/notes/0000-primer-snyk.md)
- **Notes** (5): [Snyk Quickstart Tripped](../snyk/notes/2026-10-27-snyk-quickstart-tripped.md), [Explore Snyk Cli Commands](../snyk/notes/2026-10-07-explore-snyk-cli-commands.md), [First Vulnerability Scan](../snyk/notes/2026-06-14-first-vulnerability-scan.md) _…and 2 more under `snyk/` — browse the folder._
- **Docs** (4): [Integrating Snyk With Cicd Security Scanning](../snyk/docs/integrating-snyk-with-cicd-security-scanning.md), [Multi Project Ci Pipeline](../snyk/docs/multi-project-ci-pipeline.md), [Snyk Security Policy Migration Patterns](../snyk/docs/snyk-security-policy-migration-patterns.md) _…and 1 more under `snyk/` — browse the folder._
- **Scripts** (2): [First Snyk Test](../snyk/scripts/2026-10-20-first-snyk-test.sh), [Snyk Vuln Scan Pipeline](../snyk/scripts/snyk-vuln-scan-pipeline.sh)
- **Configs** (3): [Snyk Ci Github Actions](../snyk/configs/snyk-ci-github-actions.yaml), [Snyk Dependency Patch Ignore](../snyk/configs/snyk-dependency-patch-ignore.yaml), [Snyk Project Configuration Template](../snyk/configs/snyk-project-configuration-template.yaml)
- **Snippets** (1): [My First Snyk Commands](../snyk/snippets/my-first-snyk-commands.sh)
- **Templates** (10): [Snyk](../snyk/templates/snyk-multilang-scan-scaffold/.snyk), [Makefile](../snyk/templates/snyk-multilang-scan-scaffold/Makefile), [Readme](../snyk/templates/snyk-multilang-scan-scaffold/README.md) _…and 7 more under `snyk/` — browse the folder._
- **Manifests** (1): [Snyk Github Actions Cicd Workflow](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **Dockerfiles** (1): [Custom Snyk Cli Air Gapped](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- **Notebooks** (1): [Cli Vs Api Modes](../snyk/notebooks/cli-vs-api-modes.ipynb)

## SonarQube  ·  7 files

- **primer:** [Primer Sonarqube](../sonarqube/notes/0000-primer-sonarqube.md)
- **Notes** (2): [Follow Sonarqube Quickstart](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md), [Explore Sonarqube Quality Gates Profiles](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md)
- **Scripts** (1): [Sonarqube Scan Setup](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **Configs** (2): [Minimal Quality Gate](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml), [Minimal Project Quality Gate](../sonarqube/configs/minimal-project-quality-gate.yaml)
- **Snippets** (1): [First Sonarscanner Run](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## Syft  ·  44 files

- **primer:** [Primer Syft](../syft/notes/0000-primer-syft.md)
- **Notes** (4): [First Image Sbom](../syft/notes/2026-10-27-first-image-sbom.md), [Sbom Format Comparison](../syft/notes/2026-05-30-sbom-format-comparison.md), [Syft Quickstart Trip Ups](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md) _…and 1 more under `syft/` — browse the folder._
- **Docs** (8): [Enterprise Registry Auth Caching Patterns](../syft/docs/enterprise-registry-auth-caching-patterns.md), [Enterprise Registry Auth Caching](../syft/docs/enterprise-registry-auth-caching.md), [Output Format Selection Guide](../syft/docs/output-format-selection-guide.md) _…and 5 more under `syft/` — browse the folder._
- **Scripts** (5): [Scan Docker Images Aggregate Sboms](../syft/scripts/2026-10-27-scan-docker-images-aggregate-sboms.sh), [Gen Multi Format Sboms](../syft/scripts/gen-multi-format-sboms.sh), [Multi Image Sbom Pipeline](../syft/scripts/multi-image-sbom-pipeline.sh) _…and 2 more under `syft/` — browse the folder._
- **Configs** (1): [.Syft](../syft/configs/.syft.yaml)
- **Snippets** (3): [Syft Cli Output Formats](../syft/snippets/2026-10-27-syft-cli-output-formats.sh), [First Sbom](../syft/snippets/2026-10-14-first-sbom.sh), [Tried Sbom Formats](../syft/snippets/tried-sbom-formats.sh)
- **Templates** (13): [Gitignore](../syft/templates/sbom-pipeline-scaffold/.gitignore), [Makefile](../syft/templates/sbom-pipeline-scaffold/Makefile), [Readme](../syft/templates/sbom-pipeline-scaffold/README.md) _…and 10 more under `syft/` — browse the folder._
- **Manifests** (4): [Syft Cicd Pipeline](../syft/manifests/syft-cicd-pipeline.yaml), [Syft Gha Multi Arch Sbom Registry Auth](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml), [Syft Gha Sbom Oci Push Attestation](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml) _…and 1 more under `syft/` — browse the folder._
- **Dockerfiles** (1): [Multi Stage Sbom](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **Notebooks** (4): [Output Format Comparison](../syft/notebooks/output-format-comparison.ipynb), [Sbom Layer Package Analysis](../syft/notebooks/sbom-layer-package-analysis.ipynb), [Source Vs Library Multiarch](../syft/notebooks/source-vs-library-multiarch.ipynb) _…and 1 more under `syft/` — browse the folder._

## Terraform  ·  35 files

- **primer:** [Primer Terraform](../terraform/notes/0000-primer-terraform.md)
- **Notes** (2): [Install Terraform First Vm](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [Explore Terraform](../terraform/notes/2026-07-15-explore-terraform.md)
- **Docs** (2): [Terraform Module Composition](../terraform/docs/terraform-module-composition.md), [Terraform Testing Patterns](../terraform/docs/terraform-testing-patterns.md)
- **Scripts** (4): [Deploy](../terraform/scripts/2026-07-18-deploy.sh), [Cleanup](../terraform/scripts/2026-07-18-cleanup.sh), [Zip Build](../terraform/scripts/2026-07-13-zip-build.sh) _…and 1 more under `terraform/` — browse the folder._
- **Configs** (12): [Minimal Quickstart Config](../terraform/configs/2026-10-19-minimal-quickstart-config.hcl), [First Configuration](../terraform/configs/2026-08-04-first-configuration.hcl), [First Config](../terraform/configs/2026-07-15-first-config.tf) _…and 9 more under `terraform/` — browse the folder._
- **Snippets** (1): [Practice Terraform Variables Outputs Datasources](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- **Templates** (5): [Readme](../terraform/templates/module-registry-publish-consume/README.md), [Main](../terraform/templates/module-registry-publish-consume/main.tf), [Outputs](../terraform/templates/module-registry-publish-consume/outputs.tf) _…and 2 more under `terraform/` — browse the folder._
- **Manifests** (1): [Terraform Cloud Workspace Automation](../terraform/manifests/terraform-cloud-workspace-automation.hcl)
- **Eventbridge-Lambda** (7): [Dev](../terraform/eventbridge-lambda/environments/dev.tfvars), [Main](../terraform/eventbridge-lambda/main.tf), [Outputs](../terraform/eventbridge-lambda/modules/eventbridge/outputs.tf) _…and 4 more under `terraform/` — browse the folder._

## Terrascan  ·  22 files

- **primer:** [Primer Terrascan](../terrascan/notes/0000-primer-terrascan.md)
- **Notes** (4): [Terrascan Getting Started Trip Ups](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md), [Terrascan Getting Started Trip Ups](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md), [Install Terrascan Tiny Tf](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md) _…and 1 more under `terrascan/` — browse the folder._
- **Docs** (3): [Iac Pipeline Integration](../terrascan/docs/iac-pipeline-integration.md), [Terrascan Scan Configuration Migration Patterns](../terrascan/docs/terrascan-scan-configuration-migration-patterns.md), [Terrascan Vs Checkov Terraform Iac Scanning](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md)
- **Scripts** (2): [Policy As Code Workflow](../terrascan/scripts/policy-as-code-workflow.sh), [Tried Terrascan Ci Scan](../terrascan/scripts/tried-terrascan-ci-scan.sh)
- **Configs** (2): [Terrascan Config Template](../terrascan/configs/terrascan-config-template.yaml), [Tried Custom S3 Rule](../terrascan/configs/tried-custom-s3-rule.yaml)
- **Snippets** (2): [Insecure Terraform](../terrascan/snippets/insecure-terraform.tf), [Tiny Tf With Findings](../terrascan/snippets/tiny-tf-with-findings.tf)
- **Templates** (6): [Gitignore](../terrascan/templates/scanning-pipeline-scaffold/.gitignore), [Readme](../terrascan/templates/scanning-pipeline-scaffold/README.md), [Config](../terrascan/templates/scanning-pipeline-scaffold/config.yaml) _…and 3 more under `terrascan/` — browse the folder._
- **Manifests** (1): [Terrascan Gha Ci Multi Iac](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **Notebooks** (1): [Rego Vs Yaml Rule Authoring](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)

## Tetragon  ·  11 files

- **primer:** [Primer Tetragon](../tetragon/notes/0000-primer-tetragon.md)
- **Notes** (2): [Tetragon Observability Tutorial](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [Install Tetragon Docker First Events](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md)
- **Docs** (1): [Runtime Security Workflow](../tetragon/docs/runtime-security-workflow.md)
- **Scripts** (3): [Tetragon Event Collection Pipeline](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh), [Build Tetragon File Access Tracing Policy](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh), [Build Tetragon Policy](../tetragon/scripts/build-tetragon-policy.sh)
- **Configs** (4): [Minimal Network Tracing Policy](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml), [First Tracing Policy Exec File](../tetragon/configs/first-tracing-policy-exec-file.yaml), [Policy Approaches Comparison](../tetragon/configs/policy-approaches-comparison.yaml) _…and 1 more under `tetragon/` — browse the folder._

## tfsec  ·  6 files

- **primer:** [Primer Tfsec](../tfsec/notes/0000-primer-tfsec.md)
- **Notes** (2): [Followed Tfsec Quickstart What Tripped Me Up](../tfsec/notes/2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md), [First Tfsec Scan](../tfsec/notes/2026-09-20-first-tfsec-scan.md)
- **Scripts** (1): [Ran My First Tfsec Scan](../tfsec/scripts/2026-10-19-ran-my-first-tfsec-scan.sh)
- **Configs** (1): [Minimal Tfsec Scan Config](../tfsec/configs/2026-10-19-minimal-tfsec-scan-config.yaml)
- **Snippets** (1): [Enforce S3 Bucket Encryption](../tfsec/snippets/enforce-s3-bucket-encryption.rego)

## Trivy  ·  40 files

- **primer:** [Primer Trivy](../trivy/notes/0000-primer-trivy.md)
- **Notes** (7): [Trivy First Image Scan](../trivy/notes/2026-10-19-trivy-first-image-scan.md), [Quickstart Trip Ups](../trivy/notes/2026-10-14-quickstart-trip-ups.md), [Install Trivy First Container Scan](../trivy/notes/2026-09-05-install-trivy-first-container-scan.md) _…and 4 more under `trivy/` — browse the folder._
- **Docs** (6): [Ci Cd Pipeline Recipes](../trivy/docs/ci-cd-pipeline-recipes.md), [Ci Pipeline Sarif Output](../trivy/docs/ci-pipeline-sarif-output.md), [Multi Arch Vulnerability Scanning](../trivy/docs/multi-arch-vulnerability-scanning.md) _…and 3 more under `trivy/` — browse the folder._
- **Scripts** (6): [Compose Multi Scan](../trivy/scripts/compose-multi-scan.sh), [Container Vuln Scan](../trivy/scripts/container-vuln-scan.sh), [Custom Trivy Check Conftest](../trivy/scripts/custom-trivy-check-conftest.sh) _…and 3 more under `trivy/` — browse the folder._
- **Configs** (4): [Minimal Trivy Config](../trivy/configs/2026-10-19-minimal-trivy-config.yaml), [.Trivy](../trivy/configs/.trivy.yaml), [Trivy Ci Gate](../trivy/configs/trivy-ci-gate.yml) _…and 1 more under `trivy/` — browse the folder._
- **Snippets** (1): [Scan Docker Image](../trivy/snippets/scan-docker-image.sh)
- **Templates** (10): [Readme](../trivy/templates/trivy-k8s-workload-scanning/README.md), [K8S Scan Cronjob](../trivy/templates/trivy-k8s-workload-scanning/k8s-scan-cronjob.yaml), [K8S Scan Job](../trivy/templates/trivy-k8s-workload-scanning/k8s-scan-job.yaml) _…and 7 more under `trivy/` — browse the folder._
- **Manifests** (2): [Trivy Operator Deployment](../trivy/manifests/trivy-operator-deployment.yaml), [Trivy Sarif Code Scanning](../trivy/manifests/trivy-sarif-code-scanning.yaml)
- **Dockerfiles** (1): [Custom Policies](../trivy/dockerfiles/custom-policies.Dockerfile)
- **Notebooks** (2): [Trivy Sarif Output Processing](../trivy/notebooks/trivy-sarif-output-processing.ipynb), [Trivy Scan Mode Comparison](../trivy/notebooks/trivy-scan-mode-comparison.ipynb)

## TruffleHog  ·  49 files

- **primer:** [Primer Trufflehog](../trufflehog/notes/0000-primer-trufflehog.md)
- **Notes** (3): [Explore Cli](../trufflehog/notes/2026-07-27-explore-cli.md), [Following Trufflehog Quickstart](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md), [Install Trufflehog](../trufflehog/notes/2026-05-27-install-trufflehog.md)
- **Docs** (4): [Comparing Scan Modes Git Filesystem S3](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md), [Trufflehog Integration Reference Secret Detection](../trufflehog/docs/trufflehog-integration-reference-secret-detection.md), [Trufflehog Output Formats Json Sarif Csv](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md) _…and 1 more under `trufflehog/` — browse the folder._
- **Scripts** (3): [Analyze Trufflehog Results](../trufflehog/scripts/analyze-trufflehog-results.py), [Multi Repo Scan Pipeline](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [Pre Commit Scan Pipeline](../trufflehog/scripts/pre-commit-scan-pipeline.sh)
- **Configs** (2): [Custom Detector Rules](../trufflehog/configs/custom-detector-rules.yaml), [Trufflehog Custom Regex Config](../trufflehog/configs/trufflehog-custom-regex-config.yaml)
- **Snippets** (3): [First Secret Scan](../trufflehog/snippets/2026-10-14-first-secret-scan.sh), [Fake Secrets Test](../trufflehog/snippets/fake-secrets-test.sh), [Scan Github Repo For Secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- **Templates** (26): [Gitignore](../trufflehog/templates/github-secret-scanning-integration/.gitignore), [Makefile](../trufflehog/templates/github-secret-scanning-integration/Makefile), [Readme](../trufflehog/templates/github-secret-scanning-integration/README.md) _…and 23 more under `trufflehog/` — browse the folder._
- **Manifests** (2): [Trufflehog Cicd Pipeline](../trufflehog/manifests/trufflehog-cicd-pipeline.yaml), [Trufflehog Pr Secret Scan Reusable](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- **Dockerfiles** (2): [Pipeline Scanner](../trufflehog/dockerfiles/pipeline-scanner.Dockerfile), [Pre Commit Scanner](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile)
- **Notebooks** (3): [Analyzing Trufflehog False Positives](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb), [Detector Comparison Patterns](../trufflehog/notebooks/detector-comparison-patterns.ipynb), [Trufflehog Scan Modes Comparison](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb)

## HashiCorp Vault  ·  21 files

- **primer:** [Primer Vault](../vault/notes/0000-primer-vault.md)
- **Notes** (3): [Install Vault First Command](../vault/notes/2026-08-26-install-vault-first-command.md), [Vault Getting Started Trip Ups](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md), [Install Vault And Explore Cli](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
- **Docs** (3): [Configuring Vault Dev Server](../vault/docs/configuring-vault-dev-server.md), [Vault Agent Auto Auth Kubernetes](../vault/docs/vault-agent-auto-auth-kubernetes.md), [Vault Secrets Engine Selection Guide](../vault/docs/vault-secrets-engine-selection-guide.md)
- **Scripts** (4): [Cloud Iam Dynamic Secrets](../vault/scripts/cloud-iam-dynamic-secrets.sh), [Vault Db Dynamic Secrets](../vault/scripts/vault-db-dynamic-secrets.sh), [Vault Kv Crud](../vault/scripts/vault-kv-crud.sh) _…and 1 more under `vault/` — browse the folder._
- **Configs** (3): [Aws Secrets Engine Policy](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl), [Dev Test Policies](../vault/configs/2026-06-26-dev-test-policies.hcl), [Multi Environment Access Control](../vault/configs/multi-environment-access-control.hcl)
- **Snippets** (2): [First Vault Secret](../vault/snippets/2026-08-30-first-vault-secret.sh), [Vault Read Write](../vault/snippets/vault-read-write.go)
- **Manifests** (2): [Vault Cluster Deployment](../vault/manifests/vault-cluster-deployment.yaml), [Vault Sidecar Secrets Refresh](../vault/manifests/vault-sidecar-secrets-refresh.yaml)
- **Dockerfiles** (1): [Custom Vault Image With Plugins Tls](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **Notebooks** (2): [Static Vs Dynamic Secrets](../vault/notebooks/static-vs-dynamic-secrets.ipynb), [Vault Secrets Backend Comparison Patterns](../vault/notebooks/vault-secrets-backend-comparison-patterns.ipynb)

## OWASP ZAP  ·  31 files

- **primer:** [Primer Zap](../zap/notes/0000-primer-zap.md)
- **Notes** (5): [Install Zap First Baseline Scan](../zap/notes/2026-09-05-install-zap-first-baseline-scan.md), [Install Zap Baseline Scan](../zap/notes/2026-07-20-install-zap-baseline-scan.md), [Spider Scan Test App](../zap/notes/2026-06-13-spider-scan-test-app.md) _…and 2 more under `zap/` — browse the folder._
- **Docs** (5): [Passive Vs Active Scanning Zap](../zap/docs/passive-vs-active-scanning-zap.md), [Zap Automation Plan Structure](../zap/docs/zap-automation-plan-structure.md), [Zap Integration Patterns](../zap/docs/zap-integration-patterns.md) _…and 2 more under `zap/` — browse the folder._
- **Scripts** (3): [Dast Workflow From Scratch](../zap/scripts/dast-workflow-from-scratch.sh), [Zap Baseline Scan](../zap/scripts/zap-baseline-scan.sh), [Zap Dast Sarif Code Scanning](../zap/scripts/zap-dast-sarif-code-scanning.sh)
- **Configs** (3): [Ci Dast Automation Framework Plan](../zap/configs/ci-dast-automation-framework-plan.yaml), [Zap Authenticated Scan Context](../zap/configs/zap-authenticated-scan-context.yaml), [Zap Dast Github Actions Workflow](../zap/configs/zap-dast-github-actions-workflow.yaml)
- **Snippets** (4): [Zap Docker Quickstart Json Export](../zap/snippets/2026-07-16-zap-docker-quickstart-json-export.sh), [Authenticated Scan With Context](../zap/snippets/authenticated-scan-with-context.sh), [My First Zap Baseline Scan](../zap/snippets/my-first-zap-baseline-scan.sh) _…and 1 more under `zap/` — browse the folder._
- **Templates** (7): [Gitignore](../zap/templates/zap-dast-integration-scaffold/.gitignore), [Makefile](../zap/templates/zap-dast-integration-scaffold/Makefile), [Readme](../zap/templates/zap-dast-integration-scaffold/README.md) _…and 4 more under `zap/` — browse the folder._
- **Manifests** (1): [Zap Cicd Pipeline](../zap/manifests/zap-cicd-pipeline.yaml)
- **Dockerfiles** (1): [Custom Zap Automation](../zap/dockerfiles/custom-zap-automation.Dockerfile)
- **Notebooks** (1): [Scan Strategy Comparison Patterns](../zap/notebooks/scan-strategy-comparison-patterns.ipynb)
