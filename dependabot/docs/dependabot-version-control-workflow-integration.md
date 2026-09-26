---
last_verified: 2026-09-26
tool_version: n/a
---

# Dependabot integration with version control workflows

## Purpose

Dependabot's output is a pull request. That single fact drives most of the decisions in this guide: the configuration is not just a list of ecosystems to watch, it is a statement about how update work enters the repository, who is asked to review it, and what has to pass before it lands. This document covers the version-control side of that integration — branch targeting, pull-request queue shape, grouping, review routing, and the checks an update must clear — for repositories that want dependency updates to arrive as ordinary reviewable work rather than as out-of-band noise.

The configuration keys referenced here are the ones demonstrated in [`../configs/dependabot-configuration-template.yaml`](../configs/dependabot-configuration-template.yaml), which remains the authoritative layout for this repository. This document does not restate the full schema; it covers how the pieces interact once updates are turned on.

## When to use

Use this guidance when:

- A repository is adopting Dependabot and the first open pull requests need to be shaped deliberately rather than by default
- Update volume is high enough that a single-package-per-pull-request model produces an unreviewable queue
- The repository has release branches, and updates must land on the right branch rather than only on the default one
- Required status checks and branch protection exist, and it must be decided whether dependency updates are exempt from human approval
- Multiple ecosystems share one repository, and the review load from each should land on a different team

## Prerequisites

- Dependabot version updates enabled for the repository
- A dependency manifest per ecosystem, in a location that the configuration can name
- A pull request CI workflow that runs on Dependabot branches and reports a status check
- Branch protection rules on the branches that update pull requests target
- An agreed owner for the dependency queue, whether that is a person or a team

## Steps

### 1. Align directory layout with the repository, not with the ecosystem

Each update entry names one ecosystem and the directory holding its manifest. A repository with a single manifest needs a single entry; a monorepo needs one entry per manifest location. Getting this wrong is the most common cause of a repository that appears to be configured correctly and then produces no updates at all, because the configured directory resolves to nothing.

Where a monorepo resolves a lockfile from one place while keeping manifests per package, the same entry can list several locations instead of one. See [`../configs/monorepo-ecosystem-schedules-reviewers.yaml`](../configs/monorepo-ecosystem-schedules-reviewers.yaml) for a layout where several ecosystems and several directories are declared together.

### 2. Set the schedule to the release cadence, not to the noise level

`schedule.interval` is the only required field in an update entry; `day`, `time`, and `timezone` narrow the window without changing how often checks run. Choose the interval that matches how the team wants to consume updates, not the interval that produces the most pull requests.

`cooldown` separates the two concerns. A default number of days holds all updates, while a larger value for major version bumps keeps the disruptive upgrades out of the normal review queue until they have been available to absorb. This is the mechanism for keeping the routine queue small without ignoring majors.

### 3. Bound the pull request queue

`open-pull-requests-limit` caps how many update pull requests an entry may have open at once. Without a limit, a large manifest with many stale dependencies produces a burst that is hard to work through as a queue: reviewers stall, merges land out of order, and the backlog itself becomes the reason updates stop being reviewed.

A limit also interacts with the schedule. If the cap is consistently saturated, the interval is producing more work than the team drains, and the fix is a longer interval, a coarser grouping, or both.

### 4. Group updates by reviewability, not by convenience

`groups` collapses multiple updates into one pull request per group. A group is a review decision, so its membership should match how the team reviews. Linting and formatting tools that ship together and are validated by the same check are a good group. Runtime libraries that interact with each other are a good group. Everything else is not.

The trade-off is blast radius: a grouped pull request mixes the changelog of every package it covers, so a reviewer who cannot separate the packages cannot judge the risk. Keep groups small, and use `exclude-patterns` to pull a package back out when it needs independent review — for example a security-relevant plugin that should never ride along with a formatting update.

Where the ecosystem carries no semantic versioning, semver-based update types do not apply and grouping should key on package name alone. Base image tags in the `docker` ecosystem are the common case.

