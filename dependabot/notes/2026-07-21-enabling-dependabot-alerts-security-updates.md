---
last_verified: 2026-07-21
tool_version: n/a
---

# Enabling Dependabot alerts and security updates — what I learned

I turned on Dependabot alerts for a public npm sample repo today. Here is what happened and where I got confused.

## What I did

Went to the repo Settings → Code security and analysis and flipped the Dependabot alerts toggle on. Then I also checked "Dependabot security updates" since I wanted auto-fix PRs, not just a dashboard warning.

Within 15 minutes the Alerts tab showed a `minimist` finding with a "Create Dependabot security update" button. I clicked it and got a PR bumping the version.

## What tripped me up

- **Alerts and security updates are two toggles.** I thought alerts included auto-fix, but they are separate. Security updates create PRs; alerts light up the dashboard.
- **Public repo only.** The toggle was grayed out on a private free-tier repo. Moved to a public one and it worked.
- **No config file needed for alerts.** I kept looking for a `.github/dependabot.yml`, but alerts-only mode does not need one.
- **Advisory pages need login.** Clicking a CVE linked to GitHub's advisory page behind login. I copied the ID and searched elsewhere.
- **Dismissing is permanent.** I dismissed a low-severity alert and could not undo it from the dashboard. Had to use the API.

## What I'd try next

I want to try this on a private paid-plan repo. Also curious whether both alerts and version-bump updates create duplicate PRs.
