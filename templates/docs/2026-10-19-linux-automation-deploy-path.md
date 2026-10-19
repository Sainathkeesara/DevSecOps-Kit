---
last_verified: 2026-10-19
tool_version: n/a
---

# Reconciling the linux-automation README's deploy.sh path

I noticed the README section 8 said "Create `scripts/deploy.sh`" and the rollback snippet ran `./scripts/deploy.sh <env>`, but the template actually ships `deploy.sh` at the template root with no `scripts/` sub-folder. Following the README verbatim would leave a reader with a second copy of the deploy script in the wrong place and a rollback command that does not match the shipped file.

I changed both references to point at `./deploy.sh` so the documented path matches what ships:

- Section 8 heading: `Create `scripts/deploy.sh`` → `Create `deploy.sh``
- Rollback snippet: `./scripts/deploy.sh <env>` → `./deploy.sh <env>`

The shipped `deploy.sh` stays where it is; the README now agrees with the tree.
