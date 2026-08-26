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

**become (Ansible)**: Ansible directive that escalates privileges for a task or play (e.g., `become: true` to run as root via sudo). Requires `--ask-become-pass` or a NOPASSWD sudoers entry on the target.

**ansible.cfg**: Ansible's configuration file, which controls defaults such as `host_key_checking`, inventory path, and remote user. Searched for in the current directory, then `~/.ansible.cfg`, then `/etc/ansible/ansible.cfg`.

**group_vars / host_vars (Ansible)**: Directories holding variable files automatically loaded by Ansible for groups (`group_vars/`) or individual hosts (`host_vars/`). A file named `all.yml` inside `group_vars/` applies to every host.

**serial (Ansible)**: A play keyword that limits how many hosts run the task at once (e.g., `serial: 1` for a rolling update, one host at a time).

**throttle (Ansible)**: A task-level keyword that caps concurrent execution on a per-task basis, useful for limiting simultaneous SSH connections or API calls.

**Shamir key (Vault)**: Vault's default seal mechanism that splits the unseal key into multiple shares using Shamir's secret sharing algorithm.

**Auto-unseal (Vault)**: Vault feature that automatically unseals using a trusted cloud KMS (AWS KMS, Azure Key Vault, GCP Cloud KMS) or HSM.

**HSM (Hardware Security Module)**: Physical device that provides secure key storage and cryptographic operations.

**PKCS#11**: Standard interface for communicating with cryptographic devices like HSMs.

**Recovery mode (Vault)**: Vault operation mode used for recovery when standard unseal is not possible.

**Dynamic secrets (Vault)**: Short-lived credentials generated on demand by Vault for a specific lease duration. Unlike static secrets stored in the KV store, dynamic secrets are created when read and automatically revoked when the lease expires, minimizing the blast radius of a leaked credential.

**Trivy**: Open-source vulnerability scanner for containers and Kubernetes.

**Trivy offline scan**: Running Trivy with `--offline-scan` so it never reaches the network, using a pre-populated local vulnerability database cache. Used in air-gapped pipelines or to make scans fast and deterministic.

**Trivy cache**: The local store of vulnerability databases and scan metadata. Reused across runs and pruned (`trivy cache clean`) to bound disk usage and control when DB refresh happens.

**Parallel scanning (Trivy)**: Splitting a scan workload across multiple targets or raised-internal parallelism to cut wall-clock time on large repositories, at the cost of more memory and CPU.

**Multi-arch scanning (Trivy)**: Scanning images and manifests for multiple CPU architectures (e.g. amd64, arm64) through a single registry reference. Trivy resolves the per-architecture manifest list so each platform's packages are checked against the vulnerability database.

**Manifest list (container registry)**: A registry object that points a single image tag to platform-specific image manifests. Tools like Trivy read it to discover every architecture behind one tag.

**Trivy ignorefile (`.trivyignore`)**: A file listing vulnerabilities to suppress from a Trivy scan, referenced via the `--ignorefile` flag. Kept separate from scan config so temporary suppressions live with the project rather than in the scanner config.

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

**pattern-inside (Semgrep)**: A Semgrep combinator that restricts matches to code within a specific surrounding structure, reducing false positives by requiring context. Example: matching SQL injection only inside Django view functions.

**pattern-either (Semgrep)**: A Semgrep combinator that matches any one of several alternative code patterns. Example: detecting either `subprocess.call` or `os.system` with a single rule.

**pattern combinators (Semgrep)**: Semgrep features (`pattern-inside`, `pattern-either`, `pattern-not`, etc.) that combine multiple patterns to narrow scan scope and reduce noise in large codebases.

**SAST (Static Application Security Testing)**: Security testing methodology that analyzes source code for vulnerabilities without executing the program.

**Checkov**: Infrastructure as Code security scanner that checks Terraform, CloudFormation, Kubernetes, and other IaC frameworks for misconfigurations.

