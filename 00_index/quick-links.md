# Quick Links

## I need to...

### Audit and remediate CVEs

- [Ansible CVE-2026-33228 path verification](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md)
- [Trivy CVE severity filtering](../scripts/bash/ci_cd_toolkit/trivy-severity-filter.sh)
- [TruffleHog PR secret scan reusable workflow](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml)
- [Falco K8s admission control rule](../falco/manifests/falco-k8s-admission-control.yaml)
- [DefectDojo vulnerability scanner setup](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml) — Scanner integration scaffold with finding ingestion
- [Flatted CVE-2026-33228 runbook](../docs/runbooks/cve-2026-33228-ansible-flatted.md)
- [Kaniko CVE-2026-28406 runbook](../docs/how-to/docker-kaniko-cve-2026-28406.md)

### Build and sign container images

- [First custom Docker image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile)
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- [Cosign verification patterns](../cosign/docs/cosign-verification-patterns.md)
- [Container signing pipeline integration](../cosign/docs/container-signing-pipeline.md) — Where signing and verification stages belong in an image pipeline, and the verify gate that rejects unsigned images
- [Cosign key management workflow](../cosign/scripts/cosign-key-management-workflow.sh)
- [Cosign signature configuration](../cosign/configs/cosign-signature-configuration.yaml) — CI workflow wiring keyless and key-based signing into an image pipeline
- [Key-based vs keyless signing](../cosign/notebooks/key-based-vs-keyless-signing.ipynb) — Operational comparison of Cosign signing modes
- [Cosign key rotation and migration patterns](../cosign/docs/key-rotation-and-migration-patterns.md) — Rotate signing trust without leaving published images unverifiable
- [Custom Cosign image](../cosign/dockerfiles/custom-cosign-image.Dockerfile)
- [Multi-stage SBOM Dockerfile](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- [Multi-stage Grype scan Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- [Build a multi-service Docker Compose app](../docker/scripts/build-multi-service-compose-app.sh)
- [Multi-service Compose scaffold](../docker/templates/multi-service-setup/README.md) — Web plus API plus Postgres with health-gated startup and named volumes
- [Docker Compose production manifest](../docker/manifests/docker-compose-production.yaml) — Replicated app service with rolling updates, resource limits, and restart policy
- [Syft + Trivy Kubernetes scan scaffold](../syft/templates/syft-trivy-k8s-scan-scaffold/README.md)

### Diagnose failures

- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md)
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md)
- [Vault seal/unseal troubleshooting](../docs/troubleshooting/vault-seal-unseal.md)
- [Jenkins troubleshooting](../docs/troubleshooting/jenkins-troubleshooting.md)
- [Kafka consumer lag](../docs/troubleshooting/kafka-consumer-lag.md)
- [Linux production system administration runbook](../linux/docs/system-administration-runbook.md) — A deterministic triage sequence for a degraded host: reachability first, then load, memory, and disk in that order, then stabilisation and handoff
- [Host health check and rollback](../linux/scripts/health-check-and-rollback.sh) — One entry point with check, snapshot, and rollback subcommands; thresholds overridable from the environment, exit codes separating healthy from degraded and critical

### Explore Syft SBOM capabilities

- [Syft CLI scan vs library mode](../syft/notebooks/source-vs-library-multiarch.ipynb) — When to use CLI scan mode vs library mode for multi-arch image SBOMs
- [Multi-language SBOM generation with release upload](../syft/scripts/syft-sbom-generation.py) — Generate SBOMs for every language ecosystem in a repo and attach them to a release
- [SBOM output formats reference](../syft/docs/sbom-output-formats-reference.md) — What each format carries and when to pick it
- [SBOM formats compared](../syft/docs/sbom-formats-comparison.md)

### Understand secrets management

- [Vault static vs dynamic secrets](../vault/notebooks/static-vs-dynamic-secrets.ipynb) — Comparing static vs dynamic secrets for cloud IAM credential management
- [Vault secrets engine selection guide](../vault/docs/vault-secrets-engine-selection-guide.md) — Which engine to reach for, and what it hands back
- [Dynamic secrets for cloud IAM](../vault/scripts/cloud-iam-dynamic-secrets.sh)

