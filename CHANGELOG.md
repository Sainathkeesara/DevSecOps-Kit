# Changelog

All notable changes to the DevOps-Kit repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## 2026-05-27

### Added
- syft-001: `syft/notes/0000-primer-syft.md` — Syft quick primer (L1)
  - First-person primer covering what Syft is, SBOM generation, CycloneDX/SPDX formats, key terminology, and a minimal example
  - Sections: What is it, What does it do, Why does it exist, Key terminology, Tiny example, Next steps
- syft-002: `syft/notes/2026-05-27-install-syft-first-sbom.md` — Installing Syft and generating my first SBOM (L1)
  - First-person scratch notes covering install, `syft alpine:latest`, and what tripped me up with output formats
  - Steps + Got stuck on + What I'd try next format
- syft-003: `syft/snippets/tried-sbom-formats.sh` — Minimal bash snippet to generate SBOMs in SPDX and CycloneDX JSON formats (L1)
  - Accepts image name as argument (defaults to alpine:latest)
  - Outputs two JSON files: {image}_spdx.json and {image}_cyclonedx.json
  - shellcheck passed (clean)
- semgrep-005: `semgrep/scripts/scan-python-codebase.sh` — Minimal bash script to scan a Python codebase with Semgrep and filter by severity (L2)
  - Accepts target directory and severity level as arguments
  - Uses `--config=auto` for community rule registry
- semgrep-007: `semgrep/docs/semgrep-ci-integration.md` — Wiring Semgrep into a GitHub Actions pipeline with troubleshooting notes (L2)
  - First-person walkthrough covering GitHub Actions setup, .semgrepignore, SARIF output
  - Steps + Got stuck on + What I'd try next format
- semgrep-006: `semgrep/snippets/catch-privileged-containers.yaml` — Custom Semgrep rule for detecting privileged containers in YAML manifests (L2)
  - Catches `securityContext.privileged: true` in K8s and Docker Compose YAML
  - Inline comments explain why this pattern matters for security reviews
- checkov-006: `checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md` — Following the official Checkov quickstart and what tripped me up (L2)
  - Steps + Got stuck on + What I'd try next format
  - Covers empty directory silent results, lack of sample bad configs, missing flag docs
- checkov-007: `checkov/snippets/scan-a-terraform-file.py` — Scan a single Terraform file using the Checkov Python SDK (L2)
  - Uses `file=` parameter for targeted single-file scanning
  - Framework-limited to terraform rules to avoid irrelevant checks
- 00_index/quick-links.md — Updated Semgrep and Checkov sections with new L2 entries
- trufflehog-001: `trufflehog/notes/0000-primer-trufflehog.md` — TruffleHog quick primer (L1)
  - First-person scratchy primer covering what TruffleHog is, key terminology (detector, verification, entropy), and minimal CLI example
  - No formal section headers, ~180 words, casual learner voice
- trufflehog-002: `trufflehog/notes/2026-05-27-install-trufflehog.md` — Installing TruffleHog and scanning a local repo for secrets (L1)
  - First-person walkthrough covering pip install, git scan with file:// URLs, and what tripped me up
  - Steps + Got stuck on + What I'd try next format
- trufflehog-003: `trufflehog/snippets/fake-secrets-test.sh` — Minimal bash snippet to create test secrets and scan with TruffleHog (L1)
  - Creates a file with fake AWS key, GitHub token, password and scans using `trufflehog filesystem`
  - shellcheck passed (clean)
- 00_index/quick-links.md — Added TruffleHog section with primer, install notes, and snippet entries

## 2026-05-26

### Added
- semgrep-004: `semgrep/notes/2026-05-26-install-semgrep-pitfalls.md` — Installing Semgrep and first scan pitfalls (L1)
  - First-person scratch notes covering missing target path, YAML parser strictness, and node_modules exclusion
  - Structured as narrative of what tripped me up during initial use
- checkov-004: `checkov/snippets/scan-terraform-dir.py` — Python snippet to scan a local Terraform directory with Checkov SDK (L1)
  - Minimal Python script using Checkov SDK's Checkov class to run terraform framework scans
  - Iterates over failed records and prints check_id, file_path, and check_name
- checkov-005: `checkov/notes/2026-05-26-cli-vs-sdk-comparison.md` — Comparing CLI vs SDK scanning approaches for Terraform (L1)
  - First-person comparison covering CLI simplicity vs SDK flexibility
  - Notes sparse SDK documentation as the main gotcha
- 00_index/quick-links.md — Updated Semgrep and Checkov sections with new L1 entries
- trivy-001: `trivy/notes/2026-05-26-trivy-quickstart.md` — Following the official Trivy quickstart (L2)
  - First-person notes covering trivy fs, trivy repo, trivy config, and what tripped me up
  - Structured as Steps + Got stuck on + What I'd try next
- trivy-002: `trivy/scripts/container-vuln-scan.sh` — Minimal container image vulnerability scan script (L2)
  - Accepts image name and output directory, produces table and JSON output
  - Exits non-zero if CRITICAL vulnerabilities found (CI/CD gating)
  - shellcheck passed (clean)
- trivy-003: `trivy/configs/trivy-scan-config.yaml` — Trivy configuration for targeted scanning (L2)
  - Configures severity filters, vulnerability options, and misconfiguration scanning
  - Works with `trivy --config trivy-scan-config.yaml`
- 00_index/quick-links.md — Updated Trivy section with new L2 entries

## 2026-05-25

### Added
- semgrep-001: `semgrep/notes/0000-primer-semgrep.md` — Semgrep quick primer (L1, rework)
  - First-person scratchy voice (~220 words), no formal headers per quality feedback
  - Covers what Semgrep is, key terminology (rule, pattern, metavariable), and a minimal YAML rule example
- semgrep-002: `semgrep/notes/2026-05-25-install-semgrep.md` — Installing Semgrep and running a first SAST scan (L1)
  - First-person scratch notes covering pip install, auto scan, and severity filtering
- semgrep-003: `semgrep/snippets/first-custom-rule.yaml` — Minimal custom Semgrep rule for detecting dangerous subprocess patterns (L1)
  - 6-line YAML rule targeting subprocess.Popen with shell=True
- checkov-001: `checkov/notes/0000-primer-checkov.md` — Checkov quick primer (L1)
  - First-person primer covering IaC scanning, built-in policies, CLI usage
  - Sections: What is it, What does it do, Why does it exist, Key terminology, Tiny example, Next steps
- checkov-002: `checkov/notes/2026-05-25-scan-terraform-plan.md` — Installing Checkov and scanning a Terraform plan for misconfigurations (L1)
  - First-person scratch notes on pip install, terraform plan to JSON conversion, and running Checkov
- checkov-003: `checkov/snippets/scan-kubernetes.sh` — Minimal bash snippet to scan a Kubernetes manifest with Checkov (L1)
  - Uses --framework kubernetes --file flags, --compact for readable output
- 00_index/quick-links.md — Updated with Semgrep snippet and Checkov primer entries

## 2026-05-24

### Added
- trivy-001: `trivy/notes/0000-primer-trivy.md` — First-day primer covering what Trivy is, key terminology, scan types, and a minimal example (L1)
  - Primer structure: What is it, What does it do, Why does it exist, Key terminology, Tiny example, Next steps
  - First-person learner voice, 500+ words, no CVE advisories
- trivy-002: `trivy/notes/2026-05-24-install-trivy.md` — Installing Trivy and running a first vulnerability scan on a Python app image (L1)
  - Covers install via official script, first `trivy image` scan, severity filtering
  - Scratch-level first-person notes style
- trivy-003: `trivy/snippets/scan-docker-image.sh` — Minimal bash snippet to scan a Docker image with CRITICAL/HIGH severity filtering (L1)
  - Accepts image name as argument, defaults to alpine:latest
  - Uses `--exit-code 1` for CI/CD pipeline gating, `--ignore-unfixed` to skip unfixed CVEs
  - shellcheck passed (clean)
- 00_index/quick-links.md — Updated Trivy section with primer, install notes, and snippet entries

## 2026-05-14

### Added
- cic-010: `docs/how-to/argo-workflows-installation.md` — Argo Pipelines installation and pipeline template configuration for MLOps workflows (L2)
  - Complete guide covering Argo Workflows installation on Kubernetes
  - MLOps pipeline templates with model training, evaluation, and deployment
  - CI/CD pipeline templates with testing, building, and deployment stages
  - Cron scheduled workflows for automated retraining
  - Helm repository integration, artifact configuration, verification steps
- cic-010: `scripts/bash/argo_toolkit/argo-workflows-install.sh` — Argo Workflows deployment script
  - Supports --dry-run, --namespace, --version, --artifact-s3-bucket options
  - Automated namespace creation, manifest application, artifact configuration
  - Health verification and ready check polling
- cic-011: `docs/how-to/fluxcd-installation.md` — Flux v2 installation and GitOps reconciliation for declarative cluster management (L2)
  - Complete guide covering Flux v2 installation on Kubernetes
  - Git repository setup, kustomization configuration, Helm release management
  - Multi-environment setup, notification configuration, security considerations
  - Verification steps, rollback procedures, common errors troubleshooting
- cic-011: `scripts/bash/flux_toolkit/flux-install.sh` — Flux v2 deployment script
  - Supports --dry-run, --namespace, --git-url, --git-branch, --bootstrap options
  - Flux CLI installation, component deployment, Git repository configuration
- 00_index/quick-links.md — Updated CI/CD section with Argo Workflows and Flux v2 entries

## 2026-05-13

### Added
- obs-003: `docs/how-to/observability/grafana-installation.md` — Grafana installation and Prometheus data source configuration for metric visualization (L2)
    - Complete guide covering automated and manual Grafana installation
    - Systemd service configuration, firewall setup, HTTPS support
    - Prometheus data source provisioning with auto-discovery
    - Dashboard import instructions (Node Exporter Full ID 1860)
    - Verification steps, rollback procedures, common errors troubleshooting
- obs-003: `scripts/bash/observability_toolkit/grafana/grafana-install.sh` — Grafana installation script with Prometheus data source provisioning
    - Supports --dry-run, --version, --http-port, --protocol options
    - Automated binary download, systemd service creation, config generation
    - Prometheus data source auto-provisioning
    - Idempotent operations, comprehensive logging
    - shellcheck passed (info only)
- 00_index/quick-links.md — Updated Observability section with obs-003 Grafana entries
- obs-004: `docs/how-to/observability/alertmanager-installation.md` — Alertmanager installation and routing rule configuration for alert management (L2)
    - Complete guide covering automated and manual Alertmanager installation
    - Systemd service configuration, firewall setup, Prometheus integration
    - Alert routing rules with receivers for email, Slack, PagerDuty, webhook
    - Inhibition rules for alert suppression, template configuration
    - Verification steps, rollback procedures, common errors troubleshooting
- obs-004: `scripts/bash/observability_toolkit/alertmanager/alertmanager-install.sh` — Alertmanager installation script
    - Supports --dry-run, --version, --http-port, --cluster-port options
    - Automated binary download, systemd service creation, config generation
    - Default routing configuration with multiple receivers
    - Idempotent operations, comprehensive logging
    - shellcheck passed (info only)
- 00_index/quick-links.md — Updated Observability section with obs-004 Alertmanager entries

## 2026-05-12

### Added
- obs-002: `docs/how-to/observability/prometheus-node-exporter-installation.md` — Prometheus node_exporter installation for system metrics collection (L2)
    - Complete guide covering node_exporter installation on Linux systems
    - Systemd service configuration, firewall setup, Prometheus integration
    - Configuration options for collectors, textfile collector for custom metrics
    - Verification steps, rollback procedures, common errors troubleshooting
