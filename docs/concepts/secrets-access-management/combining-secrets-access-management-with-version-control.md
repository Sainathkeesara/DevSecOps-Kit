---
last_verified: 2026-09-04
tool_version: n/a
sources:
  - https://lucaberton.com/blog/secrets-management-vault-vs-external-secrets/
  - https://khimananda.com/blog/external-secrets-operator-with-vault
  - https://oneuptime.com/blog/post/2026-02-09-external-secrets-operator-hashicorp-vault/view
  - https://developer.hashicorp.com/vault/docs/updates/release-notes
---

# Combining Secrets & Access Management with Version Control with Git

## Purpose

Secrets and version control exist in tension: Git is designed for full transparency and branching, while secrets must stay opaque and never enter the repository history. This doc covers the patterns that let a team use Git as the control plane for infrastructure and application delivery without ever committing a credential to the repo.

## When to use this pattern

Use a secrets + VCS integration when:
- Infrastructure-as-code (Terraform, Ansible, Helm) is stored in Git.
- Multiple environments need different credentials that rotate on a schedule.
- A team needs an audit trail linking each credential change to a specific commit and reviewer.
- Compliance frameworks require proof that secrets never resided in source control.

## Prerequisites

- A secret store (HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager, or similar) in place.
- CI platform capable of injecting secrets at runtime (GitHub Actions secrets, GitLab CI variables).
- A pre-commit or CI secret-scanning tool (gitleaks, trufflehog, git-secrets) installed on developer machines and in the pipeline.
- Branch protection rules that require PR review before merge.

## Key terminology

- **Secret store** — the system that holds credentials at rest. Vault provides dynamic secrets with TTL; cloud KMS stores static key material. The store never pushes secrets into Git; consumers fetch them at runtime.
- **Layered model** — a composition where cloud KMS encrypts data at rest, Vault or ESO manages rotation and access policies, and Kubernetes Secrets (or equivalent) deliver credentials to workloads. No single layer is optional for regulated environments.
- **GitOps secret reference** — a manifest in Git that references a secret by name or External Secrets Operator (ESO) selector, but never contains the secret value itself. The ESO controller fetches the real value from Vault and writes it to a Kubernetes Secret at runtime.
- **Pre-commit scanning** — running a secret-detection tool against the local working tree before a commit is created. Tools like gitleaks compare staged files against known secret patterns and entropy thresholds, blocking the commit if a match is found.
- **Dynamic secrets** — credentials generated on demand by Vault rather than stored long-term. Vault issues PostgreSQL credentials with a configurable TTL (default 1 hour, max 24 hours); the credential expires automatically without manual rotation.
- **Refresh interval** — the cadence at which ESO re-syncs secrets from the source store to the cluster. Values between 1 hour and 15 minutes are common; shorter intervals reduce the window after rotation but increase API load on the secret store.

## Integration patterns

### Pattern 1 — GitOps with External Secrets Operator

Store only the ESO `ExternalSecret` manifest in Git. This manifest selects which secret to fetch from Vault and where to write it in the cluster. The actual credential value never touches the repository.

Typical sequence:
1. Define a Vault KV v2 path and a Kubernetes auth role bound to the application's ServiceAccount.
2. Write an `ExternalSecret` YAML that references the Vault path and target Kubernetes Secret name.
3. Commit the `ExternalSecret` to Git; the ESO controller reconciles it and populates the Kubernetes Secret.
4. The application reads the Kubernetes Secret via environment variable or volume mount.

Vault's Kubernetes auth method uses the ServiceAccount JWT as proof of identity, so no long-lived token is stored in the cluster. This is the pattern ESO's documentation and the Vault community identify as the standard for 2026 deployments.

### Pattern 2 — Pre-commit secret scanning in the developer workflow

Install gitleaks or git-secrets as a pre-commit hook. The hook scans staged files against a database of known secret regex patterns and high-entropy strings. If a match is found, the commit is blocked and the developer must remove the secret before proceeding.

The hook catches accidental commits early, before the secret reaches the remote repository. If a secret does reach the remote, the remediation steps are: rotate the credential immediately in Vault, purge the commit from Git history with `git filter-repo`, and force-push the cleaned branch. The rotation step is non-negotiable; removing a secret from Git history does not invalidate it.

### Pattern 3 — CI pipeline secret injection for infrastructure tools

CI pipelines that run Terraform, Ansible, or Helm need cloud provider credentials. Rather than storing those credentials in the repo, inject them at runtime from the CI platform's secret store.

For Terraform, AWS credentials are typically injected as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. The pipeline references these variables but never echoes them to logs. A common misstep is to export credentials in a step that writes to stdout — CI platforms mask secrets in logs, but only if the variable is passed correctly through the platform's secret-injection mechanism, not via a shell export that the platform cannot intercept.

For Ansible, Vault passwords or cloud credentials are injected similarly. The inventory file in Git references variables (`{{ vault_db_password }}`) that are resolved at runtime from the CI environment, never from a checked-in `vars.yml`.

### Pattern 4 — Vault dynamic secrets with Kubernetes workloads

Vault's database secrets engine generates ephemeral PostgreSQL, MySQL, or MongoDB credentials with a TTL. The application never sees a static password. When the TTL expires, Vault revokes the credential automatically.

ESO can be configured to use Vault's Dynamic Secret generator, which tells ESO to request a fresh credential from Vault on each sync rather than reading a static value. The generated credential is written to the Kubernetes Secret, and the application reloads when the Secret changes (either via a mounted file update or a sidecar signal).

The TTL tradeoff is straightforward: shorter TTLs reduce the blast radius of a compromised credential but increase Vault API traffic. A 1-hour TTL is the common production default for database credentials; shorter-lived tokens (5–15 minutes) work when the application supports graceful reload without restart.

## Verify

After setting up the integration:
- Confirm that `gitleaks detect` (or equivalent) returns clean on a PR that intentionally contains a fake API key in a test file — the hook should block it.
- Verify that the Kubernetes Secret populated by ESO contains the expected keys and that the value does not match anything stored in Git.
- Rotate a Vault dynamic secret manually and confirm that ESO refreshes the Kubernetes Secret within the configured `refreshInterval`.
- Check Vault audit logs to confirm that each secret access maps to a specific ServiceAccount and namespace.

## Common errors

- **Committing `.env` files or `secrets.yaml` to Git.** The most common first mistake. Even if the file is later deleted, the secret persists in Git history. Rotate the credential and purge the history; do not rely on deletion alone.
- **Missing `system:auth-delegator` ClusterRoleBinding for Vault Kubernetes auth.** Without this binding, Vault cannot validate ServiceAccount JWTs and authentication fails silently. This is the most frequently reported first-deploy error.
- **Setting `refreshInterval` too low.** A 30-second interval for hundreds of services creates unnecessary load on Vault. Start with 1 hour, tune down only if the application requires near-real-time rotation.
- **Using static Vault tokens in CI.** Static tokens do not expire and cannot be scoped per-pipeline. Use Vault's Kubernetes auth role with a short TTL for CI runners instead.
