---
last_verified: 2026-09-26
tool_version: n/a
---

# Integrating Terrascan with infrastructure as code pipelines

> Reference for wiring Terrascan into a CI pipeline as a gated stage: what to scan, where the policies live, how results become artifacts, and how the failure decision is made.

## Purpose

Running `terrascan scan` by hand is a local convenience. A pipeline integration has to answer four questions the local run never asks: **when** the scan runs, **what** is scanned, **which policies** are in force, and **how a finding becomes a build failure**. Each of those is a decision, not a default — and each one is where pipeline integrations tend to be quietly wrong.

The failure mode to design against is the silent pass: a scan that runs, finds problems, and still reports success because nothing was configured to translate findings into an exit status. Everything below exists to close that gap.

## When to use

Use this pattern when an IaC repository needs a scan that is:

- **Required on pull requests** — the branch policy is that unscanned IaC cannot merge.
- **Repeatable** — the same rules, the same threshold, on every run and on every engineer's machine.
- **Auditable** — the raw result is retained as a build artifact, not just printed to a log that scrolls away.

Do not use a single severity gate as the only signal on an established codebase. See the gradual-adoption section under Common errors.

## Prerequisites

- `terrascan` on `PATH` for the pipeline runner.
- `jq` for result parsing — the gate logic below is a `jq` program, not a log-line grep.
- A version-controlled policy directory (for example `.terrascan-policies/`) holding the custom Rego policies, in the same repository as the IaC they govern.
- A deterministic working directory for the scan, so `-d` resolves the same way on a developer laptop and on the runner.

## Steps

### 1. Decide the scan unit

| Mode | Command shape | Catches | Misses |
|---|---|---|---|
| Raw configuration | `terrascan scan -d <dir>` | Misconfiguration in files as written, including resources no module references | Values that only appear after variable and module resolution |
| Plan output | Point Terrascan at a generated Terraform plan | What will actually be created after resolution | Resources the plan does not include |

The two are complementary, not alternatives. Plan-based scanning is the higher-fidelity signal; the raw directory scan is the broader one. The trip-up recorded in the [plan-scanning notes](../notes/2026-07-10-terrascan-getting-started-trip-ups.md) is the concrete case: a resource that no module referenced never appeared in the plan, so plan-only coverage would have missed it.

### 2. Load custom policies explicitly

Built-in rules cover the common cloud misconfigurations. Organizational guardrails are expressed as custom Rego policies — see the [example S3 rule](../configs/tried-custom-s3-rule.yaml) for the `apiVersion: v1, kind: policy` shape, and the [primer](../notes/0000-primer-terrascan.md) for the model.

Load them with `--config-path <policy-dir>`, or pin the target and policy path in a [scan configuration file](../templates/scanning-pipeline-scaffold/config.yaml):

```bash
terrascan scan -d ./infra --config-path ./.terrascan-policies -o json > results.json
```

An explicit `--config-path` is preferable to relying on a default location — it makes the policy set visible in the pipeline log, which is the question you want answered when a scan result is disputed.

### 3. Emit JSON as the artifact

Add `-o json` and write the result to a file, keeping stderr as a separate log. The JSON is what the gate reads and what gets uploaded for later inspection; stdout-formatted findings are not machine-consumable.

### 4. Translate findings into a build failure

Do not depend on Terrascan's own exit status to gate the build. The [tutorial notes](../notes/2026-06-29-terrascan-getting-started-trip-ups.md) record that a scan uses `0` for clean and `3` for violations-only, and — more importantly — that the `--severity` flag filters the output without changing the exit code, so a thresholded gate cannot be expressed through it. The [CI scan script](../scripts/tried-terrascan-ci-scan.sh) pairs the scan with an explicit `--exit-code` for the same reason. Parse the JSON and fail the step directly, as in the [policy-as-code workflow script](../scripts/policy-as-code-workflow.sh):

```bash
FAIL_ON="high"
fail_count=$(jq --arg failon "$FAIL_ON" '
  def rank(s): {"critical":0,"high":1,"medium":2,"low":3}[(s|ascii_downcase)] // 9;
  [ (.results.violations // [])[] | select(rank(.severity) <= rank($failon)) ] | length
' results.json)
[ "$fail_count" -eq 0 ] || exit 1
```

Two properties matter here. The rank map makes the threshold a *level* rather than an exact string match, so a finding is blocked whether it is exactly at the threshold or above it. And the `// []` guard means a result document with no `violations` key yields a count of zero rather than a `jq` error that could itself mask a real failure.

### 5. Wire the stage into CI

The complete stage, including path filters, the read/write permission split, artifact upload, and the severity gate, is in the [multi-IaC workflow manifest](../manifests/terrascan-gha-ci-multi-iac.yaml). Three choices in it are worth copying deliberately:

- **Upload results with `if: always()`** — the artifact set is most useful on the run that failed.
- **Filter paths to IaC and policy files** — a scan stage that triggers on every commit is a stage people learn to ignore.
- **Set the threshold as a workflow environment variable** — tightening the gate is then a pull request against a visible value, not a code edit buried in a script.

### 6. Add a local fast path

The same invocation works in a pre-commit hook or a `make scan` target, so an engineer sees a finding before pushing rather than after. Reuse the wrapper rather than retyping the command — a divergent local invocation is how policy coverage quietly starts to differ between machines and CI.

## Verify

Run the stage against known-misconfigured IaC — the [deliberately insecure snippet](../snippets/insecure-terraform.tf) is the fixture for exactly this — and confirm three things independently:

1. The JSON result contains violations.
2. The gate exits non-zero at a low threshold (`--fail-on low`).
3. The same scan passes when the threshold is raised above the highest severity present.

If (3) does not hold, the gate is not reading the severity it claims to read.

## Common errors

- **Build passes with findings present.** No severity translation in the pipeline, or reliance on the scanner's own exit status. Diagnose by checking the exit code of the scan command in isolation.
- **`no IaC files found` in a containerized runner.** The mounted path does not match the scan target. Keep the mount and `-d` argument identical.
- **Custom policies appear to be ignored.** The policy directory was not passed, or was passed relative to a different working directory. Log the resolved path at the start of the stage.
- **`jq: error` on the results file.** The result document is not valid JSON — usually a scan error written to stdout instead of a result written to stdout. Keep stderr on its own stream.
- **A plan-based stage misses a resource.** Expected: the plan omits unreferenced resources. Pair it with a raw directory scan.
- **The gate is too noisy on an existing codebase.** Tighten incrementally rather than switching the gate off: start by reporting without failing, then enable failure for the highest severity and widen from there.

## References

- [Terrascan quick primer](../notes/0000-primer-terrascan.md) — concepts and first-run commands.
- [Terrascan vs Checkov for Terraform scanning](./terrascan-vs-checkov-terraform-iac-scanning.md) — where each scanner fits in the same pipeline.
- [Scanning pipeline scaffold](../templates/scanning-pipeline-scaffold/README.md) — a reporting-only baseline to copy.
- [Multi-IaC CI workflow manifest](../manifests/terrascan-gha-ci-multi-iac.yaml) — the full gated stage.