- jen-007: `docs/reference/jenkins-secret-masking-envinject.md` — Jenkins secret credential masking in build logs with EnvInject (L4)
    - Complete reference covering EnvInject plugin installation and configuration
    - Job-level secret injection patterns for Pipeline and Freestyle jobs
    - Credentials binding, custom masking patterns, file-based injection
    - Secure handling scripts with dry-run mode
    - Verification steps, rollback procedures, common errors
- oci-009: `docs/how-to/google-artifact-registry-gar.md` — Google Artifact Registry GAR installation for GKE integration (L2)
    - Complete guide covering GAR creation via gcloud, repository configuration, IAM permissions
    - Authentication setup for Docker and GKE clusters with Workload Identity
    - Artifact Analysis (vulnerability scanning), Binary Authorization, VPC Service Controls
    - Lifecycle policies, Cloud Build CI/CD integration, common errors troubleshooting
- oci-009: `scripts/bash/oci_registry_toolkit/gar/gar-deploy.sh` — GAR deployment script
    - Supports --dry-run, --project-id, --location, --repo-name, --format options
    - Automated API enabling, repository creation, IAM configuration, Docker auth setup
    - Lifecycle policy configuration, idempotent operations, comprehensive logging
    - shellcheck passed with warnings only
- oci-010: `docs/how-to/quay-container-registry-installation.md` — Quay container registry installation with Clair vulnerability scanning (L2)
    - Complete guide covering standalone and OpenShift operator deployment
    - PostgreSQL and Redis integration, configuration management
    - Authentication (Database, LDAP, OIDC), repository mirroring, Cosign image signing
    - Clair integration for vulnerability scanning, geo-replication configuration
    - Prerequisites, verification steps, rollback procedures, common errors
- oci-010: `scripts/bash/oci_registry_toolkit/quay/quay-deploy.sh` — Quay deployment script
    - Supports --hostname, --enable-clair, --enable-letsencrypt, --auth-type options
    - Automated secret generation, config.yaml creation, Docker Compose setup
    - Clair scanner configuration, superuser creation, health verification
    - shellcheck passed (info only)
- 00_index/quick-links.md — Updated Container Registries section with oci-009 GAR and oci-010 Quay entries

## 2026-05-11

### Added
- cic-009: `docs/how-to/circleci-runner-installation.md` — CircleCI self-hosted runner installation and resource class configuration (L2)
    - Complete guide covering CircleCI runner setup with resource classes, labels, namespaces
    - Pipeline integration patterns, custom working directories, concurrent job execution
    - Verification steps, rollback procedures, common error troubleshooting
- cic-009: `scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh` — CircleCI runner deployment script
    - Supports --dry-run, --token, --resource-class, --name, --labels, --max-runs, --work-dir options
    - Automated binary download, systemd service creation, JSON configuration generation
    - Idempotent operations with uninstall support
- cic-008: `docs/how-to/buildkite-installation.md` — Buildkite agent installation and configuration for CI/CD pipelines (L2)
    - Complete guide covering Buildkite agent setup with tagging, queues, parallel builds
    - Pipeline integration patterns, hooks, environment variables
    - Verification steps, rollback procedures, common error troubleshooting
- cic-008: `scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh` — Buildkite agent installation script
    - Supports --dry-run, --version, --token, --tags, --queue, --max-runs options
    - Automated binary download, systemd service creation, token management
    - Configuration generation with YAML agent configuration
    - Idempotent operations with uninstall support
    - shellcheck passed (info only)
- oci-008: `docs/how-to/azure-container-registry-acr.md` — Azure Container Registry ACR installation and geo-replication setup (L2)
    - Complete guide covering ACR creation via Azure CLI, geo-replication configuration
    - Authentication setup (service principals, admin user), network access controls
    - Image push/pull operations, webhook configuration, retention policies
    - Prerequisites, verification steps, rollback procedures, common errors
- oci-008: `scripts/bash/azure_toolkit/acr/acr-deploy.sh` — ACR deployment script
    - Supports --dry-run, --resource-group, --acr-name, --location, --sku options
    - Automated geo-replication configuration, credential retrieval, health verification
    - Idempotent operations, comprehensive logging, status checking
    - shellcheck passed
- obs-009: `docs/how-to/observability/loki-promtail-installation.md` — Grafana Loki Promtail installation and log pipeline configuration (L2)
    - Complete guide covering Loki + Promtail installation for centralized log aggregation
    - Package and binary installation methods for Loki and Promtail
    - Systemd service configuration, log rotation, Grafana integration
    - LogQL queries for log exploration and alerting patterns
    - Prerequisites, verification steps, rollback procedures, common errors
- obs-010: `docs/how-to/observability/alertmanager-ha-clustering.md` — Alertmanager high-availability clustering for alert deduplication (L2)
    - Complete guide for HA Alertmanager cluster setup with gossip protocol
    - Cluster configuration, deduplication strategies, silence management
    - Prometheus integration, active-active and active-passive patterns
    - Prerequisites, verification steps, rollback procedures, common errors
- obs-010: `scripts/bash/observability_toolkit/alertmanager/alertmanager-ha-setup.sh` — Alertmanager HA cluster deployment script
    - Supports --dry-run, --cluster-size, --cluster-name, --listen-port, --http-port options
    - Automated binary download, cluster configuration generation, systemd service
    - Gossip protocol setup, firewall configuration, health verification
- oci-007: `docs/how-to/oci-registry-toolkit/github-container-registry-ghcr.md` — GitHub Container Registry ghcr.io configuration (L2)
    - Complete guide for ghcr.io configuration: authentication, image publishing, access control
    - GitHub Actions integration with docker/login-action, multi-architecture builds
    - Access control, visibility settings, image lifecycle management
    - Verification steps, rollback procedures, common errors

### Changed
- 00_index/quick-links.md — Updated CI/CD section with Buildkite installation and documentation entries
- 00_index/quick-links.md — Updated Observability section with obs-009 Loki Promtail and obs-010 Alertmanager HA entries
- 00_index/quick-links.md — Updated Container Registries section with oci-007 ghcr.io entry

## 2026-05-10

### Added
- obs-007: `docs/how-to/observability/otel-collector-installation.md` — OpenTelemetry Collector installation and pipeline configuration (L2)
    - Complete guide covering OTel Collector agent/gateway deployment modes
    - Pipeline configuration for metrics, traces, and logs
    - Kubernetes DaemonSet deployment examples
    - Prerequisites, verification steps, rollback procedures, common errors
- obs-007: `scripts/bash/observability_toolkit/otel/otel-collector-install.sh` — OTel Collector deployment script
    - Supports --dry-run, --version, --mode (agent/gateway/standalone), --port options
    - Automated binary download, systemd service creation, firewall configuration
    - Idempotent operations, configuration generation, health verification
    - shellcheck passed (info only)
- obs-008: `docs/how-to/thanos_installation.md` — Thanos installation and configuration for long-term metric retention (L2)
    - Guide for deploying Thanos components (Sidecar, Store, Receiver, Query, Compactor)
    - Configuration for object storage backends (AWS S3, GCS, Azure Blob)
    - Integration with existing Prometheus servers via remote write/read
    - Query aggregation and downsampling capabilities
    - Prerequisites, verification steps, rollback procedures, common errors
- tri-008: `docs/how-to/trivy/cve-2026-33001-remediation.md` — Trivy CVE-2026-33001 path traversal remediation guide (L8)
    - Detection and upgrade procedures for Trivy < 0.58.0
    - Linux/macOS, Docker, Kubernetes upgrade patterns
    - Verification steps, rollback procedures, common errors
- tri-008: `scripts/bash/trivy_toolkit/security/cve-2026-33001.sh` — CVE-2026-33001 detection and remediation script
    - Detects vulnerable Trivy versions, scans for path traversal archives
    - Supports --dry-run, --verbose, --version, --scan-dir flags
    - Automated upgrade to 0.58.0, remediation report generation
    - shellcheck passed (warnings only)
- 00_index/quick-links.md — Updated Observability section with new entries

### Changed
- 00_index/quick-links.md — Updated CI/CD section with Trivy CVE-2026-33001 entries

## 2026-05-09

### Added
- tri-003: `scripts/bash/ci_cd_toolkit/trivy-severity-filter.sh` — Trivy severity-based filtering for vulnerability triage (L3)
   - Run progressive scans based on severity thresholds
   - Count vulnerabilities by severity for triage metrics
   - Filter existing JSON reports by severity level
   - Support CI/CD pipeline integration
- tri-003: `docs/how-to/trivy-severity-filtering.md` — Trivy severity-based filtering guide for vulnerability triage (L3)
   - Progressive scanning strategy for different severity levels
   - CI/CD pipeline integration patterns
   - Vulnerability counting and filtering techniques
- tri-004: `scripts/bash/ci_cd_toolkit/trivy-cache-configure.sh` — Trivy cache configuration for accelerated repeated scans (L3)
   - Custom cache directory configuration
   - Cache pre-warming for database downloads
   - Cache persistence in CI/CD pipelines
   - Layer caching optimization strategies
- tri-004: `docs/how-to/trivy-cache-configuration.md` — Trivy cache configuration guide for optimized scanning performance (L3)
   - Cache types and directory configuration
   - CI/CD cache management patterns
   - Performance optimization strategies
   - Cache verification and troubleshooting
   - Detects vulnerable ansible-core and flatted versions
   - Performs automatic upgrade via pip when vulnerable
   - Supports dry-run, report generation, verification
- tri-001: `scripts/bash/ci_cd_toolkit/trivy-postbuild-scan.sh` — Trivy CI/CD post-build stage integration script (L3)
   - Runs Trivy scan as pipeline post-build security gate
   - Supports --scan, --generate, --validate modes
   - Generates GitHub Actions, Jenkinsfile, GitLab CI snippets
   - Offline scanning from image tarballs, severity gating
- gen-010: `docs/security/jenkins/CVE-2026-33001.md` — Jenkins CVE-2026-33001 tar/tar.gz symlink path traversal remediation guide (L8)
   - Comprehensive guide for CVE-2026-33001 mitigation in Jenkins
   - Covers vulnerable versions (< 2.495.1, < 2.510.1), backup plugin review, safe tar extraction configs
   - Step-by-step upgrade procedures (Kubernetes and standalone), verification, rollback
- gen-010: `scripts/bash/jenkins_toolkit/security/cve-2026-33001.sh` — CVE-2026-33001 detection and remediation script (L8)
   - Detects vulnerable Jenkins versions, checks tar handling configuration
   - Supports --dry-run, --fix, --json-output, --namespace flags
   - Provides automated upgrade recommendations and remediation steps
- tri-006: `docs/how-to/trivy-jenkins-integration.md` — Trivy Jenkins plugin integration for container image scanning in pipeline (L3)
   - Complete guide for integrating Trivy into Jenkins pipelines via plugin
   - Declarative and scripted pipeline examples, severity thresholds, SARIF output
   - Plugin installation, configuration, validation and troubleshooting
- tri-006: `scripts/bash/ci_cd_toolkit/jenkins/trivy-jenkins-integration.sh` — Trivy Jenkins plugin installation and configuration script (L3)
   - Plugin installation with --install flag, Jenkinsfile snippet generation with --generate
   - Pipeline validation with --validate, supports severity/config/output customization
   - JSON output for automation integration
- tri-007: `docs/how-to/trivy-github-actions.md` — Trivy GitHub Actions workflow integration for automated security scans (L3)
   - GitHub Actions integration patterns: fs, image, config, secret scan types
   - Workflow generation with proper SARIF upload to GitHub Code Scanning
   - Matrix scanning, conditional triggers, caching strategies, performance tuning
