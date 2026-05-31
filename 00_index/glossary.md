# Glossary

## Terms

**dry-run**: A mode where operations are simulated without making actual changes. Used for validation and safety before executing potentially destructive actions.

**AIDE (Advanced Intrusion Detection Environment)**: File integrity monitoring tool that detects unauthorized changes to files using cryptographic hashes.

**File integrity monitoring**: Security process that verifies files have not been altered by comparing current checksums against known baseline values.

**guardrails**: Safety checks and constraints built into scripts to prevent unintended modifications or destructive operations.

**kubectl**: Command-line interface for running commands against Kubernetes clusters.

**OCI registry**: Open Container Initiative compliant container registry (e.g., Docker Hub, GitHub Container Registry, private registries).

**SRE**: Site Reliability Engineering - discipline that applies software engineering practices to infrastructure and operations.

**toolkit**: A curated collection of scripts, documentation, and templates focused on a specific domain (e.g., k8s_toolkit).

**Consumer lag (Kafka)**: Difference between the latest offset and consumer's committed offset.

**Drain (Kubernetes)**: Mark a node unschedulable and evict all pods from it.

**KRaft**: Kafka's ZooKeeper-less mode using Kafka Raft consensus protocol for metadata management.

**Static membership (Kafka)**: Kafka consumer feature that maintains consistent group membership across restarts using group.instance.id.

**JAAS**: Java Authentication and Authorization Service - used for Kafka Connect SASL authentication.

**bound_principal_iam (Vault)**: IAM principal associated with Vault AWS auth method for authentication.

**Chart.yaml**: Helm chart manifest file containing chart metadata and dependencies.

**Model Runner (Docker)**: Docker feature for running local AI models with the docker model command.

**no_log (Ansible)**: Ansible directive that prevents task output from being logged for security.

**Shamir key (Vault)**: Vault's default seal mechanism that splits the unseal key into multiple shares using Shamir's secret sharing algorithm.

**Auto-unseal (Vault)**: Vault feature that automatically unseals using a trusted cloud KMS (AWS KMS, Azure Key Vault, GCP Cloud KMS) or HSM.

**HSM (Hardware Security Module)**: Physical device that provides secure key storage and cryptographic operations.

**PKCS#11**: Standard interface for communicating with cryptographic devices like HSMs.

**Recovery mode (Vault)**: Vault operation mode used for recovery when standard unseal is not possible.

**Trivy**: Open-source vulnerability scanner for containers and Kubernetes.

**Kubescape**: Kubernetes security platform for scanning clusters and manifests.

**Checkov**: Infrastructure as Code security scanner that checks Terraform, CloudFormation, and Kubernetes manifests.

**Falco**: Cloud-native runtime security tool that detects anomalous activity in containers and Kubernetes.

**GitOps**: A DevOps workflow where Git is the single source of truth for infrastructure and application deployments, enabling automated, auditable, and reversible changes.

**CVE (Common Vulnerabilities and Exposures)**: Standardized identifier for publicly known cybersecurity vulnerabilities, providing a unified reference for security issues and their remediation.

**Hardening**: The process of securing a system by reducing its attack surface, removing unnecessary components, and implementing security controls to resist attacks.

**Supply chain attack**: An attack that compromises software dependencies, build systems, or distribution channels to inject malicious code into trusted software.

**IaC (Infrastructure as Code)**: Managing infrastructure through code-based definitions that are versioned, reviewed, and automated for consistent, repeatable deployments.

**Seal (Vault)**: The action of encrypting Vault's data store, making all stored information inaccessible until the vault is unsealed with the appropriate keys or mechanism.

**go-getter (Vault)**: A Go-based utility used by Vault's Terraform provider to download remote configuration files, vulnerable to arbitrary file read when fetching untrusted sources.

**Flatted**: A JavaScript library for serializing and deserializing circular JSON structures, vulnerable to prototype pollution when processing untrusted input (CVE-2026-33228).

**Geo-replication (ACR)**: Azure Container Registry feature that replicates container images across multiple Azure regions for low-latency access and redundancy.

