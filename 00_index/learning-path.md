# Learning path — devsecops

Work through the stages in order. Each lesson says what it expects you to know already, ends with an exercise you can check, and links to the next lesson.

## Stage 1: Foundations

1. [Linux and shell fundamentals](../docs/concepts/linux-shell-fundamentals/0000-primer-linux-shell-fundamentals.md)
2. [Navigate and script on Linux](../learn/01-foundations/02-shell-scripting.md) · needs: Linux and shell fundamentals
3. [Version control with Git — concepts](../docs/concepts/version-control-with-git/0000-primer-version-control-with-git.md)
4. [Branch, merge and rebase safely](../learn/01-foundations/04-git-branch-merge-rebase.md) · needs: Version control with Git — concepts, Navigate and script on Linux
5. [Read an HTTP exchange and a certificate](../learn/01-foundations/05-http-and-tls.md) · needs: Navigate and script on Linux
6. YAML, JSON, jq and regex for security tooling — *not written yet* · needs: Navigate and script on Linux
7. Set up the lab and the sample app — *not written yet* · needs: Branch, merge and rebase safely
8. First win: find a secret and a vulnerable package — *not written yet* · needs: Set up the lab and the sample app, YAML, JSON, jq and regex for security tooling

## Stage 2: Build and ship

1. [Containers and orchestration — concepts](../docs/concepts/containers-orchestration/0000-primer-containers-orchestration.md)
2. [Docker — quick primer](../docker/notes/0000-primer-docker.md)
3. Build the sample app image — *not written yet* · needs: Docker — quick primer, Containers and orchestration — concepts, Set up the lab and the sample app
4. [CI/CD pipeline concepts](../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md)
5. [GitHub Actions — quick primer](../github-actions/notes/0000-primer-github-actions.md)
6. CI for the sample app — build, test and push — *not written yet* · needs: GitHub Actions — quick primer, CI/CD pipeline concepts, Build the sample app image

## Stage 3: Shift-left security in the pipeline

1. [Application security testing — SAST, DAST, SCA and secrets](../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md)
2. [Secrets and access management — concepts](../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md)
3. Catch secrets before they land with Gitleaks — *not written yet* · needs: Application security testing — SAST, DAST, SCA and secrets, Secrets and access management — concepts, CI for the sample app — build, test and push
4. Search the whole history and verify secrets with TruffleHog — *not written yet* · needs: Catch secrets before they land with Gitleaks
5. Find the SQL injection with Semgrep — *not written yet* · needs: Application security testing — SAST, DAST, SCA and secrets, CI for the sample app — build, test and push
6. Follow tainted data with CodeQL — *not written yet* · needs: Find the SQL injection with Semgrep
7. [Software supply chain security — concepts](../docs/concepts/software-supply-chain-security/0000-primer-software-supply-chain-security.md)
8. Keep dependencies patched with Dependabot — *not written yet* · needs: Software supply chain security — concepts, CI for the sample app — build, test and push
9. Gate the image on Trivy findings in CI — *not written yet* · needs: First win: find a secret and a vulnerable package, CI for the sample app — build, test and push
10. Produce and read an SBOM with Syft — *not written yet* · needs: Software supply chain security — concepts, Gate the image on Trivy findings in CI
11. Scan the SBOM with Grype and compare with Trivy — *not written yet* · needs: Produce and read an SBOM with Syft
12. Sign the image and attach the SBOM with Cosign — *not written yet* · needs: Produce and read an SBOM with Syft
13. Scan the running app with ZAP — *not written yet* · needs: Application security testing — SAST, DAST, SCA and secrets, Build the sample app image, Read an HTTP exchange and a certificate
14. Bring all findings together in DefectDojo — *not written yet* · needs: Catch secrets before they land with Gitleaks, Find the SQL injection with Semgrep, Gate the image on Trivy findings in CI, Scan the running app with ZAP

## Stage 4: Infrastructure as code and its security

