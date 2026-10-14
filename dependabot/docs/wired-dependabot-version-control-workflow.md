---
last_verified: 2026-10-14
tool_version: n/a
---

# How I wired Dependabot into my version control workflow

## Purpose

My dependency updates kept arriving as surprise pull requests nobody owned, so I wired Dependabot into the normal version control workflow: updates open branches, get routed to a reviewer, and merge under the same branch protection as any other change. This is one way to do it; the configuration template also supports schedules and groupings I did not need yet.

## Steps

### 1. Pointed each update entry at the manifest directory

Each entry names one ecosystem and the directory holding its manifest. I started with one entry for the single manifest in my repo and confirmed the directory actually matched where the manifest lives — a wrong path silently produces no updates at all, which is what happened on my first attempt before I fixed the path. The full annotated layout I worked from is [`../configs/dependabot-configuration-template.yaml`](../configs/dependabot-configuration-template.yaml).

### 2. Picked a schedule I could actually review

`schedule.interval` is the only required field per entry. I set a weekly interval rather than daily, because a daily queue filled faster than I reviewed and the backlog itself became the reason updates stalled. The docs also suggest narrowing with `day` and `time`, which I left at defaults for now.

### 3. Capped the pull request queue

I set `open-pull-requests-limit` so one stale manifest cannot flood the queue. When the cap stays saturated, that is a signal the interval is too frequent or the updates need grouping — raising the limit alone just postpones the review work.

### 4. Routed updates to an owner

I added `labels` and `reviewers` per entry so each update pull request reaches someone instead of aging quietly. A labelled pull request with nobody watching it gets closed rather than reviewed, so assigning an owner mattered more than the label names.

### 5. Let branch protection decide the merge

Update pull requests are ordinary branches, so I left the existing branch protection and required status checks in force rather than exempting dependency branches. Security updates that cross a version boundary go back to manual review; the conditioning for that decision follows [`dependabot-security-update-auto-merge.md`](dependabot-security-update-auto-merge.md).

## Verify

- An update pull request opens against the intended branch, not just the default one
- The number of open update pull requests respects `open-pull-requests-limit`
- Each update pull request carries its entry's labels and reaches the assigned reviewer
- Required status checks report on the update branch and the merge follows branch protection

## References

- [`../configs/dependabot-configuration-template.yaml`](../configs/dependabot-configuration-template.yaml) — annotated layout for the keys used here
- [`dependabot-security-update-auto-merge.md`](dependabot-security-update-auto-merge.md) — conditioning auto-merge on update type
- [`../notes/0000-primer-dependabot.md`](../notes/0000-primer-dependabot.md) — introductory orientation
