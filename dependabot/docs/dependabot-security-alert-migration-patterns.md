---
last_verified: 2026-09-26
tool_version: n/a
---

# Dependabot security alert migration patterns

## Purpose

This guide documents common patterns for migrating Dependabot security alert configurations across repositories, organizations, and management tiers. It covers transitions from legacy alerting systems, configuration consolidation, and scaling alert management from individual repositories to enterprise-wide policies.

## When to use

Use these patterns when:
- Consolidating security alert configurations across multiple repositories
- Migrating from a legacy vulnerability scanning tool to native Dependabot alerts
- Standardizing alert settings (severity thresholds, notification routing, auto-dismiss rules) across an organization
- Moving from repository-level configuration to organization-level security policies
- Onboarding new repositories into an established security alert baseline

## Prerequisites

- Admin or security manager access to the target repositories or organization
- Dependabot alerts enabled on source repositories (for configuration reference)
- Organization-level security policies configured (if migrating to organization-wide settings)
- CI/CD pipeline access for validating alert behavior after migration

## Migration patterns

### Pattern 1: Repository-to-organization policy promotion

Promote a proven repository-level alert configuration to an organization-wide security policy.

**Steps**

1. Identify a reference repository with a mature Dependabot alert configuration (severity filters, notification settings, auto-dismiss rules)
2. Export the effective configuration: document enabled alert types, severity thresholds, notification channels, and any custom auto-dismiss patterns
3. In organization settings, navigate to **Code security and analysis** → **Dependabot alerts**
4. Configure organization-wide defaults matching the reference repository:
   - Enable alerts for all repositories (or selected repository types)
   - Set default severity threshold (e.g., "High" and "Critical" only)
   - Configure default notification recipients (security team, repository admins)
   - Define organization-level auto-dismiss rules for known false positives
5. Apply the policy to target repositories using the "Inherit from organization" option
6. Validate inheritance by checking the **Dependabot alerts** tab on several repositories — they should show organization-level settings as the source

**Verify**

- New repositories created in the organization automatically inherit the alert configuration
- Existing opted-in repositories reflect organization defaults without manual override
- Alert notifications route to the configured organization-level recipients

**Common errors**

- **Repository-level overrides persist**: Repositories with explicit alert settings do not inherit organization changes. Use the API or UI to reset repository settings to "Inherit from organization."
- **Private repository restrictions**: Free-tier private repositories may not support organization-level alert inheritance. Verify plan eligibility before migration.
- **Notification channel mismatch**: Organization-level notification settings (e.g., Slack, email) must be configured separately from repository-level webhooks.

### Pattern 2: Legacy scanner to Dependabot alert migration

Replace a third-party vulnerability scanner (e.g., Snyk, WhiteSource, custom scanning jobs) with native Dependabot alerts.

**Steps**

1. Inventory current scanner coverage: list repositories, ecosystems scanned, severity thresholds, and notification destinations
2. Enable Dependabot alerts on all target repositories (bulk via API or organization settings)
3. Map scanner severity levels to Dependabot severity tiers (Critical, High, Medium, Low)
4. Configure Dependabot severity threshold to match or exceed the scanner's alerting threshold
5. Recreate notification routing: configure Dependabot alert webhooks or GitHub notifications to match existing destinations
6. Run both systems in parallel for one vulnerability disclosure cycle (typically 7–14 days)
7. Compare alert coverage: verify Dependabot surfaces the same CVEs at the same or higher severity
8. Decommission the legacy scanner once parity is confirmed

**Verify**

- Dependabot alerts appear for known vulnerabilities in the test repositories
- Notification delivery matches the previous scanner's channels and format
- No critical vulnerabilities were missed during the parallel run
- False positive rate is comparable or lower

**Common errors**

- **Ecosystem gaps**: Dependabot supports a fixed set of package ecosystems. Legacy scanners may cover additional ecosystems (e.g., Go modules before Dependabot support, proprietary registries). Plan supplementary scanning for unsupported ecosystems.
- **Advisory timing differences**: Dependabot relies on GitHub Advisory Database publication timing. Some scanners ingest NVD or vendor feeds directly, potentially surfacing alerts hours earlier.
- **Transitive dependency depth**: Configure the scanner and Dependabot to the same transitive analysis depth to ensure comparable coverage.

### Pattern 3: Configuration-as-code migration with `dependabot.yml`

Migrate from UI-configured alerts to a version-controlled `dependabot.yml` that defines both version updates and security update behavior.

**Steps**

1. Document current UI-configured settings per repository: enabled ecosystems, schedules, open PR limits, security update enablement
2. Create a standardized `dependabot.yml` template covering:
   - All required package ecosystems with appropriate directories
   - Schedule intervals aligned with organizational policy (e.g., daily for security, weekly for version updates)
   - `open-pull-requests-limit` to prevent PR flood
   - `groups` configuration to batch related updates
   - `commit-message` and `labels` for consistent PR metadata
