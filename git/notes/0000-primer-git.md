---
last_verified: 2026-07-26
tool_version: n/a
sources:
  - https://thelinuxcode.com/how-to-install-git-on-windows-command-line-2026-practical-guide/
  - https://thelinuxcode.com/install-git-and-set-up-github-a-practical-modern-guide/
---

# Git — quick primer

> First-day notes for someone who's never used Git. Personal voice, plain language.

## What is it?

Git is a version control system — it tracks changes to files over time. Every commit is a snapshot of your project at that point. I think of it like a save game for code: you can always go back to a previous save, try a new branch, and merge your experiments back in without losing what you had.

## What does it do?

Git lets you record snapshots of your project, branch off to try ideas in isolation, and merge work back when it's ready. You push and pull changes to and from remote repos. I installed Git once and immediately hit a PATH issue on Windows — selecting "Git Bash only" during install left `git` invisible in PowerShell until I re-ran the installer with the right option. That kind of thing is exactly the sort of first-contact pitfall this primer is about.

## Why does it exist?

Before Git, teams shared code by copying files or using centralized systems like CVS and SVN. Single points of failure, network dependency — you couldn't work offline. Git was built to be distributed: every developer has the full history locally. You can commit, branch, and browse history without a network connection. Linus Torvalds created Git in 2005 for Linux kernel work because the existing tools were too slow.

## Key terminology

- **Repository** — A directory containing your project files and full Git history. Example: `git init` creates a new repo.
- **Commit** — A snapshot of changes at a point in time. Example: `git commit -m "add login feature"` saves your staged changes.
- **Branch** — A movable pointer to a commit, letting you develop in isolation. Example: `git checkout -b feature-xyz` creates and switches to a new branch.
- **Remote** — A copy of the repo hosted elsewhere. Example: `origin` is the default remote name when you clone from GitHub.
- **Push / Pull** — Sync changes with a remote. Pull fetches and merges; push sends your commits. Example: `git push origin main`.
- **SSH** — A cleaner long-term auth option for GitHub since it avoids repeated credential prompts.

## A tiny example

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git init
git add README.md
git commit -m "first commit"
```

This creates a new repo, stages README.md, and makes the first commit. On macOS, Apple ships an outdated Git — `brew install git` puts a newer version earlier in PATH.

## What I'll cover next

I want to try branching and merging in a real project next, and then figure out how to handle merge conflicts without losing work. After that I'll explore GitHub Actions for CI with Git-based triggering.