**Atlantis**: Terraform CI/CD tool that automates plan/apply workflows triggered by pull request comments.

**Flux**: GitOps operator for Kubernetes that reconciles cluster state with configuration stored in Git repositories.

**GitOps reconciliation**: Continuous process where a GitOps operator (e.g., Flux, ArgoCD) ensures the live cluster state matches the desired state defined in a Git repository.

**ArgoCD**: Declarative GitOps continuous delivery tool for Kubernetes that automates application deployment and synchronization.

**Repository Secret (ArgoCD)**: A Kubernetes Secret labelled `argocd.argoproj.io/secret-type: repository` that ArgoCD auto-discovers to register a private Git repository — no `argocd repo add` needed. Credentials must still be kept out of Git.

**policy.csv (ArgoCD RBAC)**: ArgoCD's CSV-based RBAC policy. `p` lines grant a subject a resource+action on a project-scoped object; `g` lines bind users to roles. First-match-wins, so named roles can be scoped tighter than `policy.default`.

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

**ZAP (Zed Attack Proxy)**: OWASP's open-source DAST tool for finding security vulnerabilities in web applications during dynamic testing.

**DAST (Dynamic Application Security Testing)**: Security testing methodology that analyzes running applications by simulating attacks, complementing SAST by finding runtime vulnerabilities.

**Baseline scan (ZAP)**: A non-intrusive ZAP spider and passive scan mode that identifies common vulnerabilities without active attack payloads.

**ZAP context**: A ZAP configuration that defines URL patterns, authentication methods, and session handling for targeted scanning of specific web applications.

**CodeQL**: GitHub's semantic code analysis engine that treats code as data, enabling custom vulnerability queries using QL query language.

**QL**: CodeQL's declarative query language for expressing code patterns and security vulnerabilities across multiple programming languages.

**Grype**: Open-source vulnerability scanner for container images and filesystems, focused on CVE matching against multiple upstream databases.

**CPE (Common Platform Enumeration)**: Standardized naming scheme for identifying software platforms and versions used by vulnerability databases for matching.

**Vulnerability matching**: The process of comparing software inventory (from SBOM or filesystem scan) against known CVE databases to identify affected packages.

**Cosign**: Open-source tool for container image signing and verification using cryptographic signatures, part of the Sigstore project, enabling supply chain security through signed artifact provenance.

**OPA (Open Policy Agent)**: Open-source policy engine that uses Rego language to define and enforce policies across cloud-native stacks, including Kubernetes admission control, Terraform plan validation, and CI/CD gate decisions.

**Rego**: OPA's declarative policy language for defining rules that query and transform structured data (JSON, YAML) to make policy decisions.

**Snyk**: Developer security platform for finding and fixing vulnerabilities in open-source dependencies, container images, and infrastructure as code configurations.

**GitGuardian**: Security platform for detecting secrets and sensitive data in source code repositories, known for its custom policy engine and ggshield CLI for pre-commit scanning.

**ggshield**: GitGuardian's CLI tool for scanning git repositories, files, and CI/CD pipelines for exposed secrets and sensitive data.

**Dependabot**: GitHub's automated dependency update tool that monitors dependencies for known vulnerabilities and creates pull requests to update them.

**Terrascan**: Static code analysis tool for Infrastructure as Code that detects security violations and compliance issues in Terraform, Kubernetes, and other IaC templates.

**HCL (HashiCorp Configuration Language)**: Domain-specific language used by Terraform, Vault, and other HashiCorp tools for defining infrastructure and policy configurations in a human-readable format.

**OIDC (OpenID Connect)** — Authentication protocol used by Cosign for keyless container image signing, delegating identity to a trusted issuer like GitHub Actions or a cloud provider.

**Attestation (Cosign)** — A signed statement about a container artifact (often containing an SBOM or build provenance), verified alongside the image signature to establish supply chain provenance.

