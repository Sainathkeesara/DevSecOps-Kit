---
last_verified: 2026-08-30
tool_version: n/a
sources: []
---

# Vault Secrets Engine Selection Guide

## Purpose

HashiCorp Vault exposes multiple secrets engines, each designed for a different class of secret lifecycle. Choosing the wrong engine leads to over-provisioning, stale credentials, or operational burden that doesn't map to the actual workload. This guide compares the three most common engine families — KV (key-value), database, and cloud (AWS/Azure/GCP) — to help select the right one for a given use case.

## When to Use This Guide

- You are standing up a new Vault deployment and need to decide which engines to enable.
- You are migrating an existing secrets workflow (e.g., environment variables, config files) to Vault and need to map it to the closest engine.
- You are reviewing an existing Vault configuration and want to confirm the engine choice is appropriate for the secret type.

## Secrets Engine Families

### KV Secrets Engine (v1 and v2)

**What it stores:** Arbitrary key-value pairs — API tokens, configuration strings, connection info that doesn't have a Vault-managed lifecycle.

**How it works:** Clients read and write static secrets at a path. KV v2 adds versioning, soft-deletion, and check-and-set semantics. The engine never generates or rotates secrets on its own.

**Best for:**

- Application configuration that changes infrequently (feature flags, endpoints).
- Third-party API keys where Vault is the source of truth but not the issuer.
- Legacy secrets that must be stored as opaque blobs.

**Not suitable for:**

- Database credentials that need automatic rotation (use the database engine).
- Cloud IAM credentials with short TTLs (use the cloud-specific engine).
- Any secret where the lifecycle should be managed by Vault.

### Database Secrets Engine

**What it stores:** Credentials for relational databases (PostgreSQL, MySQL, Oracle, MSSQL, MongoDB, Cassandra, and others) and some NoSQL stores.

**How it works:** Vault connects to the database with a set of privileged "connection" and "role" configurations. When a client requests credentials for a role, Vault generates a unique user/password pair with a configurable TTL. On expiration or revocation, Vault drops the user. The privileged account is never exposed to the requesting client.

**Best for:**

- Dynamic database credentials tied to workload identity (Kubernetes SA, IAM role).
- Environments where per-connection credentials must rotate without redeploying the application.
- Compliance scenarios requiring per-request audit trails of who accessed which database.

**Not suitable for:**

- Static connection strings embedded in config files (use KV for the string itself).
- Databases where Vault cannot create/drop users (requires a superuser-level connection).

### Cloud Secrets Engines (AWS, Azure, GCP)

**What it stores:** IAM credentials — AWS STS assume-role tokens, Azure service principal credentials, GCP service account keys.

**How it works:** Vault is configured with privileged cloud credentials (an IAM role, service principal, or service account). When a client requests credentials for a role, Vault assumes the role or creates a service credential with a short TTL, then revokes it on expiry. The client never holds long-lived cloud credentials.

**Best for:**

- CI/CD pipelines that need temporary cloud access (deploy to AWS, push to GCR).
- Cross-account access patterns where static IAM keys are a security liability.
- Workloads that need cloud permissions scoped to a specific job, not the lifetime of an instance.

**Not suitable for:**

- On-premises workloads that don't interact with cloud APIs.
- Scenarios where the cloud provider's native credential rotation (e.g., AWS IAM Roles Anywhere) is preferred.

## Decision Matrix

| Criteria | KV v2 | Database | Cloud (AWS/Azure/GCP) |
|----------|-------|----------|----------------------|
| Secret lifecycle | Static (client-managed) | Dynamic (Vault-managed) | Dynamic (Vault-managed) |
| Rotation | Manual | Automatic (TTL-based) | Automatic (TTL-based) |
| Audit trail | Read/write events | Credential issue/revoke | Credential issue/revoke |
| Prerequisite | None | DB superuser connection | Cloud admin credentials |
| Versioning | Yes (v2 only) | No | No |
| Blast radius | Entire secret path | Single credential | Single role/session |

## Common Multi-Engine Patterns

**Web application stack:** KV for app config + database engine for RDS/PostgreSQL credentials + AWS engine for S3/SES access. The application reads all three at startup; Vault handles rotation for the dynamic engines.

**CI/CD pipeline:** KV for non-sensitive build config (branch names, image tags) + cloud engine for the deploy role (assume-role with S3 + EKS permissions). The pipeline never holds long-lived AWS keys.

**Microservices with shared databases:** Database engine with per-service roles. Each service gets its own credential pair scoped to the tables/schemas it needs. Revoking one service's credential doesn't affect others.

## Operational Considerations

**Lease management:** Dynamic engines (database, cloud) produce leases with TTLs. Applications must handle credential refresh before TTL expiry, or use Vault Agent / Vault K8s injector for sidecar-based renewal.

**Revocation on shutdown:** Dynamic credentials should be revoked when a workload shuts down, not just left to expire. This shortens the window of exposure if a credential is compromised.

**Engine mount points:** Each engine instance has a unique mount path (e.g., `database/postgres-prod`, `aws/ci-deploy`). Naming conventions should reflect the environment and purpose to avoid path collisions.

**Capacity limits:** KV v2 has a per-secret size limit; very large blobs (multi-MB config files) may need to be stored externally with the reference in Vault.

## Verifying Your Choice

1. Enable the candidate engine in a dev namespace: `vault secrets enable -path=dev <engine-type>`.
2. Configure a role that matches your workload's access pattern.
3. Request credentials from a test client and verify the TTL, permissions, and revocation behavior.
4. Confirm the audit log captures the issue and revoke events.
5. Stress-test the lease renewal path if the workload is long-running.

## Common Errors

- **Enabling KV v1 by mistake:** The default for `vault secrets enable kv` is v1, which lacks versioning and soft-delete. Explicitly pass `-version=2` if you need those features.
- **Expired credentials without refresh:** Applications that read dynamic credentials once and never re-read will fail when the TTL expires. Use Vault Agent or implement a refresh loop.
- **Insufficient database privileges:** Vault's database engine requires the connection user to have `CREATE USER` and `DROP USER` (or equivalent) permissions. A read-only connection string will fail at credential generation time.
- **Cloud engine trust misconfiguration:** The AWS/Azure/GCP engine must be configured with a principal that can assume roles or create service credentials. A common error is configuring the engine with an identity that only has read permissions.

## References

- HashiCorp Vault documentation: Secrets Engines overview
- HashiCorp Vault documentation: KV Secrets Engine v2
- HashiCorp Vault documentation: Database Secrets Engine
- HashiCorp Vault documentation: AWS Secrets Engine
- HashiCorp Vault documentation: Azure Secrets Engine
- HashiCorp Vault documentation: GCP Secrets Engine
