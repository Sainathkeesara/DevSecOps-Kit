---
last_verified: 2026-11-04
tool_version: n/a
sources: []
---
# Keep dependencies patched with Dependabot

Dependabot watches your repository's dependencies and opens pull requests when new versions are available — including security fixes. This lesson continues from the supply-chain concepts primer and the CI workflow for the sample app, and turns on automated dependency updates so a planted vulnerable dependency gets bumped without anyone remembering to check.

## What you'll learn

- Configure Dependabot for the app's ecosystems and the workflow actions
- Merge an update that fixes the planted vulnerable dependency

## Before you start

- [Software supply chain security — concepts](../../docs/concepts/software-supply-chain-security/0000-primer-software-supply-chain-security.md) — you know why dependency updates matter
- [CI for the sample app — build, test and push](../02-build-and-ship/06-gha-sample-app-ci.md) — you have a green CI workflow gating merges
- Confirm `gh` is available: `gh --version`
- A reference configuration is checked in at [`../../dependabot/configs/dependabot-configuration-template.yaml`](../../dependabot/configs/dependabot-configuration-template.yaml)

## Walkthrough

1. Create the Dependabot configuration file at `.github/dependabot.yml`.

   Dependabot reads one file that lists every ecosystem and directory it should watch. At minimum each entry needs `package-ecosystem`, `directory`, and a `schedule.interval`. Add one entry for the app's manifest and one for the GitHub Actions workflows.

   ```yaml
   version: 2
   updates:
     - package-ecosystem: "pip"
       directory: "/"
       schedule:
         interval: "weekly"
       open-pull-requests-limit: 5
       labels:
         - "dependencies"
         - "python"
     - package-ecosystem: "github-actions"
       directory: "/.github/workflows"
       schedule:
         interval: "weekly"
       open-pull-requests-limit: 3
       labels:
         - "dependencies"
         - "ci"
   ```

   You should see a valid `dependabot.yml` with two update entries, one per ecosystem.

2. Commit and push so Dependabot picks it up.

   ```bash
   git add .github/dependabot.yml
   git commit -m "Enable Dependabot for pip and GitHub Actions"
   git push
   ```

   You should see Dependabot open pull requests for any outdated or vulnerable dependencies within the next scheduled run.

3. Review and merge the update that fixes the planted vulnerable dependency.

   Dependabot's pull request includes the changelog and, for security updates, the advisory that triggered it. Read the diff, confirm CI passes, then merge.

   ```bash
   gh pr list --label dependencies
   gh pr view <pr-number>
   gh pr merge <pr-number> --squash
   ```

   You should see the vulnerable dependency bumped to a patched version and CI green on the merge commit.

## Exercise

Add a third entry to `dependabot.yml` for a container image ecosystem (`docker`, `directory: "/"`) with a weekly schedule and a cap of 3 open pull requests. Push it and confirm Dependabot opens an update PR for the base image used by the sample app Dockerfile.

## Check your work

- `.github/dependabot.yml` exists and parses as valid YAML.
- At least one Dependabot pull request is opened for a vulnerable dependency.
- After merging, the dependency is at a patched version and CI is green.

## Common mistakes

- Pointing `directory` at the wrong path, so Dependabot cannot find the manifest and silently does nothing.
- Setting `open-pull-requests-limit` too low in a monorepo, which hides updates behind the cap.
- Merging a grouped update without checking that the new versions are mutually compatible.

## Next

[Gate the image on Trivy findings in CI](../../00_index/learning-path.md)