**Severity gating**: A CI/CD practice where pipeline stages are blocked or allowed based on the severity level of security findings, typically failing builds on CRITICAL or HIGH vulnerabilities.

**SCA (Software Composition Analysis)**: Security testing methodology that analyzes open-source dependencies and third-party libraries for known vulnerabilities, license violations, and outdated packages.

**IAST (Interactive Application Security Testing)**: Security testing methodology that instruments running applications to identify vulnerabilities in real time during functional testing, combining aspects of SAST and DAST.

**Secrets scanning**: Automated process of detecting hardcoded credentials, API keys, tokens, and passwords in source code, configuration files, and git history before they reach production.

**Detection**: The act of scanning code, commits, or runtime environments for secret patterns. Example: a scanner reviewing Git history for high-entropy strings that resemble generated tokens.

**Entropy**: A measure of randomness in a string. High-entropy strings often indicate generated secrets rather than natural language. Example: `xQ7kP9mR2vL5` has higher entropy than `password123`.

**Remediation**: The process of invalidating a compromised secret and replacing it with a new one. Example: rotating an AWS access key after a leak is detected.

**Incident response**: A structured process for detecting, containing, investigating, and remediating security incidents. In the secrets context it moves from alert (a scanner flags a leaked key) to verified remediation (the credential is revoked and access is confirmed cut) without leaving loose ends.

**Blast radius**: The scope of systems or data exposed by a single compromised secret. Example: a leaked database password may expose all schemas, while a leaked read-only token may expose only metadata.

**Dashboard (Grafana)** — A named collection of panels on a single screen, usually sharing a time range. Example: a "Web API Overview" dashboard with panels for request rate, error rate, p99 latency, and active connections.

**Panel (Grafana)** — A single visualization unit inside a dashboard — graph, stat/gauge, table, heatmap, or bar gauge. Example: a stat panel showing current request rate as a big number with a sparkline.

**Data source (Grafana)** — The backend Grafana queries — Prometheus, Loki, InfluxDB, etc. Each data source has its own query language. Example: Prometheus data source uses PromQL.

**Variable (Grafana)** — A dashboard-level placeholder that lets you parameterize queries. Example: a `$namespace` dropdown that filters all panels to a specific Kubernetes namespace.

**Row (Grafana)** — A visual grouping of panels within a dashboard. Example: grouping all latency panels under a "Latency" row and all volume panels under "Throughput."

**Alert (Grafana)** — A condition evaluated against a query result that triggers a notification channel when true. Example: alert when `up{job="api"} == 0` for 60 seconds.

**Notification channel (Grafana)** — The endpoint Grafana sends alert payloads to — Slack, webhook, PagerDuty, email, etc.

**Annotation (Grafana)** — A vertical marker or region overlay on a panel timeline, usually tied to deployment events. Example: a marker at each deployment time so you can correlate latency changes with code releases.

**Explore (Grafana)** — An ad-hoc query mode for investigating metrics and logs without building a dashboard panel first.

**Logs (Observability)** — Timestamped text records of discrete events. Example: an application writing `2026-07-13T14:02:01Z WARN connection pool exhausted` to stdout.

**Metrics (Observability)** — Numeric values measured at regular intervals. Example: `http_requests_total{method="POST",code="500"} 42` scraped every 15 seconds.

**Traces (Observability)** — Records of a single request's journey across service boundaries, broken into spans. Example: a POST /checkout trace showing spans for auth-service (12ms), inventory-service (34ms), and payment-service (890ms).

**Distributed tracing** — Traces collected across multiple services in a microservice architecture, linked by a shared trace ID injected at the edge.

**Structured logging** — Logging in a parseable format (usually JSON) instead of freeform text. Example: `{"ts":"...","level":"warn","msg":"pool exhausted","pool":"checkout","active":50,"waiting":120}`.

**Metric (Prometheus)** — A named numeric measurement with labels. Example: `http_requests_total{method="POST",endpoint="/api/checkout",code="200"} 1042`.

