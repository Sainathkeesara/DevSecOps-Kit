# Checkov pre-commit hook with version pinning

## Purpose

Running `checkov -d .` manually is easy to forget. Wiring it into pre-commit runs Checkov automatically on every commit, catching misconfigurations before they land in the repo. Version pinning ensures the hook uses a known Checkov release — no surprise failures when a new version changes default behavior.

## Prerequisites

- Python 3.8+ with `pip`
- A Git repository with Terraform, Kubernetes, or other IaC files Checkov can scan

## Steps

### 1. Install pre-commit

```bash
pip install pre-commit
```

Verify the install:

```bash
pre-commit --version
```

### 2. Create `.pre-commit-config.yaml`

Place this in the root of the repository:

```yaml
repos:
  - repo: https://github.com/bridgecrewio/checkov
    rev: 3.2.246
    hooks:
      - id: checkov
        args:
          - --soft-fail
          - --compact
```

`rev` pins a specific Checkov release. `--soft-fail` makes the hook warn instead of blocking the commit — useful when you're still tuning the rule set. Remove it once you want hard failures.

Other useful args:
- `--compact` — shorter output lines
- `--skip-check CKV_123` — skip a noisy rule
- `--framework terraform` — limit to one framework

### 3. Install the hook

```bash
pre-commit install
```

This writes the hook script into `.git/hooks/pre-commit`.

### 4. Validate by scanning all files

```bash
pre-commit run --all-files
```

The first run downloads the Checkov image (the hook runs via Docker), so expect a short delay.

## Verify it works

1. Run `pre-commit run --all-files` — Checkov should scan the repo and exit 0 (or warn with `--soft-fail`).
2. Introduce a known bad config (e.g. a Terraform resource with `security_group-rule-ssh-allowed`):

```hcl
resource "aws_security_group_rule" "bad" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

3. Stage and commit (or run `pre-commit run --all-files` again). Checkov should flag the rule.

## Common issues

- **Hook not running** — `pre-commit install` wasn't run, or the hook script path is wrong. Re-run `pre-commit install`.
- **Docker not available** — Checkov's pre-commit hook runs via Docker by default. If Docker isn't installed, the hook fails. The docs also suggest a `pip`-based hook, but this approach keeps the pinned version isolated.
- **`rev` tag not found** — The version tag must exist in the bridgecrewio/checkov repo. Check the [releases page](https://github.com/bridgecrewio/checkov/releases) before pinning.

## Notes

- Version pinning trades a bit of convenience (you have to manually bump `rev`) for predictability — no unexpected rule changes mid-sprint. This seems worth it for team repos.
- `--soft-fail` is handy during setup. Once the team is used to the hook, dropping it makes the hook a hard gate.
