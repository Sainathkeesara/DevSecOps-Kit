---
last_verified: 2026-10-18
tool_version: n/a
sources:
  - https://oneuptime.com/blog/post/2026-02-21-how-to-use-ansible-with-monorepo-structure/view
---

# Combining Configuration Management with Infrastructure as Code

## Purpose

Configuration management (CM) and infrastructure as code (IaC) solve adjacent but distinct problems. IaC provisions the infrastructure — networks, VMs, clusters, load balancers — while CM brings the provisioned systems into a known, consistent state: packages, users, services, and application configuration. Combining them means a host is not considered "ready" just because it exists; it is ready because IaC created it and CM configured it, with both steps described in code and reviewed together.

## When to use this pattern

Use CM + IaC integration when:
- You provision hosts or clusters with an IaC tool (Terraform, OpenTofu, CloudFormation, or similar) and need them configured before they serve traffic.
- You want the same change to provision infrastructure and apply configuration in a single reviewable unit.
- You need drift detection that spans both layers: a host created by IaC and then altered outside CM should surface as drift, not as a silent configuration gap.
- You manage multiple environments (dev, staging, prod) and want the same provision-then-configure sequence promoted through each.

## Prerequisites

- An IaC tool installed and configured with a backend for state storage.
- A CM tool (for example Ansible) that can reach the provisioned hosts over SSH or an equivalent transport.
- A way to hand provisioned hosts from IaC to CM — typically an inventory file generated from IaC outputs (IPs, hostnames, tags).
- Credentials (SSH keys, cloud tokens) available to both the IaC run and the CM run.

## Steps

1. **Provision with IaC.** Define the infrastructure (VMs, subnets, security groups) in IaC and run `apply`. Capture the resulting host addresses and identifiers as outputs.
2. **Generate the CM inventory.** Convert IaC outputs into an inventory file the CM tool can consume, grouping hosts by role or environment. In monorepo setups this inventory is generated alongside the deployment playbooks so the two stay aligned [source: https://oneuptime.com/blog/post/2026-02-21-how-to-use-ansible-with-monorepo-structure/view].
3. **Run CM against the inventory.** Apply playbooks that install packages, write configuration files, start services, and register the host with any service discovery or monitoring.
4. **Verify convergence.** Run the CM playbook a second time and confirm it reports no changes (idempotency), meaning the actual state matches the desired state.
5. **Chain the two in CI.** Run IaC `plan` as a required check, then `apply` only after review, then the CM run against the newly provisioned inventory. Do not run CM before IaC reports success — a half-provisioned host is not a valid configuration target.

## Verify

- The IaC run outputs the host addresses used by the CM inventory, with no hardcoded IPs.
- `ansible-playbook` (or equivalent) runs against the generated inventory and reaches every host.
- A second CM run reports zero changed resources (idempotent).
- A manual change to a CM-managed file on a provisioned host is detected as drift on the next run.
- Destroying and recreating the infrastructure with IaC results in the same CM-applied state after the next provision-configure cycle.

## Common errors

- **Running CM before IaC finishes.** The CM run targets hosts that do not yet exist or are not reachable, producing cryptic connection failures that look like CM bugs.
- **Inventory drift.** The inventory file goes stale after an IaC scale event, so CM targets old or missing hosts and reports "unreachable" instead of configuring the new fleet.
- **Credential mismatch.** The IaC run creates hosts with one SSH key but the CM run attempts to connect with another; verify the same key material (or cloud OS login) is configured on both sides.
- **Configuration applied to the wrong environment.** Using a dev inventory against staging or prod hosts applies environment-specific settings to the wrong targets; gate inventory selection on the target environment explicitly.

## References

- `docs/concepts/configuration-management/0000-primer-configuration-management.md` — CM foundations: idempotency, desired state, drift, push/pull models.
- `docs/concepts/configuration-management/combining-configuration-management-with-ci-cd-pipeline-concepts.md` — CM + CI/CD integration patterns (plan-as-check, lint, drift detection, promotion gates).
- `https://oneuptime.com/blog/post/2026-02-21-how-to-use-ansible-with-monorepo-structure/view` — Ansible + Terraform integration: provisioning with Terraform, configuring with Ansible, sharing data through generated inventory files [source].
