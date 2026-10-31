---
last_verified: 2026-10-31
tool_version: n/a
sources:
  - https://www.gnu.org/software/findutils/manual/find.html
  - https://man7.org/linux/man-pages/man1/find.1.html
  - https://www.gnu.org/software/bash/manual/bash.html
  - https://github.com/koalaman/shellcheck/releases
  - https://www.shellcheck.net/wiki/SC2086
---
# Navigate and script on Linux

The previous lesson introduced the Linux shell, exit codes, shebangs, and variables. This lesson puts those ideas to work: you will move around the filesystem, locate files by name and type, and write a small script that finds large log files — then make it pass ShellCheck so it is safe to reuse.

## What you'll learn
- Navigate, search and inspect files from the command line
- Write a script that finds large log files, with quoting and exit codes done right
- Make the script pass shellcheck

## Before you start
- [Linux and shell fundamentals](../../docs/concepts/linux-shell-fundamentals/0000-primer-linux-shell-fundamentals.md) — introduces the shell, exit codes (`$?`), shebangs, and variables you will use in this lesson.
- `bash` must be installed. Confirm it with `bash --version`.
- `shellcheck` must be installed to run the lint step. Confirm it with `shellcheck --version` (latest stable is v0.11.0).

## Walkthrough
1. Print your current location.
   ```bash
   pwd
   ```
   You should see: an absolute path such as `/home/yourname` — the directory you are currently in.

2. Move into a directory and inspect it.
   ```bash
   cd /var/log || exit
   ls -la
   ```
   You should see: a listing of files with permissions, owners, sizes, and names. `cd ... || exit` stops the script if the directory does not exist, so the rest never runs in the wrong place (ShellCheck rule SC2164).

3. Find log files by name and type.
   ```bash
   find . -name '*.log' -type f
   ```
   You should see: the paths of regular files ending in `.log`. Single quotes around `'*.log'` stop the shell from expanding the wildcard before `find` sees it.

4. Write the script. Save it as `find-large-logs.sh` (a reference copy lives at [`linux/scripts/find-large-logs.sh`](../../linux/scripts/find-large-logs.sh)):
   ```bash
   #!/bin/bash
   set -e

   LOG_DIR="${1:-.}"

   cd "$LOG_DIR" || exit

   find . -name '*.log' -type f -size +1M
   ```
   `set -e` makes the script stop on the first failed command (exit codes done right), `"$LOG_DIR"` is double-quoted so paths with spaces do not break (SC2086), and `-size +1M` finds files larger than one megabyte (suffixes `k`, `M`, `G` are supported).

5. Make it executable and run it.
   ```bash
   chmod +x find-large-logs.sh
   ./find-large-logs.sh /var/log
   echo "exit code: $?"
   ```
   You should see: the list of large log files, then `exit code: 0`.

6. Run ShellCheck.
   ```bash
   shellcheck find-large-logs.sh
   ```
   You should see: no output and exit code 0 — the script is clean.

## Exercise
Write a script named `find-large-files.sh` that takes a directory as its first argument (defaulting to `.`), finds regular `.log` files larger than `500 KB` in that directory, and passes ShellCheck. Use `set -e`, double-quote every variable expansion, and guard `cd` with `|| exit`. Use a different size suffix than the walkthrough (for example `-size +500k`) so you are not just copying it.

## Check your work
```bash
shellcheck find-large-files.sh
./find-large-files.sh /var/log
echo "exit code: $?"
```
`shellcheck` prints nothing and exits 0; the script lists log files larger than 500 KB and exits with code 0.

## Common mistakes
- **Unquoted variables** (`echo $LOG_DIR`) undergo word splitting and glob expansion, breaking on paths with spaces or glob characters — always write `"$LOG_DIR"` (SC2086).
- **Iterating `ls` output** is fragile — use a glob or `find` instead of `for f in $(ls)` (SC2045).
- **`cd` failing silently** lets the rest of the script run in the wrong directory — always write `cd "$DIR" || exit` (SC2164).
- **Single vs double quotes**: `echo '$LOG_DIR'` prints `$LOG_DIR` literally; `echo "$LOG_DIR"` expands it.

## Next
[Version control with Git — concepts](../../docs/concepts/version-control-with-git/0000-primer-version-control-with-git.md)
