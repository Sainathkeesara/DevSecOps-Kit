---
last_verified: 2026-08-21
tool_version: n/a
sources: []
---

# GitGuardian incident response workflow — alert triage to remediation

## Purpose

This doc walks through a structured incident response workflow for secrets detected by GitGuardian. The goal is to move from raw alert to verified remediation without leaving loose ends — no half-rotated keys, no incidents that silently age out, no secrets that get "fixed" by deleting the commit but never revoked.

## When to use this approach

This pattern works when:
- GitGuardian detects secrets in CI scans, pre-commit hooks, or scheduled full-repo scans
- The team needs a repeatable process instead of ad-hoc "oh no, someone pushed a key"
- Findings span multiple repositories or teams and need consistent triage
- You want to track remediation status and ensure nothing falls through the cracks

## Prerequisites

- `ggshield` installed and authenticated, or GitGuardian dashboard access with appropriate permissions
- A webhook or notification channel (Slack, email, PagerDuty) receiving GitGuardian alerts
- Access to rotate the affected credential (cloud provider console, secret manager, etc.)
- A shared tracking system (issue tracker, spreadsheet, or GitGuardian's built-in incident tracking)

## Steps

### 1. Receive and classify the alert

Every GitGuardian alert arrives with context: the file path, commit SHA, author, and the type of secret detected. The first triage decision is whether this is a true positive or a false positive.

**True positive:** A real credential exists in the code. Rotate immediately.

**False positive:** A test key, a documentation example, or a pattern that looks like a secret but isn't. Allowlist it and close the incident.

**Investigating:** Not sure yet. Assign to someone with context on the code and set a time-bound window (24 hours is reasonable).

The classification drives everything downstream — a true positive that's a live API key with write access needs a different response time than a revoked test key.

### 2. Assess severity and blast radius

Not all secrets are equal. A read-only database password in a private repo is lower risk than a production Stripe key pushed to a public repo. Key factors:

- **Repository visibility:** Public repos expose secrets to the entire internet. Private repos limit exposure but don't eliminate it (forks, CI logs, backup systems).
- **Credential scope:** Does the secret grant read access, write access, or admin access? Does it have network restrictions?
- **Time exposed:** How long has the secret been in the code? Git blame can answer this — if it's been there for 6 months, assume it's compromised.
- **Downstream exposure:** Check if CI logs, artifact registries, or deployment systems captured the secret.

### 3. Contain the immediate risk

Before investigating root cause, stop the bleeding:

1. **Revoke the credential** at the source (cloud provider, SaaS dashboard, etc.)
2. **Check for unauthorized use** — pull access logs for the affected service. Most providers retain these for 30+ days.
3. **If the repo is public**, consider that the secret may have been scraped by bots that monitor public repos. Revocation is the only real containment.
4. **Notify affected teams** — if the secret grants access to shared infrastructure, the blast radius may extend beyond the repo owner.

### 4. Investigate and remediate

With the immediate risk contained, figure out how the secret got there and clean it up properly:

- **Remove the secret from code** — use `git filter-branch` or BFG Repo-Cleaner for history, not just a new commit that "removes" it (the old commit still has it).
- **Check for copies** — the same secret may appear in other files, other repos, or in configuration files that aren't scanned by default.
- **Rotate any related credentials** — if the leaked key was derived from or paired with other secrets, rotate those too.
- **Update access controls** — if the secret had more permissions than needed, tighten the scope while you're rotating it.

### 5. Document and close

For each incident, record:
- What was detected and where
- Whether it was a true or false positive
- What rotation/remediation was performed
- Whether unauthorized access was detected
- What preventive measure was added (pre-commit hook, CI gate, allowlist entry)

This becomes the audit trail. If an auditor asks "how do you handle secret leaks?" six months from now, this is your evidence.

### 6. Prevent recurrence

The incident response workflow is reactive. The goal is to make it less necessary over time:

- Enforce pre-commit scanning so secrets never reach the remote
- Add CI gates that block PRs containing secrets
- Use a secrets manager (Vault, cloud-native) instead of hardcoded values
- Rotate credentials on a schedule regardless of incidents
- Review and prune allowlists periodically — entries accumulate and some become stale

## Verify

1. **Check that the revoked credential actually stops working** — test the old key after rotation. If it still works, the rotation didn't take.
2. **Confirm the secret is removed from git history** — clone the repo fresh and grep for the pattern. If it's still there, the history rewrite didn't work or was applied to the wrong branch.
3. **Verify the incident is closed in the tracking system** — no "open" incidents older than your SLA without a documented exception.
4. **Run a follow-up scan** — re-scan the affected repo to confirm no remaining instances of the secret.

## Common errors

- **Fixing the code but not rotating the credential:** Deleting a secret from a commit does nothing if the credential is still active. An attacker who scraped the public commit already has the key.
- **Rotating the credential but not cleaning the code:** The secret is still in git history. Anyone with repo access can find it. Both steps are required.
- **Closing the incident before verifying the fix:** Marking an incident "resolved" before confirming the old credential is revoked and the code is clean creates a false sense of security.
- **Not checking for copies:** The same API key may appear in `.env` files, Docker Compose files, Kubernetes manifests, or other repos. A single-file fix may miss half the exposure.
- **Ignoring the time window:** If a secret was exposed for months, the rotation is necessary but insufficient — you also need to check for unauthorized access during the exposure window.

## References

- Existing GitGuardian incident response pipeline script in this repo: `gitguardian/scripts/gg-incident-response-pipeline.sh`
- GitGuardian monorepo CI configuration: `gitguardian/docs/monorepo-ci-per-team-exclusions.md`