**KRaft (Kafka)**: Kafka's internal consensus protocol that replaces ZooKeeper for metadata management, enabling simpler cluster operations and improved scalability.

**Semgrep**: Static analysis tool for finding code patterns and security vulnerabilities using customizable rules, supporting multiple languages.

**SAST (Static Application Security Testing)**: Security testing methodology that analyzes source code for vulnerabilities without executing the program.

**Checkov**: Infrastructure as Code security scanner that checks Terraform, CloudFormation, Kubernetes, and other IaC frameworks for misconfigurations.

**Atlantis**: Terraform CI/CD tool that automates plan/apply workflows triggered by pull request comments.

**Flux**: GitOps operator for Kubernetes that reconciles cluster state with configuration stored in Git repositories.

**GitOps reconciliation**: Continuous process where a GitOps operator (e.g., Flux, ArgoCD) ensures the live cluster state matches the desired state defined in a Git repository.

**ArgoCD**: Declarative GitOps continuous delivery tool for Kubernetes that automates application deployment and synchronization.

**Vulnerability database**: A curated collection of known security vulnerabilities (e.g., Trivy's vulnerability database) used by scanners to identify affected software versions.

**Alertmanager HA clustering**: Running multiple Alertmanager instances that use a gossip protocol to share alert state, providing high availability and alert deduplication across instances.

**Promtail**: Grafana Loki's log collection agent that watches local logs and forwards them to Loki for centralized log aggregation and querying.

**OTel Collector**: OpenTelemetry Collector - a vendor-neutral proxy that receives, processes, and exports telemetry data (metrics, traces, logs) to backends like Prometheus, Jaeger, or Loki.

**Gossip protocol (Alertmanager)**: Peer-to-peer communication mechanism used by Alertmanager HA cluster to share silences, notifications, and state without requiring a central coordinator.

**Jaeger**: Open-source distributed tracing system for monitoring and troubleshooting microservices-based distributed systems.

**CircleCI Runner**: Self-hosted agent that executes CI/CD jobs on user-managed infrastructure, providing more control compared to CircleCI's cloud executors.

**Buildkite Agent**: Self-hosted CI agent that polls Buildkite for jobs and executes them on your own infrastructure, supporting Docker, Kubernetes, and bare-metal environments.

**Syft**: Open-source tool for generating SBOMs (Software Bill of Materials) from container images and filesystems.

**TruffleHog**: Open-source secret scanning tool that detects exposed credentials, API keys, and sensitive data in git repositories using regex patterns and entropy analysis.

**SBOM (Software Bill of Materials)**: A machine-readable inventory of software components and dependencies used in an application, commonly generated in CycloneDX or SPDX formats by tools like Syft.

**CycloneDX**: OWASP standard lightweight SBOM format for software component identification and dependency analysis, commonly used for supply chain security.

**SPDX (Software Package Data Exchange)**: ISO standard format for exchanging SBOM information, developed by the Linux Foundation for license compliance and security use cases.

**Rule pack (Semgrep)**: A collection of Semgrep rules combined with logical operators (AND, OR, NOT) to create composable scanning patterns for complex code analysis.

**Custom detector (TruffleHog)**: A user-defined YAML-based rule that extends TruffleHog's secret detection to match proprietary or organization-specific secret patterns using regex and entropy thresholds.

**Plan scanning (Checkov)**: Analyzing a Terraform plan output (not just source code) with Checkov to catch misconfigurations that only become visible after variable interpolation and resource resolution.

**SARIF (Static Analysis Results Interchange Format)**: OASIS standard JSON format for exchanging static analysis results, enabling scanners like Semgrep to integrate with platforms such as GitHub Code Scanning.

## Acronyms

**CI/CD** - Continuous Integration/Continuous Deployment
**IaaS** - Infrastructure as a Service
**PaaS** - Platform as a Service
**SaaS** - Software as a Service
**VCS** - Version Control System
**RCE** - Remote Code Execution
**DoS** - Denial of Service
**SSRF** - Server-Side Request Forgery
**OTel** - OpenTelemetry
**ACR** - Azure Container Registry
**KRaft** - Kafka Raft (consensus protocol)