**Labels (Prometheus)** — Key-value pairs attached to a metric that let you distinguish time-series with the same name. Example: `method`, `endpoint`, `code` on `http_requests_total`.

**Scrape (Prometheus)** — A single pull of a metrics endpoint. Example: Prometheus GETs `http://myapp:8080/metrics` every 15 seconds and stores the result.

**Scrape interval (Prometheus)** — How often Prometheus pulls each target. Example: `15s` (scrape every 15 seconds) is the default; sensitive metrics may use `5s`.

**Exporter (Prometheus)** — An agent that translates an existing system's metrics into the Prometheus format. Example: `node_exporter` exposes CPU, memory, disk, and network metrics from a Linux host as `/metrics`.

**PromQL** — Prometheus's query language. Example: `rate(http_requests_total[5m])` computes the per-second average rate of requests over the last 5 minutes.

**Instant vector (Prometheus)** — A set of time-series with a single sample each, at a specific timestamp. Example: `http_requests_total` at right now returns one sample per (method, endpoint, code) combination.

**Range vector (Prometheus)** — A set of time-series with a range of samples over time. Example: `http_requests_total[5m]` returns all samples from the last 5 minutes for each series.

**Recording rule (Prometheus)** — A pre-computed query stored as a new time-series, reducing query load for dashboards and alerts. Example: pre-compute `job:request_rate:rate5m` so your 20 dashboards don't all run the same `rate()` query.

**Alerting rule (Prometheus)** — A PromQL expression evaluated on a schedule that fires an alert when the result is true. Example: `up{job="api"} == 0` fires a "service down" alert if the API hasn't responded to a scrape for 60 seconds.

**Target (Prometheus)** — An endpoint Prometheus scrapes, defined by a static config or service discovery. Example: `myapp:8080/metrics` on port 8080.

**Service discovery (Prometheus)** — Automatic target discovery from an external system. Example: Kubernetes SD watches the API server and adds/removes pod targets as pods are scheduled and terminated.

**Pushgateway (Prometheus)** — A standalone component for short-lived jobs (batch, cron) that cannot be scraped because they don't run long enough. The job pushes its final metrics to the gateway, and Prometheus scrapes the gateway.

**Tetragon**: Cloud-native eBPF-based security observability and runtime enforcement tool that monitors kernel-level events for detecting and preventing malicious behaviour in containers and Kubernetes.

**eBPF (extended Berkeley Packet Filter)**: Linux kernel technology that allows sandboxed programs to run within the kernel without modifying kernel source code or loading modules, used for observability, networking, and security.

**tetra**: Tetragon's CLI tool for streaming process, file, and network events from a running Tetragon agent, used for real-time debugging and ad-hoc observation.

**TracingPolicy**: Tetragon custom resource that defines which kernel events to observe (exec, file access, network connect) and optional enforcement actions, written in YAML with match criteria for binaries, namespaces, and process ancestry.

**Macro (Falco)** — Reusable rule fragment in Falco that abstracts common condition patterns, allowing rules to share and compose complex detection logic.

**List (Falco)** — Named collection of values in Falco rules that can be referenced across macros and rules for maintainable, ordered pattern matching.

**Vault Agent auto-auth** — Vault Agent sidecar feature that automatically authenticates with a trusted identity source (Kubernetes service account, AWS IAM, etc.) and renews tokens without manual intervention.

**Automation Framework (ZAP)** — ZAP's structured, scriptable scanning workflow engine that defines contexts, users, and scan sequences for repeatable DAST pipelines in CI environments.

**Idempotency**: A property of configuration management operations where running the same operation multiple times produces the same result as running it once — subsequent runs only make changes if the current state differs from the desired state.

**Desired state**: The target configuration declared in a configuration management tool (e.g., "nginx 1.24 on port 80"). The tool converges the actual system toward this state.