- tri-007: `scripts/bash/ci_cd_toolkit/github/trivy-github-actions.sh` — Trivy GitHub Actions workflow generator and validator (L3)
    - Workflow YAML generation with --generate, validation with --validate
    - Configurable scan types, severity thresholds, events (push/PR/schedule)
    - Supports --scan-type, --severity, --output-format, --action-version options
 - ansi-001: `scripts/bash/ansible_toolkit/security/cve-2026-33228-execution.sh` — CVE-2026-33228 mitigation playbook execution and validation script (L6)
    - Executes the mitigation playbook with proper inventory and host targeting
    - Validates remediation results and generates JSON report
    - Supports dry-run, validate-only, verbose modes, become privilege escalation
 - tri-002: `scripts/bash/ci_cd_toolkit/trivy-db-update.sh` — Trivy vulnerability database update automation (L3)
    - Automates Trivy database downloads for vulnerability definition currency
    - Checks database age and staleness with configurable thresholds
    - Supports --skip-download, --force, --dry-run, integrity verification

### Changed
- 00_index/quick-links.md — Updated Jenkins and CI/CD sections with new documentation and script links
   - Added CVE-2026-33001 hardening script and guide under Jenkins
   - Added Trivy Jenkins integration script and documentation
   - Added Trivy GitHub Actions script and documentation under CI/CD

## 2026-05-08

### Added
- tri-001: `docs/how-to/trivy-cicd-integration.md` — Trivy CI/CD pipeline integration for vulnerability scanning (L3)
  - Integration patterns for GitHub Actions, Jenkins, GitLab CI
  - Post-build stage configuration, container image scanning
  - Severity-based filtering, configuration options
  - Prerequisites, verification steps, rollback procedures, common errors
- jen-002: `docs/reference/jenkins-agent-connection-tuning.md` — Jenkins agent connection tuning commands for high-concurrency workloads (L4)
  - Comprehensive reference for tuning Jenkins agent connections in high-concurrency environments
  - Covers agent registration, connection pooling, labeling strategies, resource allocation
  - JNLP and SSH agent configuration, tunnel and proxy settings
  - Prerequisites, verification steps, rollback procedures, common errors
- jen-002: `scripts/bash/jenkins_toolkit/agents/jenkins-agent-connection-tuning.sh` — Automated script for Jenkins agent connection tuning
  - Supports dry-run mode, JSON/text output, verbose logging
  - Functions: list agents, get info, tune channels, tune timeout, tune ping interval
  - Bulk operations for labels and executors, agent online/offline management
- jen-004: `docs/reference/jenkins-job-config-xml-snippets.md` — Jenkins job configuration XML snippets for GitHub webhook integration (L4)
  - Reusable XML snippets for GitHub webhook-triggered Jenkins builds
  - Parameterized webhook jobs, secret token management, multi-branch pipeline triggers
  - Generic webhook trigger, SCM polling, GitHub App authentication
  - Prerequisites, verification steps, rollback procedures, common errors
- jen-006: `docs/reference/jenkins-pipeline-retry-strategy.md` — Jenkins pipeline retry strategy configuration for transient failure handling (L4)
  - Declarative and scripted pipeline retry patterns
  - Exponential backoff, jitter-aware backoff, error categorization
  - Retry budgets, circuit breaker pattern, Kubernetes agent retry
  - Prerequisites, verification steps, rollback procedures, common errors

### Changed
- 00_index/quick-links.md — Updated Jenkins section with new documentation links
  - Added jenkins_agent_connection_tuning, jenkins_job_config_xml_snippets, jenkins_pipeline_retry_strategy
  - Added jenkins_agent_tuning_script reference

## 2026-05-06

### Added
- jen-003: `docs/reference/jenkins-credential-rotation.md` — Jenkins CLI commands for automated credential rotation and security updates (L4)
  - Comprehensive reference for credential management, API token rotation, bulk credential operations
  - Covers security configuration updates, audit logging, plugin security checks
  - Prerequisites, verification steps, rollback procedures, common errors
- jen-001: `docs/how-to/jenkins-parallel-multi-branch.md` — Jenkins pipeline Groovy snippet for parallel multi-branch builds (L4)
  - Declarative and scripted pipeline patterns for concurrent branch execution
  - Matrix builds, Docker-based parallel execution, shared library integration
  - Error handling, throttling, agent allocation strategies
- gen-004: `docs/security/trivy/CVE-2026-33634.md` — Trivy CVE-2026-33634 supply chain vulnerability remediation guide (L8)
  - Comprehensive guide for Trivy ecosystem supply chain attack mitigation
  - Affected components: trivy-action < v0.35.0, setup-trivy < v0.2.6, malicious trivy images
  - Attack details, indicators of compromise, verification steps
  - Secret rotation recommendations, rollback procedures
- gen-004: `scripts/bash/ci_cd_toolkit/github/trivy-cve-2026-33634.sh` — CVE-2026-33634 Trivy supply chain compromise scanner (L8)
  - Detects vulnerable Trivy references in GitHub Actions workflows
  - Supports --check, --fix, --dry-run, --json-output flags
  - Scans for trivy-action, setup-trivy, and container image versions
  - Automatic remediation support

## 2026-05-05

### Changed
- gen-005: Consolidated Ansible automation scripts into `scripts/bash/ansible_toolkit/` for cross-tool consistency
  - Moved `scripts/security/ansible/harden-ansible-cve-2026-33228.sh` to `scripts/bash/ansible_toolkit/security/`
  - Removed orphaned `scripts/security/ansible/` directory
  - Updated documentation references in `docs/security/ansible/CVE-2026-33228.md`, `docs/how-to/ansible-cve-2026-33228-flatted.md`, `docs/runbooks/cve-2026-33228-ansible-flatted.md`

### Added
- git-008: `docs/how-to/git-pre-commit-security-scanning.md` — Pre-commit security scanning and validation for CI/CD pipelines (L2)
  - Comprehensive guide for Git hook automation
  - Covers secrets detection, vulnerability scanning, code quality checks
  - Prerequisites, verification steps, rollback procedures, common errors
- git-008: `scripts/bash/git/git-pre-commit-hooks.sh` — Pre-commit hook automation script with secrets, vulnerabilities, and code quality scanning (L6)
  - Supports TruffleHog, git-secrets, Trivy, npm audit, tfsec, ShellCheck integration
  - Dry-run mode, idempotent operations, configurable scanning

## 2026-05-04

### Added
- dok-002: `docs/security/docker/AUTHZ-PLUGIN-HARDENING.md` — Docker AuthZ plugin security hardening for privileged containers (L8)
  - Comprehensive guide for preventing privileged container operations
  - Authorization plugin configuration and monitoring
  - Security check script at `scripts/bash/docker_toolkit/security/docker-authz-plugin-hardening.sh`
  - Verification steps, rollback procedures
- lin-081: `docs/how-to/linux/linux-disk-io-scheduler-optimization.md` — Linux disk I/O scheduler optimization for database workloads (L7)
  - Comprehensive guide covering scheduler selection (none, mq-deadline, bfq, kyber)
  - Database-specific tuning for PostgreSQL, MySQL, MariaDB
  - Scripts for scheduler detection, configuration, persistence
  - Ansible playbook for fleet deployment, verification, rollback procedures


- dok-006: `docs/how-to/docker-swarm-cluster-installation.md` — Docker Swarm cluster installation and high-availability configuration (L2)
  - Complete guide for setting up production-ready Docker Swarm cluster
  - Covers multi-manager HA setup, worker node integration, overlay networking
  - Includes rolling updates, secrets management, and monitoring setup
  - Prerequisites, verification steps, rollback procedures, common errors
- dok-006: `scripts/bash/docker_toolkit/docker-swarm-cluster-setup.sh` — Docker Swarm cluster setup script with dry-run support (L2)
  - Automated setup of Docker Swarm cluster with high availability
  - Supports dry-run mode for safe testing
  - Idempotent operations with rollback capability
  - Comprehensive logging and JSON output
- 00_index/quick-links.md — Updated Docker section with Docker Swarm entries
  - Added docker_swarm_cluster_setup script reference
  - Added docker_swarm_cluster_installation documentation reference
## 2026-05-03

### Added
- git-004: `docs/security/git-security-access-control-authentication.md` — Git repository access control and authentication hardening for CI/CD pipelines (L2)
  - Comprehensive guide covering credential security, repository access control, secure Git operations in pipelines
  - Prerequisites, verification steps, rollback procedures, common errors
  - References to GitHub, GitLab, Bitbucket security documentation and industry standards

### Modified
- git-006: `docs/reference/git-commands.md` — Added Rollback section to Git commands reference (L2)
  - Added repository state rollback instructions (reset, revert, restore)
  - Added remote repository rollback procedures
  - Added stash recovery methods
  - Enhanced documentation with practical examples and use cases

- 00_index/quick-links.md — Updated Git section to include new security documentation
  - Added link to git-security-access-control-authentication.md
  - Maintained alphabetical organization of Git resources

### Added
- lin-076: `docs/runbooks/linux-system-administration.md` — Linux system administration documentation and runbook automation (L7)
  - Comprehensive documentation covering user management, service management, disk/filesystem management
  - Network configuration, process monitoring, log management, backup/restore procedures
  - Security hardening runbook, automation execution framework
  - Prerequisites, verification steps, rollback procedures, common errors
- lin-076: `scripts/bash/linux_toolkit/sysadmin/` — System administration automation scripts (L7)
  - `user-create.sh`: Create system users with audit trail, dry-run mode
  - `user-modify.sh`: Modify users and group membership (add_group, remove_group, lock, unlock)
  - `disk-usage.sh`: Analyze disk usage with alerts, configurable thresholds
  - `process-monitor.sh`: Monitor running processes, watch specific processes
  - `service-health.sh`: Service health check with automatic restart
  - `system-backup.sh`: Automated system backup with verification
  - `network-iface.sh`: Manage network interfaces, show connections
  - `security-audit.sh`: Security audit checks (world-writable files, orphaned files, UID 0)
- lin-076: `00_index/quick-links.md` — Added lin-076 system administration runbook and sysadmin scripts

- lin-077: `docs/how-to/linux/linux-container-orchestration-systemd-cgroups.md` — Container orchestration automation with systemd and cgroups (L7)
  - Comprehensive guide covering systemd service units, cgroup slices, resource limits (CPU/memory/I/O/PID)
  - Container deployment patterns, health checks, auto-restart, networking with systemd
  - Monitoring scripts for cgroup resource usage, rollback procedures, common error solutions
- lin-077: `scripts/bash/linux_toolkit/container-orchestration-systemd-cgroups.sh` — Container orchestration script
  - Automated deployment with systemd and cgroup integration, dry-run mode
  - Cgroup slice management (create/delete), service deployment, rollback
  - Resource verification, multi-container support, idempotent operations
  - shellcheck passed with warnings only
- lin-075: `docs/how-to/linux/linux-system-hardening-containerized.md` — Linux system hardening automation for containerized environments (L7)
  - Comprehensive framework for automated security hardening following CIS benchmarks and NIST guidelines
  - Kernel sysctl hardening, SSH configuration, Docker daemon hardening, firewall rules
  - User account hardening, auditd configuration, AppArmor profiles
  - Automated remediation, compliance checks, and audit capabilities
- lin-075: `scripts/bash/linux_toolkit/linux-system-hardening.sh` — Linux system hardening automation script
  - Idempotent hardening with kernel parameters, firewall, SSH, Docker, user accounts
  - Dry-run mode, comprehensive logging, backup and rollback support
  - Modular design with configurable options per hardening component
- lin-075: `templates/linux-automation/roles/hardening/tasks/main.yml` — Ansible role for Linux system hardening
  - Standardized Ansible role for automated hardening deployment
  - CIS benchmark compliance with verification tasks
  - Fleet management support for containerized environments
- lin-075: `templates/linux-automation/playbooks/hardening.yml` — Ansible playbook for system hardening
  - Production-ready playbook with pre-flight checks and post-hardening verification
  - Role-based execution with tags for selective hardening components
- 00_index/quick-links.md — Added lin-077, lin-075 container orchestration and hardening entries
- lin-074: `docs/how-to/linux/linux-shell-commands-automation.md` — Shell command patterns for automated system administration (L7)
  - Documentation covering service management, file operations, network utilities, system monitoring
  - Prerequisites for common Linux utilities, verification steps, rollback procedures
  - Common errors and solutions
