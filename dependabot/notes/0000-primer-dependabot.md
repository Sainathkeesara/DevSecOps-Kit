# Dependabot — quick primer

> First-day notes for someone who's never used Dependabot. Personal voice, plain language.

## What is it?

Dependabot is GitHub's dependency updater. I think of it like a helper that watches package files and opens small PRs when versions move on, instead of me checking every library by hand.

## What does it do?

It reads dependency manifests, checks for newer versions, and opens pull requests with updated files. For npm, that usually means `package.json` and `package-lock.json` change together.

## Why does it exist?

Before this, I had to manually check package versions, compare changelogs, and update files myself. Dependabot is useful when I want GitHub to do the boring tracking and bring me a clean PR to review.

## Key terminology

- **Dependabot** — GitHub's built-in dependency update tool. Example: it opens a PR when `lodash` has a newer version.
- **Package ecosystem** — The dependency system Dependabot watches. Example: `npm`.
- **Manifest** — The file that declares dependencies. Example: `package.json`.
- **Lockfile** — The file that pins exact resolved versions. Example: `package-lock.json`.
- **Update pull request** — The PR Dependabot opens with dependency changes. Example: `Bump lodash from 4.17.20 to 4.17.21`.
- **Schedule** — How often Dependabot checks for updates. Example: `weekly`.
- **Open pull request limit** — A cap on active Dependabot PRs.

## A tiny example

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
```

This is the smallest config I can write: watch the root npm project weekly.

## What I'll cover next

Next I want to try a real npm repo and see how Dependabot changes the manifest and lockfile together. I also want to learn how labels and update limits keep the PR queue from getting noisy.
