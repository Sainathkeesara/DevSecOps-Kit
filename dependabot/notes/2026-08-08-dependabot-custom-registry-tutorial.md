---
last_verified: 2026-08-08
tool_version: n/a
---

# Setting up Dependabot with a private package registry — what tripped me up

I spent the afternoon wiring Dependabot to a private npm registry. Here's what I did and the spots where the YAML structure surprised me.

## What I did

Started with a basic `dependabot.yml` that only had `version: 2` and a single `updates` entry pulling from the public npm registry. Then I added a `registries` block to point at our internal feed. I generated a personal access token with `read:packages` scope, stored it as a GitHub secret called `NPM_TOKEN`, and wrote the registry config to reference that secret.

## What tripped me up

- **The `registries` key sits at the top level, not inside `updates`.** On my first pass I nested it under `updates:` and Dependabot rejected the file with a schema validation error. Both `registries:` and `updates:` are siblings under `version: 2`.

- **Registry `type` values are specific, not intuitive.** For a private npm registry the type must be `npm_registry`. I tried `npm` and `private-npm` and neither was accepted — the schema validator told me the type didn't match any expected value.

- **`registries` in an update entry is an array, not a string.** I initially wrote `registries: my-private-registry` (single scalar). Dependabot silently ignored it and fell back to the public npm registry, which meant the PRs never targeted our internal packages. Switching to `registries: [my-private-registry]` fixed it.

- **No `/v2/` suffix on Docker registry URLs.** When I set up a Docker registry later, I copied the URL from our registry client which included `/v2/`. Dependabot appends that path itself, so the double segment caused auth to fail. Stripping it to just the hostname and port worked.

- **The `token` field takes a secret name, not a literal token.** It should be the bare secret name (`NPM_TOKEN`), not `${{ secrets.NPM_TOKEN }}`. I initially wrapped it in `${{ }}` because that's what I'm used to in Actions workflows, and Dependabot complained it couldn't resolve the secret.

- **Dependabot needs explicit per-secret access.** Even after creating the secret, the scan failed until I went to Settings → Secrets and variables → Actions and toggled on "Allow Dependabot to access this secret" for each one. The toggle defaults to off and is easy to overlook.

- **Hostname must match the registry URL exactly.** For npm scoped packages, the `hostname` in the registry config has to match the hostname that appears in the `registry` field of `package.json`. I had a trailing slash on one but not the other.

- **Self-hosted registries behind a private VPC aren't reachable.** Dependabot runs from GitHub's network, so a registry with no public endpoint just timed out. The fix is a public entry point or a GitHub App integrated with private network access.

## What I'd try next

I want to test the same pattern with a Maven registry to see if `replaces-base` is needed when the registry acts as both a proxy and a host. I'm also curious how Dependabot handles mixed registries in a monorepo — one workspace on a private npm feed and another on the public one.
