# Dependabot on my first repo — getting a version-bump PR

Created a throwaway npm repo today and turned on Dependabot to see version-bump PRs in action.

## What I did

1. Created `.github/dependabot.yml` with npm as the ecosystem, root directory, and weekly schedule.
2. Pushed to the repo and opened Settings → Code security and analysis to confirm the Dependabot toggles were on.
3. Waited about 25 minutes and a PR showed up: `Bump lodash from 4.17.21 to 4.17.21`. The version number had not actually changed, which confused me at first — Dependabot opened the PR because the manifest was stale, even if the resolved version is the same.

## What tripped me up

- **Wrong directory path.** I wrote `directory: "root"` instead of `directory: "/"`. Dependabot silently scanned nothing for 25 minutes. The PR showed up only after I fixed it.
- **PR number limits.** I set `open-pull-requests-limit: 5` and had an existing open PR. Dependabot only opened two new PRs instead of five. The limit is a ceiling, not a target.
- **Ecosystem mismatch.** I tried `dotnet` in a Python repo. Dependabot opened zero PRs. Switching to `pip` fixed it.

## What I'd try next

I want to dig into `allow` / `ignore` blocks to block major-version bumps. I also want to compare daily vs weekly schedules on a busier repo.
