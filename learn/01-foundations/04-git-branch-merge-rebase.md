---
last_verified: 2026-10-31
tool_version: n/a
sources: []
---
# Branch, merge and rebase safely

You've learned the Git basics — initializing a repo, making commits, and understanding the core concepts. Now you'll learn how to work with branches, combine changes safely, and rewrite history when mistakes happen. These skills are essential for maintaining a clean, meaningful commit history in any team environment.

## What you'll learn

- Commit in small steps and read the history
- Merge a feature branch and resolve a planted conflict
- Rebase a branch and recover from a mistake with reflog

## Before you start

- [Version control with Git — concepts](../../docs/concepts/version-control-with-git/0000-primer-version-control-with-git.md) — you should understand what a repo, commit, branch, and merge are
- [Navigate and script on Linux](02-shell-scripting.md) — you should be comfortable using the command line

## Walkthrough

1. Start with a fresh branch from main:

   ```bash
   git checkout -b feature/add-auth
   ```

   You should see no output and be on branch `feature/add-auth`.

2. Make a small commit on the new branch:

   ```bash
   echo "auth=true" >> config.toml
   git add config.toml
   git commit -m "feat: add auth configuration"
   ```

   You should see: `[feature/add-auth (root-commit)] ... feat: add auth configuration`

3. Merge the feature branch into main (fast-forward merge):

   ```bash
   git checkout main
   git merge feature/add-auth
   ```

   You should see: `Already up to date.` if no new commits, or a fast-forward message.

4. Introduce a conflict and resolve it:

   ```bash
   echo "debug=1" >> config.toml
   git commit -m "temp: add debug flag"
   git checkout main
   echo "production=TRUE" >> config.toml
   git add config.toml
   git commit -m "chore: set production mode"
   git merge feature/add-auth
   ```

   You should see: `Automatic merge failed; fix conflicts then commit.`

   Open `config.toml`, you'll see both changes conflicted. Resolve by keeping the production version:

   ```toml
   auth=true
   production=TRUE
   ```

   Stage and commit the resolution:

   ```bash
   git add config.toml
   git commit -m "chore: resolve merge conflict, kept production settings"
   ```

   You should see: `Committed merge commit...`

5. Rebase the feature branch onto main:

   ```bash
   git checkout feature/add-auth
   git rebase main
   ```

   You should see the commits being replayed onto main. If a conflict occurs, resolve it, then run `git rebase --continue`.

6. Recover from a rebase mistake with reflog:

   ```bash
   git reflog
   ```

   You should see a list of recent branch tips and HEAD movements, including the old `feature/add-auth` reference.

   ```bash
   git reset --hard HEAD@{2}
   ```

   You should see the branch return to the state it was at 2 entries ago in the reflog.

## Exercise

1. Create a new branch `feature/fix-layout` from `main`
2. Add a file `layout.html` with `<h1>Hello</h1>`, add and commit it with message `"feat: add layout page"`
3. Switch back to `main` and add a line `bgcolor=white` to `config.toml`, commit it
4. Merge `feature/fix-layout` into `main`
5. If there's a conflict, resolve it keeping the main version
6. Run `git log --oneline` and confirm the merge commit appears

## Check your work

```bash
git log --oneline
```

You should see at least 3 commits including the merge commit from step 4. If you completed the rebase recovery step, `git reflog` should show the old `feature/add-auth` reference and `git reset --hard HEAD@{2}` should restore it.

## Common mistakes

- Forgetting `git add` before `git commit` — staged changes are not included
- Merging without resolving all conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) — the merge will fail
- Running `git rebase` without `git rebase --continue` after resolving a conflict — the rebase stalls

## Next

[Read an HTTP exchange and a certificate](../../00_index/learning-path.md)