---
last_verified: 2026-07-10
tool_version: n/a
---

# Enabling Dependabot alerts — what tripped me up

I wanted Dependabot to watch a sample repo for vulnerable dependencies, so I turned on the alerts. Here's what actually happened.

## What I did

First I went into the repo's **Settings → Code security and analysis** and flipped on **Dependabot alerts** and **Dependabot security updates**. That part "just worked" — within a few minutes I saw an alert appear for an old transitive package.

Then I added a `dependabot.yml` at `.github/dependabot.yml` so it would also open version-bump PRs, not only security fixes:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
```

## What tripped me up

- **Nothing happened for a while.** I expected an immediate PR. Turns out the first scheduled run fires on the next interval tick, not instantly. I had to be patient (or trigger a re-scan from the Dependabot tab).
- **Wrong `directory`.** My app lives in `./app`, not repo root, so the first config scanned an empty folder. Pointing `directory: "/app"` fixed it.
- **Security updates need alerts on.** If I'd left Dependabot alerts off, the auto-fix PRs wouldn't have been created. The two settings are independent.
- **Ecosystem name matters.** `npm` vs `pip` vs `github-actions` — a typo means a silent no-op, not an error.

## What I'd try next

I'll add a second `package-ecosystem` block for `github-actions` and a `open-pull-requests-limit` so it doesn't spam me with dozens of PRs at once.