### Explore Tetragon observability

- [Tetragon observability tutorial](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md)
- [Minimal network tracing policy](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml)
- [Tetragon event collection pipeline](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh)
- [Build a small Tetragon policy from scratch](../tetragon/scripts/build-tetragon-policy.sh) — Generate a minimal TracingPolicy watching execve calls and verify it applies
- [Tetragon runtime security workflow](../tetragon/docs/runtime-security-workflow.md) — Install, apply a narrow policy, read the events back
- [K8s runtime-monitoring policy](../tetragon/configs/tetragon-policy-config-for-k8s-runtime-monitoring.yaml) — Observe-mode TracingPolicy covering exec, file access, and network connects
- [File-access policy builder](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh) — Render a narrow file-access TracingPolicy from flags instead of hand-editing YAML
- [Policy approaches comparison](../tetragon/configs/policy-approaches-comparison.yaml) — Cheap exec tracepoint vs narrow file-descriptor kprobe side by side

### Visualize metrics

- [Grafana primer](../grafana/notes/0000-primer-grafana.md)
- [First Grafana datasource](../grafana/configs/2026-09-19-first-datasource.yaml) — Wire one Prometheus backend in so a first panel query has something to read
- [First dashboard browser check](../grafana/notes/2026-09-19-first-dashboard-browser.md) — What to inspect once the dashboard browser is reachable
- [Grafana dashboard UI walkthrough](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md) — Panels, plain-Prometheus queries, and the Loki log view in a default install
- [Grafana installation](../docs/how-to/observability/grafana-installation.md)
- [Prometheus + node_exporter installation](../docs/how-to/observability/prometheus-node-exporter-installation.md)
- [Loki and Promtail installation](../docs/how-to/observability/loki-promtail-installation.md)

### Tune runtime detection

- [Falco primer](../falco/notes/0000-primer-falco.md)
- [Falco runtime security monitoring integration](../falco/docs/runtime-security-monitoring-integration.md) — End-to-end deployment: custom rules, priority routing, and forwarding alerts onward
- [Falco rule engine vs eBPF probes](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb) — When a syscall rule engine is enough and when eBPF probes earn their extra complexity
- [Falco rule optimization with priority-based filtering](../falco/docs/rule-optimization-priority-filtering.md) — Rank the noisiest rules first, then cut volume with lists, macros, and priority-tiered routing
- [Tuned Falco rules for noise reduction](../falco/docs/tuned-falco-rules-noise-reduction.md)
- [Falco event output formats](../falco/notebooks/falco-event-output-formats.ipynb) — What each output format is good for when events leave the node
- [Minimal Falco runtime config](../falco/configs/2026-10-03-minimal-runtime-config.yaml) — The daemon config passed to `falco --config`: which rule files load, JSON alert output, log level, and the output rate limit
- [First custom Falco rule](../falco/configs/first-custom-rule-detect-shell-in-container.yaml)
- [Falco K8s admission control rule](../falco/manifests/falco-k8s-admission-control.yaml)
- [Custom rules library scaffold](../falco/templates/falco-custom-rules-library/README.md) — Rules, tests, and a runner for iterating on a ruleset locally

### Get started with vulnerability scanning