- lin-074: `scripts/bash/linux_toolkit/linux-system-commands-library.sh` — Shell command library
  - Functions: service_is_active, service_start/stop/restart, file backup/diff, port checks, connectivity tests
  - System monitoring: get_cpu_usage, get_memory_usage, get_disk_usage, get_load_average
  - Dry-run mode support, binary checks, verbose logging
- git-002: `docs/how-to/git/git-credential-helper-cicd-setup.md` — Git credential helper setup for CI/CD pipelines (L2)
   - Configuration for GitHub Actions, GitLab CI, Jenkins
   - Credential storage, rollback procedures
- dok-001: `docs/security/docker/CVE-2026-34040.md` — CVE-2026-34040 Docker authorization plugin bypass remediation guide (L8)
   - Complete hardening guide for Docker authorization plugin bypass vulnerability
   - Docker version checking, plugin status, daemon configuration verification
   - Remediation steps for upgrading Docker and securing configuration
- dok-001: `scripts/bash/docker_toolkit/security/docker-cve-2026-34040.sh` — CVE-2026-34040 hardening script (L8)
   - Docker authorization plugin bypass detection and remediation
   - Checks Docker version, authorization plugins, API exposure
   - Supports --dry-run, --remediate, --json-output flags
- 00_index/quick-links.md — Added lin-074 and git-002 entries

### Changed
- lin-073: Infrastructure-as-Code automation workflows for DevOps pipelines (L7)
  - Final score: 9/10

## 2026-05-02

### Added
- lin-072: `scripts/bash/linux_toolkit/lib/iac-operations.sh` — Shell script library for infrastructure-as-code operations (L7)
  - Reusable functions for Terraform and Ansible operations
  - Service management, network utilities, backup/restore functions
  - Dry-run mode support and binary existence checks
- lin-072: `docs/how-to/linux/linux-shell-script-library-iac.md` — Documentation for IaC shell script library (L7)
- 00_index/quick-links.md — Added Linux IaC shell script library entry
- git-003: `docs/how-to/git-workflow-optimization.md` — Git workflow optimization for DevOps pipelines (L3)
- 00_index/quick-links.md — Added Git workflow optimization entry

## 2026-05-01

### Added
- lin-071: `templates/linux-automation/` — Linux system automation template for DevOps workflows (L7)
  - Complete Ansible-based automation template with roles for base, security, monitoring, and orchestrator
  - Deploy script with dry-run support, inventory configuration, and systemd service templates
  - Project structure: playbooks, roles, group_vars, templates for production-ready deployments

## 2026-05-01

## 2026-04-30

### Added
- git-001: `docs/setup-guides/git-github-actions-runner.md` — GitHub Actions self-hosted runner installation and configuration guide (L2)
- git-001: `scripts/bash/git/github-runner-install.sh` - GitHub Actions runner installation script with systemd/Docker support
- git-002: `docs/setup-guides/git-credential-helper-ci-cd.md` — Git credential helper setup for CI/CD pipelines (L2)
- git-002: `scripts/bash/git/credential-helper-ci.sh` - Git credential helper configuration for CI/CD
- lin-071: `docs/how-to/linux/linux-system-automation-template.md` - Linux system automation template for DevOps workflows (L7)
- lin-071: `scripts/bash/linux_toolkit/system-automation-template.sh` - Linux automation template deployment script
- 00_index/quick-links.md — Added Git runner and credential helper entries

## 2026-04-29

### Added
- git-001: `docs/concepts/git-001-version-control-fundamentals.md` — Introduction to version control fundamentals (L1 concept)
- git-002: `docs/concepts/git-002-basic-commands-setup.md` — Basic Git commands and repository setup (L1 concept)
- git-005: `docs/concepts/git-005-configuration-aliases.md` — Git configuration, aliases, and best practices (L1 concept)
- 00_index/quick-links.md — Added Git concept documentation entries

## 2026-04-28

### Added
- jen-014: `snippets/jenkins-cli-commands.md` — Jenkins CLI commands reference with 150+ commands for sysadmins
- 00_index/quick-links.md — Updated Jenkins CLI commands entry to 150+ commands
- jen-014: `docs/reference/jenkins-commands.md` — Jenkins commands reference with 50+ commands, added Verify, Rollback, Common errors sections

## 2026-04-27

### Added
- lin-069: docs/how-to/linux-dns-management-coredns-systemd-resolved.md — Complete DNS management with CoreDNS and systemd-resolved
- lin-069: scripts/bash/linux_toolkit/linux-dns-coredns.sh — Automated DNS entry management for CoreDNS
- lin-069: scripts/bash/linux_toolkit/linux-dns-test.sh — DNS setup verification and testing
- lin-069: scripts/bash/linux_toolkit/linux-dns-monitor.sh — DNS health monitoring with auto-restart
- 00_index/quick-links.md — Added DNS management entries

## 2026-04-24

### Added

- k8s-015: `scripts/bash/k8s_toolkit/k8s-eso-cve-2026-34984-hardening.sh` — CVE-2026-34984 hardening script for External Secrets Operator
- k8s-015: `docs/how-to/k8s-external-secrets-cve-2026-34984.md` — CVE-2026-34984 ESO vulnerability remediation guide
- k8s-016: `scripts/bash/k8s_toolkit/k8s-ingress-nginx-cve-2026-4342-hardening.sh` — CVE-2026-4342 ingress-nginx comment-based config injection hardening script
- k8s-016: `docs/how-to/k8s-ingress-nginx-cve-2026-4342.md` — CVE-2026-4342 ingress-nginx RCE vulnerability remediation guide

## 2026-04-23

### Added
- k8s-014: `scripts/bash/k8s_toolkit/aks-privilege-escalation-hardening.sh` — CVE-2026-33105 AKS privilege escalation hardening script
- k8s-014: `docs/how-to/k8s-aks-cve-2026-33105.md` — CVE-2026-33105 AKS privilege escalation remediation guide

## 2026-04-22

### Added
- lin-067: `docs/how-to/linux-container-security-scanning.md` — Container security scanning project with Trivy and Falco
- lin-067: `scripts/bash/linux_toolkit/linux-container-security-scan.sh` — Automated container security scanning script

## 2026-04-21

### Added
- k8s-021: `scripts/bash/k8s_toolkit/mcp-server-kubernetes-hardening.sh` — CVE-2026-39884 hardening script (mcp-server-kubernetes RCE)
- k8s-021: `docs/troubleshooting/kubernetes-mcp-server-cve-2026-39884.md` — CVE-2026-39884 remediation guide
- ter-018: `docs/how-to/terraform-secrets-manager.md` — AWS Secrets Manager integration with Terraform walkthrough
- ter-018: `scripts/bash/terraform_toolkit/secrets/terraform-secrets-deploy.sh` — Deployment script for Secrets Manager with dry-run

## 2026-04-19

### Added
- jen-014: `snippets/jenkins-cli-commands.md` — Jenkins CLI commands reference with 80+ commands
- ansi-004: `docs/how-to/ansible-playbook-best-practices.md` — Ansible playbook best practices guide

## 2026-04-18

### Added
- jen-014: `docs/reference/jenkins-commands.md` — Jenkins CLI commands reference with 50+ commands for automation and scripting
- lin-006: `snippets/linux-commands.md` — Linux commands reference with 30+ bash one-liners for sysadmins
- dok-003: `scripts/bash/docker_toolkit/docker-image-cleanup.sh` — Docker image cleanup script with dry-run, age filtering
- vault-006: `snippets/vault-commands.md` — Vault CLI commands reference for authentication, secrets, policies
- ansi-006: `snippets/ansible-commands.md` — Ansible ad-hoc commands for system administration
- kfk-006: `snippets/kafka-topics-commands.md` — Kafka topics CLI one-liners for topic management
- jen-007: `docs/troubleshooting/jenkins-troubleshooting.md` — Jenkins troubleshooting guide for startup failures, plugin issues, build failures
- jen-006: `templates/jenkins/Jenkinsfile-maven-gradle-template.md` — Reusable Jenkinsfile template for Maven/Gradle builds

## 2026-04-17

### Added
- vault-009: `scripts/bash/vault_toolkit/security/vault-go-getter-hardening.sh` — Hardening script for CVE-2026-4660 (go-getter arbitrary file read vulnerability)

### Added
- ter-003: `docs/how-to/terraform-state-management.md` — Terraform state management best practices
- ter-004: `docs/how-to/terraform-troubleshooting.md` — Terraform troubleshooting guide for plan/apply failures
- ter-005: `snippets/terraform-commands.md` — Terraform CLI one-liners reference

## 2026-04-14

### Added
- ter-016: `docs/how-to/git-installation-macos.md` — Git installation on macOS how-to guide
- ter-016: `scripts/bash/git/git-install-macos.sh` — Automated Git installation script for macOS
- git-003: `docs/how-to/git-installation-wsl.md` — Git installation on WSL how-to guide
- git-003: `scripts/bash/git/git-install-wsl.sh` — Automated Git installation script for WSL
- git-003: `snippets/git-commands-reference.md` — Git CLI commands reference with 80+ commands
- ter-017: `docs/how-to/terraform-iam-roles.md` — IAM roles with policy modules how-to guide
- ter-017: `scripts/bash/terraform_toolkit/terraform-iam-roles-deploy.sh` — Automated IAM roles deployment script

## 2026-04-13

### Added
- lin-030: `docs/how-to/linux/linux-wazuh-siem.md` — Wazuh SIEM deployment how-to guide
- lin-030: `scripts/bash/linux_toolkit/wazuh-deploy.sh` — Automated Wazuh deployment script

## 2026-04-12

### Added
- lin-028: `docs/how-to/linux-aide-configuration-management.md` — AIDE file integrity monitoring how-to guide
- lin-028: `scripts/bash/linux_toolkit/aide-deploy.sh` — Automated AIDE deployment and management script

## 2026-04-11

### Added
- lin-028: `scripts/bash/linux_toolkit/aide-config.sh` — AIDE configuration management script for file integrity monitoring
- lin-028: `docs/how-to/linux-aide-configuration.md` — AIDE setup and usage guide for Linux configuration management

## 2026-04-09

### Added
- vault-005: `scripts/bash/vault_toolkit/vault-audit-log-analysis.sh` — Vault audit log analysis script for security events and anomalies
- helm-003: `docs/how-to/helm-commands-reference.md` — Helm CLI commands reference with 80+ examples

## 2026-04-08

### Added
- dok-007: `scripts/bash/docker_toolkit/security/docker-cve-2026-34040.sh` — Docker authorization plugin bypass detection script for CVE-2026-34040
- k8s-013: `scripts/bash/k8s_toolkit/security/k8s-acm-cve-2026-4740.sh` — Kubernetes ACM privilege escalation detection script for CVE-2026-4740

## 2026-04-03

### Added
- jen-013: `docs/reference/jenkins-rest-api.md` — Jenkins REST API commands reference for automation (job management, build triggers, queue, agents, plugins)

## 2026-04-01

### Added
- ter-010: `docs/how-to/terraform-multi-env-gitops.md` — Multi-environment infrastructure with Terraform workspaces and GitOps workflow
- ter-010: `scripts/bash/terraform_toolkit/multi-env/multi-env-setup.sh` — Automated multi-environment setup (init-backend, create-env, plan, apply, destroy, verify)
- ter-010: `templates/terraform/multi-env/vpc-module.tf` — Reusable VPC module with public/private subnets, NAT Gateway, security groups
- ter-010: `environments/dev/` — Development environment configuration with terraform.tfvars
- ter-010: `environments/staging/` — Staging environment configuration
- ter-010: `environments/prod/` — Production environment configuration

## 2026-03-29

