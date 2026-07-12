---
last_verified: 2026-07-12
tool_version: n/a
sources:
  - https://nhimg.org/faq/what-do-security-teams-get-wrong-about-sast-and-dast-coverage/
  - https://safeweave.dev/blog/sast-vs-dast-complete-guide
  - https://winfunc.com/blog/sast-vs-dast
  - https://corgea.com/learn/application-security-testing-complete-guide
  - https://theethicalhacker.blog/web-application-security-testing/
  - https://guptadeepak.com/research/application-security-101/
---

# Applying Application Security Testing in DevSecOps

I've been learning how to weave security testing into CI/CD pipelines rather than treating it as a separate phase after deployment. Here's what I've found about where each testing approach fits and the mistakes I want to avoid.

## Where each type fits in a pipeline

The key insight is that different testing methods belong at different pipeline stages because they make different trade-offs between speed, depth, and what they can detect.

- **SAST** runs against source code — no build, no deployment needed. I can run it on every commit in a few seconds and block the build if I want. The trade-off is false positives (I've read 30–70% is typical in the industry).
- **SCA** (dependency scanning) fits right next to SAST — also per-commit, also source-level. It checks my lockfile or manifest against known vulnerability databases.
- **DAST** needs a running instance. That means a deployed staging or review environment. It runs slower (minutes, not seconds), so it belongs later in the pipeline — per-deployment or nightly, not per-commit.
- **Secrets scanning** fits everywhere — pre-commit hooks, PRs, and periodic repo sweeps. It catches credentials before they reach git history where removal is harder.

## What I got wrong at first

#### Treating SAST and DAST as interchangeable

I assumed they found the same things, just at different speeds. They don't. SAST finds injection *code patterns* (a function call with unsanitized input). DAST confirms injection *exploitability* (it sends a real payload and sees if the server executes it). A finding from one doesn't invalidate or duplicate the other. Research I read calls this the most common pitfall teams make — losing coverage by treating them as substitutes instead of complementary controls.

#### Relying only on tool output

It took me a while to realize that automated scanners can't catch business-logic flaws — things like "a user can view another user's orders by changing an ID in the URL." Those need manual testing or custom rules. The research I've been reading repeats this: beginners slow their progress depending solely on tool output and ignoring manual testing.

#### Letting findings pile up with no owner

The same SQL injection can appear as a SAST finding, a DAST finding, and a pen-tester note. Without deduplication and ownership, the finding just lives in three places and nobody fixes it. Every alert needs a repo, a team, and a fix path.

## What a minimum viable pipeline looks like

Based on what I've read and tried, the starting point for a serious pipeline is:

1. **SCA in CI** — catch known vulnerable dependencies
2. **SAST in CI** — catch insecure patterns per-commit
3. **Secrets scanning** — pre-commit hooks + PR scans
4. **Mandatory code review** — human eyes catch what tools miss

From there, add DAST/IAST in staging and IaC scanning as the program matures. This covers the bulk of real risk without overwhelming the team with findings.