- [Install Trivy and run a first container scan](../trivy/notes/2026-09-05-install-trivy-first-container-scan.md)
- [Install ZAP and run a baseline scan](../zap/notes/2026-09-05-install-zap-first-baseline-scan.md)
- [ZAP baseline scan script](../zap/scripts/zap-baseline-scan.sh) — Run a containerised ZAP baseline against a target URL and fail on High findings
- [ZAP integration reference](../zap/docs/zap-integration-reference.md) — Baseline, Automation Framework, and REST API patterns for wiring DAST into automated pipelines
- [ZAP scan configuration migration guide](../zap/docs/zap-scan-configuration-migration-guide.md) — Consolidate scattered scan config into one version-controlled Automation Framework plan
- [ZAP scan strategy comparison](../zap/notebooks/scan-strategy-comparison-patterns.ipynb) — Passive baseline vs active full scan vs narrowed-context active scan, and what each costs you
- [Nuclei primer](../nuclei/notes/0000-primer-nuclei.md)
- [Trivy primer](../trivy/notes/0000-primer-trivy.md)
- [Trivy scanning performance optimization](../trivy/notes/scanning-performance-optimization.md)
- [Trivy ignore-rules pipeline](../trivy/scripts/ignore-rules-pipeline.sh)
- [Trivy SARIF code-scanning output](../trivy/docs/ci-pipeline-sarif-output.md)
- [Multi-arch vulnerability scanning with Trivy](../trivy/docs/multi-arch-vulnerability-scanning.md)
- [Container vulnerability scan with Trivy](../trivy/scripts/container-vuln-scan.sh)
- [Minimal Grype scan](../grype/scripts/minimal-grype-scan.sh)
- [CI-ready Grype scanning](../grype/scripts/ci-ready-grype-scan.sh)
- [Grype in a vulnerability-management pipeline](../grype/docs/vulnerability-management-pipeline-integration.md) — The loop around the scan: target choice, database caching, machine-readable reports, gate thresholds, tracker routing, and diffing against the last accepted result
- [Grype vulnerability reporting migration patterns](../grype/docs/grype-vulnerability-reporting-migration-patterns.md) — Move a report from table to JSON to SARIF for a new downstream consumer, keeping the raw scan result and the old format until the new one is verified
- [Grype filtering configuration template](../grype/configs/grype-filtering-configuration-template.yaml) — Severity gate, fix-state filtering, path exclusions, and ignore rules where every entry carries a reason, an owner, and what retires it
- [Grype database vs registry sources](../grype/notebooks/grype-db-vs-registry-sources.ipynb) — Registry image scan vs DB-backed SBOM scan compared on network cost and repeat-scan cost, plus a database-freshness check
- [Grype and Syft together](../grype/docs/grype-syft-integration-guide.md) — Generate an SBOM with Syft and scan it offline with Grype
- [SBOM generation with Syft](../syft/scripts/gen-multi-format-sboms.sh)
- [Syft output format comparison](../syft/notebooks/output-format-comparison.ipynb)
- [Snyk vulnerability prioritization with reachability and Fix PRs](../snyk/docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md)
- [Snyk security policy migration patterns](../snyk/docs/snyk-security-policy-migration-patterns.md) — Move ignore rules, severity thresholds, and exclusion paths without weakening the gate
- [Snyk multi-language scan scaffold](../snyk/templates/snyk-multilang-scan-scaffold/README.md)
- [Snyk project configuration template](../snyk/configs/snyk-project-configuration-template.yaml) — Per-project severity gate, scan targets, and exclusions in one versioned file
- [Snyk CLI vs API modes](../snyk/notebooks/cli-vs-api-modes.ipynb) — When to scan through the CLI versus the HTTP API
- [Exploring the Snyk CLI](../snyk/notes/2026-10-07-explore-snyk-cli-commands.md) — `test` vs `monitor` and the flags used for CI gating

### Learn Linux shell scripting

