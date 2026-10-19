---
last_verified: 2026-10-19
tool_version: n/a
sources: []
---

# Snippets quickstart — what tripped me up

> Following the official snippets quickstart and writing up where I got stuck. L2 organized notes.

## Steps I actually ran

I started by exploring the snippets directory structure to understand how it's organized. The primer at `snippets/notes/0000-primer-snippets.md` gave a good overview — it's a flat collection of markdown reference files, one per tool or topic.

First, I listed the root to see what snippet files already exist:

```bash
ls /work/DevSecOps-Kit/snippets/
```

This showed about 20 markdown files at the root (ansible-commands.md, docker-commands.md, git-commands.md, etc.) plus subdirectories for `notes/`, `snippets/`, and `configs/`.

Then I checked the existing snippet in `snippets/snippets/2026-09-20-first-snippet.sh` to see the expected format — a simple bash function with a `# last_verified` comment header.

I also looked at the existing config in `snippets/configs/2026-09-20-first-category.yaml` to understand the category schema.

## Got stuck on

**The "official quickstart" doesn't exist as a single document.** The primer mentions snippets are organized as flat `.md` files at the root, but there's no dedicated quickstart guide that walks through creating your first snippet end-to-end. I had to piece together the conventions by reading the primer, the existing snippet, and the existing config.

**Naming convention ambiguity for the root-level cheatsheets.** The root files like `kubectl-cheatsheet.md` and `linux-commands.md` don't follow the dated `YYYY-MM-DD-` prefix that the L1-L2 notes/snippets/configs in subdirectories use. The primer says "flat `.md` files at the root" but doesn't explain whether new root-level cheatsheets should be dated or not. Looking at the existing files, they all use stable kebab-case names without dates — so the dated prefix convention only applies inside `notes/`, `snippets/`, `configs/` subdirectories.

**Category vs. root-file relationship.** The config defines categories like `bash-scripting`, `k8s-operations`, etc., but the root cheatsheet files don't explicitly reference these categories. It's unclear whether a new root cheatsheet should also add an entry to the category config, or if they're meant to be separate organizational systems.

**No validation script for snippet format.** There's no linting or validation that checks whether a new snippet follows the expected header format (`# last_verified: ... · snippets Lx`). I had to manually verify the existing examples.

## What I'd try next

I'd write a minimal Python snippet for the kit (snippets-005) to test the snippet subdirectory conventions, then create a shared index config (snippets-006) that maps root cheatsheets to categories. That would clarify whether the category config is meant to index the root files or if it's for a different purpose entirely.

I'd also look for any CI/CD integration — like a GitHub Action that validates snippet headers or checks for broken links in the root cheatsheets.