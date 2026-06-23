# Enabling Dependabot on my first repo and triggering a version bump PR

I enabled Dependabot on a personal npm repo today and got a version-bump PR within a few hours. Here is what I did and what I noticed.

## Setting it up

I added a `.github/dependabot.yml` file:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 3
    labels:
      - "dependencies"
```

Committed and pushed. GitHub flagged the file as invalid until I noticed I had spelled `directory` as `directoy`. Easy fix.

## Triggering a bump

Dependabot runs on a schedule by default, so after I pushed the config I waited about 20 minutes and saw a PR appear: `Bump axios from 0.27.2 to 0.27.2`. It opened with both `package.json` and `package-lock.json` updated, and the `dependencies` label applied.

## What tripped me up

1. **YAML indentation** — Tabs instead of spaces silently broke the config. GitHub does not always surface the exact reason.
2. **Limited by open PR count** — I had another open PR already, so the first batch only opened two instead of three. The `open-pull-requests-limit` field is a ceiling, not a target.
3. **npm vs nuget** — I accidentally wrote `package-ecosystem: "npm"` for a repo that uses `dotnet`. Dependabot opened zero PRs. I adjusted the ecosystem and re-pushed the config.

## What I'd try next

I want to try the `allow` and `ignore` sections for skipping major versions or noisy test dependencies. Also curious about the weekly schedule versus daily in a busier repo.
