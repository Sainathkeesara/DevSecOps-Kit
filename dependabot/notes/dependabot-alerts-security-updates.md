# Enabling Dependabot alerts and security updates — what tripped me up

I turned on both Dependabot alerts and version updates in a sample npm repo and watched the dashboard fill in over a few days. Here is what I did and where I got stuck.

## Alerts

I went to the repo Settings → Code security and analysis and clicked Enable for "Dependabot alerts". That was it — no YAML file needed for alerts alone. Within a couple of scans the Alerts tab showed a high-severity lodash vulnerability in my devDependencies.

I clicked through to the alert page and saw the advisory number, affected version, and the fixed version. From there I could either open a Dependabot PR or dismiss the alert. Dismissing requires a reason (won't fix, false positive, etc.) — I tried to just close the dropdown and the UI wouldn't let me, so I picked one.

## Security updates

Security updates are separate from version updates. I flipped that toggle next to alerts in the same settings page. Within an hour Dependabot opened a PR bumping the affected package. The PR title was auto-generated and the commit message referenced the GitHub Advisory ID.

## What tripped me up

1. **Alerts vs. updates are two separate toggles** — I assumed enabling alerts would also auto-open fix PRs. They don't; you have to enable Security updates separately.

2. **I had no `.dependabot.yml` and everything still worked** — At first I thought alerts needed a config file. They don't — the dashboard toggle is enough. Version updates DO need one, which confused me when I went looking for alerts in the PR run log.

3. **Private repos need the repo's visibility set** — Alerts are not available on private repos for free GitHub accounts. I tried in a private test repo and the toggle was greyed out. Moved to a public one and it lit up.

4. **Dismissed alerts are hard to re-open** — Once I dismissed a low-priority alert to clean the board, I could not undo the dismissal from the UI. I had to use the REST API to reopen it.
