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
- [Install Cosign and run a first signing command](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md) — Binary install, keypair generation, and `cosign sign` against a full registry path
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