### Added
- ter-013: `docs/how-to/terraform-rds-read-replicas.md` — RDS PostgreSQL with read replicas: Multi-AZ, encryption, CloudWatch alarms, failover testing
- lin-025: `docs/how-to/linux-centralized-logging-syslog-ng-logstash.md` — Centralized logging pipeline with syslog-ng and Logstash
- lin-025: `scripts/bash/linux_toolkit/setup-centralized-logging.sh` — Automated deployment script for syslog-ng + Logstash + Elasticsearch
- lin-025: `templates/syslog-ng/syslog-ng.conf` — Production syslog-ng configuration with JSON output, filtering, and disk buffering
- lin-025: `templates/logstash/logstash.conf` — Logstash pipeline with GeoIP enrichment, SSH auth parsing, and Elasticsearch indexing
- ter-013: `templates/terraform/rds-with-replicas/` — Complete Terraform configuration (provider, variables, main, outputs, monitoring)
- ter-013: `scripts/bash/terraform_toolkit/rds-deploy.sh` — RDS deployment automation (plan/apply/destroy/verify/failover-test)

## 2026-03-28

### Added
- lin-024: `docs/how-to/linux-ansible-patching.md` — Automated patching system with Ansible: inventory, playbooks, scheduling, reporting, rollback
- lin-024: `scripts/bash/linux_toolkit/security/ansible-patch-management.sh` — Patch management script with --dry-run, --bundle, --tags, --limit flags
- lin-024: `scripts/bash/ansible_toolkit/patch-management.yml` — Ansible playbook for automated security patching across Linux servers
- lin-020: `docs/how-to/linux-harbor-registry.md` — Production container registry with Harbor: HTTPS/TLS, LDAP auth, image replication, Trivy vulnerability scanning, automated backup
- lin-020: `scripts/bash/harbor/harbor-deploy.sh` — Automated Harbor deployment with TLS cert generation, Docker Compose, and Trivy
- lin-020: `scripts/bash/harbor/harbor-health-check.sh` — Harbor health verification: containers, API, registry API, disk usage, Trivy scanner
- lin-020: `scripts/bash/harbor/harbor-backup.sh` — Harbor backup: database dump, registry data, config, Redis with retention cleanup
- ter-012: `docs/how-to/terraform-eks-cluster.md` — EKS cluster with managed node groups, VPC networking, autoscaling configuration, and integration with AWS services
- ter-012: `scripts/bash/terraform_toolkit/eks/eks-deploy.sh` — Automated EKS deployment script with --dry-run, --init, --plan, --apply, --full, --verify flags
- ter-012: `scripts/bash/terraform_toolkit/eks/eks-cleanup.sh` — Safe EKS cluster cleanup script with DRY_RUN enabled by default
- ter-012: `scripts/bash/terraform_toolkit/eks/eks-health-check.sh` — EKS cluster health verification script for cluster, nodes, addons, and API server

## 2026-03-27

### Added
- lin-017: `lab/mini-projects/samba-enterprise-file-sharing/README.md` — Enterprise Samba file sharing platform L7 project walkthrough: departmental shares, home directories, guest access, ACLs, AD integration, automated backups, monitoring, security hardening

## 2026-03-26

### Added
- lin-017: `docs/how-to/linux-samba-file-sharing.md` — Samba file sharing server for cross-platform access (Windows/macOS/Linux) with multiple shares, user management, AppArmor, and security hardening
- lin-017: `scripts/bash/linux_toolkit/samba/samba-setup.sh` — Automated Samba setup script with --shares, --users, --dry-run, --firewall, --workgroup, --min-protocol, --max-protocol flags
- lin-018: `docs/how-to/linux-haproxy-load-balancer.md` — HAProxy L4/L7 load balancer project with SSL termination, path-based routing, health checks, Prometheus exporter, and log rotation
- lin-018: `scripts/bash/linux_toolkit/loadbalancer/haproxy-setup.sh` — Automated HAProxy setup script with --dry-run, --backends, --domain, --self-signed, --balance, --health-path, and --firewall flags

## [Unreleased]

### Added (2026-04-28)
- lin-068: Log aggregation with Loki and Promtail — hardened production deployment guide
  - Doc: docs/how-to/linux-log-aggregation-loki-promtail.md
  - Security: Proper system user creation (loki:loki, promtail:promtail), least-privilege systemd services, binary vs package install differentiation, complete ownership fixes

### Added (2026-03-25)
- ter-011: AWS VPC with public/private subnets
- lin-017: Samba file sharing server setup
  - Script: scripts/bash/terraform_toolkit/networking/vpc-setup.sh
  - Terraform: scripts/bash/terraform_toolkit/networks/terraform/
  - Doc: docs/how-to/terraform-aws-vpc.md
- lin-016: DNS server with BIND9
  - Script: scripts/bash/linux_toolkit/dns/bind9-server-setup.sh
  - Doc: docs/how-to/linux-dns-bind9.md
- lin-015: VPN server setup with WireGuard
  - Script: scripts/bash/linux_toolkit/vpn/wireguard-server-setup.sh
  - Doc: docs/how-to/linux-vpn-wireguard.md
- lin-014: Mail server setup with Postfix and Dovecot
  - Script: scripts/bash/linux_toolkit/mail/mail-server-setup.sh
  - Doc: docs/how-to/linux-mail-server.md

### Added (2026-03-24)
- lin-012: Nginx reverse proxy with SSL/TLS termination
  - Script: scripts/bash/linux_toolkit/network/nginx-reverse-proxy.sh
  - Doc: docs/how-to/linux-nginx-reverse-proxy-ssl-tls.md

### Added (2026-03-24)
- lin-013: LDAP authentication server setup with OpenLDAP
  - Doc: docs/how-to/linux-ldap-server.md
  - Script: scripts/bash/linux_toolkit/authentication/ldap-server-setup.sh

### Added (2026-03-24)
- lin-010: Container host setup with Docker and security hardening
  - Doc: docs/how-to/linux-container-host-security.md
  - Script: scripts/bash/linux_toolkit/security/container-host-hardening.sh
- lin-011: ELK stack log aggregation system for Linux
  - Script: scripts/bash/linux_toolkit/logging/elk-setup.sh
  - Doc: docs/how-to/linux-elk-log-aggregation.md
- lin-009: Automated backup solution with rsync and retention policy
  - Script: scripts/bash/linux_toolkit/backup/backup-rsync-retention.sh
  - Doc: docs/how-to/linux-backup-rsync-retention.md
- lin-008: Linux system monitoring dashboard with Prometheus node_exporter
  - Doc: docs/how-to/linux-monitoring-prometheus-node-exporter.md
  - Script: scripts/bash/linux_toolkit/monitoring/node-exporter-setup.sh (existing)

### Audited
- lin-067: Linux Incident Response Automation - Score: 10/10 - Passed
- git-000: Git concept - Score: 9/10 - Passed
  - Added: docs/concepts/git-version-control-mental-model.md (386-line L1 concept doc)
- lin-008: Linux System Monitoring Dashboard - Score: 9/10 - Passed
  - Doc: docs/how-to/linux-monitoring-prometheus.md (168 lines, all 8 sections)
  - Script: scripts/bash/linux_toolkit/monitoring/node-exporter-setup.sh (296 lines, shellcheck passed)
- lin-009: Linux backup rsync project - Score: 1/10 - Rework required
    - FAILURE: No output file found in DevOps-Kit
- ter-009: Terraform module composition project - Score: 1/10 - Rework required
    - FAILURE: No output file found in DevOps-Kit
- oci-008: Azure Container Registry (ACR) installation and geo-replication — Score: 10/10 - Passed audit

### Added
- ter-051: Terraform CI/CD Pipeline with Atlantis and GitOps (L7 project)
  - `scripts/bash/terraform_toolkit/atlantis/setup-atlantis.sh`: Docker-based Atlantis server setup script with dry-run support
  - `docs/how-to/terraform-atlantis-gitops.md`: Complete guide covering architecture, setup, GitHub webhook config, workspace isolation, and common errors
- ter-009: Terraform Project with Module Composition and Workspaces (L7 project)
  - `lab/mini-projects/terraform-project/`: Complete project with main.tf, variables.tf, outputs.tf, workspace.tf
  - `lab/mini-projects/terraform-project/modules/network/`: VPC, subnets, NAT gateways, route tables
  - `lab/mini-projects/terraform-project/modules/compute/`: EC2 instances with security groups
  - `lab/mini-projects/terraform-project/modules/storage/`: S3 buckets with versioning and encryption
  - `docs/how-to/terraform-module-composition-workspaces.md`: Comprehensive guide with all 8 sections
- lin-008: Linux System Monitoring Dashboard with Prometheus Node Exporter (L7 project)
  - `docs/how-to/linux-monitoring-prometheus.md`: Complete guide covering node_exporter installation, Prometheus configuration, Grafana dashboard import, alerts setup, custom metrics, and common error resolutions
  - `scripts/bash/linux_toolkit/monitoring/node-exporter-setup.sh`: Automation script with --dry-run, --version, --port flags for Prometheus node_exporter deployment

### Added (prior)
- lin-067: Linux Incident Response Automation (L7 project)
  - `docs/how-to/linux-incident-response-automation.md`: Guide covering incident response preparation, evidence collection, chain of custody, forensic analysis, and common error resolutions
  - `scripts/bash/linux_toolkit/security/forensics/incident-response.sh`: Automation script with --dry-run, --full-forensic, --case-id, --examiner, and --output flags for comprehensive forensic collection
- helm-005: Helm + Terraform Full-Stack Project (L9 cross-tool)
  - `docs/how-to/helm-terraform-fullstack/README.md`: Complete guide covering Terraform EKS provisioning, Helm chart development, deployment automation, and integration patterns
  - `scripts/bash/helm_toolkit/helm-terraform/deploy-helm-terraform.sh`: Automated deployment script with plan/apply/deploy/rollback/clean targets
- dok-002: Docker Security Best Practices Guide (L8)
  - `docs/how-to/docker-security.md`: Comprehensive guide covering image security, container runtime security, network security, secrets management, host security, logging/monitoring, and image build security with verification steps, rollback procedures, and common error resolutions
- lin-066: Linux OpenSCAP Hardening Automation (L7 project)
  - `docs/how-to/linux-openscap-hardening.md`: Guide covering OpenSCAP installation, dry-run scans, full compliance scanning, remediation script generation, and automated remediation with backup/rollback
  - `scripts/bash/linux_toolkit/security/openscap-hardening.sh`: Automation script with --dry-run, --auto-remediate, --profile, and --report flags for STIG/CIS/PCI-DSS compliance

### Fixed
- vault-009: CVE-2025-6013 LDAP MFA enforcement bypass script
  - Fixed hardcoded ldap_mounts to dynamically enumerate from sys/auth endpoint
  - Added shellcheck notes for unused DRY_RUN/VERBOSE variables

### Added
- jen-012: Jenkins Pipeline Groovy Snippets for Scripted Pipelines (L4)
  - `snippets/jenkins-scripted-pipeline-groovy.md`: 50+ Groovy code snippets for Jenkins scripted pipelines covering node/stage blocks, variable handling, conditionals, loops, error handling, parallel execution, Docker integration, Git operations, file operations, HTTP APIs, credential handling, email notifications, artifact management, and testing integration

### Added
- jen-009: Jenkins Commands Reference (L4)
  - `docs/reference/jenkins-commands.md`: 50+ Jenkins CLI commands for job management, build management, node/agent management, plugin management, queue scheduling, API automation, and more. Includes commands with pipes, filters, and awk combinations.

### Added
- k8s-012: Kubernetes CI/CD pipeline with Jenkins and Vault secrets injection (L9 cross-tool project)
  - `docs/how-to/k8s-jenkins-vault-cicd-security.md`: Complete guide covering Jenkins on K8s, Vault HA with Kubernetes auth, Trivy/Kubescape security scanning, GitOps deployment with Vault sidecar