- [First look around a Linux box](../linux/notes/2026-10-02-explore-linux-environment.md) — `uname -a`, `/etc/os-release`, `whoami`, `df -h`, and the permission and process surprises that turn up on the first pass
- [Linux VM terminal first commands](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- [Linux shell scripting tutorial confusions](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md)
- [Cron job configuration](../linux/configs/2026-08-06-cron-job-configuration.ini)
- [Automation shell patterns that survive failure](../docs/concepts/linux-shell-fundamentals/scripts/2026-09-27-devops-automation-shell-patterns.sh) — Wrap each step so one failure doesn't hide the rest, retry transient errors, read config from a key=value file
- [Linux shell fundamentals practice exercises](../docs/concepts/linux-shell-fundamentals/scripts/2026-07-23-practice-exercises.sh)
- [Combining shell automation with Git hooks](../docs/concepts/linux-shell-fundamentals/combining-shell-automation-with-git-hooks.md) — Pipelines, exit-code discipline, and idempotent checks firing at the right point in the commit cycle

### Manage infrastructure as code

- [Terraform primer](../terraform/notes/0000-primer-terraform.md)
- [Small reusable Terraform module](../terraform/configs/small-module-from-scratch.hcl) — Environment-aware naming and tagging with variables, locals, and outputs
- [Composing Terraform modules](../terraform/docs/terraform-module-composition.md)
- [Terraform workspace variable precedence](../terraform/configs/workspace-variable-precedence.hcl)
- [Terraform state management](../docs/how-to/terraform-state-management.md)
- [Terraform basics practice loop](../docs/concepts/infrastructure-as-code/scripts/2026-09-27-terraform-basics-practice.sh) — Walk init/validate/plan/apply once on a provider-free config so you can see which command creates which file
- [Reusable module HCL pattern](../docs/concepts/infrastructure-as-code/snippets/2026-09-27-reusable-module-hcl-pattern.sh) — One module folder owning a resource, callers passing inputs, no environment name hardcoded
- [First environment comparison](../environments/notes/2026-09-19-first-environment-comparison.md) — Dev vs staging vs prod variable differences worth understanding before changing anything
- [Environments quickstart trip-ups](../environments/notes/2026-09-30-environments-quickstart-trip-ups.md) — Why a plan run in `staging/` reads dev's state file, and the three other things that stop the per-environment loop
- [Minimal per-tier environments config](../environments/configs/2026-09-30-minimal-environments-config.yaml) — Only the values that differ between dev, staging, and prod, with the state key as written and as intended
- [Explore the environments directory](../environments/notes/2026-09-29-explore-environments-directory.md) — Primer, three-environment comparison, and minimal variable-set config on disk today
- [Validate environments deploy config](../environments/scripts/2026-10-01-validate-deploy-config.sh) — Walk dev, staging, and prod checking for the four files each root module needs
- [OpenTofu primer](../opentofu/notes/0000-primer-opentofu.md)
- [Kubernetes primer](../kubernetes/notes/0000-primer-kubernetes.md)
- [Helm primer](../helm/notes/0000-primer-helm.md)
- [Helm quickstart trip-ups](../helm/notes/2026-09-21-quickstart-tripped-me-up.md)
- [Minimal Helm chart](../helm/manifests/2026-09-21-minimal-service-chart.yaml) — A bare minimum Helm chart to validate the chart scaffolding pattern
- [Kustomize primer](../kustomize/notes/0000-primer-kustomize.md)
- [Kustomize quickstart trip-ups](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md)
- [Minimal Kustomize config with overlay](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml) — A bare minimum kustomization plus overlay to validate the patching pattern
- [Kustomize tutorial manifest](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)
- [ArgoCD primer](../argocd/notes/0000-primer-argocd.md)
- [ArgoCD private repo credentials and RBAC](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- [ArgoCD quickstart trip-ups](../argocd/notes/2026-08-12-quickstart-tripups.md)
- [ArgoCD multi-environment GitOps delivery](../argocd/docs/multi-environment-gitops-delivery.md)
- [How ArgoCD fits the GitOps workflow](../argocd/docs/gitops-workflow-wiring.md) — Pinned install, separate manifests repo, plain YAML to Kustomize to Helm to app-of-apps
- [ArgoCD Helm guestbook application](../argocd/manifests/helm-guestbook-application.yaml) — Minimal Application spec wiring a Helm chart source into GitOps sync
- [Kubernetes cluster workflow wiring](../kubernetes/docs/cluster-workflow-wiring.md) — Namespace-per-environment layout with a Deployment plus Service per app
- [Namespace strategy: environment vs team](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml)
- [Small Kubernetes Deployment from scratch](../kubernetes/manifests/small-deployment-from-scratch.yaml) — Deployment to ReplicaSet to Pod chain behind a ClusterIP Service
- [Provision a Kubernetes cluster with Terraform + Ansible](../docs/how-to/k8s-terraform-ansible-provisioning.md)
- [EKS cluster setup](../docs/setup-guides/eks-cluster-setup.md)

### Manage policies and compliance

- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md)
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh)
- [Gatekeeper constraint template design patterns](../opa/docs/constraint-template-design-patterns.md)
- [OPA policy-as-code governance](../opa/docs/integrating-opa-with-policy-as-code-governance.md) — Running one ConstraintTemplate across dev, staging, and prod: designing the parameter surface, promoting Config then ConstraintTemplate then Constraint, fail-closing last, and gating the Terraform plan from the same rules
- [OPA policy configuration template](../opa/configs/opa-policy-configuration-template.yaml) — Tune one check per environment without editing the policy: audit-only instances where workloads are still being fixed, enforcing where the baseline is clean
- [Rego vs built-in policies](../opa/notebooks/rego-vs-builtin-policies.ipynb) — Score a new requirement on four questions to decide between hand-written Rego and a platform check, with the same intent expressed both ways
- [Wiring OPA into admission control](../opa/docs/wired-opa-admission-control.md)
- [Gatekeeper policy library scaffold](../opa/templates/gatekeeper-policy-library-scaffold/README.md)
- [Gatekeeper production deployment manifest](../opa/manifests/gatekeeper-production-deployment.yaml)
- [Test Gatekeeper policies locally](../opa/templates/gatekeeper-policy-library-scaffold/tests/test-policies.sh)
- [Export Gatekeeper audit results](../opa/scripts/export-audit-results.sh)
- [Terrascan primer](../terrascan/notes/0000-primer-terrascan.md)
- [Terrascan configuration template](../terrascan/configs/terrascan-config-template.yaml) — The real TerrascanConfig schema, and which keys Terrascan silently ignores
- [Rego vs YAML rule authoring](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb) — When a Terrascan rule needs real logic instead of a declarative policy block
- [Terrascan in an IaC pipeline](../terrascan/docs/iac-pipeline-integration.md) — Where the scan stage belongs and what the exit code should gate
- [Terrascan vs Checkov for Terraform](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md)
- [tfsec primer](../tfsec/notes/0000-primer-tfsec.md)

