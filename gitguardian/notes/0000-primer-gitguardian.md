# GitGuardian — quick primer

> First-day notes for someone who's never used GitGuardian. Personal voice, plain language.

## What is it?

GitGuardian is a secret detection platform. Think of it as a scanner that looks for API keys, passwords, tokens, and other secrets that accidentally end up in your code. It's like having a spell-checker for secrets — but instead of typos, it finds credentials that shouldn't be there.

## What does it do?

It scans Git repos (and other places) for leaked secrets, classifies what it finds (real credential vs. false positive), and tracks findings over time so you don't re-introduce the same leak. The CLI tool is called `ggshield`.

## Why does it exist?

Before tools like GitGuardian, teams relied on manual code review or basic grep patterns to catch secrets in commits. That doesn't scale — people miss things, and by the time a secret is pushed it could already be compromised. GitGuardian automates that detection and hooks into your workflow (pre-commit, CI, etc.) so leaks get caught before they cause damage.

## Key terminology

- **Secret** — any sensitive string: API key, password, private key, database URL, etc. Example: `AIzaSy...` (GCP key).
- **Incident** — a confirmed secret detected in a repo. Example: a Stripe live key pushed to a public GitHub repo.
- **ggshield** — GitGuardian's CLI tool for local scanning. Run `ggshield scan commit-range` to check recent commits.
- **Occurrence** — a single instance of a secret in a file (multiple occurrences can appear in one incident).
- **Policy** — rules that define which patterns are flagged. Default policies cover hundreds of provider formats.
- **False positive** — something flagged as a secret that isn't (e.g. a test key like `sk_test_...`). You can allowlist these.

## A tiny example

```bash
ggshield scan path .
```

Scans every file in the current directory for secrets. Fast way to check a repo before pushing.

## What I'll cover next

I want to install ggshield, run it against a real repo, and figure out how to hook it into my commit workflow so I stop worrying about accidental pushes.
