---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# Exploring the scripts directory — what helpers exist

I listed everything under `scripts/` to see what helpers are already available before writing my own. The root has `bump-version.sh`, `patch-report.sh`, and `triage-vulnerabilities.sh`. Under `scripts/bash/` there are toolkit directories for nearly every tool: ansible_toolkit, docker_toolkit, git_toolkit, k8s_toolkit, terraform_toolkit, etc. There's also a `pipeline/` folder with deploy and rollback wrappers, and a `scripts/lib/` area with shared logging, retry, and config modules.

What surprised me: the `scripts/bash/` tree has 16 toolkit folders but `scripts/snippets/` doesn't exist yet — I created it for my first utility script. I also noticed `scripts/README.md` documents the bash standards and safety policies that all scripts should follow.

What I'd try next: write a small utility script and place it in the right spot — probably `scripts/snippets/` since it's a first script, then maybe expand into one of the toolkits.