**Drift (configuration management)**: When a system's actual configuration differs from the desired state defined in code, often caused by manual changes or failed automation runs.

**Push model (configuration management)**: A central server pushes configuration to target nodes on demand, typically via SSH (e.g., Ansible).

**Pull model (configuration management)**: Nodes fetch their configuration from a central source on a schedule, typically using an agent (e.g., Puppet, Chef).

**SLI (Service Level Indicator)**: A specific metric that measures an aspect of service quality, such as the proportion of requests completed under 500ms.

**SLO (Service Level Objective)**: A target value for an SLI, such as "99.9% of requests complete in under 500ms per month."

**SLA (Service Level Agreement)**: A contractual commitment based on SLOs, often with financial penalties for breaches.

**Git hooks**: Scripts that Git runs automatically on events such as pre-commit, pre-push, and commit-msg, used to validate or gate changes before they are committed or pushed.

**Conventional Commits**: A lightweight commit-message convention (`<type>: <description>`, e.g. `feat:`, `fix:`) that makes history readable and machine-parseable for changelogs and release tooling.

**Personal access token (PAT)**: A long-lived credential used for Git over HTTPS or API authentication in place of a password; should be scoped to the minimum required permissions and rotated regularly.

**Private registry**: A container or package registry that is not publicly reachable and requires authentication (tokens, service accounts, or credential helpers). Referenced via a `registries` block in tooling config such as Dependabot, or via a credential helper in CI.

**Module (Terraform)**: A self-contained folder of `.tf` files exposing `variable` and `output` blocks, callable from environment configs by relative path or published version. The unit of reuse that makes infrastructure composable across environments.

**Version constraint (Terraform)**: A semantic-version range (e.g. `~> 2.3`) that pins a module or provider to an acceptable release line. Upgrading to a new minor version requires editing the constraint, making the change visible in a pull-request diff.

**Environment-container pattern (Terraform)**: A thin wrapper configuration that composes versioned service modules into a deployable environment (dev/staging/prod), passing environment-specific values through variables while sharing the same module sources.

**Dependency lock file (`.terraform.lock.hcl`)**: The committed Terraform lockfile that pins exact provider and module versions and checksums, so CI and local runs use the same revisions. Updated deliberately via `terraform init -upgrade`.

**Workspace (Terraform)**: A named state instance within a single configuration, often mapped one-to-one with an environment. `terraform.workspace` exposes the active workspace name for use in locals and resources.

**Backend (Terraform)**: Where Terraform stores state — local or remote (S3, GCS, etc.). Separate backends or workspaces per environment keep a state lock or corruption in one environment from blocking the others.

**Variable precedence (Terraform)**: The order in which variable values win: defaults < `terraform.tfvars` < `*.auto.tfvars` < `-var`/`-var-file` on the command line (and environment variables) — later sources override earlier ones.

**registries block (Dependabot)**: A top-level `registries:` key in `dependabot.yml` (a sibling of `updates:`, not nested inside it) that defines private package and container registries referenced by name from each update entry.

**Registry type (Dependabot)**: The schema-validated `type` value for a Dependabot registry entry (e.g. `npm_registry`, `docker_registry`, `maven_repository`). Values are specific, not free-form — a wrong type is rejected by Dependabot's schema validator.

**replaces-base (Dependabot)**: A flag on a Dependabot registry entry used when a private registry proxies and also hosts the same packages as a public base registry, so updates aren't duplicated against both sources.

## DefectDojo

- **Product** — An application or service tracked in DefectDojo.
- **Engagement** — A time-boxed testing window or sprint within a DefectDojo product.
- **Finding** — A single vulnerability or issue imported from a security scanner into DefectDojo.
- **Test** — The result of importing one scan file into a DefectDojo engagement.
- **Deduplication** — Merging identical findings across scans so one issue doesn't fan out into multiple tickets.