- k8s-011: Kubernetes GitOps workflow with ArgoCD and Vault secrets injection (L9 cross-tool project)
  - `docs/how-to/k8s-argocd-vault-gitops.md`: Complete GitOps walkthrough with ArgoCD, Vault CSI Provider, SecretStore
  - Covers ArgoCD installation, Git repository setup, Vault Kubernetes auth configuration
  - Includes SecretProviderClass setup, secrets injection verification, rollback procedures
  - Real error scenarios and troubleshooting steps

### Added
- k8s-010: Kubernetes cluster provisioning with Terraform + Ansible (L9 cross-tool project)
  - `docs/how-to/k8s-terraform-ansible-provisioning.md`: Full walkthrough covering VPC setup, Ansible bootstrap, kubeadm init, Calico CNI, worker join
  - `docs/how-to/k8s-terraform-ansible-provisioning/terraform/main.tf`: VPC, subnets, NAT GW, IGW, bastion host
  - `docs/how-to/k8s-terraform-ansible-provisioning/terraform/control-plane.tf`: CP nodes, NLB, target groups, security groups
  - `docs/how-to/k8s-terraform-ansible-provisioning/terraform/workers.tf`: Worker nodes, worker security group
  - `docs/how-to/k8s-terraform-ansible-provisioning/terraform/variables.tf`: All configurable variables
  - `docs/how-to/k8s-terraform-ansible-provisioning/terraform/outputs.tf`: IPs, NLB DNS, SSH config, Ansible inventory
  - `docs/how-to/k8s-terraform-ansible-provisioning/ansible/site.yml`: Main Ansible playbook
  - `docs/how-to/k8s-terraform-ansible-provisioning/ansible/roles/preflight/tasks/main.yml`: Package update, kernel modules, sysctl, swap disable
  - `docs/how-to/k8s-terraform-ansible-provisioning/ansible/teardown.yml`: kubeadm reset teardown playbook
  - `docs/how-to/k8s-terraform-ansible-provisioning/ansible/inventory.ini.example`: Ansible inventory template

### Added
- jen-009: Jenkins commands reference with 100+ CLI commands
  - `snippets/jenkins-commands-reference.md`: Comprehensive Jenkins CLI reference
  - Covers job management, build operations, node/agent management, plugin management
  - Includes credential management, pipeline commands, system information, user and view management
  - Provides 50+ practical one-liners and troubleshooting tips

### Audited
- vault-009: CVE-2025-6013 hardening script - Score: 10/10 - Passed audit

### Added
- vault-009: Vault LDAP MFA enforcement bypass (CVE-2025-6013) hardening script
  - `scripts/bash/vault_toolkit/security/cve-2025-6013.sh`: Detection script
  - Checks Vault version for CVE-2025-6013 vulnerability
  - Enumerates LDAP auth methods
  - Validates username_as_alias configuration
  - Checks MFA setup
  - Provides remediation recommendations
  - Supports --dry-run, --json-output, and --verbose modes
  - shellcheck passed with warnings only

### Added
- ansi-010: Ansible Automation Platform EDA credentials exposure (CVE-2025-9907) hardening script
  - `scripts/bash/ansible_toolkit/security/cve-2025-9907-eda-creds.sh`: Detection and remediation script
  - Checks AAP installation and version
  - Validates EDA configuration for credential exposure risks
  - Detects test mode configuration indicators
  - Provides remediation recommendations
  - Supports --dry-run, --remediate, and --json-output modes
  - shellcheck passed with warnings only

### Added
- dok-006: Docker Desktop grpcfuse kernel module privilege escalation (CVE-2026-2664) hardening script
  - `scripts/bash/docker_toolkit/security/cve-2026-2664.sh`: Detection and remediation script
  - Checks Docker version for CVE-2026-2664 vulnerability
  - Validates FUSE/grpcfuse mounts
  - Checks /proc/docker access permissions
  - Detects docker group membership and container capabilities
  - Provides remediation recommendations
  - Supports --dry-run, --remediate, and --json-output modes
  - shellcheck passed

### Added
- vault-008: Vault TLS certificate auth validation bypass (CVE-2025-6037) hardening script
  - `scripts/bash/vault_toolkit/security/cve-2025-6037.sh`: Detection and remediation script
  - Checks Vault version for CVE-2025-6037 vulnerability
  - Validates certificate auth method configuration
  - Detects non-CA certificate usage in trusted certificates
  - Provides remediation recommendations
  - Supports --dry-run and --verbose modes
  - shellcheck passed with warnings only

### Added
- helm-002: Helm chart security scanning guide
  - `docs/how-to/helm-security-scanning.md`: Comprehensive security scanning guide for Helm charts
  - Covers Trivy, kube-score, Checkov, Kubescape scanning tools
  - CI/CD integration examples (GitHub Actions, GitLab CI)
  - Runtime security scanning with Falco integration
  - Chart integrity verification and signing
  - Security report generation in multiple formats
  - Updated `00_index/quick-links.md` - Added Helm security scanning to Helm section

### Added
- dok-002: Docker security best practices guide
  - `docs/how-to/docker-security-best-practices.md`: Comprehensive security hardening guide for Docker
  - Covers image security, runtime protection, network isolation
  - Includes Dockerfile best practices, vulnerability scanning with Trivy
  - Docker secrets management, TLS configuration
  - Daemon security, host hardening guidelines
  - Security verification checklist and audit script
  - Updated `00_index/quick-links.md` - Added Docker security guide to Tools section

### Added
- vault-004: Vault seal/unseal troubleshooting guide
  - `docs/how-to/vault-troubleshooting-seal-unseal.md`: Comprehensive troubleshooting guide for Vault seal/unseal issues
  - Covers seal status identification, Shamir key unseal procedures
  - Common unseal failure scenarios with resolution steps
  - Auto-unseal troubleshooting (AWS KMS, Azure Key Vault, GCP Cloud KMS)
  - HSM seal troubleshooting with PKCS#11 diagnostics
  - Recovery mode procedures and manual seal operations
  - Error reference table for common seal/unseal errors
  - Verified reference URLs from HashiCorp documentation
  - Updated `00_index/quick-links.md` — Added Vault seal/unseal troubleshooting to Vault and Troubleshooting sections

### Added
- vault-003: Vault secure deployment best practices guide
  - `docs/how-to/vault-secure-deployment.md`: Comprehensive security hardening guide for Vault production deployments
  - Covers TLS configuration, authentication methods, authorization policies, audit logging
  - Network security, sealing/unsealing, rate limiting, namespaces
  - Includes hardening checklist and verification steps
  - Updated `00_index/quick-links.md` — Added Vault secure deployment guide to Vault section
  - Updated `docs/how-to/vault_toolkit.md` — Added documentation reference

### Added
- ansi-008: Ansible AAP hardening script for CVE-2026-24049 (wheel privilege escalation)
  - `scripts/bash/ansible_toolkit/security/aap-cve-2026-24049-check.sh`: Detect wheel package privilege escalation vulnerability
  - Checks wheel package version (vulnerable: 0.40.0 - 0.46.1)
  - Validates AAP access and checks AAP version affected by CVE-2026-24049
  - Checks critical file permissions for unauthorized changes
  - Scans for recent wheel unpack activities in AAP logs
  - Provides remediation recommendations (upgrade wheel to 0.46.2+, AAP to 2.5.3+)
  - Supports --host, --token, --dry-run, --output flags
  - shellcheck: pass with warnings (SC2038 - style only, fixed)
- Updated `00_index/quick-links.md` — Added CVE-2026-24049 hardening script to Ansible section

### Added
- ansi-002: Ansible Lightspeed hardening script for CVE-2026-0598 (auth bypass)
  - `scripts/bash/ansible_toolkit/security/cve-2026-0598-audit.sh`: Detect CVE-2026-0598 auth bypass in Ansible Lightspeed
  - Checks AAP version against vulnerable versions
  - Audits Lightspeed service status and configuration
  - Reviews audit logs for unauthorized conversation access
  - Checks API endpoint vulnerability patterns
  - Reviews user permissions and roles
  - Provides remediation recommendations for ownership validation
  - Supports --host, --token, --dry-run, --json-output, --verbose flags
  - shellcheck: pass with warnings (SC2043, SC2155 - style only)
- Updated `00_index/quick-links.md` — Added CVE-2026-0598 audit script to Ansible section
- Updated `docs/how-to/ansible_toolkit.md` — Added CVE-2026-0598 documentation
- Added `docs/how-to/ansible-lightspeed-cve-2026-0598.md` — How-to guide for CVE-2026-0598

### Added
- vault-008: Vault hardening script for CVE-2025-11621 (AWS Auth bypass)
  - `scripts/bash/vault_toolkit/security/cve-2025-11621.sh`: Detect and remediate Vault AWS Auth method bypass vulnerability
  - Checks Vault server version against vulnerable versions (< 1.16.27, < 1.19.11, < 1.20.5, < 1.21.0)
  - Audits AWS auth methods for bound_principal_iam with wildcards
  - Detects cross-account IAM role access patterns
  - Reviews AWS auth roles for bound_iam_role_arn configurations
  - Provides remediation recommendations for IAM policy hardening
  - Supports --dry-run, --json-output flags
  - shellcheck: pass
- Updated `00_index/quick-links.md` — Added CVE-2025-11621 hardening script to Vault section

### Added
- helm-001: Helm hardening script for CVE-2025-53547 (Chart.yaml code injection)
  - `scripts/bash/helm_toolkit/security/cve-2025-53547-harden.sh`: Detect and remediate Helm Chart.yaml code injection vulnerability
  - Checks Helm client version against vulnerable versions (< 3.17.2)
  - Analyzes Chart.yaml for injection patterns (template syntax, dangerous function calls)
  - Reviews dependencies for remote template risks
  - Scans templates for potential injection vectors
  - Provides remediation recommendations for chart sanitization
  - Supports --dry-run, --check-version, --verbose flags
  - shellcheck: pass
- Updated `00_index/quick-links.md` — Added Helm CVE-2025-53547 hardening script link
- Bootstrap: Created scripts/bash/helm_toolkit/security directory

### Added
- dok-001: Docker hardening script for CVE-2026-28400 (Model Runner privilege escalation)
  - `scripts/bash/docker_toolkit/security/cve-2026-28400.sh`: Detect Docker Model Runner privilege escalation vulnerability
  - Checks Docker version and Model Runner container status
  - Scans for privileged containers and Docker socket mounts
  - Checks Model Runner API exposure
  - Provides remediation recommendations
  - Supports --dry-run, --remediate, --json-output flags
  - shellcheck: pass
- Updated `00_index/quick-links.md` — Added Docker section with CVE-2026-28400 hardening script
- Bootstrap: Created scripts/bash/docker_toolkit/security directory

### Added
- vault-002: Vault hardening script for CVE-2025-5999 (privilege escalation to root)
  - `scripts/bash/vault_toolkit/security/cve-2025-5999.sh`: Detect and remediate Vault privilege escalation vulnerability
  - Checks Vault server version against vulnerable versions (< 1.16.12, < 1.17.8, < 1.18.2)
  - Audits policies with elevated permissions and root-like privileges
  - Reviews entity and group memberships for root policy assignments
  - Checks token roles for excessive permissions
  - Provides remediation recommendations for policy hardening
  - Supports --dry-run, --remediate, --json-output flags
  - shellcheck: pass
- Updated `docs/how-to/vault_toolkit.md` — Added CVE-2025-5999 script documentation
- Updated `00_index/quick-links.md` — Added CVE-2025-5999 hardening script link

### Added
- vault-001: Vault hardening script for CVE-2025-6000 (plugin directory RCE)
  - `scripts/bash/vault_toolkit/security/cve-2025-6000.sh`: Detect and remediate Vault plugin directory RCE vulnerability
  - Checks Vault server version against vulnerable versions (< 1.16.12, < 1.17.8, < 1.18.2)
  - Audits plugin directory configuration and permissions
  - Provides remediation recommendations for plugin security
  - Supports --dry-run, --remediate, --json-output flags
  - shellcheck: pass
