---
last_verified: 2026-09-19
tool_version: n/a
---

# Falco custom rules library scaffold

## Purpose

A starting layout for keeping team-owned Falco detection rules in version control:
one directory for the rule library, one for local overrides, and a test harness
that validates every rule file before it is shipped to the Falco deployment.

## When to use

Use this scaffold when the default Falco ruleset is too noisy or too generic
and the team needs its own detections (for example: package tools launched
inside a running container, or reads of sensitive host files from a
container). Keep vendor-supplied rules untouched and put every customization
in `rules/` or `examples/` so an upstream ruleset refresh never overwrites
local work.

## Prerequisites

- A Falco deployment that loads additional rule files alongside the default
  ruleset (drop-in `-o rule_files` entries or the equivalent config option).
- `python3` with the `yaml` module available for the offline checks.
- Optionally, the `falco` binary on the test machine for the
  `--validate` pass.

## Steps

1. Copy this directory into the repository that owns runtime detections.
2. Add or edit rules in `rules/custom-rules.yaml`. Reuse the shared
   `macro` and `list` blocks instead of repeating conditions inline.
3. Put host- or cluster-specific tuning in a copy of
   `examples/override-example.yaml`, not by editing the library file.
4. Run the test harness before every commit:

   ```console
   ./tests/test-rules.sh
   ```

5. Ship the files the harness accepted: load `rules/custom-rules.yaml`
   (plus any override file) after the default ruleset so local rules take
   precedence.

## Verify

- `./tests/test-rules.sh` exits `0` and reports each rule file as valid.
- Rule names are unique across all loaded files (the harness fails on
  duplicates, which would shadow each other at load time).
- After deploying, trigger one benign test event and confirm the expected
  alert appears in the Falco output with the rule name attached.

## Common errors

- **Duplicate rule names across files.** Falco loads the first definition it
  sees; the harness rejects duplicates so a stale copy cannot silently win.
- **Overriding by editing the library file.** Local edits to
  `rules/custom-rules.yaml` get lost when the library is refreshed from its
  source; keep environment tweaks in a separate override file.
- **Overly broad conditions.** A rule without a container or process scope
  fires on every host event and buries real alerts; scope each rule with the
  narrowest `macro` that still matches the threat.

## References

- Rule library: [rules/custom-rules.yaml](rules/custom-rules.yaml)
- Test harness: [tests/test-rules.sh](tests/test-rules.sh)
- Override pattern: [examples/override-example.yaml](examples/override-example.yaml)
