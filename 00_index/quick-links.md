# Quick Links

## Getting started
- [README](../README.md) — Repository overview
- [topics.md](topics.md) — Full topic index by tool
- [glossary.md](glossary.md) — Tool and domain terminology
- [learning-path.md](learning-path.md) — Suggested progression from beginner to advanced

## Core concepts
- [Application Security Testing Concepts](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — SAST, DAST, SCA, and key security testing terminology
- [CI/CD Pipeline Concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md) — Stages, gates, triggers, and pipeline fundamentals
- [Configuration Management](../docs/concepts/configuration-management/0000-primer-configuration-management.md) — Desired state, idempotency, drift, and config management fundamentals (L1)
- [Container & Runtime Security](../docs/concepts/container-runtime-security/0000-primer-container-runtime-security.md) — Image vs runtime security, syscalls, eBPF
- [Software Supply Chain Security](../docs/concepts/software-supply-chain-security/0000-primer-software-supply-chain-security.md) — Supply chain attacks, SBOM, signing, and dependency verification
- [Version Control with Git](../docs/concepts/version-control-with-git/0000-primer-version-control-with-git.md) — Repos, commits, branches, and collaboration workflows
- [Containers & Orchestration](../docs/concepts/containers-orchestration/0000-primer-containers-orchestration.md) — Images, containers, registries, and Kubernetes fundamentals
- [Infrastructure as Code](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md) — What IaC is, why it matters, and key terminology (L1)
- [Linux & Shell Fundamentals](../docs/concepts/linux-shell-fundamentals/0000-primer-linux-shell-fundamentals.md) — What Linux and the shell are, why they matter, and core terminology (L1)
- [Observability & Monitoring](../docs/concepts/observability-monitoring/0000-primer-observability-monitoring.md) — Metrics, logs, traces, SLOs, and telemetry fundamentals (L1)
- [Secrets & Access Management](../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md) — Controlling access and handling credentials securely (L1)

## Learn Git
- [Git primer](../git/notes/0000-primer-git.md) — What Git is, key commands, and first repository

## Set up a tool
- [Install Semgrep](../semgrep/notes/2026-05-25-install-semgrep.md)
- [Install Checkov](../checkov/notes/2026-05-25-scan-terraform-plan.md)
- [Install Trivy](../trivy/notes/2026-05-24-install-trivy.md)
- [Git primer](../git/notes/0000-primer-git.md) — What is Git? — quick primer for version control beginners
- [Install Git](../scripts/bash/git/git-install.sh)
- [Install Jenkins](../scripts/bash/jenkins_toolkit/install-jenkins.sh)
- [Deploy Loki + Promtail](../scripts/bash/observability_toolkit/loki/loki-promtail-install.sh)
- [Deploy Grafana](../scripts/bash/observability_toolkit/grafana/grafana-install.sh)
- [Deploy Prometheus Node Exporter](../docs/how-to/observability/prometheus-node-exporter-installation.md)
- [Deploy OTel Collector](../scripts/bash/observability_toolkit/otel/otel-collector-install.sh)
- [Deploy Alertmanager](../scripts/bash/observability_toolkit/alertmanager/alertmanager-install.sh)
- [Set up Alertmanager HA cluster](../scripts/bash/observability_toolkit/alertmanager/alertmanager-ha-setup.sh)
- [Set up Buildkite agent](../scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh)
- [Set up CircleCI runner](../scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh)
- [Deploy Argo Workflows](../scripts/bash/argo_toolkit/argo-workflows-install.sh)
- [Deploy Flux v2](../scripts/bash/flux_toolkit/flux-install.sh)
- [Deploy Harbor registry](../scripts/bash/harbor/harbor-deploy.sh)
- [Deploy Docker Swarm cluster](../scripts/bash/docker_toolkit/docker-swarm-cluster-setup.sh)
- [Deploy EKS cluster](../scripts/bash/terraform_toolkit/eks/eks-deploy.sh)
- [Set up Atlantis](../scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh)
- [Set up Git credential helper for CI/CD](../scripts/bash/git/credential-helper-ci.sh)
- [Install GitHub Actions runner](../scripts/bash/git/github-runner-install.sh)
- [Install Syft and generate first SBOM](../syft/notes/2026-05-27-install-syft-first-sbom.md)
- [Install TruffleHog](../trufflehog/notes/2026-05-27-install-trufflehog.md)

## Troubleshoot a tool
- [Kubernetes CrashLoopBackOff](../docs/troubleshooting/k8s-crashloopbackoff.md)
- [Kafka consumer lag](../docs/troubleshooting/kafka-consumer-lag.md)
- [Vault seal/unseal](../docs/troubleshooting/vault-seal-unseal.md)
- [Jenkins failures](../docs/troubleshooting/jenkins-troubleshooting.md)
- [Terraform errors](../docs/how-to/terraform-troubleshooting.md)

## Compare semgrep scan vs semgrep ci
- [semgrep scan vs semgrep ci comparison notebook](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## Scan with Checkov (CI/CD)
- [Layered Checkov CI: PR gate + scheduled deep scan + merge block](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml)
- [Checkov SARIF scan — PR gate workflow](../checkov/manifests/checkov-sarif-pr-blocking.yaml)

## Deploy Trivy Operator
- [Trivy Operator deployment manifest](../trivy/manifests/trivy-operator-deployment.yaml) — Operator controller + node collector for cluster-wide vulnerability scanning

## Scan for CVEs
- [Kubernetes CVEs](topics.md#kubernetes)
- [Docker CVEs](topics.md#docker)
- [Jenkins CVE-2026-33001](../docs/security/jenkins/CVE-2026-33001.md)
- [Ansible CVE-2026-33228 remediation](../docs/security/ansible/CVE-2026-33228.md)
- [Docker CVE-2026-34040](../docs/security/docker/CVE-2026-34040.md)
- [Trivy CVE-2026-33634](../docs/security/trivy/CVE-2026-33634.md)
- [Trivy CVE-2026-33001](../docs/how-to/trivy/cve-2026-33001-remediation.md)
- [Vault go-getter CVE](../scripts/bash/vault/security/vault-go-getter-hardening.sh)
- [Scan with Semgrep](../semgrep/notes/0000-primer-semgrep.md)
- [Semgrep CI pipeline from scratch](../semgrep/docs/github-actions-ci-from-scratch.md)
- [Semgrep CI/CD integration guide](../semgrep/docs/semgrep-ci-integration.md)
- [Semgrep rule-writing approaches: pattern vs pattern-inside vs pattern-either](../semgrep/docs/comparing-rule-writing-approaches.md)
- [Semgrep rule writing reference: pattern to metavariable](../semgrep/docs/semgrep-rule-writing-reference.md)
- [Diff-aware Semgrep CI pipeline (manifest)](../semgrep/manifests/diff-aware-semgrep-ci.yaml)
- [Semgrep GitLab CI SAST pipeline (manifest)](../semgrep/manifests/semgrep-gitlab-ci.yaml)
- [Scan with Checkov (K8s)](../checkov/snippets/scan-kubernetes.sh)
- [Scan with Checkov (Terraform)](../checkov/snippets/scan-terraform-dir.py)
- [Scan with Checkov (single file SDK)](../checkov/snippets/scan-a-terraform-file.py)
- [Checkov quickstart walkthrough](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md)
- [Checkov skip & severity config](../checkov/configs/checkov-skip-severity-config.yaml)
- [Checkov pre-commit hook with version pinning](../checkov/docs/pre-commit-hook-with-version-pinning.md)
- [Checkov integration patterns: plan scanning + custom policies](../checkov/docs/checkov-integration-patterns.md)
- [Checkov CI config with framework selection](../checkov/configs/checkov-ci-config.yaml)
- [Build Terraform scanning project with Checkov custom policies](../checkov/snippets/terraform-scan-custom-policies.py)
- [Multi-IaC scanning project scaffold (template)](../checkov/templates/multi-iac-scan-project/)
- [Checkov reusable workflow for custom policies (template)](../checkov/templates/reusable-workflow-custom-policies/)
- [Scan Terraform plan with Checkov](../checkov/scripts/scan-terraform-plan.sh)
- [Deep Checkov Terraform plan scan with severity gating](../checkov/scripts/deep-terraform-plan-scan.sh)
- [Checkov AI infrastructure checks reference (Bedrock, Vertex AI, OpenAI)](../checkov/docs/checkov-ai-infrastructure-checks.md)
- [Custom Semgrep rule — privileged containers](../semgrep/snippets/catch-privileged-containers.yaml)
- [Detect hardcoded secrets with Semgrep](../semgrep/scripts/detect-hardcoded-secrets.py)
- [Multi-rule Semgrep pack with combinators](../semgrep/configs/multi-rule-pack.yaml)
- [Scan Docker images with Trivy](../trivy/scripts/container-vuln-scan.sh)
- [Scan multi-service Docker Compose with Trivy](../trivy/scripts/compose-multi-scan.sh)
- [Automated image vulnerability scanning pipeline](../trivy/scripts/image-vuln-pipeline.sh)
- [Trivy CI/CD pipeline integration](../docs/how-to/trivy-cicd-integration.md)
- [Trivy CI pipeline with SARIF output](../trivy/docs/ci-pipeline-sarif-output.md)
- [Trivy CI/CD pipeline recipes](../trivy/docs/ci-cd-pipeline-recipes.md)
- [Trivy multi-target scanner (image/fs/repo)](../trivy/scripts/multi-target-scanner.sh)
- [Trivy project config (.trivy.yaml)](../trivy/configs/.trivy.yaml)
- [Trivy SARIF output processing notebook](../trivy/notebooks/trivy-sarif-output-processing.ipynb)
- [Trivy scan mode comparison: fs vs image vs repo](../trivy/notebooks/trivy-scan-mode-comparison.ipynb) — Decision guide with practical CI/CD recommendations
- [Trivy SBOM scanning reference guide](../trivy/docs/sbom-scanning-reference-guide.md)
- [Containerized Trivy scanning environment with custom policies (Dockerfile)](../trivy/dockerfiles/custom-policies.Dockerfile)
- [Trivy monorepo scanner scaffold (template)](../trivy/templates/trivy-monorepo-scanner/)
- [Custom Trivy check with Conftest Rego policies](../trivy/scripts/custom-trivy-check-conftest.sh)
- [Trivy SARIF Code Scanning workflow](../trivy/manifests/trivy-sarif-code-scanning.yaml) — GitHub Actions manifest for image and filesystem SARIF scanning with Code Scanning upload

## Scan with Grype
- [Grype primer](../grype/notes/0000-primer-grype.md)
- [Install Grype and run first scan](../grype/notes/2026-05-31-install-grype.md)
- [My first Grype commands](../grype/snippets/my-first-grype-commands.sh)
- [Minimal Grype scan script](../grype/scripts/minimal-grype-scan.sh)
- [Minimal Grype scan with Go SDK](../grype/snippets/minimal-grype-scan.go)
- [Grype quickstart walkthrough](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md)
- [First Grype vulnerability scan](../grype/notes/2026-06-08-first-grype-scan.md)
- [CI-ready Grype scanning wrapper with severity thresholds](../grype/scripts/ci-ready-grype-scan.sh)
- [Vulnerability diff across two image versions](../grype/scripts/vuln-diff-two-images.sh)
- [Grype CI GitHub Actions workflow](../grype/configs/grype-ci-github-actions.yaml)
- [Grype SBOM and vulnerability output explorer](../grype/notebooks/grype-sbom-output-explorer.ipynb)
- [Grype vulnerability scanning pipeline with SARIF output](../grype/scripts/grype-vuln-pipeline.sh) — Scan images, generate SARIF, integrate with CI
- [Grype results to SARIF converter](../grype/scripts/grype-results-to-sarif.py) — Reusable Python script to convert Grype JSON output to SARIF 2.1.0 format
- [Multi-stage Grype vulnerability scanning Dockerfile](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile) — Build + scan + runtime stages with Grype
- [Grype + Syft integration guide](../grype/docs/grype-syft-integration-guide.md) — SBOM generation with Syft, offline scanning with Grype, and CI pipeline integration

## Scan with OPA/Gatekeeper
- [OPA/Gatekeeper primer](../opa/notes/0000-primer-opa.md)
- [Install OPA and explore the REPL](../opa/notes/2026-06-06-install-opa-repl.md)
- [My first OPA policy evaluation](../opa/snippets/my-first-opa-policy-eval.sh)
- [Enforce image registry constraints](../opa/snippets/enforce-image-registry-constraints.rego)
- [OPA getting-started tutorial — what tripped me up](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)
- [Gatekeeper admission policy — block host network](../opa/configs/tried-a-gatekeeper-constraint.yaml)
- [How I test OPA policies locally](../opa/scripts/how-i-test-policies-locally.sh)
- [Deny privileged containers and hostNetwork (Rego snippet)](../opa/snippets/deny-privileged-hostnetwork.rego)
- [How I wired OPA into admission control](../opa/docs/wired-opa-admission-control.md)

## Scan for SBOM generation

- [Syft primer](../syft/notes/0000-primer-syft.md)
- [Install Syft and generate first SBOM](../syft/notes/2026-05-27-install-syft-first-sbom.md)
- [Syft quickstart walkthrough](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)
- [Generate SPDX + CycloneDX SBOMs](../syft/snippets/tried-sbom-formats.sh)
- [Generate all Syft SBOM formats](../syft/scripts/gen-multi-format-sboms.sh)
- [Multi-image SBOM pipeline](../syft/scripts/multi-image-sbom-pipeline.sh)
- [SBOM pipeline scaffold template](../syft/templates/sbom-pipeline-scaffold/) — Syft + Grype CI integration scaffold
- [Syft + Grype SBOM vulnerability pipeline](../syft/scripts/sbom-vuln-pipeline.sh) — Generate a CycloneDX SBOM and scan it with Grype
- [Syft configuration (.syft.yaml)](../syft/configs/.syft.yaml)
- [SBOM format comparison: SPDX vs CycloneDX vs Syft JSON](../syft/docs/sbom-formats-comparison.md)
- [SBOM layer package analysis notebook](../syft/notebooks/sbom-layer-package-analysis.ipynb)
- [Multi-stage Dockerfile with Syft SBOM generation](../syft/dockerfiles/multi-stage-sbom.Dockerfile) — Build + SBOM + runtime pattern
- [Syft SBOM output formats reference](../syft/docs/sbom-output-formats-reference.md) — JSON structure guide for native, CycloneDX, and SPDX formats

## Scan with Snyk
- [Snyk primer](../snyk/notes/0000-primer-snyk.md)
- [Install Snyk CLI and run first project test](../snyk/notes/2026-06-08-install-snyk-first-test.md)
- [Snyk quickstart walkthrough](../snyk/notes/2026-06-07-snyk-quickstart-walkthrough.md)
- [My first Snyk commands](../snyk/snippets/my-first-snyk-commands.sh)
- [Run my first vulnerability scan with Snyk](../snyk/notes/2026-06-14-first-vulnerability-scan.md)
- [Snyk CI pipeline integration with GitHub Actions](../snyk/configs/snyk-ci-github-actions.yaml)
- [Snyk dependency patch and ignore policy](../snyk/configs/snyk-dependency-patch-ignore.yaml)
- [Snyk multi-project CI pipeline with per-service monitoring](../snyk/docs/multi-project-ci-pipeline.md)
- [Snyk vulnerability scanning pipeline](../snyk/scripts/snyk-vuln-scan-pipeline.sh) — Test, monitor, and fail on high CVEs

## Scan with GitGuardian
- [GitGuardian primer](../gitguardian/notes/0000-primer-gitguardian.md)
- [Install ggshield and run first scan](../gitguardian/notes/2026-06-07-first-ggshield-scan.md)
- [My first ggshield commands](../gitguardian/snippets/my-first-ggshield-commands.sh)
- [ggshield scheduled scanning config](../gitguardian/configs/.ggshield.yaml)
- [Custom policy engine with ggshield](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- [Minimal ggshield pre-commit hook integration](../gitguardian/scripts/pre-commit-hook-ggshield.sh)
- [ggshield quickstart walkthrough — trip-ups and next steps](../gitguardian/notes/2026-06-13-ggshield-quickstart-trip-ups.md)
- [Run my first secrets scan on a repo with ggshield](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md)
- [GitGuardian incident response pipeline](../gitguardian/scripts/gg-incident-response-pipeline.sh)
- [Monorepo CI with per-team exclusions](../gitguardian/docs/monorepo-ci-per-team-exclusions.md) — How I wired GitGuardian into a monorepo CI with per-directory allowlist overrides and team-based alert routing

## Scan with Terrascan
- [Terrascan primer](../terrascan/notes/0000-primer-terrascan.md)
- [Install Terrascan and run first scan](../terrascan/notes/2026-06-13-first-scan.md)
- [Deliberately insecure Terraform snippet](../terrascan/snippets/insecure-terraform.tf)
- [Install Terrascan via pip and scan a tiny Terraform file](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md)
- [Minimal Terraform that triggers findings](../terrascan/snippets/tiny-tf-with-findings.tf)
- [Minimal Terrascan CI scan script](../terrascan/scripts/tried-terrascan-ci-scan.sh) — Scan Terraform and fail on high severity violations
- [Custom S3 bucket policy rule (config)](../terrascan/configs/tried-custom-s3-rule.yaml) — Custom Rego rules for S3 public access and encryption checks
- [Terrascan getting-started tutorial — what tripped me up](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md) — L2 notes following the official quick start: install, scan, exit codes, and CI gating gotchas

## Scan with CodeQL
- [CodeQL primer](../codeql/notes/0000-primer-codeql.md)
- [CodeQL quickstart walkthrough: custom query and upload](../codeql/notes/2026-06-05-install-codeql-first-analysis.md)
- [CodeQL QL Datalog gotchas from the language tutorial](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md)
- [My first CodeQL analysis (workflow)](../codeql/configs/first-codeql-analysis.yml)
- [My first CodeQL query: hardcoded credentials in Python](../codeql/snippets/find-hardcoded-creds.ql)
- [Hardcoded credential via local data flow](../codeql/snippets/hardcoded-creds-local-flow.ql) — L3 query using taint tracking
- [Minimal CodeQL database + query runner](../codeql/scripts/first-codeql-analysis.sh)
- [How I wired custom queries into a GitHub Actions CI pipeline](../codeql/docs/wired-custom-queries-into-ci.md)
- [Multi-language CodeQL analysis CI workflow](../codeql/manifests/multi-language-codeql-analysis.yaml) — Matrix workflow for Python, JavaScript, Go, and Java

## Update dependencies with Dependabot
- [Dependabot primer](../dependabot/notes/0000-primer-dependabot.md)
- [Minimal Dependabot npm update config](../dependabot/configs/tried-npm-dependabot.yaml)
- [First-time Dependabot setup — what tripped me up](../dependabot/notes/2026-06-22-first-time-dependabot-setup.md)
- [Dependabot alerts and security updates — what tripped me up](../dependabot/notes/dependabot-alerts-security-updates.md)

## Build a Semgrep rule pack
- [Multi-rule pack with combinators](../semgrep/configs/multi-rule-pack.yaml)

## Custom Semgrep scanning Docker image
- [Custom Semgrep scanning image (Dockerfile)](../semgrep/dockerfiles/custom-scanning-image.Dockerfile)

## Compare scanning approaches
- [Checkov static vs plan scanning notebook](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb)
- [Semgrep scan vs semgrep ci notebook](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb)

## Scan for leaked secrets
- [TruffleHog primer](../trufflehog/notes/0000-primer-trufflehog.md)
- [Install TruffleHog and scan a repo](../trufflehog/notes/2026-05-27-install-trufflehog.md)
- [Test fake secrets scan with TruffleHog](../trufflehog/snippets/fake-secrets-test.sh)
- [TruffleHog quickstart walkthrough](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md)
- [Comparing TruffleHog scan modes: git vs filesystem vs S3](../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md)
- [TruffleHog output format reference — JSON, SARIF, and CSV for CI ingestion](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md) — Reference covering v3+ JSON schema, SARIF conversion, and CSV export patterns for GitHub Actions and other CI pipelines
- [Scan a GitHub repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh)
- [Custom regex + entropy config for TruffleHog](../trufflehog/configs/trufflehog-custom-regex-config.yaml)
- [Pre-commit secret scanning pipeline](../trufflehog/scripts/pre-commit-scan-pipeline.sh)
- [Multi-repo secret scanning pipeline](../trufflehog/scripts/multi-repo-scan-pipeline.sh)
- [Custom detector rules for proprietary patterns](../trufflehog/configs/custom-detector-rules.yaml)
- [Analyzing TruffleHog false positives notebook](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)
- [TruffleHog scan modes comparison notebook](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb) — Git history vs filesystem vs GitHub API scanning
- [TruffleHog secret scanning pipeline scaffold (template)](../trufflehog/templates/secret-scanning-pipeline/)
- [TruffleHog multi-repository configuration scaffold (template)](../trufflehog/templates/multi-repo-secret-scan/) — Centralized config and allowlist for organization-wide scanning
- [Analyze TruffleHog results (Python helper)](../trufflehog/scripts/analyze-trufflehog-results.py) — Filter, group, and summarize TruffleHog JSON output
- [Dockerized TruffleHog pre-commit scanner (Dockerfile)](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile) — Containerized secret scanning for pre-commit hooks
- [TruffleHog GitHub secret scanning integration scaffold (template)](../trufflehog/templates/github-secret-scanning-integration/)
- [TruffleHog PR secret scan reusable workflow (manifest)](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml) — Reusable GitHub Actions workflow for PR-level secret scanning with SARIF upload and verified-only gating

## Scan with OWASP ZAP
- [ZAP primer](../zap/notes/0000-primer-zap.md)
- [Install ZAP and explore the desktop UI](../zap/notes/2026-06-06-install-zap-desktop-ui.md)
- [My first ZAP baseline scan](../zap/snippets/my-first-zap-baseline-scan.sh)
- [ZAP quickstart walkthrough — UI gotchas](../zap/notes/2026-06-06-zap-quickstart-ui-gotchas.md)
- [Authenticated scan context config](../zap/configs/zap-authenticated-scan-context.yaml) — Form-based auth context with CSRF handling
- [Passive vs active scanning in ZAP](../zap/docs/passive-vs-active-scanning-zap.md) — When to use each mode and a practical workflow split
- [Authenticated scan with ZAP context](../zap/snippets/authenticated-scan-with-context.sh)
- [ZAP integration patterns for web app security testing](../zap/docs/zap-integration-patterns.md)
- [Spider scan against a test app](../zap/notes/2026-06-13-spider-scan-test-app.md)
- [DAST workflow from spider to active scan](../zap/scripts/dast-workflow-from-scratch.sh) — Start ZAP, crawl a target, run active scanning, and save reports
- [My first ZAP spider scan via API](../zap/snippets/my-first-zap-spider-scan.sh)
- [CI-integrated DAST Automation Framework plan](../zap/configs/ci-dast-automation-framework-plan.yaml) — Headless scanning pipeline for CI environments
- [ZAP DAST pipeline with SARIF output and GitHub Code Scanning](../zap/scripts/zap-dast-sarif-code-scanning.sh) — Run DAST scan, convert alerts to SARIF, and upload to GitHub Code Scanning
- [Custom ZAP Docker image with pre-configured Automation Framework plans](../zap/dockerfiles/custom-zap-automation.Dockerfile) — Self-contained image with embedded quick-scan and full-scan plans
- [OWASP ZAP DAST integration scaffold (template)](../zap/templates/zap-dast-integration/) — GitHub Actions workflow + Automation Framework plan for CI-integrated DAST scanning
- [ZAP DAST CI scaffold (template)](../zap/templates/dast-github-actions-scaffold/) — GitHub Actions scaffold with Automation Framework plans for CI-integrated DAST scanning

## Runtime security with Falco
 - [Falco primer](../falco/notes/0000-primer-falco.md)
 - [Install Falco and run first detection](../falco/notes/2026-06-10-install-falco-first-detection.md)
 - [Falco rule structure — macros, lists, and the append trick](../falco/notes/2026-06-15-falco-rules-macros-lists.md)
 - [My first custom Falco rule: detect shell in container](../falco/configs/first-custom-rule-detect-shell-in-container.yaml)
 - [Custom Falco rules for container drift detection](../falco/configs/container-drift-detection.yaml)
 - [Comparing syscall vs tracepoint rules for container monitoring](../falco/docs/syscall-vs-tracepoint-rules.md) — Syscall vs tracepoint rule sources, coverage, and performance tradeoffs
 - [Deploy custom Falco ruleset with Helm](../falco/scripts/deploy-falco-ruleset.sh)
 - [Deploy Falco with alert forwarding via Falcosidekick](../falco/scripts/tried-falco-k8s-alert-forwarding.sh) — L2 bash script that deploys Falco with JSON output and forwards alerts to a webhook
 - [Go Falco event parser: suspicious file access detector](../falco/snippets/tried-file-access-detector.go) — L2 Go snippet that reads Falco JSON output and alerts on sensitive file access patterns
 - [Minimal Falco deployment with alert forwarding](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh) — L2 bash script: deploy Falco on Kubernetes, configure stdout or webhook alert forwarding, and test with a trigger alert

## Runtime security with Tetragon
- [Tetragon primer](../tetragon/notes/0000-primer-tetragon.md)
- [Install Tetragon via Docker and observe first events](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md) — L1 first-person walkthrough of running Tetragon in standalone Docker mode and streaming process events with tetra
- [First TracingPolicy: exec and file access](../tetragon/configs/first-tracing-policy-exec-file.yaml) — Minimal TracingPolicy to observe exec and file access events

## Manage secrets with Vault
- [Vault primer](../vault/notes/0000-primer-vault.md)
- [Install Vault and explore the CLI](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
- [Vault getting-started tutorial — what tripped me up](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md)
- [My first Vault read/write commands](../vault/snippets/vault-read-write.go)
- [Minimal Vault KV CRUD script](../vault/scripts/vault-kv-crud.sh)
- [Vault dynamic database secrets workflow](../vault/scripts/vault-db-dynamic-secrets.sh) — Postgres dynamic credentials from scratch: config, role, generate, verify, revoke
- [Configuring Vault's dev server](../vault/docs/configuring-vault-dev-server.md)
- [Vault Agent auto-auth with Kubernetes service accounts](../vault/docs/vault-agent-auto-auth-kubernetes.md) — L3 docs: wire Vault Agent sidecar to authenticate via Kubernetes service account and render secrets into pods
- [Vault dev/test policy and secrets engine config](../vault/configs/2026-06-26-dev-test-policies.hcl) — L2 HCL policy configuration for KV v2 with separate dev (full CRUD) and test (read-mostly) access
- [Vault multi-environment access control policy](../vault/configs/multi-environment-access-control.hcl) — L3 HCL policy for dev/staging/prod secrets, transit, database, and PKI engine access

## Run a Kubernetes task
- [k8s_toolkit usage guide](../docs/how-to/k8s_toolkit.md)
- [Context switcher](../scripts/bash/k8s_toolkit/context/context-manager.sh)
- [Drain a node](../scripts/bash/k8s_toolkit/node/drain-node.sh)
- [Rollout restart](../scripts/bash/k8s_toolkit/rollout-restart.sh)
- [Rollout status check](../scripts/bash/k8s_toolkit/rollout-status.sh)
- [Debug pod](../scripts/bash/k8s_toolkit/debug/debug-pod.sh)
- [Pod exec](../scripts/bash/k8s_toolkit/pod/exec-pod.sh)
- [Pod logs](../scripts/bash/k8s_toolkit/pod/pod-logs.sh)
- [Decode K8s secret](../scripts/bash/k8s_toolkit/secret/decode-secret.sh)
- [Namespace resource report](../scripts/bash/k8s_toolkit/report/namespace-report.sh)
- [Clean up jobs](../scripts/bash/k8s_toolkit/job/cleanup-jobs.sh)
- [Production deployment template](../templates/k8s/production-deployment.yaml)
- [Deploy production app](../templates/k8s/deploy-prod-app.sh)
- [Kubectl cheatsheet](../snippets/kubectl-cheatsheet.md)

## Run a Linux administration task
- [Linux toolkit usage guide](../docs/how-to/linux_toolkit.md)
- [System health check](../scripts/bash/linux_toolkit/system/health-check.sh)
- [Disk usage](../scripts/bash/linux_toolkit/system/disk-usage.sh)
- [Service management](../scripts/bash/linux_toolkit/service/manage-services.sh)
- [Network diagnostics](../scripts/bash/linux_toolkit/network/net-diag.sh)
- [Process manager](../scripts/bash/linux_toolkit/process/process-manager.sh)
- [User create](../scripts/bash/linux_toolkit/sysadmin/user-create.sh)
- [User modify](../scripts/bash/linux_toolkit/sysadmin/user-modify.sh)
- [System backup](../scripts/bash/linux_toolkit/sysadmin/system-backup.sh)
- [Security check](../scripts/bash/linux_toolkit/security/security-check.sh)
- [Linux cheatsheet](../snippets/linux-cheatsheet.md)

## Run a Terraform workflow
- [Terraform workflow script](../scripts/bash/terraform_toolkit/terraform-workflow.sh)
- [Multi-environment setup](../scripts/bash/terraform_toolkit/multi-env/multi-env-setup.sh)
- [Terraform commands cheatsheet](../snippets/terraform-commands.md)
- [State management guide](../docs/how-to/terraform-state-management.md)
- [Module composition guide](../docs/how-to/terraform-module-composition-workspaces.md)

## Work with Kafka
- [Kafka toolkit usage guide](../docs/how-to/kafka_toolkit.md)
- [Topic list](../scripts/bash/kafka_toolkit/topics/topic-list.sh)
- [Topic create](../scripts/bash/kafka_toolkit/topics/topic-create.sh)
- [Topic config](../scripts/bash/kafka_toolkit/topics/topic-config.sh)
- [Topic delete](../scripts/bash/kafka_toolkit/topics/topic-delete.sh)
- [Consumer group management](../scripts/bash/kafka_toolkit/consumers/consumer-groups.sh)
- [Consumer lag monitoring](../scripts/bash/kafka_toolkit/monitoring/consumer-lag.sh)
- [Cluster health check](../scripts/bash/kafka_toolkit/admin/cluster-health.sh)
- [ACL management](../scripts/bash/kafka_toolkit/acl/manage-acls.sh)
- [Kafka cheatsheet](../snippets/kafka-cheatsheet.md)

## Work with container registries
- [OCI registry toolkit usage guide](../docs/how-to/oci_registry_toolkit.md)
- [List repos](../scripts/bash/oci_registry_toolkit/registry/list-repos.sh)
- [List tags](../scripts/bash/oci_registry_toolkit/registry/list-tags.sh)
- [Find old tags](../scripts/bash/oci_registry_toolkit/tags/find-old-tags.sh)
- [Harbor deploy](../scripts/bash/harbor/harbor-deploy.sh)
- [ACR deploy](../scripts/bash/azure_toolkit/acr/acr-deploy.sh)
- [GAR deploy](../scripts/bash/oci_registry_toolkit/gar/gar-deploy.sh)
- [Quay deploy](../scripts/bash/oci_registry_toolkit/quay/quay-deploy.sh)
- [OCI registry cheatsheet](../snippets/oci-registry-cheatsheet.md)

## Get started with Git
- [Git primer](../git/notes/0000-primer-git.md) — What Git is, key terminology, and the basic commit workflow (L1)

## Sign container images with Cosign
- [Cosign primer](../cosign/notes/0000-primer-cosign.md)
- [Install Cosign and generate first keypair](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md)
- [Install Cosign and sign first image](../cosign/notes/2026-06-13-install-cosign-sign-first-image.md)
- [Cosign getting-started tutorial — what tripped me up](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md)
- [Cosign keyless GitHub Actions CI signing config](../cosign/configs/keyless-signing-github-actions.yaml)
- [Sign and verify my first image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- [Verify a signed image](../cosign/scripts/verify-signed-image.sh)
- [Minimal sign and verify script](../cosign/scripts/minimal-sign-verify.sh) — Quick key pair workflow with Cosign

## Manage security findings with DefectDojo
- [DefectDojo primer](../defectdojo/notes/0000-primer-defectdojo.md) — What DefectDojo is, key terminology, and a local Docker Compose startup example (L1)
- [Install DefectDojo and import first scan report](../defectdojo/snippets/install-defectdojo-first-scan-report.sh) — Clone repo, start stack, and point browser at localhost:8080