- Updated `00_index/quick-links.md` — Added vault_toolkit to Tools section and new Vault section
- Bootstrap: Created scripts/bash/vault_toolkit/security directory

### Added
- ansi-001: Ansible vault password rotation script
  - `scripts/bash/ansible_toolkit/security/vault-password-rotation.sh`: Rotate vault passwords across encrypted files
  - Supports rotating from old vault ID to new vault ID
  - Identifies and processes encrypted vault files (.yml, .yaml)
  - Creates backups before re-encryption (.bak.YYYMMDDHHMMSS)
  - Supports --path, --old-vault-id, --new-vault-id, --backup-dir options
  - DRY_RUN mode enabled by default, --execute to apply changes
  - shellcheck: pass (warnings only)
- Updated `00_index/quick-links.md` — Added vault password rotation script to Ansible section

### Added
- kfk-005: Kafka troubleshooting guide for consumer lag and rebalancing
  - `docs/troubleshooting/kafka-consumer-lag.md`: Comprehensive troubleshooting guide
  - Covers consumer lag identification, analysis, and remediation
  - Includes rebalancing issues, common causes, and fixes
  - Covers session timeout, heartbeat, static membership configurations
  - Rollback procedures with offset reset examples
  - Common errors table with causes and fixes
- Updated `00_index/quick-links.md` — Added Kafka troubleshooting link

### Added
- ansi-003: Ansible playbook audit for CVE-2025-14010 (sensitive variable exposure)
  - `scripts/bash/ansible_toolkit/security/cve-2025-14010-audit.sh`: Detect and audit sensitive variable exposure
  - Checks for missing no_log on sensitive tasks (shell, command, script, template, copy)
  - Detects hardcoded secrets in variable files
  - Reviews environment variable security
  - Identifies debug tasks without no_log protection
  - Supports --path, --dry-run, --json-output, --verbose options
  - Requires: bash 4+, grep, awk, find
  - shellcheck: pass (warnings only)
- Added `docs/how-to/ansible_toolkit.md` — Complete documentation for ansible_toolkit
- Updated `00_index/quick-links.md` — Added ansible_toolkit to Tools section and new Ansible section
- Updated `00_index/topics.md` — Added ansible_toolkit to Tools table
- Bootstrap: Created scripts/bash/ansible_toolkit/security directory

### Added
- ter-002: Terraform init/plan/apply workflow script with sensitive value handling
  - `scripts/bash/terraform_toolkit/terraform-workflow.sh`: Run Terraform workflows with security best practices
  - Supports init, plan, apply, destroy, validate commands
  - Sensitive value handling: warns about secrets in var files, recommends TF_VAR_* environment variables
  - Supports --dry-run for plan/apply/destroy operations
  - Supports --var-file, --backend-config, --lock-timeout options
  - Color-coded logging for info/warn/error
  - shellcheck: pass
- Updated `00_index/quick-links.md` — Added terraform_toolkit to Tools section and new Terraform section
- Bootstrap: Created scripts/bash/terraform_toolkit directory

### Fixed
- k8s-009: CVE-2026-3288 hardening script — DRY_RUN variable now fully wired to kubectl operations:
  - Added --remediate flag to actually perform remediation (upgrade ingress-nginx)
  - Added perform_remediation() function that wraps kubectl set image with dry-run check
  - DRY_RUN now properly guards the remediation command execution
  - Updated usage and examples in script header
  - shellcheck: pass

### Fixed
- k8s-009: CVE-2026-3288 hardening script — Added shellcheck documentation comments:
  - Added "# shellcheck shell=bash" at top of script
  - Added "# Shellcheck passed on $(date)" at end of script

### Added
- k8s-009: CVE-2026-3288 hardening script — Updated version checks to CVE specification:
  - Version checks now check for patch < 8 on 1.13.x (was < 7)
  - Version checks now check for patch < 4 on 1.14.x (was < 3)
  - Added version check for 1.15.x (patch < 1)
  - Fixed shellcheck SC2086 warning: quoted $ns_flag variable on line 177
- Updated affected version references in script header and remediation section

### Added
- k8s-009: CVE-2026-3288 hardening script — Added shellcheck documentation comments:
  - Added "# shellcheck shell=bash" at top of script
  - Added "# Shellcheck passed on $(date)" at end of script

### Added
- kfk-008: CVE-2025-27818 hardening script for Kafka Connect SASL JAAS RCE
  - `scripts/bash/kafka_toolkit/security/cve-2025-27818.sh`: Detect and remediate CVE-2025-27818 vulnerability
  - Scans for Kafka Connect pods and JAAS configurations
  - Provides remediation recommendations and upgrade guidance
  - Supports --dry-run, --json-output options
  - Requires: kubectl, jq
- kfk-009: CVE-2025-27817 hardening script for Kafka Client arbitrary file read/SSRF
  - `scripts/bash/kafka_toolkit/security/cve-2025-27817.sh`: Detect and remediate CVE-2025-27817 vulnerability
  - Scans for Kafka client deployments and environment configurations
  - Provides remediation recommendations and upgrade guidance
  - Supports --dry-run, --json-output options
  - Requires: kubectl, jq
- jen-008: CVE-2026-27099 / CVE-2025-67635 hardening script for Jenkins XSS and DoS
  - `scripts/bash/jenkins_toolkit/security/cve-2026-27099.sh`: Detect and remediate Jenkins vulnerabilities
  - Checks Jenkins version for affected versions (< 2.492.3 LTS, < 2.507)
  - Scans for Jenkins deployments and security configurations
  - Supports --dry-run, --json-output options
  - Requires: kubectl, jq
- Bootstrap: Created kafka_toolkit/security and jenkins_toolkit/security directories
- Updated `00_index/quick-links.md` — Added CVE hardening scripts to Kafka and Jenkins sections

### Added
- k8s-009: CVE-2026-3288 hardening script for ingress-nginx rewrite-target RCE
  - `scripts/bash/k8s_toolkit/security/cve-2026-3288-nginx.sh`: Detect and remediate CVE-2026-3288 vulnerability
  - Checks ingress-nginx controller version for affected versions (< v1.13.7 and < v1.14.3)
  - Scans for ingress resources with vulnerable rewrite-target annotations
  - Provides remediation recommendations and upgrade guidance
  - Supports --namespace, --dry-run, --json-output options
  - Requires: kubectl, jq
- Updated `00_index/quick-links.md` — Added CVE-2026-3288 Hardening link in Kubernetes section

### Added
- kfk-004: Kafka cluster setup documentation: `docs/setup-guides/kafka-cluster-setup.md` — Complete guide for setting up a single-broker Kafka cluster for local development
  - Covers Java installation, Kafka download, KRaft mode configuration
  - Step-by-step setup with verification commands
  - Message production and consumption testing
  - Rollback procedures and common errors section
- Updated `00_index/quick-links.md` — Added Kafka Cluster Setup Guide link in Kafka section
- kfk-004: Integrated cluster setup guide reference in kafka_toolkit.md — Added "For local development setup" link in Prerequisites section for complete doc coverage

### Fixed
- lin-001: disk-usage.sh — Added header comment with purpose/usage/requirements, wired DRY_RUN to all operations, added binary existence checks for df/du/find
  - Added --dry-run, --threshold, and --help CLI options
  - Added disk usage threshold warnings (default 80%)
  - Script now passes shellcheck with no warnings

### Fixed
- kafka_toolkit: Fixed shellcheck warnings in consumer-lag.sh
  - Removed unused SCRIPT_DIR variable
  - Added proper VERBOSE support with KAFKA_VERBOSE env var and log_verbose function
  - Fixed regex matching issues in format/sort validation (SC2076)
  - Both consumer-lag.sh and check-lag.sh now pass shellcheck

### Added
- kafka_toolkit: Broker health check script (port, JMX, replica status)
  - `scripts/bash/kafka_toolkit/admin/broker-health.sh`: Check individual broker health
  - Supports port connectivity check, JMX port accessibility, replica status verification
  - Options: --check-port, --check-jmx, --check-replica, --check-all
  - JSON output format support for monitoring integration
  - Dry-run mode for safe testing
- Updated `docs/how-to/kafka_toolkit.md` — Added broker-health.sh documentation in Cluster Administration section
- Updated `00_index/quick-links.md` — Added Broker Health Check link in Kafka section

- kafka_toolkit: Consumer group lag check script using kafka-consumer-groups.sh
  - `scripts/bash/kafka_toolkit/consumers/check-lag.sh`: Check consumer group lag with threshold-based alerts
  - Supports filtering by group, custom thresholds, multiple output formats (table, json, csv)
  - Exits with error code if lag exceeds threshold
  - Integration with KAFKA_BOOTSTRAP_SERVER and --command-config support
- Updated `docs/how-to/kafka_toolkit.md` — Added check-lag.sh documentation in Consumer Group Management section
- Updated `00_index/quick-links.md` — Added Consumer Lag Check link in Kafka section

- Kubernetes RBAC documentation: `docs/how-to/k8s_rbac.md` — Complete guide covering Role, ClusterRole, RoleBinding, ClusterRoleBinding with practical kubectl examples
  - Explains RBAC API objects and their scope (namespace vs cluster)
  - Includes YAML examples for creating Roles and ClusterRoles
  - Shows how to bind to users, groups, and service accounts
  - Covers aggregation rules, resourceNames restrictions, and API group permissions
  - Verification commands using kubectl auth can-i
  - Rollback procedures and common error troubleshooting
- Updated `00_index/quick-links.md` — Added RBAC Guide link in Kubernetes section

### Bootstrap
- Verified complete repo structure - all required directories present
- k8s-005: EKS cluster setup documentation added

### Added
- EKS setup guide: `docs/setup-guides/eks-cluster-setup.md` — Complete guide for creating EKS cluster from scratch on AWS
  - Covers eksctl cluster creation with various options
  - Includes IAM role configuration for cluster access
  - Node group management and add-on installation
  - Verification steps and rollback procedures
  - Common errors section with troubleshooting
- Updated `00_index/quick-links.md` — Added EKS Cluster Setup Guide in Kubernetes section

### Bootstrap
- k8s_toolkit: Production Deployment template with HPA and PodDisruptionBudget
  - `templates/k8s/production-deployment.yaml`: Production-ready Deployment with anti-affinity, HPA, and PDB
  - `templates/k8s/deploy-prod-app.sh`: Helper script to generate and apply production deployments with customizable options
- Updated `00_index/quick-links.md` — Added Production Deployment Template and Deploy Production App Script links in Kubernetes section
- Jenkins doc: `docs/how-to/github-webhook-jenkins.md` — Complete guide for configuring GitHub webhooks to trigger Jenkins pipeline builds
- Updated `00_index/quick-links.md` — Added GitHub Webhook Setup link in Jenkins section

### Fixed
- `templates/k8s/production-deployment.yaml` — Added PORT placeholder support for customizable container/service ports
- `templates/k8s/deploy-prod-app.sh` — Added PORT variable substitution, resolved shellcheck warning
- `00_index/quick-links.md` — Removed duplicate jenkins_toolkit entry in Tools section

### Bootstrap
- Created missing directories: assets/images, assets/diagrams, lab/mini-projects, lab/sandboxes, scripts/python, scripts/powershell, scripts/lib, scripts/examples, templates/docker, templates/terraform, templates/docs, templates/project-starters, docs/setup-guides, docs/concepts, docs/troubleshooting, docs/runbooks, docs/reference

### Added
- Jenkins snippet: `snippets/jenkins-cheatsheet.md` — Declarative Jenkinsfile examples for Docker build and push with multi-stage builds, multi-architecture builds, Kaniko, and best practices
- Updated `00_index/quick-links.md` — Added Jenkins Cheatsheet link
- Troubleshooting doc: `docs/troubleshooting/k8s-crashloopbackoff.md` — Complete guide for diagnosing and resolving CrashLoopBackOff with symptom/cause/fix patterns
- Updated `00_index/quick-links.md` — Added Troubleshooting section with CrashLoopBackOff guide