### Manage secrets and access

- [HashiCorp Vault primer](../vault/notes/0000-primer-vault.md)
- [Install Vault and run a first command](../vault/notes/2026-08-26-install-vault-first-command.md)
- [Vault PKI workflow](../vault/scripts/vault-pki-workflow.sh) — Root CA, role, issuance, rotation, revocation with CRL verification
- [Vault KV CRUD operations](../vault/scripts/vault-kv-crud.sh)
- [Vault multi-environment access control](../vault/configs/multi-environment-access-control.hcl)
- [Vault AWS secrets engine policy](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl)
- [Vault Agent auto-auth on Kubernetes](../vault/docs/vault-agent-auto-auth-kubernetes.md)
- [Vault Agent sidecar for secret refresh](../vault/manifests/vault-sidecar-secrets-refresh.yaml)
- [Vault cluster deployment manifest](../vault/manifests/vault-cluster-deployment.yaml) — HA Raft StatefulSet plus a single-replica dev variant with probes, PDB, and network policy
- [Vault troubleshooting: seal and unseal](../docs/how-to/vault-troubleshooting-seal-unseal.md)

### Practice and learn

- [Version control with Git fundamentals](../docs/concepts/git-001-version-control-fundamentals.md)
- [CI/CD pipeline concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md)
- [Pipeline artifact promotion practice](../docs/concepts/ci-cd-pipeline-concepts/scripts/2026-09-18-practice-pipeline-artifact-promotion.sh) — Build once, then promote the same artifact staging → prod only when checks pass
- [Application Security Testing concepts](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md)
- [SCA and dependency exercises](../docs/concepts/application-security-testing-concepts/snippets/2026-08-26-appsec-sca-dependency-exercises.py)
- [Infrastructure as Code fundamentals](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md)
- [Terraform validate-then-plan loop](../docs/concepts/infrastructure-as-code/snippets/2026-09-18-validate-and-plan-terraform.sh) — fmt, init, validate, and plan before ever running apply
- [Common Linux scripting patterns in Python](../docs/concepts/linux-shell-fundamentals/snippets/2026-09-18-common-linux-scripting-patterns.py)
- [Supply-chain CI verification gate](../docs/concepts/software-supply-chain-security/scripts/ci-pipeline-verification.py) — Prevention, reachability triage, and SBOM governance gates for a pipeline step
- [Applying secrets & access management](../docs/concepts/secrets-access-management/snippets/2026-08-25-applying-secrets-access-management.py)
- [Applying version control in DevSecOps](../docs/concepts/version-control-with-git/snippets/2026-08-25-applying-version-control-in-devsecops.py)
- [Container & runtime security fundamentals](../docs/concepts/container-runtime-security/0000-primer-container-runtime-security.md)
- [Containers & orchestration fundamentals](../docs/concepts/containers-orchestration/0000-primer-containers-orchestration.md)
- [Configuration management fundamentals](../docs/concepts/configuration-management/0000-primer-configuration-management.md)
- [Lab primer](../lab/notes/0000-primer-lab.md) — What the lab scratch space is for and how mini-projects are organised
- [First lab environment](../lab/configs/2026-09-19-first-lab-env.yaml) — A one-machine practice box you can rebuild from when experiments get messy
- [DefectDojo tutorial check](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh) — Verify DefectDojo setup and prerequisites before starting
- [Version-control patterns in real projects](../docs/concepts/version-control-with-git/notebooks/version-control-patterns-in-real-projects.ipynb) — Feature-branch, trunk-based, and squash-merge histories compared through the same Git queries
- [Image optimisation trip-ups](../assets/notes/2026-09-29-image-optimization-tripped-me-up.md) — Resizing kit diagrams without squashing them, and relative image links from nested notes
- [Assets directory walkthrough](../assets/notes/2026-09-30-explore-assets-directory.md) — What the diagram store holds today and how docs reference it
- [Asset index](../assets/configs/2026-09-29-asset-index.yaml) — Which diagram file is which size, and where each one is referenced from
- [Audit asset references](../assets/scripts/2026-10-01-audit-asset-references.sh) — Find the diagrams on disk and the docs that link to them, and spot the ones nothing references

