---
last_verified: 2026-08-06
tool_version: n/a
---

# Linux shell scripting tutorial — what tripped me up

> Following the official Linux shell scripting tutorial, here's what worked and where it broke.

## What I tried

I started with the Bash Guide for Beginners from the Linux Documentation Project. The first few chapters on basic commands (`echo`, `ls`, `cd`, `cat`) felt familiar — I'd used a terminal before. The real learning started when the tutorial moved into shell variables and command substitution.

I got stuck on the difference between single quotes and double quotes. The tutorial explained that single quotes preserve literal values while double quotes allow variable expansion, but I kept forgetting which was which. I wrote a script that used `echo '$HOME'` expecting it to print my home directory, and it printed `$HOME` literally instead.

Then came the `for` loop syntax. The tutorial used `for file in *.txt; do ... done` and I kept trying to write it like a Python `for` loop with parentheses and colons. The `do` and `done` keywords felt unnatural at first.

## What worked

Writing small scripts to automate repetitive tasks clicked quickly. I created a script that listed all `.log` files in a directory and printed their sizes. The `wc -l` command to count lines in a file was satisfying to get right on the first try.

The section on `if` statements made sense once I realized the syntax is `[ condition ]` with spaces inside the brackets — missing a space is a silent syntax killer that produces confusing error messages.

## What I'd try next

I want to practice writing scripts that combine `grep`, `awk`, and `sed` in a single pipeline. The tutorial touched on each separately but didn't show how they chain together. I also want to try writing a script that backs up a directory with a date-stamped filename using `tar` and command substitution.