3. For security-specific behavior, ensure `allow`/`ignore` rules cover:
   - Auto-merge eligibility for patch security updates
   - Exclusion of major-version security updates requiring manual review
   - Ecosystem-specific versioning constraints
4. Deploy the template to target repositories via PR automation or repository template
5. Disable UI-configured schedules (the YAML file takes precedence)
6. Validate that security update PRs are generated with the expected grouping, labeling, and commit message format

**Verify**

- Dependabot creates security update PRs matching the `dependabot.yml` schedule and grouping rules
- PR metadata (labels, commit messages, branch names) conforms to the template
- Open PR count respects the configured limit
- Version update PRs and security update PRs are distinguishable via labels

**Common errors**

- **Directory misconfiguration**: Incorrect `directory` paths cause silent failures — Dependabot logs "no dependency files found" without raising an error. Validate paths against actual manifest locations.
- **Schedule conflicts**: Security updates follow the ecosystem's schedule block. If version updates and security updates share an ecosystem block, they run on the same schedule. Use separate blocks if different cadences are needed.
- **Grouping side effects**: Aggressive `groups` settings can bundle security updates with breaking version changes, delaying critical fixes. Keep security-relevant dependencies in separate groups or use `allow`/`ignore` to isolate patch-level updates.

### Pattern 4: Multi-organization alert synchronization

Synchronize alert configurations across multiple GitHub organizations (e.g., separate orgs for business units, environments, or compliance boundaries).

**Steps**

1. Designate a source organization with the canonical alert configuration
2. Export the source organization's security policy via API:
   - Alert enablement status
   - Default severity threshold
   - Notification targets
   - Auto-dismiss rules
3. For each target organization, apply the configuration using the GitHub REST API or GraphQL mutations:
   - `PATCH /orgs/{org}/dependabot/alerts` for enablement and defaults
   - `PUT /orgs/{org}/dependabot/secrets` for shared secrets used in private registry access
4. Implement a reconciliation job (scheduled workflow) that:
   - Fetches source organization configuration
   - Compares against each target organization
   - Applies deltas or raises drift alerts
5. Establish a change management process: all alert configuration changes go through the source organization first

**Verify**

- All target organizations reflect the source organization's alert settings
- Drift detection alerts fire when manual changes occur in target organizations
- New repositories in any organization inherit the synchronized defaults

**Common errors**

- **API permission scope**: The token used for synchronization requires `admin:org` scope on all organizations. Fine-grained PATs with organization administration permissions are recommended.
- **Rate limiting**: Bulk configuration across many organizations can hit API rate limits. Implement exponential backoff and batch operations.
- **Enterprise policy conflicts**: GitHub Enterprise Cloud security policies may override organization settings. Verify enterprise-level policies do not conflict with the synchronized configuration.

## Cross-pattern considerations

### Secrets and private registry access

When migrating alert configurations that depend on private registry credentials:

- Store registry credentials as Dependabot secrets at the organization or repository level
- Ensure the migrating configuration references the correct secret names
- Validate that Dependabot can authenticate to private registries in the target environment before completing migration

### Notification deduplication

During parallel-run migrations (Pattern 2), configure notification deduplication to avoid alert fatigue:

- Route Dependabot and legacy scanner alerts to the same channel with distinct prefixes
- Implement a correlation rule that suppresses duplicate CVEs within a configurable window
- Gradually shift routing weight from legacy to Dependabot as confidence increases

### Compliance evidence

For audit-bound migrations, preserve evidence of the migration process:

- Export pre-migration configuration snapshots (API responses, UI screenshots)
- Record the parallel-run comparison results
- Document the cutover decision and approval
- Retain post-migration validation reports

## Verify (general)

After any migration pattern:

1. Trigger a test vulnerability (e.g., add a known-vulnerable dependency to a test repository)
2. Confirm Dependabot alert fires within the expected SLA
3. Verify notification delivery to all configured channels
4. Confirm auto-dismiss rules apply correctly (if configured)
5. Validate that security update PRs are generated (if security updates are enabled)
6. Review the alert dashboard for completeness — no repositories should show "Dependabot alerts not configured"

## Common errors (general)

- **Assuming UI and API parity**: Some organization-level settings are only configurable via API. Verify API coverage for every setting in the migration plan.
- **Ignoring repository archival state**: Archived repositories retain their last alert state but do not receive new alerts. Decide whether to include archived repositories in migration scope.
- **Overlooking GitHub App permissions**: If the organization uses GitHub Apps for security tooling, ensure the app has `dependabot_alerts:read` and `dependabot_alerts:write` permissions for the migration automation.

## References

- GitHub Docs: "Configuring Dependabot alerts" — organization and repository configuration
- GitHub Docs: "Dependabot configuration file reference" — `dependabot.yml` schema for security update behavior
- GitHub REST API: "Dependabot alerts" endpoints for programmatic configuration management
- GitHub Advisory Database: Source of vulnerability data for Dependabot alerts