### Run infrastructure tasks

- [Ansible quickstart trip-ups](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md)
- [Ansible inventory with group and host vars](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml)
- [Minimal Ansible playbook: package and service](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- [How I wired Ansible into my infrastructure workflow](../ansible/docs/wired-ansible-infrastructure-workflow.md) — A site.yml entry point plus roles layout for a small infrastructure workflow
- [Roles vs tasks in Ansible](../ansible/notes/roles-vs-tasks.md) — When a reusable concern earns a role and when a task list stays readable
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh)
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh)
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh)
- [Deploy wrapper](../scripts/pipeline/deploy.sh)
- [Rollback wrapper](../scripts/pipeline/rollback.sh)

### Run static analysis

- [Semgrep primer](../semgrep/notes/0000-primer-semgrep.md)
- [Checkov primer](../checkov/notes/0000-primer-checkov.md)
- [Validate custom Checkov policies](../checkov/scripts/validate-policies.sh) — Structural and required-section checks on every policy folder, then `checkov --external-checks-dir` and a yamllint pass
- [Checkov health check and rollback](../checkov/scripts/checkov-health-check-and-rollback.sh) — One entry point for a Checkov scan gate: prove the scanner runs, classify the latest scan result, and undo a bad scan-gate change by restoring the previous Checkov configuration
- [Checkov 2.x to 3.x upgrade checklist](../checkov/docs/checkov-v3-upgrade-checklist.md) — Roll out the major-version upgrade on a trial branch without breaking the CI gate
- [Checkov cross-module scanning limitations](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb) — Static directory scan vs plan JSON scan for cross-module IaC
- [Checkov custom policy authoring comparison](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb) — Four authoring styles for one "no public S3 bucket" rule, scored against a labelled corpus
- [Checkov platform config](../checkov/configs/platform-config.yaml)
- [CodeQL primer](../codeql/notes/0000-primer-codeql.md)
- [Install CodeQL and run a first query](../codeql/notes/2026-08-26-install-codeql-first-query.md)
- [First CodeQL query example](../codeql/snippets/2026-09-24-first-codeql-query.py) — A minimal hardcoded-password query to save out and run with the CodeQL CLI
- [CodeQL query-writing patterns for JavaScript/TypeScript](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md) — Source, sink, and sanitizer patterns for custom data-flow queries
- [CodeQL CLI vs GitHub Actions scan modes](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb) — When to run CodeQL locally via the CLI versus declaratively in Actions
- [CodeQL multi-language repository scan](../codeql/manifests/codeql-multi-language-scan.yaml) — One workflow that analyses every language in a repo with a single status check
- [CodeQL CI/CD pipeline deployment gate](../codeql/manifests/codeql-cicd-pipeline.yaml) — PR gate running interpreted languages fast, full multi-language analysis on merge, and a promotion job that blocks deployment when analysis fails
- [CodeQL database migration guide](../codeql/docs/codeql-database-migration-guide.md) — Move a setup between language sets, build modes, and database locations without losing coverage
- [CodeQL integration reference](../codeql/docs/codeql-integration-reference.md) — How the kit's workflows, manifests, and local CLI loop fit together as one pipeline
- [CodeQL custom query-pack scaffold](../codeql/templates/custom-query-pack-ci-harness/README.md) — Reusable layout for project-specific queries with CI and local test harness
- [Semgrep rule-writing reference](../semgrep/docs/semgrep-rule-writing-reference.md)
- [Custom Semgrep rule example](../semgrep/snippets/first-custom-rule.yaml)
- [Semgrep rule performance optimization](../semgrep/docs/semgrep-rule-performance-optimization.md)
- [Semgrep rules migration guide](../semgrep/docs/semgrep-rules-migration-guide.md) — Move an organically grown ruleset into a consistent layout with normalized envelopes and CI rollout
- [Semgrep code-scanning integration reference](../semgrep/docs/semgrep-code-scanning-integration-reference.md) — CI patterns, SARIF upload, rule sources, and severity tuning for code scanning
- [Semgrep CI/CD pipeline deployment manifest](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml) — Full-repo SAST gate with SARIF upload, weekly scheduled scans, and configurable severity-based quality gating
- [AST-based security pattern checker](../docs/concepts/application-security-testing-concepts/scripts/2026-08-26-ast-devsecops.py)
- [SonarQube quality gates and profiles](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md)
- [Semgrep rule-design comparison](../semgrep/notebooks/rule-matching-mode-comparison.ipynb) — Search, context-constrained, and taint rules for one injection class scored on a labelled corpus

