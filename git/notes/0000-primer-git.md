# Git — quick primer

> First-day notes for someone who's never used Git. Personal voice, plain language.

## What is it?

Git is a version control system — it tracks changes to files over time. Every time you save a snapshot (a "commit"), Git remembers what changed, who changed it, and when. It's like a time machine for your code: you can go back to any previous state, compare versions, and branch off to try experiments without breaking the main project.

If you've ever saved a file as `report_final_v3_actuallyfinal.docx`, Git is the tool that makes that pattern obsolete. Instead of naming hacks, you get clean history that you can search, diff, and revert.

## What does it do?

Git lets you record snapshots of your project at any point, switch between different versions, merge work from multiple people, and sync changes with remote repositories (like GitHub). You can create "branches" to work on features in isolation, then merge them back when they're ready. It's the backbone of modern software collaboration — nearly every open-source project and team workflow runs on Git.

## Why does it exist?

Before Git, teams shared code by copying files to shared drives, FTP servers, or central CVS/SVN servers. Centralized version control had a single point of failure and required network access for every operation. Git was built to be distributed — every developer has a full copy of the entire history on their machine. You can commit, branch, and browse history offline. It also introduced cryptographic hashing (SHA-1) of content, so history can't be altered without detection.

Linus Torvalds created Git in 2005 to manage the Linux kernel development. The kernel team needed something faster and more reliable than the existing tools, and Git solved that problem. Today it's the most widely used version control system in the world.

## Key terminology

- **Repository (repo)** — A directory containing your project files and the entire Git history. Example: `git init` creates a new repo.
- **Commit** — A snapshot of changes at a point in time. Example: `git commit -m "add login feature"` saves your staged changes.
- **Branch** — A movable pointer to a commit, letting you develop in isolation. Example: `git checkout -b feature-xyz` creates and switches to a new branch.
- **Staging area (index)** — A middle step between editing files and committing. You stage specific changes, then commit what's staged. Example: `git add file.py` stages a file.
- **Remote** — A copy of the repository hosted elsewhere. Example: `origin` is the default remote name when you clone from GitHub.
- **Pull / Push** — Sync changes with a remote. Pull fetches and merges; push sends your commits. Example: `git push origin main`.
- **Merge** — Combining changes from two branches. Example: `git merge feature-xyz` integrates the feature into the current branch.
- **Clone** — Downloading a remote repository to your local machine. Example: `git clone https://github.com/user/repo.git`.
- **Diff** — Showing what changed between two versions. Example: `git diff` shows unstaged changes.

## A tiny example

```bash
git init my-first-repo
cd my-first-repo
echo "# Hello World" > README.md
git add README.md
git commit -m "first commit"
git log --oneline
```

This creates a new repository, adds one file, commits it, and shows the single-entry history. That's the entire basic workflow: init, add, commit, repeat.

## What I'll cover next

I want to get comfortable with branching and merging, understand how to undo mistakes (reset, revert), and learn how to collaborate on GitHub with pull requests. After that, rebasing and the stash command — the stuff that makes Git really powerful once the basics are solid.