### 5. Route the queue

`labels`, `reviewers`, `assignees`, and `milestone` decide who is asked to look and where the pull request lands in project tracking. These are per-entry keys, so the routing follows the ecosystem. A repository that declares the `docker` and `terraform` entries in one file can route container updates and infrastructure-as-code updates to different teams without splitting the configuration.

Assigning an owner matters more than labelling. A labelled pull request with nobody watching it ages quietly, and an aged dependency pull request is one that gets closed rather than reviewed.

### 6. Decide what an update must clear before it lands

An update pull request is an ordinary branch, so the same rules apply as to any other: it must satisfy branch protection and its required status checks must pass. Two decisions are specific to dependency updates.

First, the CI workflow has to be fast enough to keep the exposure window short. A dependency update that opens a pull request and then waits a long time for a full test suite is leaving a known-old version in the tree for the duration of that wait. A dedicated fast path for dependency branches — install, unit tests, and the checks that specifically validate the changed manifest — buys more than a faster general pipeline.

Second, decide explicitly whether dependency updates are exempt from human approval. If they are, the exemption has to be conditional on the checks, not unconditional. Where a security update raises the version across a minor or major boundary, the update carries more risk than a patch and should return to manual review. The workflow for that decision is in [`dependabot-security-update-auto-merge.md`](dependabot-security-update-auto-merge.md).

### 7. Pin the branch behaviour

`target-branch` sets where the pull request is opened, which is what makes update pull requests usable on a repository with release branches: an update intended for a maintenance branch opens there, and one intended for the default branch opens there. A single configuration file can target different branches per ecosystem, so a service whose patch line diverges from the mainline does not need a separate configuration file.

`pull-request-branch-name.separator` and `commit-message.prefix` control how the branch and commit appear in history. These are worth setting once and leaving alone; inconsistent naming across ecosystems is what makes an update trail hard to search later.

## Verify

After changing the configuration, confirm each of the following before assuming the integration is working:

- An update pull request opens against the branch named by `target-branch`, not only the default branch
- The number of simultaneously open update pull requests respects `open-pull-requests-limit` for each entry
- A grouped update produces one pull request covering the intended packages, and an excluded package opens separately
- Each update pull request carries its entry's labels and reaches the assigned reviewer
- The required status checks report on the update branch, and the pull request merges under the branch protection rules in force
- A dependency pinned by `ignore` produces no pull request, and a package still inside the ignored version range stays ignored

## Common errors

**Configuration is valid but no updates arrive.** Usually the `directory` does not match where the manifest actually lives, or the manifest is in a location the entry does not name. Confirm the path resolves before looking at anything else.

**The queue is permanently saturated.** The interval and the pull request limit are set independently, and a low limit with a frequent schedule guarantees a backlog. Raise the interval or group more aggressively before raising the limit.

**Major upgrades never get reviewed.** If majors are held by a long cooldown, they accumulate outside the visible queue. Review the cooldown periodically; a bump held for a long time is one nobody is tracking.

**Grouped pull requests get approved unread.** Large groups are cheap to approve and expensive to verify. Treat group size as a review-quality problem, not a scheduling one.

**Updates land on the wrong branch.** Without `target-branch`, updates follow the repository default. On a repository with release branches, confirm where each update entry is aimed.

**Auto-merge applies more broadly than intended.** An exemption written for security updates can quietly absorb routine version updates too. Verify the exemption is conditioned on the update type and the version boundary, not just on the branch.

## References

- [`../configs/dependabot-configuration-template.yaml`](../configs/dependabot-configuration-template.yaml) — full annotated layout for the configuration keys used in this document
- [`dependabot-security-update-auto-merge.md`](dependabot-security-update-auto-merge.md) — conditioning auto-merge on version boundary for security updates
- [`../notes/0000-primer-dependabot.md`](../notes/0000-primer-dependabot.md) — introductory orientation to Dependabot