### Scan for secrets

- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md)
- [Gitleaks primer](../gitleaks/notes/0000-primer-gitleaks.md)
- [First secret scan with Gitleaks](../gitleaks/notes/2026-09-19-first-secret-scan.md) — What to set up before a first scan, using a fake credential in a test repo
- [Gitleaks quickstart trip-ups](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md) — Full-history vs staged-changes scans and the custom detection-rules config
- [First Gitleaks scan script](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh) — Point Gitleaks at a sample repo and save the findings as JSON
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md)
- [GitGuardian CI/CD secret scanning integration](../gitguardian/docs/cicd-secret-scanning-integration.md) — Where pre-commit, pull-request, and scheduled ggshield scans belong, plus incident-response hooks
- [GitGuardian incident response workflow](../gitguardian/docs/gitguardian-incident-response-workflow.md)
- [GitGuardian scanning migration patterns](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md) — ggshield v1 to v2 config moves, replacing TruffleHog or Gitleaks, consolidating per-repo config into an org baseline, and rolling out across a monorepo
- [GitGuardian API integration](../gitguardian/scripts/gitguardian-api-integration.py)
- [GitGuardian org secret-scanning policy](../gitguardian/configs/policy-configuration.yaml) — Which detectors stay enforced, which paths are ignored and why, who owns findings per directory, and what an incident handoff must carry
- [Hosted vs self-managed secret scanning](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb) — Where scan content travels, who operates the service, and a per-tier scoring function with data residency as a veto
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- [Secrets detection workflow analysis](../docs/concepts/secrets-access-management/notebooks/secrets-detection-remediation-workflow-analysis.ipynb)
- [Dependabot configuration template](../dependabot/configs/dependabot-configuration-template.yaml) — A single dependabot.yml covering ecosystems, schedules, grouping, and review routing
- [Dependabot integration with version control workflows](../dependabot/docs/dependabot-version-control-workflow-integration.md) — Branch targeting, PR queue shape, grouping, review routing, and required checks
- [Auto-merge vs manual review](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb) — Trade-offs between auto-merging update PRs and reviewing each one by hand
- [Dependabot alert migration patterns](../dependabot/docs/dependabot-security-alert-migration-patterns.md) — Move alert configs from repo level to an org-wide policy when consolidating scanning
- [Configure Dependabot for private registries](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md)
- [Dependabot alerts and security updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md)
- [Pre-commit secret scanning with Git](../docs/how-to/git-pre-commit-security-scanning.md)