**Quality Gate** — SonarQube's pass/fail conditions for a project (e.g., no new bugs, coverage ≥ 80%). Enforced in CI to block PRs that degrade code quality.

**Quality Profile** — SonarQube's per-language set of activated rules. Default is "Sonar way"; teams can create custom profiles with stricter or looser rules.

**Issue (SonarQube)** — A single bug, vulnerability, or code smell detected during analysis. Examples include "Remove this unused parameter" or "Potential SQL injection".

**Hotspot (SonarQube)** — Security-sensitive code requiring human review, such as `eval()` usage or direct SQL string concatenation.

**Technical Debt (SonarQube)** — Estimated remediation time for all maintainability issues in a project, expressed in days or hours.

**Workflow (GitHub Actions)** — A YAML file (`.github/workflows/*.yml`) defining automation that triggers on events like `push`, `pull_request`, or `schedule`.

**Job (GitHub Actions)** — A group of steps that share a runner. A workflow can have multiple jobs (e.g., lint, test, deploy).

**Runner (GitHub Actions)** — The VM or container executing jobs. Can be `ubuntu-latest` (GitHub-hosted) or a self-hosted machine.

**Event (GitHub Actions)** — The workflow trigger. Examples: `push` to main, `pull_request` opened, `schedule` at midnight.

**Action (GitHub Actions)** — Reusable unit from the GitHub Marketplace, like `actions/checkout@v4`.

**Chart (Helm)** — A packaged collection of Kubernetes manifest templates, metadata, and default values. Example: `bitnami/nginx`.

**Release (Helm)** — A running instance of a chart in a cluster with a specific name and configuration. Example: `helm install my-nginx bitnami/nginx`.

**Cluster (Kubernetes)** — A set of machines (nodes) controlled by Kubernetes, combining a control plane with worker nodes.

**Pod (Kubernetes)** — The smallest deployable unit, usually wrapping one container. Example: a single Pod running the `nginx` container.

**Deployment (Kubernetes)** — Manages a set of identical Pods, ensuring the desired count is running and performing rolling updates.

**Service (Kubernetes)** — A stable network endpoint that load-balances traffic to a set of Pods. Example: a ClusterIP Service.

**Namespace (Kubernetes)** — A virtual partition inside a cluster for isolation and resource grouping. Example: `default` or `kube-system`.

**Base (Kustomize)** — The directory with core Kubernetes manifests and a `kustomization.yaml` listing them. The source of truth for common config.

**Overlay (Kustomize)** — A directory with its own `kustomization.yaml` that references bases and adds patches, name prefixes, or namespace changes for a specific environment.

**Patch (Kustomize)** — A partial YAML file (strategic merge or JSON patch) that overrides specific fields in a base resource without rewriting the whole manifest.

**Provider (OpenTofu/Terraform)** — Plugin that talks to a cloud API. Example: `hashicorp/aws`.

**Resource (OpenTofu/Terraform)** — A managed cloud object defined in configuration. Example: `aws_s3_bucket.data`.

**Plan (OpenTofu/Terraform)** — Diff showing what changes OpenTofu will make. Example: `tofu plan`.

**Init (Terraform)** — The `terraform init` command that downloads provider plugins and sets up the working directory before other Terraform commands can run.

**SonarQube** — Static analysis platform inspecting code for bugs, code smells, and security issues with Quality Gates enforced in CI.

**OpenTofu** — Open-source infrastructure-as-code tool forked from Terraform, using the same HCL syntax under an MPL 2.0 license.

**GitHub Actions** — GitHub's built-in CI/CD system using YAML workflow files to automate builds, tests, and deployments.

**Workflow (general)** — A repeatable sequence of automated steps in a CI/CD pipeline.

**Grafana** — Open-source dashboard and visualization layer for time-series metrics, connecting to data sources like Prometheus, Loki, and Elasticsearch.

**Prometheus** — Open-source time-series database and monitoring system that scrapes metrics from HTTP endpoints and exposes a PromQL query API.

