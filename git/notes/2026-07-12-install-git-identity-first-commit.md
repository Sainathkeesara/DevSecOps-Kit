---
last_verified: 2026-07-12
tool_version: 2.54.0
sources:
  - https://syssignals.com/articles/day-01-git-branching-strategies
  - https://medium.com/@eloquentcoder/the-complete-guide-to-git-init-from-your-first-repository-to-advanced-configuration-7f6bfb1ef6b9
  - https://thelinuxcode.com/git-init-what-it-is-how-it-works-and-how-to-use-it-well-in-real-projects/
  - https://blog.stackademic.com/5-git-blunders-beginners-make-in-real-companies-and-how-to-fix-them-d4cda41165d2
  - https://commitlog.cc/posts/common-git-mistakes
---

# Installing Git and making my first commit — what tripped me up

I installed Git on a fresh machine, tried to make my first commit, and immediately hit problems. Here's what went wrong so you can avoid it.

## Installing

I ran `apt install git` (Debian) and got 2.54.0. Simple enough.

## First commit failed

I created a directory, ran `git init`, added a file, then `git commit -m "first"`. Git refused:

```
Author identity unknown
```

I hadn't set `user.name` or `user.email`. Running `git config --global user.name "Me"` and `git config --global user.email "me@example.com"` fixed it. This trips up everyone on a fresh machine.

## Wrong directory

I almost ran `git init` in my home directory. That would have made Git track everything on my machine. I checked with `git rev-parse --show-toplevel` first. Good habit.

## `.gitignore` too late

I committed a `.env` file with a test API key, then added it to `.gitignore`. By then the secret was already in history — anyone can check out the old commit. I had to rotate the key. Set up `.gitignore` before the first commit.

## `git switch` not found

I tried `git switch my-branch` and got `git: 'switch' is not a git command`. Turns out `switch` and `restore` need Git ≥ 2.23. On an older machine I had 2.17. I used `git checkout -b` instead.

## Recovery safety net

I did a bad `git reset --hard` and lost commits. `git reflog` showed every HEAD I'd ever pointed at — I recovered by checking out the right one. Good to know before you panic.

## What I'd try next

I want to practice branching and merging without breaking things, and learn `git stash` for when I'm in the middle of something and need to switch contexts.