### Secure version control

- [Git primer](../git/notes/0000-primer-git.md)
- [How Git fits the version-control workflow](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- [Layered vs conditional Git config](../git/configs/config-strategy-layered-vs-conditional.yaml) — System/global/local tiers compared against `includeIf` context includes
- [Git first repo stage and log](../git/scripts/2026-08-24-first-repo-stage-log.sh)
- [Git hooks for security checks](../docs/concepts/version-control-with-git/scripts/git-hooks-devsecops-security-checks.sh)
- [Git security: access control and authentication](../docs/security/git-security-access-control-authentication.md)
- [Git credential helper for CI/CD](../docs/setup-guides/git-credential-helper-ci-cd.md)
- [Git workflow optimization](../docs/how-to/git-workflow-optimization.md)

### Set up CI/CD pipelines

- [GitHub Actions primer](../github-actions/notes/0000-primer-github-actions.md)
- [Install the GitHub CLI and run a first command](../github-actions/notes/2026-08-26-install-gh-cli-first-command.md)
- [My first GitHub Actions workflow](../github-actions/snippets/2026-08-26-first-workflow.yaml)
- [Reusing inputs with a composite action](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- [CI/CD security scanner wrapper](../docs/concepts/linux-shell-fundamentals/scripts/ci-cd-pipeline-security-scanner-wrapper.sh)
- [Docker CI/CD end-to-end](../docker/docs/cicd-end-to-end.md) — Build once in CI, smoke-test the image, push the verified tag, and deploy that exact tag
- [Reusable Docker build script](../docker/scripts/reusable-build.sh) — Single and multi-stage image builds with build args and cache-from support
- [ZAP baseline scan for CI](../zap/notes/2026-07-20-install-zap-baseline-scan.md)
- [ZAP CI/CD pipeline manifest](../zap/manifests/zap-cicd-pipeline.yaml) — Reusable ZAP DAST workflow with baseline, full, and authenticated scan modes
- [Trivy CI/CD pipeline recipes](../trivy/docs/ci-cd-pipeline-recipes.md)
- [Trivy in GitHub Actions](../docs/how-to/trivy-github-actions.md)
- [Trivy in Jenkins](../docs/how-to/trivy-jenkins-integration.md)
- [GitHub Actions runner setup](../docs/setup-guides/git-github-actions-runner.md)
- [Jenkins parallel multi-branch pipelines](../docs/how-to/jenkins-parallel-multi-branch.md)