---
last_verified: 2026-10-15
tool_version: n/a
sources: []
---

# Shell scripting quickstart trip-ups

I worked through a shell scripting quickstart this morning so I could stop cargo-culting the helper scripts in this kit. Here is what worked, where it broke, and what I still want to try.

## Steps I actually ran

I started with the smallest possible script: a shebang line, one `echo`, `chmod +x`, run it. That worked first try, which gave me false confidence. Then I added a variable for a target directory and quoted it everywhere (`"$TARGET"` instead of `$TARGET`) after the guide showed how an unquoted path with a space splits into two arguments. I tested that with a directory named `my dir` and watched the unquoted version fail exactly the way the guide said it would.

Next I tried a function with a local variable and a return code check using `$?` right after the call. That worked too. Finally I read through the kit's own `scripts/snippets/2026-09-20-first-utility-script.sh` to see how a real helper in this repo looks, and I noticed it lists toolkit directories with `find` instead of hardcoding them, which is a trick I want to steal.

## Got stuck on

My first snag was the shebang. I wrote `#!/bin/sh` out of habit, then used a bash-only feature (`[[ ... ]]`) inside the script, and it failed on a system where `sh` is not bash. Switching the shebang to `#!/usr/bin/env bash` fixed it, but it took me a while because the error message pointed at the `[[` line and I kept re-reading that line instead of looking at line one.

My second snag was `$?` going stale. I called a function, then added an `echo` for debugging before checking `$?`, and of course by then `$?` held the exit code of the `echo`, not the function. The fix is to capture it immediately (`rc=$?` on the very next line), but nobody warns you how easy it is to clobber it with a debug print.

My third snag was `read` in a pipeline. I piped `find` output into a `while read` loop, set a counter inside, and the counter was zero after the loop ended. That is the subshell problem: the loop runs in a subshell when it is part of a pipeline, so variables set inside do not survive. Redirecting into the loop with `< <(find ...)` instead of piping fixed it.

## What I'd try next

I want to rewrite one of my throwaway scripts using a small shared logging helper so every script prints timestamps the same way, instead of each script inventing its own `echo` format. I also want to practice the retry pattern from scripts-007, since half of my scripts are just "call something, sleep, call it again" loops written by hand each time.
