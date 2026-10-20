# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## ansible  ·  27 files

- **notes** (3): [Roles Vs Tasks](../ansible/notes/roles-vs-tasks.md), [Followed Ansible Quickstart What Tripped Me Up](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md), [Verify Ansible Cve 2026 33228 Paths](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md)
- **docs** (1): [Wired Ansible Infrastructure Workflow](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **scripts** (4): [Reusable Inventory Generator From Terraform Outputs For Ansible](../ansible/scripts/reusable-inventory-generator-from-terraform-outputs-for-ansible.py), [Bootstrap](../ansible/scripts/bootstrap.sh), [Bootstrap Target Node](../ansible/scripts/bootstrap-target-node.sh)  — _…and 1 more under `ansible/scripts/`._
- **configs** (3): [Terraform Nginx Integration](../ansible/configs/terraform-nginx-integration.yaml), [Small Ansible Project](../ansible/configs/small-ansible-project.yaml), [Inventory Groups Host Vars](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml)
- **snippets** (1): [Minimal Ansible Playbook Package Service](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- **templates** (15): [Site](../ansible/templates/ansible-roles-staging-production/site.yml), [Main](../ansible/templates/ansible-roles-staging-production/roles/common/vars/main.yml), [Example.service](../ansible/templates/ansible-roles-staging-production/roles/common/templates/example.service.j2)  — _…and 12 more under `ansible/templates/`._

## argocd  ·  13 files

- **primer:** [0000 Primer Argocd](../argocd/notes/0000-primer-argocd.md)
- **notes** (5): [Quickstart Tripups](../argocd/notes/2026-08-12-quickstart-tripups.md), [Verify Readme Layout](../argocd/notes/2026-08-01-verify-readme-layout.md), [Verify Readme Layout](../argocd/notes/2026-07-31-verify-readme-layout.md)  — _…and 2 more under `argocd/notes/`._
- **docs** (2): [Multi Environment Gitops Delivery](../argocd/docs/multi-environment-gitops-delivery.md), [Gitops Workflow Wiring](../argocd/docs/gitops-workflow-wiring.md)
- **configs** (2): [Values Dev](../argocd/configs/2026-09-20-values-dev.yaml), [Private Repo Credentials Rbac](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- **manifests** (3): [Helm Guestbook Application](../argocd/manifests/helm-guestbook-application.yaml), [Gitops Sync Sample Web App](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml), [Sample App Application](../argocd/manifests/2026-07-06-sample-app-application.yaml)

## checkov  ·  45 files

- **primer:** [0000 Primer Checkov](../checkov/notes/0000-primer-checkov.md)
- **notes** (3): [Checkov Quickstart Trip Ups](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md), [Cli Vs Sdk Comparison](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [Scan Terraform Plan](../checkov/notes/2026-05-25-scan-terraform-plan.md)
- **docs** (6): [Pre Commit Hook With Version Pinning](../checkov/docs/pre-commit-hook-with-version-pinning.md), [Multi Cloud Policy Management](../checkov/docs/multi-cloud-policy-management.md), [Checkov V3 Upgrade Checklist](../checkov/docs/checkov-v3-upgrade-checklist.md)  — _…and 3 more under `checkov/docs/`._
- **scripts** (4): [Validate Policies](../checkov/scripts/validate-policies.sh), [Scan Terraform Plan](../checkov/scripts/scan-terraform-plan.sh), [Deep Terraform Plan Scan](../checkov/scripts/deep-terraform-plan-scan.sh)  — _…and 1 more under `checkov/scripts/`._
- **configs** (3): [Platform Config](../checkov/configs/platform-config.yaml), [Checkov Skip Severity Config](../checkov/configs/checkov-skip-severity-config.yaml), [Checkov Ci Config](../checkov/configs/checkov-ci-config.yaml)
- **snippets** (4): [Terraform Scan Custom Policies](../checkov/snippets/terraform-scan-custom-policies.py), [Scan Terraform Dir](../checkov/snippets/scan-terraform-dir.py), [Scan Kubernetes](../checkov/snippets/scan-kubernetes.sh)  — _…and 1 more under `checkov/snippets/`._
- **manifests** (3): [Layered Checkov Ci Pr Gate Deep Scan Merge Block](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml), [Checkov Sarif Pr Blocking](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [Checkov Gitlab Ci Multi Cloud Drift](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml)
- **notebooks** (4): [Compare Static Vs Plan Scanning](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb), [Compare Custom Policy Expressiveness](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb), [Compare Cross Module Scanning Limitations](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb)  — _…and 1 more under `checkov/notebooks/`._
- **policies** (1): [No Public S3 Buckets](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)
- **templates** (16): [Example Caller Workflow](../checkov/templates/reusable-workflow-custom-policies/example-caller-workflow.yml), [Restrict Ec2 Public Ip](../checkov/templates/reusable-workflow-custom-policies/custom-policies/restrict_ec2_public_ip.yaml), [No Public S3 Buckets](../checkov/templates/reusable-workflow-custom-policies/custom-policies/no_public_s3_buckets.yaml)  — _…and 13 more under `checkov/templates/`._

## codeql  ·  28 files

- **primer:** [0000 Primer Codeql](../codeql/notes/0000-primer-codeql.md)
- **notes** (3): [Install Codeql First Query](../codeql/notes/2026-08-26-install-codeql-first-query.md), [Codeql Datalog Gotchas](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md), [Install Codeql First Analysis](../codeql/notes/2026-06-05-install-codeql-first-analysis.md)
- **docs** (4): [Wired Custom Queries Into Ci](../codeql/docs/wired-custom-queries-into-ci.md), [Query Writing Patterns Dataflow Javascript Typescript](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md), [Codeql Integration Reference](../codeql/docs/codeql-integration-reference.md)  — _…and 1 more under `codeql/docs/`._
- **scripts** (1): [First Codeql Analysis](../codeql/scripts/first-codeql-analysis.sh)
- **configs** (1): [First Codeql Analysis](../codeql/configs/first-codeql-analysis.yml)
- **snippets** (5): [My First Codeql Commands](../codeql/snippets/my-first-codeql-commands.sh), [Hardcoded Secret From Scratch.ql](../codeql/snippets/hardcoded-secret-from-scratch.ql), [Hardcoded Creds Local Flow.ql](../codeql/snippets/hardcoded-creds-local-flow.ql)  — _…and 2 more under `codeql/snippets/`._
- **manifests** (3): [Multi Language Codeql Analysis](../codeql/manifests/multi-language-codeql-analysis.yaml), [Codeql Multi Language Scan](../codeql/manifests/codeql-multi-language-scan.yaml), [Codeql Cicd Pipeline](../codeql/manifests/codeql-cicd-pipeline.yaml)
- **dockerfiles** (1): [Custom Codeql Analysis Image](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **notebooks** (2): [Compare Cli Vs Actions Scan Modes](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb), [Codeql Query Comparison Patterns](../codeql/notebooks/codeql-query-comparison-patterns.ipynb)
- **templates** (7): [Custom Suite.qls](../codeql/templates/custom-query-pack-ci-harness/suites/custom-suite.qls), [Test Pack](../codeql/templates/custom-query-pack-ci-harness/scripts/test-pack.sh), [Hardcoded Credential Check.ql](../codeql/templates/custom-query-pack-ci-harness/queries/hardcoded-credential-check.ql)  — _…and 4 more under `codeql/templates/`._

## cosign  ·  19 files

- **primer:** [0000 Primer Cosign](../cosign/notes/0000-primer-cosign.md)
- **notes** (4): [Install Cosign First Signing Command](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md), [Cosign Getting Started Trip Ups](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [Install Cosign Generate First Keypair](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md)  — _…and 1 more under `cosign/notes/`._
- **docs** (3): [Key Rotation And Migration Patterns](../cosign/docs/key-rotation-and-migration-patterns.md), [Cosign Verification Patterns](../cosign/docs/cosign-verification-patterns.md), [Container Signing Pipeline](../cosign/docs/container-signing-pipeline.md)
- **scripts** (3): [Verify Signed Image](../cosign/scripts/verify-signed-image.sh), [Minimal Sign Verify](../cosign/scripts/minimal-sign-verify.sh), [Cosign Key Management Workflow](../cosign/scripts/cosign-key-management-workflow.sh)
- **configs** (2): [Keyless Signing Github Actions](../cosign/configs/keyless-signing-github-actions.yaml), [Cosign Signature Configuration](../cosign/configs/cosign-signature-configuration.yaml)
- **snippets** (1): [First Cosign Sign Verify Image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (2): [Signed Container Build Oidc](../cosign/manifests/signed-container-build-oidc.yaml), [Keyless Oidc Ci](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml)
- **dockerfiles** (2): [Entrypoint](../cosign/dockerfiles/entrypoint.sh), [Custom Cosign Image](../cosign/dockerfiles/custom-cosign-image.Dockerfile)
- **notebooks** (1): [Key Based Vs Keyless Signing](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## defectdojo  ·  8 files

- **primer:** [0000 Primer Defectdojo](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (3): [Followed Defectdojo Quickstart What Tripped Me Up](../defectdojo/notes/2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md), [Quickstart Tripups](../defectdojo/notes/2026-09-21-quickstart-tripups.md), [Explore Defectdojo Ui](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md)
- **scripts** (1): [Defectdojo Tutorial Check](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh)
- **configs** (1): [Vulnerability Scanner Setup](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml)
- **snippets** (2): [Install Defectdojo First Scan Report](../defectdojo/snippets/install-defectdojo-first-scan-report.sh), [Minimal Product Setup Api](../defectdojo/snippets/2026-10-19-minimal-product-setup-api.py)

## dependabot  ·  19 files

- **primer:** [0000 Primer Dependabot](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (6): [Dependabot Alerts Security Updates](../dependabot/notes/dependabot-alerts-security-updates.md), [Dependabot Custom Registry Tutorial](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md), [Enabling Dependabot Alerts Security Updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md)  — _…and 3 more under `dependabot/notes/`._
- **docs** (4): [Wired Dependabot Version Control Workflow](../dependabot/docs/wired-dependabot-version-control-workflow.md), [Dependabot Version Control Workflow Integration](../dependabot/docs/dependabot-version-control-workflow-integration.md), [Dependabot Security Update Auto Merge](../dependabot/docs/dependabot-security-update-auto-merge.md)  — _…and 1 more under `dependabot/docs/`._
- **scripts** (2): [Dependabot Alert Aggregation](../dependabot/scripts/dependabot-alert-aggregation.py), [Dependabot Alert Triage](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py)
- **configs** (5): [Tried Npm Dependabot](../dependabot/configs/tried-npm-dependabot.yaml), [Monorepo Ecosystem Schedules Reviewers](../dependabot/configs/monorepo-ecosystem-schedules-reviewers.yaml), [Dependabot Configuration Template](../dependabot/configs/dependabot-configuration-template.yaml)  — _…and 2 more under `dependabot/configs/`._
- **notebooks** (1): [Auto Merge Vs Manual Review](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## docker  ·  18 files

- **primer:** [0000 Primer Docker](../docker/notes/0000-primer-docker.md)
- **notes** (1): [Explore Docker Cli](../docker/notes/2026-07-12-explore-docker-cli.md)
- **docs** (2): [Dockerfile Optimization Patterns](../docker/docs/dockerfile-optimization-patterns.md), [Cicd End To End](../docker/docs/cicd-end-to-end.md)
- **scripts** (3): [Reusable Build](../docker/scripts/reusable-build.sh), [Build Multi Service Compose App](../docker/scripts/build-multi-service-compose-app.sh), [Custom Network Volume Mounts](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh)
- **configs** (1): [Docker Compose Dev Environment](../docker/configs/docker-compose-dev-environment.yaml)
- **manifests** (1): [Docker Compose Production](../docker/manifests/docker-compose-production.yaml)
- **dockerfiles** (2): [First Custom Docker Image](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [First Custom Image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)
- **templates** (7): [Index.html](../docker/templates/multi-service-setup/web/index.html), [Dockerfile](../docker/templates/multi-service-setup/web/Dockerfile), [Compose](../docker/templates/multi-service-setup/compose.yaml)  — _…and 4 more under `docker/templates/`._

## falco  ·  24 files

- **primer:** [0000 Primer Falco](../falco/notes/0000-primer-falco.md)
- **notes** (4): [Install Falco First Event](../falco/notes/2026-10-15-install-falco-first-event.md), [Explore Falco Cli Rules Events Output](../falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md), [Falco Rules Macros Lists](../falco/notes/2026-06-15-falco-rules-macros-lists.md)  — _…and 1 more under `falco/notes/`._
- **docs** (4): [Tuned Falco Rules Noise Reduction](../falco/docs/tuned-falco-rules-noise-reduction.md), [Syscall Vs Tracepoint Rules](../falco/docs/syscall-vs-tracepoint-rules.md), [Runtime Security Monitoring Integration](../falco/docs/runtime-security-monitoring-integration.md)  — _…and 1 more under `falco/docs/`._
- **scripts** (3): [Tried Falco K8s Deploy Alert Forwarding](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh), [Tried Falco K8s Alert Forwarding](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [Deploy Falco Ruleset](../falco/scripts/deploy-falco-ruleset.sh)
- **configs** (4): [First Custom Rule Detect Shell In Container](../falco/configs/first-custom-rule-detect-shell-in-container.yaml), [Container Drift Detection](../falco/configs/container-drift-detection.yaml), [Minimal Runtime Config](../falco/configs/2026-10-03-minimal-runtime-config.yaml)  — _…and 1 more under `falco/configs/`._
- **snippets** (1): [Tried File Access Detector](../falco/snippets/tried-file-access-detector.go)
- **manifests** (1): [Falco K8s Admission Control](../falco/manifests/falco-k8s-admission-control.yaml)
- **notebooks** (2): [Rule Engine Vs Ebpf Probes](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb), [Falco Event Output Formats](../falco/notebooks/falco-event-output-formats.ipynb)
- **templates** (4): [Test Rules](../falco/templates/falco-custom-rules-library/tests/test-rules.sh), [Custom Rules](../falco/templates/falco-custom-rules-library/rules/custom-rules.yaml), [Override Example](../falco/templates/falco-custom-rules-library/examples/override-example.yaml)  — _…and 1 more under `falco/templates/`._

## git  ·  10 files

- **primer:** [0000 Primer Git](../git/notes/0000-primer-git.md)
- **notes** (2): [Install Git Identity First Commit](../git/notes/2026-07-12-install-git-identity-first-commit.md), [Git Branching Merge Confusions](../git/notes/2026-07-04-git-branching-merge-confusions.md)
- **docs** (1): [How I Wired Git Into My Version Control Workflow](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **scripts** (4): [Git Automation](../git/scripts/git-automation.sh), [First Repo Stage Log](../git/scripts/2026-08-24-first-repo-stage-log.sh), [Bump Version](../git/scripts/2026-07-12-bump-version.sh)  — _…and 1 more under `git/scripts/`._
- **configs** (1): [Config Strategy Layered Vs Conditional](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **snippets** (1): [Git Rebase Vs Merge Conflict Patterns](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## gitguardian  ·  27 files

- **primer:** [0000 Primer Gitguardian](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (4): [Explore Interface](../gitguardian/notes/2026-10-14-explore-interface.md), [First Secrets Scan Repo](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md), [Ggshield Quickstart Trip Ups](../gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md)  — _…and 1 more under `gitguardian/notes/`._
- **docs** (4): [Monorepo Ci Per Team Exclusions](../gitguardian/docs/monorepo-ci-per-team-exclusions.md), [Gitguardian Secret Scanning Migration Patterns](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md), [Gitguardian Incident Response Workflow](../gitguardian/docs/gitguardian-incident-response-workflow.md)  — _…and 1 more under `gitguardian/docs/`._
- **scripts** (4): [Pre Commit Hook Ggshield](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [Gitguardian Api Integration](../gitguardian/scripts/gitguardian-api-integration.py), [Gg Incident Response Pipeline](../gitguardian/scripts/gg-incident-response-pipeline.sh)  — _…and 1 more under `gitguardian/scripts/`._
- **configs** (3): [Policy Configuration](../gitguardian/configs/policy-configuration.yaml), [Monorepo Allowlists](../gitguardian/configs/monorepo-allowlists.yaml), [.ggshield](../gitguardian/configs/.ggshield.yaml)
- **snippets** (2): [My First Ggshield Commands](../gitguardian/snippets/my-first-ggshield-commands.sh), [Custom Policy Engine Ggshield](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- **notebooks** (1): [Choosing Between On Premise And Cloud Modes](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb)
- **templates** (8): [Scan Multi Repo](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/scripts/scan-multi-repo.sh), [Aggregate Report](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/scripts/aggregate-report.sh), [Repos](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/repos.txt)  — _…and 5 more under `gitguardian/templates/`._

## github-actions  ·  18 files

- **primer:** [0000 Primer Github Actions](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (6): [Followed Quickstart](../github-actions/notes/2026-10-20-followed-quickstart.md), [Run First Workflow](../github-actions/notes/2026-10-14-run-first-workflow.md), [Quickstart Tripped Me Up](../github-actions/notes/2026-09-21-quickstart-tripped-me-up.md)  — _…and 3 more under `github-actions/notes/`._
- **configs** (6): [Minimal Ci](../github-actions/configs/2026-10-20-minimal-ci.yaml), [First Scheduled Workflow](../github-actions/configs/2026-10-14-first-scheduled-workflow.yaml), [Minimal Starter Workflow](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml)  — _…and 3 more under `github-actions/configs/`._
- **snippets** (3): [Trigger First Workflow Gh](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh), [First Workflow](../github-actions/snippets/2026-08-26-first-workflow.yaml), [Composite Action Input Reuse](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- **manifests** (2): [What Is Github Actions](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [Pr Validation](../github-actions/manifests/2026-08-04-pr-validation.yml)

## gitleaks  ·  6 files

- **primer:** [0000 Primer Gitleaks](../gitleaks/notes/0000-primer-gitleaks.md)
- **notes** (2): [Quickstart Trip Ups](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md), [First Secret Scan](../gitleaks/notes/2026-09-19-first-secret-scan.md)
- **scripts** (2): [Auditing Git Secrets](../gitleaks/scripts/2026-10-13-auditing-git-secrets.sh), [Run First Gitleaks Scan](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh)
- **configs** (1): [Detection Rules](../gitleaks/configs/2026-10-07-detection-rules.yaml)

## grafana  ·  7 files

- **primer:** [0000 Primer Grafana](../grafana/notes/0000-primer-grafana.md)
- **notes** (3): [Grafana Quickstart Trip Ups](../grafana/notes/2026-10-14-grafana-quickstart-trip-ups.md), [Explore Grafana Dashboard Ui](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md), [First Dashboard Browser](../grafana/notes/2026-09-19-first-dashboard-browser.md)
- **configs** (2): [Dashboard Provisioning](../grafana/configs/2026-10-14-dashboard-provisioning.yaml), [First Datasource](../grafana/configs/2026-09-19-first-datasource.yaml)
- **snippets** (1): [First Grafana Datasource Query](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)

## grype  ·  25 files

- **primer:** [0000 Primer Grype](../grype/notes/0000-primer-grype.md)
- **notes** (4): [Explore Vulnerability Database](../grype/notes/2026-10-14-explore-vulnerability-database.md), [First Grype Scan](../grype/notes/2026-06-08-first-grype-scan.md), [Grype Quickstart Trip Ups](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md)  — _…and 1 more under `grype/notes/`._
- **docs** (3): [Vulnerability Management Pipeline Integration](../grype/docs/vulnerability-management-pipeline-integration.md), [Grype Vulnerability Reporting Migration Patterns](../grype/docs/grype-vulnerability-reporting-migration-patterns.md), [Grype Syft Integration Guide](../grype/docs/grype-syft-integration-guide.md)
- **scripts** (8): [Vuln Diff Two Images](../grype/scripts/vuln-diff-two-images.sh), [Minimal Grype Scan](../grype/scripts/minimal-grype-scan.sh), [Grype Vuln Pipeline](../grype/scripts/grype-vuln-pipeline.sh)  — _…and 5 more under `grype/scripts/`._
- **configs** (2): [Grype Filtering Configuration Template](../grype/configs/grype-filtering-configuration-template.yaml), [Grype Ci Github Actions](../grype/configs/grype-ci-github-actions.yaml)
- **snippets** (2): [My First Grype Commands](../grype/snippets/my-first-grype-commands.sh), [Minimal Grype Scan](../grype/snippets/minimal-grype-scan.go)
- **manifests** (2): [Grype Sarif Reusable Workflow](../grype/manifests/grype-sarif-reusable-workflow.yaml), [Grype Reusable Sarif Workflow](../grype/manifests/grype-reusable-sarif-workflow.yaml)
- **dockerfiles** (1): [Multi Stage Grype Scan](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (2): [Grype Sbom Output Explorer](../grype/notebooks/grype-sbom-output-explorer.ipynb), [Grype Db Vs Registry Sources](../grype/notebooks/grype-db-vs-registry-sources.ipynb)

## helm  ·  6 files

- **primer:** [0000 Primer Helm](../helm/notes/0000-primer-helm.md)
- **notes** (3): [Followed Quickstart](../helm/notes/2026-10-20-followed-quickstart.md), [Quickstart Tripped Me Up](../helm/notes/2026-09-21-quickstart-tripped-me-up.md), [Explore Helm Charts Releases Values Repos](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md)
- **manifests** (2): [Minimal Service Chart](../helm/manifests/2026-09-21-minimal-service-chart.yaml), [First Chart Values](../helm/manifests/2026-07-15-first-chart-values.yaml)

## kubernetes  ·  9 files

- **primer:** [0000 Primer Kubernetes](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (2): [Cluster Resources](../kubernetes/notes/2026-10-14-cluster-resources.md), [Explore Kubernetes](../kubernetes/notes/2026-07-15-explore-kubernetes.md)
- **docs** (1): [Cluster Workflow Wiring](../kubernetes/docs/cluster-workflow-wiring.md)
- **configs** (2): [Namespace Strategy Environment Vs Team](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml), [Minimal Namespace](../kubernetes/configs/2026-10-14-minimal-namespace.yaml)
- **manifests** (3): [Small Deployment From Scratch](../kubernetes/manifests/small-deployment-from-scratch.yaml), [First Pod](../kubernetes/manifests/2026-09-10-first-pod.yaml), [First Pod Service](../kubernetes/manifests/2026-07-15-first-pod-service.yaml)

## kustomize  ·  6 files

- **primer:** [0000 Primer Kustomize](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (2): [Kustomize Quickstart Tripped Me Up](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md), [Install Kustomize First Overlay](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md)
- **configs** (2): [Minimal Kustomization With Overlay](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml), [Minimal Kustomization](../kustomize/configs/2026-07-08-minimal-kustomization.yaml)
- **manifests** (1): [Kustomize Tutorial](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## linux  ·  6 files

- **notes** (3): [Explore Linux Environment](../linux/notes/2026-10-02-explore-linux-environment.md), [Linux Shell Scripting Tutorial Confusions](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md), [Install Linux Vm Terminal First Commands](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- **docs** (1): [System Administration Runbook](../linux/docs/system-administration-runbook.md)
- **scripts** (1): [Health Check And Rollback](../linux/scripts/health-check-and-rollback.sh)
- **configs** (1): [Cron Job Configuration](../linux/configs/2026-08-06-cron-job-configuration.ini)

## nuclei  ·  5 files

- **primer:** [0000 Primer Nuclei](../nuclei/notes/0000-primer-nuclei.md)
- **notes** (2): [Nuclei Quickstart Trip Ups](../nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md), [First Template Scan Attempt](../nuclei/notes/2026-09-20-first-template-scan-attempt.md)
- **scripts** (1): [First Nuclei Scan](../nuclei/scripts/2026-10-15-first-nuclei-scan.sh)
- **configs** (1): [Minimal Scan Template](../nuclei/configs/2026-10-15-minimal-scan-template.yaml)

## opa  ·  28 files

- **primer:** [0000 Primer Opa](../opa/notes/0000-primer-opa.md)
- **notes** (2): [Opa Getting Started Trip Ups](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md), [Install Opa Repl](../opa/notes/2026-06-06-install-opa-repl.md)
- **docs** (4): [Wired Opa Admission Control](../opa/docs/wired-opa-admission-control.md), [Opa Policy Version Migration Patterns](../opa/docs/opa-policy-version-migration-patterns.md), [Integrating Opa With Policy As Code Governance](../opa/docs/integrating-opa-with-policy-as-code-governance.md)  — _…and 1 more under `opa/docs/`._
- **scripts** (2): [How I Test Policies Locally](../opa/scripts/how-i-test-policies-locally.sh), [Export Audit Results](../opa/scripts/export-audit-results.sh)
- **configs** (2): [Tried A Gatekeeper Constraint](../opa/configs/tried-a-gatekeeper-constraint.yaml), [Opa Policy Configuration Template](../opa/configs/opa-policy-configuration-template.yaml)
- **snippets** (4): [My First Opa Policy Eval](../opa/snippets/my-first-opa-policy-eval.sh), [Enforce Image Registry Constraints](../opa/snippets/enforce-image-registry-constraints.rego), [Deny Privileged Hostnetwork](../opa/snippets/deny-privileged-hostnetwork.rego)  — _…and 1 more under `opa/snippets/`._
- **manifests** (4): [Gatekeeper Production Deployment](../opa/manifests/gatekeeper-production-deployment.yaml), [Constraints](../opa/manifests/constraints.yaml), [Constraint Templates](../opa/manifests/constraint-templates.yaml)  — _…and 1 more under `opa/manifests/`._
- **notebooks** (1): [Rego Vs Builtin Policies](../opa/notebooks/rego-vs-builtin-policies.ipynb)
- **templates** (8): [Test Policies](../opa/templates/gatekeeper-policy-library-scaffold/tests/test-policies.sh), [Require Read Only Root Filesystem](../opa/templates/gatekeeper-policy-library-scaffold/policies/require-read-only-root-filesystem.rego), [Enforce Image Registry](../opa/templates/gatekeeper-policy-library-scaffold/policies/enforce-image-registry.rego)  — _…and 5 more under `opa/templates/`._

## opentofu  ·  6 files

- **primer:** [0000 Primer Opentofu](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (2): [Follow Open Tofu Quickstart](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md), [Explore Open Tofu](../opentofu/notes/2026-07-20-explore-open-tofu.md)
- **configs** (3): [Minimal Opentofu Config With Vars](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl), [Minimal Opentofu Config](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl), [First Open Tofu Config](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## prometheus  ·  4 files

- **primer:** [0000 Primer Prometheus](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (3): [Observability Primer Dedup](../prometheus/notes/2026-10-14-observability-primer-dedup.md), [First Query Log](../prometheus/notes/2026-10-14-first-query-log.md), [Checking The Metrics Interface](../prometheus/notes/2026-09-20-checking-the-metrics-interface.md)

## semgrep  ·  25 files

- **primer:** [0000 Primer Semgrep](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (2): [Install Semgrep Pitfalls](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [Install Semgrep](../semgrep/notes/2026-05-25-install-semgrep.md)
- **docs** (8): [Semgrep Rules Migration Guide](../semgrep/docs/semgrep-rules-migration-guide.md), [Semgrep Rule Writing Reference](../semgrep/docs/semgrep-rule-writing-reference.md), [Semgrep Rule Performance Optimization](../semgrep/docs/semgrep-rule-performance-optimization.md)  — _…and 5 more under `semgrep/docs/`._
- **scripts** (3): [Scan Python Codebase](../semgrep/scripts/scan-python-codebase.sh), [Detect Hardcoded Secrets](../semgrep/scripts/detect-hardcoded-secrets.py), [Bulk Scan Helper](../semgrep/scripts/bulk-scan-helper.py)
- **configs** (1): [Multi Rule Pack](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [First Custom Rule](../semgrep/snippets/first-custom-rule.yaml), [Catch Privileged Containers](../semgrep/snippets/catch-privileged-containers.yaml)
- **manifests** (3): [Semgrep Gitlab Ci](../semgrep/manifests/semgrep-gitlab-ci.yaml), [Semgrep Ci Cd Pipeline](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml), [Diff Aware Semgrep Ci](../semgrep/manifests/diff-aware-semgrep-ci.yaml)
- **dockerfiles** (2): [Custom Scanning Image](../semgrep/dockerfiles/custom-scanning-image.Dockerfile), [Ci Entrypoint](../semgrep/dockerfiles/ci-entrypoint.sh)
- **notebooks** (3): [Semgrep Scan Vs Ci Comparison](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb), [Rule Matching Mode Comparison](../semgrep/notebooks/rule-matching-mode-comparison.ipynb), [Comparing Community Vs Custom Rules](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb)

## snyk  ·  28 files

- **primer:** [0000 Primer Snyk](../snyk/notes/0000-primer-snyk.md)
- **notes** (4): [Explore Snyk Cli Commands](../snyk/notes/2026-10-07-explore-snyk-cli-commands.md), [First Vulnerability Scan](../snyk/notes/2026-06-14-first-vulnerability-scan.md), [Install Snyk First Test](../snyk/notes/2026-06-08-install-snyk-first-test.md)  — _…and 1 more under `snyk/notes/`._
- **docs** (4): [Vulnerability Prioritization Reachability Fix Prs License Compliance](../snyk/docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md), [Snyk Security Policy Migration Patterns](../snyk/docs/snyk-security-policy-migration-patterns.md), [Multi Project Ci Pipeline](../snyk/docs/multi-project-ci-pipeline.md)  — _…and 1 more under `snyk/docs/`._
- **scripts** (2): [Snyk Vuln Scan Pipeline](../snyk/scripts/snyk-vuln-scan-pipeline.sh), [First Snyk Test](../snyk/scripts/2026-10-20-first-snyk-test.sh)
- **configs** (3): [Snyk Project Configuration Template](../snyk/configs/snyk-project-configuration-template.yaml), [Snyk Dependency Patch Ignore](../snyk/configs/snyk-dependency-patch-ignore.yaml), [Snyk Ci Github Actions](../snyk/configs/snyk-ci-github-actions.yaml)
- **snippets** (1): [My First Snyk Commands](../snyk/snippets/my-first-snyk-commands.sh)
- **manifests** (1): [Snyk Github Actions Cicd Workflow](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **dockerfiles** (1): [Custom Snyk Cli Air Gapped](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- **notebooks** (1): [Cli Vs Api Modes](../snyk/notebooks/cli-vs-api-modes.ipynb)
- **templates** (10): [Scan Ruby](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-ruby.sh), [Scan Python](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-python.sh), [Scan Node](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-node.sh)  — _…and 7 more under `snyk/templates/`._

## sonarqube  ·  6 files

- **primer:** [0000 Primer Sonarqube](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (2): [Follow Sonarqube Quickstart](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md), [Explore Sonarqube Quality Gates Profiles](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md)
- **scripts** (1): [Sonarqube Scan Setup](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **configs** (1): [Minimal Quality Gate](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml)
- **snippets** (1): [First Sonarscanner Run](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## syft  ·  41 files

- **primer:** [0000 Primer Syft](../syft/notes/0000-primer-syft.md)
- **notes** (3): [Sbom Format Comparison](../syft/notes/2026-05-30-sbom-format-comparison.md), [Syft Quickstart Trip Ups](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md), [Install Syft First Sbom](../syft/notes/2026-05-27-install-syft-first-sbom.md)
- **docs** (8): [Syft Integration Reference](../syft/docs/syft-integration-reference.md), [Syft Format Migration Guide](../syft/docs/syft-format-migration-guide.md), [Sbom Output Formats Reference](../syft/docs/sbom-output-formats-reference.md)  — _…and 5 more under `syft/docs/`._
- **scripts** (4): [Syft Sbom Generation](../syft/scripts/syft-sbom-generation.py), [Sbom Vuln Pipeline](../syft/scripts/sbom-vuln-pipeline.sh), [Multi Image Sbom Pipeline](../syft/scripts/multi-image-sbom-pipeline.sh)  — _…and 1 more under `syft/scripts/`._
- **configs** (1): [.syft](../syft/configs/.syft.yaml)
- **snippets** (2): [Tried Sbom Formats](../syft/snippets/tried-sbom-formats.sh), [First Sbom](../syft/snippets/2026-10-14-first-sbom.sh)
- **manifests** (4): [Syft Remote State Backend Deployment](../syft/manifests/syft-remote-state-backend-deployment.yaml), [Syft Gha Sbom Oci Push Attestation](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml), [Syft Gha Multi Arch Sbom Registry Auth](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml)  — _…and 1 more under `syft/manifests/`._
- **dockerfiles** (1): [Multi Stage Sbom](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (4): [Syft Format Comparison Patterns](../syft/notebooks/syft-format-comparison-patterns.ipynb), [Source Vs Library Multiarch](../syft/notebooks/source-vs-library-multiarch.ipynb), [Sbom Layer Package Analysis](../syft/notebooks/sbom-layer-package-analysis.ipynb)  — _…and 1 more under `syft/notebooks/`._
- **templates** (13): [Trivy](../syft/templates/syft-trivy-k8s-scan-scaffold/trivy.yaml), [Syft](../syft/templates/syft-trivy-k8s-scan-scaffold/syft.yaml), [Scan Workload Images](../syft/templates/syft-trivy-k8s-scan-scaffold/scripts/scan-workload-images.sh)  — _…and 10 more under `syft/templates/`._

## terraform  ·  22 files

- **primer:** [0000 Primer Terraform](../terraform/notes/0000-primer-terraform.md)
- **notes** (2): [Install Terraform First Vm](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [Explore Terraform](../terraform/notes/2026-07-15-explore-terraform.md)
- **docs** (1): [Terraform Module Composition](../terraform/docs/terraform-module-composition.md)
- **scripts** (4): [State Management Workflow](../terraform/scripts/state-management-workflow.sh), [Deploy](../terraform/scripts/2026-07-18-deploy.sh), [Cleanup](../terraform/scripts/2026-07-18-cleanup.sh)  — _…and 1 more under `terraform/scripts/`._
- **configs** (6): [Workspace Variable Precedence](../terraform/configs/workspace-variable-precedence.hcl), [Small Module From Scratch](../terraform/configs/small-module-from-scratch.hcl), [Multi Environment Workspaces Variables](../terraform/configs/multi-environment-workspaces-variables.hcl)  — _…and 3 more under `terraform/configs/`._
- **snippets** (1): [Practice Terraform Variables Outputs Datasources](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)

## terrascan  ·  22 files

- **primer:** [0000 Primer Terrascan](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (4): [Terrascan Getting Started Trip Ups](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md), [Terrascan Getting Started Trip Ups](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md), [Install Terrascan Tiny Tf](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md)  — _…and 1 more under `terrascan/notes/`._
- **docs** (3): [Terrascan Vs Checkov Terraform Iac Scanning](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md), [Terrascan Scan Configuration Migration Patterns](../terrascan/docs/terrascan-scan-configuration-migration-patterns.md), [Iac Pipeline Integration](../terrascan/docs/iac-pipeline-integration.md)
- **scripts** (2): [Tried Terrascan Ci Scan](../terrascan/scripts/tried-terrascan-ci-scan.sh), [Policy As Code Workflow](../terrascan/scripts/policy-as-code-workflow.sh)
- **configs** (2): [Tried Custom S3 Rule](../terrascan/configs/tried-custom-s3-rule.yaml), [Terrascan Config Template](../terrascan/configs/terrascan-config-template.yaml)
- **snippets** (2): [Tiny Tf With Findings](../terrascan/snippets/tiny-tf-with-findings.tf), [Insecure Terraform](../terrascan/snippets/insecure-terraform.tf)
- **manifests** (1): [Terrascan Gha Ci Multi Iac](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **notebooks** (1): [Rego Vs Yaml Rule Authoring](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)
- **templates** (6): [Run Scan](../terrascan/templates/scanning-pipeline-scaffold/scripts/run-scan.sh), [Require Encryption](../terrascan/templates/scanning-pipeline-scaffold/policies/require-encryption.rego), [Block Public S3 Buckets](../terrascan/templates/scanning-pipeline-scaffold/policies/block-public-s3-buckets.rego)  — _…and 3 more under `terrascan/templates/`._

## tetragon  ·  11 files

- **primer:** [0000 Primer Tetragon](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (2): [Tetragon Observability Tutorial](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [Install Tetragon Docker First Events](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md)
- **docs** (1): [Runtime Security Workflow](../tetragon/docs/runtime-security-workflow.md)
- **scripts** (3): [Build Tetragon Policy](../tetragon/scripts/build-tetragon-policy.sh), [Build Tetragon File Access Tracing Policy](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh), [Tetragon Event Collection Pipeline](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- **configs** (4): [Tetragon Policy Config For K8s Runtime Monitoring](../tetragon/configs/tetragon-policy-config-for-k8s-runtime-monitoring.yaml), [Policy Approaches Comparison](../tetragon/configs/policy-approaches-comparison.yaml), [First Tracing Policy Exec File](../tetragon/configs/first-tracing-policy-exec-file.yaml)  — _…and 1 more under `tetragon/configs/`._

## tfsec  ·  5 files

- **primer:** [0000 Primer Tfsec](../tfsec/notes/0000-primer-tfsec.md)
- **notes** (2): [Followed Tfsec Quickstart What Tripped Me Up](../tfsec/notes/2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md), [First Tfsec Scan](../tfsec/notes/2026-09-20-first-tfsec-scan.md)
- **scripts** (1): [Ran My First Tfsec Scan](../tfsec/scripts/2026-10-19-ran-my-first-tfsec-scan.sh)
- **configs** (1): [Minimal Tfsec Scan Config](../tfsec/configs/2026-10-19-minimal-tfsec-scan-config.yaml)

## trivy  ·  39 files

- **primer:** [0000 Primer Trivy](../trivy/notes/0000-primer-trivy.md)
- **notes** (7): [Scanning Performance Optimization](../trivy/notes/scanning-performance-optimization.md), [Trivy First Image Scan](../trivy/notes/2026-10-19-trivy-first-image-scan.md), [Quickstart Trip Ups](../trivy/notes/2026-10-14-quickstart-trip-ups.md)  — _…and 4 more under `trivy/notes/`._
- **docs** (6): [Trivy Integration Reference Container Scanning](../trivy/docs/trivy-integration-reference-container-scanning.md), [Trivy Database Migration Guide](../trivy/docs/trivy-database-migration-guide.md), [Sbom Scanning Reference Guide](../trivy/docs/sbom-scanning-reference-guide.md)  — _…and 3 more under `trivy/docs/`._
- **scripts** (6): [Multi Target Scanner](../trivy/scripts/multi-target-scanner.sh), [Image Vuln Pipeline](../trivy/scripts/image-vuln-pipeline.sh), [Ignore Rules Pipeline](../trivy/scripts/ignore-rules-pipeline.sh)  — _…and 3 more under `trivy/scripts/`._
- **configs** (3): [Trivy Scan Config](../trivy/configs/trivy-scan-config.yaml), [Minimal Trivy Config](../trivy/configs/2026-10-19-minimal-trivy-config.yaml), [.trivy](../trivy/configs/.trivy.yaml)
- **snippets** (1): [Scan Docker Image](../trivy/snippets/scan-docker-image.sh)
- **manifests** (2): [Trivy Sarif Code Scanning](../trivy/manifests/trivy-sarif-code-scanning.yaml), [Trivy Operator Deployment](../trivy/manifests/trivy-operator-deployment.yaml)
- **dockerfiles** (1): [Custom Policies](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [Trivy Scan Mode Comparison](../trivy/notebooks/trivy-scan-mode-comparison.ipynb), [Trivy Sarif Output Processing](../trivy/notebooks/trivy-sarif-output-processing.ipynb)
- **templates** (10): [Trivy](../trivy/templates/trivy-monorepo-scanner/trivy.yaml), [Scan All](../trivy/templates/trivy-monorepo-scanner/scripts/scan-all.sh), [README](../trivy/templates/trivy-monorepo-scanner/README.md)  — _…and 7 more under `trivy/templates/`._

## trufflehog  ·  40 files

- **primer:** [0000 Primer Trufflehog](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (3): [Explore Cli](../trufflehog/notes/2026-07-27-explore-cli.md), [Install Trufflehog](../trufflehog/notes/2026-05-27-install-trufflehog.md), [Following Trufflehog Quickstart](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md)
- **docs** (4): [Trufflehog Secrets Database Migration Guide](../trufflehog/docs/trufflehog-secrets-database-migration-guide.md), [Trufflehog Output Formats Json Sarif Csv](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md), [Trufflehog Integration Reference Secret Detection](../trufflehog/docs/trufflehog-integration-reference-secret-detection.md)  — _…and 1 more under `trufflehog/docs/`._
- **scripts** (3): [Pre Commit Scan Pipeline](../trufflehog/scripts/pre-commit-scan-pipeline.sh), [Multi Repo Scan Pipeline](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [Analyze Trufflehog Results](../trufflehog/scripts/analyze-trufflehog-results.py)
- **configs** (2): [Trufflehog Custom Regex Config](../trufflehog/configs/trufflehog-custom-regex-config.yaml), [Custom Detector Rules](../trufflehog/configs/custom-detector-rules.yaml)
- **snippets** (3): [Scan Github Repo For Secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh), [Fake Secrets Test](../trufflehog/snippets/fake-secrets-test.sh), [First Secret Scan](../trufflehog/snippets/2026-10-14-first-secret-scan.sh)
- **manifests** (2): [Trufflehog Pr Secret Scan Reusable](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml), [Trufflehog Cicd Pipeline](../trufflehog/manifests/trufflehog-cicd-pipeline.yaml)
- **dockerfiles** (1): [Pre Commit Scanner](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile)
- **notebooks** (3): [Trufflehog Scan Modes Comparison](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb), [Detector Comparison Patterns](../trufflehog/notebooks/detector-comparison-patterns.ipynb), [Analyzing Trufflehog False Positives](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)
- **templates** (18): [Trufflehog Config](../trufflehog/templates/secret-scanning-pipeline/trufflehog-config.yaml), [Scan All](../trufflehog/templates/secret-scanning-pipeline/scripts/scan-all.sh), [README](../trufflehog/templates/secret-scanning-pipeline/README.md)  — _…and 15 more under `trufflehog/templates/`._

## vault  ·  21 files

- **primer:** [0000 Primer Vault](../vault/notes/0000-primer-vault.md)
- **notes** (3): [Install Vault First Command](../vault/notes/2026-08-26-install-vault-first-command.md), [Vault Getting Started Trip Ups](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md), [Install Vault And Explore Cli](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
- **docs** (3): [Vault Secrets Engine Selection Guide](../vault/docs/vault-secrets-engine-selection-guide.md), [Vault Agent Auto Auth Kubernetes](../vault/docs/vault-agent-auto-auth-kubernetes.md), [Configuring Vault Dev Server](../vault/docs/configuring-vault-dev-server.md)
- **scripts** (4): [Vault Pki Workflow](../vault/scripts/vault-pki-workflow.sh), [Vault Kv Crud](../vault/scripts/vault-kv-crud.sh), [Vault Db Dynamic Secrets](../vault/scripts/vault-db-dynamic-secrets.sh)  — _…and 1 more under `vault/scripts/`._
- **configs** (3): [Multi Environment Access Control](../vault/configs/multi-environment-access-control.hcl), [Aws Secrets Engine Policy](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl), [Dev Test Policies](../vault/configs/2026-06-26-dev-test-policies.hcl)
- **snippets** (2): [Vault Read Write](../vault/snippets/vault-read-write.go), [First Vault Secret](../vault/snippets/2026-08-30-first-vault-secret.sh)
- **manifests** (2): [Vault Sidecar Secrets Refresh](../vault/manifests/vault-sidecar-secrets-refresh.yaml), [Vault Cluster Deployment](../vault/manifests/vault-cluster-deployment.yaml)
- **dockerfiles** (1): [Custom Vault Image With Plugins Tls](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **notebooks** (2): [Vault Secrets Backend Comparison Patterns](../vault/notebooks/vault-secrets-backend-comparison-patterns.ipynb), [Static Vs Dynamic Secrets](../vault/notebooks/static-vs-dynamic-secrets.ipynb)

## zap  ·  31 files

- **primer:** [0000 Primer Zap](../zap/notes/0000-primer-zap.md)
- **notes** (5): [Install Zap First Baseline Scan](../zap/notes/2026-09-05-install-zap-first-baseline-scan.md), [Install Zap Baseline Scan](../zap/notes/2026-07-20-install-zap-baseline-scan.md), [Spider Scan Test App](../zap/notes/2026-06-13-spider-scan-test-app.md)  — _…and 2 more under `zap/notes/`._
- **docs** (5): [Zap Scan Configuration Migration Guide](../zap/docs/zap-scan-configuration-migration-guide.md), [Zap Integration Reference](../zap/docs/zap-integration-reference.md), [Zap Integration Patterns](../zap/docs/zap-integration-patterns.md)  — _…and 2 more under `zap/docs/`._
- **scripts** (3): [Zap Dast Sarif Code Scanning](../zap/scripts/zap-dast-sarif-code-scanning.sh), [Zap Baseline Scan](../zap/scripts/zap-baseline-scan.sh), [Dast Workflow From Scratch](../zap/scripts/dast-workflow-from-scratch.sh)
- **configs** (3): [Zap Dast Github Actions Workflow](../zap/configs/zap-dast-github-actions-workflow.yaml), [Zap Authenticated Scan Context](../zap/configs/zap-authenticated-scan-context.yaml), [Ci Dast Automation Framework Plan](../zap/configs/ci-dast-automation-framework-plan.yaml)
- **snippets** (4): [My First Zap Spider Scan](../zap/snippets/my-first-zap-spider-scan.sh), [My First Zap Baseline Scan](../zap/snippets/my-first-zap-baseline-scan.sh), [Authenticated Scan With Context](../zap/snippets/authenticated-scan-with-context.sh)  — _…and 1 more under `zap/snippets/`._
- **manifests** (1): [Zap Cicd Pipeline](../zap/manifests/zap-cicd-pipeline.yaml)
- **dockerfiles** (1): [Custom Zap Automation](../zap/dockerfiles/custom-zap-automation.Dockerfile)
- **notebooks** (1): [Scan Strategy Comparison Patterns](../zap/notebooks/scan-strategy-comparison-patterns.ipynb)
- **templates** (7): [Zap Automation Plan](../zap/templates/zap-dast-integration-scaffold/zap-automation-plan.yaml), [Run Zap Dast](../zap/templates/zap-dast-integration-scaffold/scripts/run-zap-dast.sh), [Quick Scan](../zap/templates/zap-dast-integration-scaffold/plans/quick-scan.yaml)  — _…and 4 more under `zap/templates/`._
