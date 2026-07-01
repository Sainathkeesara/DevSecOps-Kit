# Git — quick primer

> First-day notes for someone who's never used Git. Personal voice, plain language.

## What is it?

Git is a version control system that tracks changes to files over time. Every time I save (commit) my work, Git takes a snapshot of the whole project — like a checkpoint in a video game. I can go back to any checkpoint, branch off to try something risky, or merge my work with someone else's without overwriting their changes.

I'd describe it to a non-technical friend as "Google Docs for code, but way more powerful — you can see every edit ever made, who made it, and you can work on multiple versions at the same time without breaking anything."

## What does it do?

It records the complete history of every file in a project, lets me create isolated branches to work on features or fixes, and lets me merge those branches back together when I'm done. It also handles collaboration — multiple people can work on the same codebase, and Git figures out how to combine their changes (or tells me when there's a conflict I need to resolve manually).

## Why does it exist?

Before Git, teams used centralized version control (like SVN or CVS). If the central server went down, nobody could commit or check history. Git is distributed — every person has a full copy of the entire repository on their machine. You don't even need a server to use it; you can track changes locally and push to a remote only when you want to share.

Git was created by Linus Torvalds in 2005 because the Linux kernel team outgrew the existing tools. It needed to be fast, handle huge projects, and support non-linear development (hundreds of contributors working on different features simultaneously).

## Key terminology

- **Repository (repo)** — A folder that Git is tracking. Example: `git init` turns any directory into a Git repo.
- **Commit** — A snapshot of the project at a point in time. Example: `git commit -m "add login form"` saves the current state with a message describing what changed.
- **Branch** — A separate line of development. Example: `git checkout -b fix-login-bug` creates a new branch where I can fix a bug without touching the main code.
- **Staging area (index)** — A middle step between editing files and committing. Example: `git add file.py` puts the file in the staging area; `git commit` snapshots only what's staged.
- **Remote** — A copy of the repo hosted somewhere else (like GitHub). Example: `git push origin main` uploads my commits to the remote named `origin`.
- **Merge** — Combining changes from two branches. Example: `git merge feature-login` adds the commits from `feature-login` into the current branch.
- **Pull / Push** — Downloading changes from a remote (pull) or uploading your own (push). Example: `git pull origin main` fetches and merges the latest changes from the remote main branch.
- **Diff** — The difference between two versions of a file. Example: `git diff` shows what lines I've changed since the last commit.

## A tiny example

```bash
# Initialize a repo, create a file, commit it
mkdir my-project && cd my-project
git init
echo "# Hello World" > README.md
git add README.md
git commit -m "first commit — add README"
```

This creates a new Git repository, adds a README file, and commits it. I can now run `git log` to see the commit history or `git checkout` to go back to this exact state later.

## What I'll cover next

Now that I understand what Git is and the basic workflow, I want to get hands-on — install it on my machine, create my first real repo, and practice the commit-branch-merge cycle. After that I'll explore more advanced moves like rebasing, stashing, and fixing mistakes with the reflog.