1. [Infrastructure as code — concepts](../docs/concepts/infrastructure-as-code/0000-primer-infrastructure-as-code.md)
2. [Terraform — quick primer](../terraform/notes/0000-primer-terraform.md)
3. Plan, apply and destroy with remote state — *not written yet* · needs: Terraform — quick primer, Infrastructure as code — concepts, YAML, JSON, jq and regex for security tooling
4. Promote a change from dev to prod — *not written yet* · needs: Plan, apply and destroy with remote state, CI for the sample app — build, test and push
5. Block the public bucket with Checkov — *not written yet* · needs: Plan, apply and destroy with remote state, CI for the sample app — build, test and push
6. Scan IaC with Trivy config — *not written yet* · needs: Block the public bucket with Checkov, Gate the image on Trivy findings in CI
7. [Configuration management — concepts](../docs/concepts/configuration-management/0000-primer-configuration-management.md)
8. Harden a host with an idempotent Ansible playbook — *not written yet* · needs: Configuration management — concepts, Navigate and script on Linux, YAML, JSON, jq and regex for security tooling

## Stage 5: Kubernetes and GitOps

1. [Kubernetes — quick primer](../kubernetes/notes/0000-primer-kubernetes.md)
2. Deploy and debug the sample app on kind — *not written yet* · needs: Kubernetes — quick primer, Build the sample app image
3. Environment overlays with Kustomize — *not written yet* · needs: Deploy and debug the sample app on kind
4. [Helm — quick primer](../helm/notes/0000-primer-helm.md)
5. Package the sample app as a Helm chart — *not written yet* · needs: Helm — quick primer, Environment overlays with Kustomize
6. [Argo CD — quick primer](../argocd/notes/0000-primer-argocd.md)
7. Deploy per environment from Git with Argo CD — *not written yet* · needs: Argo CD — quick primer, Package the sample app as a Helm chart, Promote a change from dev to prod

## Stage 6: Policy, secrets and runtime

1. Rego basics and testing policies — *not written yet* · needs: Deploy and debug the sample app on kind, YAML, JSON, jq and regex for security tooling
2. Reject privileged and root pods with Gatekeeper — *not written yet* · needs: Rego basics and testing policies, Deploy per environment from Git with Argo CD
3. [HashiCorp Vault — quick primer](../vault/notes/0000-primer-vault.md)
4. Deliver the app's secrets from Vault — *not written yet* · needs: HashiCorp Vault — quick primer, Secrets and access management — concepts, Deploy and debug the sample app on kind
5. Admit only signed images — *not written yet* · needs: Sign the image and attach the SBOM with Cosign, Reject privileged and root pods with Gatekeeper
6. [Container and runtime security — concepts](../docs/concepts/container-runtime-security/0000-primer-container-runtime-security.md)
7. Detect a shell in a container with Falco — *not written yet* · needs: Container and runtime security — concepts, Deploy and debug the sample app on kind

## Stage 7: Observe, respond and capstone

1. [Observability and monitoring — concepts](../docs/concepts/observability-monitoring/0000-primer-observability-monitoring.md)
2. [Prometheus — quick primer](../prometheus/notes/0000-primer-prometheus.md)
3. Alert on the app and on security events — *not written yet* · needs: Prometheus — quick primer, Observability and monitoring — concepts, Detect a shell in a container with Falco
4. A security and SLO dashboard in Grafana — *not written yet* · needs: Alert on the app and on security events
5. Respond to a vulnerable-dependency incident — *not written yet* · needs: A security and SLO dashboard in Grafana, Bring all findings together in DefectDojo
6. Capstone: a secure delivery pipeline — *not written yet* · needs: Respond to a vulnerable-dependency incident, Admit only signed images, Deliver the app's secrets from Vault, Harden a host with an idempotent Ansible playbook, Follow tainted data with CodeQL, Scan the SBOM with Grype and compare with Trivy

## Stage 8: Optional tools