**Metric** — A numerical value measured over time, identified by a metric name and key-value labels (e.g., `http_requests_total{status="200"}`).

**Loki** — Grafana Labs' log aggregation system inspired by Prometheus, using a similar label-based indexing approach for log data.

**Repository (repo)** — A folder that Git is tracking, including the full change history.

**Commit** — A snapshot of the project at a point in time, saved with a message explaining why.

**Stage (Git)** — The act of adding changes from the working directory to the staging area (index) with `git add`, preparing them for the next commit. Only staged changes are included in `git commit`.

**Branch** — A parallel version of the code for isolated development.

**Merge** — Combining changes from one branch into another.

**Pull request (PR)** — A proposal to merge changes from one branch into another, usually with code review.

**Diff** — The difference between two versions of a file, showing added and removed lines.

**Remote** — A copy of a Git repository hosted on another server (GitHub, GitLab, etc.).

**Clone / Fork** — Clone: download a remote repo locally. Fork: create a copy of someone else's repo under your own account.

**Kernel** — The core of an operating system that manages hardware resources and system calls.

**Distribution (distro)** — A packaged version of the Linux kernel plus utilities and package manager (e.g., Ubuntu, Alpine).

**Shell** — The command-line interpreter that reads input and executes programs (e.g., Bash).

**Pipeline (`|`)** — A shell mechanism to pass the output of one command as input to another.

**Redirection (`>`, `>>`, `<`)** — Sending command output to a file or reading input from a file.

**Exit code** — A numeric value a process returns on completion (0 = success, non-zero = failure).

**Shebang (`#!/bin/bash`)** — The `#!` sequence at the top of a script that tells the system which interpreter to use.

**Variable** — A named container for data in a shell script.

**Process** — A running instance of a program.

**Command substitution** — Replacing a command's output inline in a script using backticks or `$(...)`. Example: `tar czf backup-$(date +%F).tar.gz /data` embeds today's date in the archive name at run time.

**Globbing** — The shell's wildcard expansion of patterns like `*.txt` into matching filenames before a command runs. Differs from regex: `*` matches any sequence, not a repeat-count quantifier.

**Quoting (single vs double)** — Single quotes (`'$HOME'`) preserve literal text; double quotes (`"$HOME"`) allow variable expansion and command substitution. Mixing them up is a common first-script footgun.

**Declarative configuration** — You describe the desired end state, and the tool figures out how to get there.

**Imperative configuration** — You specify exact steps to achieve the desired state.

**Immutable infrastructure** — Infrastructure that is replaced rather than modified.

**Mutable infrastructure** — Infrastructure that is updated in place (e.g., patching a running server).

**Provisioning** — The act of creating and configuring infrastructure resources.

**State file** — A file tracking the current state of provisioned infrastructure so the IaC tool knows what exists and needs to change.

**Authentication** — Proving who you are (e.g., presenting a username and password).

**Authorization** — Determining what an authenticated identity is allowed to do.

**Principal** — An identity that can request access to a resource (user, service account, IAM role).

**Bearer token** — A credential that grants access to whoever possesses it.

**Least privilege** — The principle of granting only the minimum permissions necessary.

**Rotation** — Regularly changing a secret to reduce the window of exposure if compromised.

**Service account** — An identity assigned to a non-human process or application.

**SLSA (Supply-chain Levels for Software Artifacts)** — A security framework that grades build pipeline trustworthiness (Level 1–4).

**Provenance** — Metadata about who or what produced an artifact and how.

**Signing** — Cryptographically proving that an artifact came from a specific source.

**Dependency confusion** — An attack where a malicious package with the same name as a private package is published to a public registry.

**Typosquatting** — Publishing a package with a name that looks like a popular one to trick users.

**Registry** — A server storing and serving packages or container images.

**Attestation** — A signed statement about something in the supply chain.

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