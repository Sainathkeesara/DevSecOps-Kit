---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# Snippets — quick primer

> First-day notes for someone who's never used Snippets. Personal voice, plain language.

I just learned about the snippets directory in this kit. It's a collection of reference materials — one markdown file per tool or topic — that gives you a quick starting point without having to dig through docs. Think of it like a recipe index at the back of a cookbook: each card covers one dish, and you grab the one you need.

The snippets are organized as flat `.md` files at the root of `snippets/`, each focused on a single tool's command set or common patterns. For example, `ansible-commands.md` covers ad-hoc Ansible commands, `docker-commands.md` covers Docker CLI patterns, and `ci-cd-cheatsheet.md` covers common CI/CD snippets. Each file is self-contained and meant to be grabbed quickly — not a tutorial, but a reference you can skim in under a minute.

## What does it do?

Snippets give you a fast way to recall a command or pattern without leaving your terminal or IDE. If you need a kubectl command or a git rebase trick, you look up the matching snippet file instead of searching the web. They're intentionally short — just enough to jog your memory and point you in the right direction.

## Why does it exist?

Before this collection, I'd waste time hunting through scattered notes or re-reading tool docs just to remember a flag name. Having everything in one place, organized by tool, means I can find what I need fast. It's especially useful when you're switching between tools and need a quick reminder of syntax you don't use every day.

## Key terminology

- **Snippet** — A short reference card covering a specific tool's commands or patterns. Example: `kubectl-cheatsheet.md` has common kubectl commands in one place.
- **Cheatsheet** — A condensed reference focused on frequently-used commands. Example: `linux-cheatsheet.md` lists essential Linux commands.
- **Ad-hoc commands** — One-off commands run directly against a tool, not part of a larger configuration. Example: `ansible all -m ping`.
- **Workspace** — A project context where snippets apply. Example: using `docker-commands.md` inside a containerized project.
- **Reference file** — The individual `.md` file that contains a snippet. Example: `vault-commands.md`.

## A tiny example

```bash
# Looking up a kubectl command from the snippets directory
cat snippets/kubectl-cheatsheet.md | grep -A3 "get pods"
```

Finds the `kubectl get pods` command quickly without searching the web.

## What I'll cover next

I'll start using these snippets in my daily workflow and see which ones need updates. Then I might try writing a snippet for a tool that doesn't have one yet.
