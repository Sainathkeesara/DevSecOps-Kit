---
last_verified: 2026-08-19
tool_version: n/a
sources: []
---

# .github/workflows stubs review — 2026-08-19

> Quick check on whether four workflow filenames need stub files in the repo or are just examples in docs.

## What I reviewed

I went back through the docs that mention `.github/workflows/trivy-scan.yml`, `ci.yml`, `semgrep-ci.yml`, and `semmp.yml` to see if any of them are missing real files that should live in-repo.

## Verdict

| File | Status | Notes |
|---|---|---|
| `semmp.yml` | Spurious | Looks like a typo. No doc currently references this exact name. |
| `ci.yml` | Legitimate example | Generic CI workflow shown in how-to guides. Users create this in their own repos. |
| `semgrep-ci.yml` | Legitimate example | Referenced in `semgrep/docs/github-actions-ci-from-scratch.md` as a user-creation example. |
| `trivy-scan.yml` | Legitimate example | Referenced in `docs/how-to/trivy-github-actions.md` as a user-creation example. |

## Bottom line

No stubs are needed. Three of the four are standard user-creation examples embedded in guides, and the fourth (`semmp.yml`) doesn't appear anywhere in the current docs tree. I won't add any files to `.github/workflows/`.