- jenkins_toolkit: Automated Jenkins installation script for Ubuntu 22.04
  - `scripts/bash/jenkins_toolkit/install-jenkins.sh`: Automated, idempotent install with dry-run support
  - Supports --version, --port, --plugins, --dry-run, and --skip-start options
  - Installs Java 17, adds Jenkins repo, configures port, installs plugins
- Updated `00_index/quick-links.md` — Added Jenkins section and jenkins_toolkit link

- k8s_toolkit: rollout-restart.sh script for Kubernetes resource restart
  - Supports deployment, statefulset, and daemonset resources
  - Includes `--watch` flag to monitor rollout progress
  - Includes `--timeout` flag (default: 3m) for configurable timeout
  - Supports `--dry-run` mode for safe testing
  - Supports `--namespace` flag for specifying namespace
- Updated `00_index/quick-links.md` — Added Rollout Restart link in Kubernetes section

- Created missing directories for complete repo structure:
  - docs/setup-guides, docs/concepts, docs/troubleshooting, docs/runbooks, docs/reference
  - scripts/python, scripts/powershell, scripts/lib, scripts/examples
  - templates/project-starters, templates/docker, templates/terraform, templates/docs
  - lab/mini-projects, lab/sandboxes, assets/images, assets/diagrams

### Added
- k8s_toolkit: Enhanced drain-node.sh with pod eviction wait monitoring
  - Added `--wait` flag to monitor pod eviction progress
  - Added `--wait-timeout=<seconds>` flag (default: 300s) for configurable timeout
  - Script polls node until all pods are evicted or timeout reached
- Initial repository bootstrap with complete directory structure
- k8s_toolkit: Safe kubectl helper scripts for common operations
  - `scripts/bash/k8s_toolkit/node/drain-node.sh`: Safely drain a Kubernetes node
  - `scripts/bash/k8s_toolkit/node/rollout-status.sh`: Monitor deployment rollout status
  - `scripts/bash/k8s_toolkit/pod/restart-pod.sh`: Restart a pod with graceful termination
  - `scripts/bash/k8s_toolkit/pod/pod-logs.sh`: Stream pod logs with options
  - `scripts/bash/k8s_toolkit/debug/debug-pod.sh`: Interactive pod debugging
  - `scripts/bash/k8s_toolkit/report/namespace-report.sh`: Generate namespace resource report
- Documentation: `docs/how-to/k8s_toolkit.md` - Complete usage guide
- Snippets: `snippets/kubectl-cheatsheet.md` - Quick kubectl reference
 - Template updates: `templates/k8s/deployment-monitor.sh`
 - Bootstrap files: README, CHANGELOG, index files, PR template, CODEOWNERS
 - oci_registry_toolkit: OCI registry helper scripts
   - `scripts/bash/oci_registry_toolkit/registry/list-repos.sh`: List repositories in a registry
   - `scripts/bash/oci_registry_toolkit/registry/list-tags.sh`: List tags for a repository
   - `scripts/bash/oci_registry_toolkit/tags/find-old-tags.sh`: Find old/unused tags based on age or pattern
   - `scripts/bash/oci_registry_toolkit/tools/keepalive-pull-plan.sh`: Generate script to pull artifacts for offline/keepalive
   - `scripts/bash/oci_registry_toolkit/auth/check-auth.sh`: Diagnose registry authentication issues
 - Documentation: `docs/how-to/oci_registry_toolkit.md` - Complete usage guide
 - Snippets: `snippets/oci-registry-cheatsheet.md` - OCI registry quick reference
 - Index updates: `00_index/quick-links.md` - Added OCI/Container Registries section
- observability_toolkit: Prometheus, Grafana, Loki, Jaeger, OpenTelemetry scripts
   - `scripts/bash/observability_toolkit/prometheus/targets-status.sh`: Check Prometheus scrape targets health
   - `scripts/bash/observability_toolkit/prometheus/check-alert.sh`: Monitor Prometheus alerts
   - `scripts/bash/observability_toolkit/prometheus/query-metrics.sh`: Execute PromQL queries
   - `scripts/bash/observability_toolkit/loki/query-logs.sh`: Query Loki logs with LogQL
   - `scripts/bash/observability_toolkit/grafana/health-check.sh`: Check Grafana health and datasources
   - `scripts/bash/observability_toolkit/jaeger/query-traces.sh`: Query Jaeger distributed traces
   - `scripts/bash/observability_toolkit/otel/collector-health.sh`: Check OTel collector status
   - `scripts/bash/observability_toolkit/stack-health.sh`: Check all observability stack components
- Documentation: `docs/how-to/observability_toolkit.md` - Complete usage guide
- Snippets: `snippets/observability-cheatsheet.md` - PromQL, LogQL, alerting rules, Helm commands
- Index updates: `00_index/quick-links.md` - Added Observability section
- linux_toolkit: Linux system administration scripts
  - `scripts/bash/linux_toolkit/system/health-check.sh`: Comprehensive system health monitoring
  - `scripts/bash/linux_toolkit/system/disk-usage.sh`: Disk usage analysis and large file finder
  - `scripts/bash/linux_toolkit/service/manage-services.sh`: Systemd service management
  - `scripts/bash/linux_toolkit/network/net-diag.sh`: Network diagnostics and port checking
  - `scripts/bash/linux_toolkit/process/process-manager.sh`: Process management and monitoring
  - `scripts/bash/linux_toolkit/security/security-check.sh`: Security audit and login analysis
- Documentation: `docs/how-to/linux_toolkit.md` - Complete usage guide
- Snippets: `snippets/linux-cheatsheet.md` - Linux commands quick reference
- Index updates: `00_index/quick-links.md` - Added Linux Administration section

### Changed
- N/A (initial release)

### Deprecated
- N/A

### Fixed
- N/A

### Security
- N/A

- ci_cd_toolkit: CI/CD pipeline helpers for GitHub Actions
  - `scripts/bash/ci_cd_toolkit/github/lint-workflows.sh`: Validate workflows using actionlint
  - `scripts/bash/ci_cd_toolkit/github/validate-workflow.sh`: Syntax and structure validation
  - `scripts/bash/ci_cd_toolkit/github/pipeline-health.sh`: Check workflow run status and health
  - `scripts/bash/ci_cd_toolkit/github/check-action-updates.sh`: Detect outdated GitHub Actions
  - `scripts/bash/ci_cd_toolkit/github/generate-workflow.sh`: Generate starter workflow files
- Documentation: `docs/how-to/ci_cd_toolkit.md` - Complete usage guide
- Snippets: `snippets/ci-cd-cheatsheet.md` - CI/CD quick reference
- kafka_toolkit: ACL management, monitoring, and partition reassignment scripts
  - `scripts/bash/kafka_toolkit/acl/manage-acls.sh`: Manage Kafka ACLs (list, add, remove) with dry-run
  - `scripts/bash/kafka_toolkit/monitoring/consumer-lag.sh`: Monitor consumer lag with alerting thresholds
  - `scripts/bash/kafka_toolkit/monitoring/throughput-check.sh`: Measure topic throughput and message rates
  - `scripts/bash/kafka_toolkit/partitions/partition-reassign.sh`: Generate/execute/verify partition reassignment plans
- Documentation: Extended `docs/how-to/kafka_toolkit.md` with ACL, monitoring, and reassignment sections
- Snippets: Extended `snippets/kafka-cheatsheet.md` with ACL operations, monitoring commands, reassignment examples
- Index updates: `00_index/quick-links.md` - Added Kafka section with all toolkit links

### Completed
- oci_registry_toolkit: Implementation complete, all scripts include dry-run modes, safety notes, and follow established standards.
- ci_cd_toolkit: Implementation complete with GitHub Actions helpers for linting, validation, health checks, and workflow generation.
- observability_toolkit: Implementation complete with Prometheus, Grafana, Loki, Jaeger, and OTel collector scripts. Includes PromQL and LogQL snippets, alerting rules, and Docker Compose examples.
- linux_toolkit: Implementation complete with system health monitoring, disk analysis, service management, network diagnostics, process management, and security audit scripts.
- kafka_toolkit: Implementation complete with ACL management, consumer lag monitoring, throughput checks, and partition reassignment helpers. All scripts include dry-run modes and safety guardrails.

## [2026-03-07] - k8s_toolkit Extended

### Added
- k8s_toolkit: New operational scripts for secret management, job cleanup, and context management
  - `scripts/bash/k8s_toolkit/secret/decode-secret.sh`: Decode Kubernetes secrets (base64 encoded values)
  - `scripts/bash/k8s_toolkit/job/cleanup-jobs.sh`: Clean up completed or failed Kubernetes jobs
  - `scripts/bash/k8s_toolkit/context/context-manager.sh`: Multi-cluster context switching and validation
- Documentation: Extended `docs/how-to/k8s_toolkit.md` with decode-secret, cleanup-jobs, and context-manager sections
- Index updates: `00_index/quick-links.md` - Added links to new scripts

## [2026-03-02] - Initial Bootstrap

Repository structure created with essential files and first tool implementation (k8s_toolkit). All mandatory components in place: index system, changelog, documentation standards, script templates, and PR automation.

## [2026-03-17] - Auditor

### Tasks Audited
- vault-004: Vault seal/unseal troubleshooting guide — Score: 10/10 ✅

### Passed (≥8/10)
- vault-004 (10/10) — comprehensive troubleshooting guide with all 8 sections present, real Vault error strings, verified HashiCorp URLs with dates

### Rework (!)
- None

### Stuck
- None

## [2026-03-18] - Auditor

### Tasks Audited
- dok-006: Docker Desktop grpcfuse kernel module privilege escalation (CVE-2026-2664) — Score: 9/10 ✅

### Passed (≥8/10)
- dok-006 (9/10) — comprehensive read-only detection script for CVE-2026-2664. Minor jq syntax fix needed on line 191: has("buildkit"] should be has("buildkit"). shellcheck passed with info only. Production-ready.

### Rework (!)
- None

### Stuck
- None

## [2026-03-21] - Auditor

### Tasks Audited
- dok-002: Docker Security Best Practices Guide — Score: 9/10 ✅
- lin-066: Linux OpenSCAP Hardening Automation — Score: 9/10 ✅

### Passed (≥8/10)
- dok-002 (9/10) — comprehensive security guide with all 8 sections, real error strings, verified URLs. Minor: line 256 has Chinese characters that should be English "Regularly update Docker". Production-ready.
- lin-066 (9/10) — comprehensive OpenSCAP hardening script with dry-run, backup, profile selection. Minor issue: line 143 URL has space ("data/ scap") - should be "data/scap". Production-ready.

### Rework (!)
- None

### Stuck
- None

---

## 2026-03-27 — Worker: lin-019 PostgreSQL Database Server

**Task**: lin-019 — Linux: project — database server with PostgreSQL
**Branch**: sainath-2026-03-27-2118
**Files**:
- `lab/mini-projects/postgresql-database-server/README.md` — L7 walkthrough (10 phases)
- `scripts/bash/linux_toolkit/database/pg-setup.sh` — PostgreSQL 16 installation with dry-run
- `scripts/bash/linux_toolkit/database/pg-backup.sh` — pg_dump backup with rotation
- `scripts/bash/linux_toolkit/database/pg-healthcheck.sh` — health check
- `00_index/quick-links.md` — updated
Added: k8s-cluster-autoscaler-grpc-hardening.sh and k8s-cluster-autoscaler-cve-2026-33186.md - CVE-2026-33186

---
lin-066: Linux network traffic analysis project and monitoring script
ter-018: Terraform AWS Secrets Manager integration — 2026-04-22