1. Secret detection with GitGuardian — *not written yet* · needs: Search the whole history and verify secrets with TruffleHog
2. Code quality and security with SonarQube — *not written yet* · needs: Follow tainted data with CodeQL
3. Dependency and container scanning with Snyk — *not written yet* · needs: Keep dependencies patched with Dependabot, Gate the image on Trivy findings in CI
4. Template-based scanning with Nuclei — *not written yet* · needs: Scan the running app with ZAP
5. IaC scanning with Terrascan — *not written yet* · needs: Block the public bucket with Checkov
6. Run the Terraform code with OpenTofu — *not written yet* · needs: Plan, apply and destroy with remote state
7. Runtime enforcement with Tetragon — *not written yet* · needs: Detect a shell in a container with Falco

## Reference shelf

Background material per tool, for looking things up after the lesson.

| Tool | Folder |
|---|---|
| Linux & Shell Fundamentals | [docs/concepts/linux-shell-fundamentals/](../docs/concepts/linux-shell-fundamentals/) |
| Version Control with Git | [docs/concepts/version-control-with-git/](../docs/concepts/version-control-with-git/) |
| Containers & Orchestration | [docs/concepts/containers-orchestration/](../docs/concepts/containers-orchestration/) |
| CI/CD Pipeline Concepts | [docs/concepts/ci-cd-pipeline-concepts/](../docs/concepts/ci-cd-pipeline-concepts/) |
| Application Security Testing Concepts | [docs/concepts/application-security-testing-concepts/](../docs/concepts/application-security-testing-concepts/) |
| Software Supply Chain Security | [docs/concepts/software-supply-chain-security/](../docs/concepts/software-supply-chain-security/) |
| Infrastructure as Code | [docs/concepts/infrastructure-as-code/](../docs/concepts/infrastructure-as-code/) |
| Configuration Management | [docs/concepts/configuration-management/](../docs/concepts/configuration-management/) |
| Secrets & Access Management | [docs/concepts/secrets-access-management/](../docs/concepts/secrets-access-management/) |
| Container & Runtime Security | [docs/concepts/container-runtime-security/](../docs/concepts/container-runtime-security/) |
| Observability & Monitoring | [docs/concepts/observability-monitoring/](../docs/concepts/observability-monitoring/) |
| Linux | [linux/](../linux/) |
| Git | [git/](../git/) |
| Docker | [docker/](../docker/) |
| GitHub Actions | [github-actions/](../github-actions/) |
| Gitleaks | [gitleaks/](../gitleaks/) |
| TruffleHog | [trufflehog/](../trufflehog/) |
| GitGuardian | [gitguardian/](../gitguardian/) |
| Semgrep | [semgrep/](../semgrep/) |
| CodeQL | [codeql/](../codeql/) |
| SonarQube | [sonarqube/](../sonarqube/) |
| Dependabot | [dependabot/](../dependabot/) |
| Snyk | [snyk/](../snyk/) |
| Trivy | [trivy/](../trivy/) |
| Syft | [syft/](../syft/) |
| Grype | [grype/](../grype/) |
| Cosign | [cosign/](../cosign/) |
| OWASP ZAP | [zap/](../zap/) |
| Nuclei | [nuclei/](../nuclei/) |
| DefectDojo | [defectdojo/](../defectdojo/) |
| Terraform | [terraform/](../terraform/) |
| OpenTofu | [opentofu/](../opentofu/) |
| Checkov | [checkov/](../checkov/) |
| Terrascan | [terrascan/](../terrascan/) |
| tfsec | [tfsec/](../tfsec/) |
| Ansible | [ansible/](../ansible/) |
| Kubernetes | [kubernetes/](../kubernetes/) |
| Kustomize | [kustomize/](../kustomize/) |
| Helm | [helm/](../helm/) |
| Argo CD | [argocd/](../argocd/) |
| OPA / Gatekeeper | [opa/](../opa/) |
| HashiCorp Vault | [vault/](../vault/) |
| Falco | [falco/](../falco/) |
| Tetragon | [tetragon/](../tetragon/) |
| Prometheus | [prometheus/](../prometheus/) |
| Grafana | [grafana/](../grafana/) |
