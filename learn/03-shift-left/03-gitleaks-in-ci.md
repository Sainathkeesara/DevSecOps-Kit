---
last_verified: 2026-11-05
tool_version: "v8.30.1"
sources:
  - https://github.com/gitleaks/gitleaks/blob/master/README.md
  - https://github.com/gitleaks/gitleaks/releases
---
# Catch secrets before they land with Gitleaks

Secrets in git history are hard to undo: deleting a file does not remove what was committed. In this lesson you add Gitleaks to the sample-app workflow so a pull request fails when a secret is committed, configure a native TOML file with an allowlist that includes a reason, and remove the planted secret to make the check green again.

## What you'll learn
- Configure Gitleaks with a native TOML config and an allowlist with a reason
- Fail the PR when a secret is committed and remove the planted secret

## Before you start
- [Application security testing — SAST, DAST, SCA and secrets](../../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — where secret scanning fits alongside SAST, DAST, and SCA
- [Secrets and access management — concepts](../../docs/concepts/secrets-access-management/0000-primer-secrets-access-management.md) — why leaked credentials must be treated as compromised
- [CI for the sample app — build, test and push](../02-build-and-ship/06-gha-sample-app-ci.md) — the workflow you will extend
- Gitleaks installed locally so you can test before pushing: `gitleaks version`
- A repository with a GitHub Actions workflow you can edit (from the CI lesson)

## Walkthrough

1. Create a native Gitleaks config at the repository root.
   ```toml
   # .gitleaks.toml
   title = "sample app gitleaks config"

   [[allowlists]]
   description = "Known test fixture: not a real credential (reviewed 2026-11-05)"
   regexTarget = "match"
   regexes = [
     '''EXAMPLE_TEST_TOKEN_DO_NOT_USE''',
   ]
   paths = [
     '''docs/fixtures/.*''',
   ]
   ```
   You should see: a file named `.gitleaks.toml` in the repo root. The allowlist entry has a `description` that explains *why* the match is allowed — that reason is what makes an allowlist safe to review later.

   Gitleaks looks for `.gitleaks.toml` in the target path by default, and you can also point to a config with `--config`/`-c` or the `GITLEAKS_CONFIG` environment variable (see the [Gitleaks README](https://github.com/gitleaks/gitleaks/blob/master/README.md)). The `[[allowlists]]` form is the current style documented for v8.25.0+ and remains backwards compatible.

2. Run a local scan to confirm the config loads.
   ```bash
   gitleaks git --config .gitleaks.toml --redact
   ```
   You should see: Gitleaks scans the git history and reports `no leaks found` (exit code `0`) if the repo is clean. If you prefer scanning the working tree without git history, use `gitleaks dir . --config .gitleaks.toml --redact`.

   For comparison, the repo also includes a reference config at [`../../gitleaks/configs/gitleaks-config.toml`](../../gitleaks/configs/gitleaks-config.toml) and integration notes in [`../../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md`](../../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md).

3. Plant a fake secret on a branch and push it in a pull request.
   ```bash
   git checkout -b demo/gitleaks-planted-secret
   printf 'API_TOKEN="ghp_abcdefghijklmnopqrstuvwxyz012345"\n' >> app.env
   git add app.env
   git commit -m "demo: add config"
   ```
   You should see: the commit succeeds locally (nothing blocks it yet). The string looks like a credential; treat it as a planted demo value and never use a real token.

4. Add Gitleaks to CI so the PR fails when a secret is committed.
   ```yaml
   name: Secret scan
   on:
     pull_request:
       branches: [master]
   jobs:
     gitleaks:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
           with:
             fetch-depth: 0
         - uses: gitleaks/gitleaks-action@v2
           env:
             GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
             GITLEAKS_CONFIG: .gitleaks.toml
   ```
   You should see: the `gitleaks` job fails on the pull request that contains `app.env`. Gitleaks returns exit code `1` when it finds leaks or encounters an error, which fails the CI job (documented in the [Gitleaks README](https://github.com/gitleaks/gitleaks/blob/master/README.md)).

5. Remove the planted secret and push the fix.
   ```bash
   git rm app.env
   git commit -m "fix: remove planted secret"
   git push --set-upstream origin demo/gitleaks-planted-secret
   ```
   You should see: the next CI run passes because the secret is no longer present in the scanned changes. In a real incident you would also rotate the exposed credential — removing it from the latest commit is necessary, but history and any place it was copied still matter.

## Exercise

1. Add a `.gitleaks.toml` to your sample app with one `[[allowlists]]` entry that has a clear `description` (the reason) and a narrow `regexes` or `paths` match.
2. Open a pull request that adds a deliberately planted fake token in a new file. Confirm the Gitleaks CI job fails.
3. Remove the planted file, push the fix, and confirm the job turns green.
4. Add one more allowlist entry for a safe test fixture path and verify Gitleaks no longer flags that fixture while still flagging real-looking secrets elsewhere.

## Check your work

Run this locally from the repository root (with no planted secret present):

```bash
gitleaks git --config .gitleaks.toml --redact --exit-code 1
```

Expected result: the command exits with code `0` and reports no leaks. On the branch where you planted the fake token, the same command exits with code `1` and names the file that contains the match.

## Common mistakes
- Writing an allowlist without a reason — future reviewers cannot tell whether the exception is still safe. Put the reason in `description`.
- Allowlisting too broadly (for example a whole directory when only one fixture file needs it) — this can hide real secrets.
- Forgetting `fetch-depth: 0` in `actions/checkout` when you need full git history for a `git` scan in CI.
- Treating "deleted from the latest commit" as the same as "safe" — if a real credential was exposed, rotate it and assess where it may have been copied.

## Next
[Bring all findings together in DefectDojo](../../00_index/learning-path.md)