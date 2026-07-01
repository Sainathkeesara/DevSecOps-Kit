# Git — quick primer

> First-day notes for someone who's never used Git. Personal voice, plain language.

## What is it?

Git is a version control tool for tracking changes in text files — source code, config files, documentation, basically anything that isn't a binary blob. It's the tool everyone in software uses to save, share, and review work.

## What does it do?

Git keeps a full history of every change I make, lets me create branches to work on things without breaking the main code, and merges branches back together when I'm done. It lives locally on my machine — I don't need a server to use it.

## Why does it exist?

Before Git, teams used older tools like Subversion or CVS, which needed a constant connection to a central server and handled branching poorly. Git was built by Linus Torvalds for the Linux kernel development, where hundreds of people needed to contribute without stepping on each other. Every copy of the repo is a full backup — if the server dies, anyone's clone has the entire history.

## Key terminology

- **Commit** — A snapshot of my changes with a message. Run `git commit -m "fix login bug"`.
- **Branch** — A parallel version of the code I can work on. Run `git branch feature-x`.
- **Clone** — A local copy of a remote repository. Run `git clone https://github.com/user/repo.git`.
- **Push / Pull** — Sending my commits to a remote / fetching theirs. Run `git push origin main`.
- **Staging area** — Where I prepare files before committing. Run `git add file.py` to stage it.
- **Diff** — The difference between two versions. Run `git diff` to see unstaged changes.

## A tiny example

```bash
mkdir hello-git && cd hello-git
git init
echo "# Hello" > README.md
git add README.md
git commit -m "first commit"
git log --oneline
```

This initialises a repo, adds a file, and saves the first commit. That's the whole core workflow in five commands.

## What I'll cover next

I want to try branching, merging, and resolving a conflict — the stuff that comes up every day in team work. Then I'll look at connecting to GitHub and pushing work up.
