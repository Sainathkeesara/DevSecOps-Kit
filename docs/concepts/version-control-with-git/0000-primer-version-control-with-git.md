# Version Control with Git — quick primer

> First-day notes on Version Control with Git. What it is, why it matters, and the key ideas to know.

## What is it?

Version control is a system that tracks changes to files over time. Git is the most popular one — it's what almost every software team uses to collaborate on code. I think of it like the undo history in a document editor, except it never expires and the whole team shares it.

Every time I save a snapshot of my work in Git (a "commit"), I can go back to it later, see exactly what changed, who changed it, and why. If something breaks, I can roll back to the last known good state. If two people edit the same file, Git can usually merge their changes automatically.

## Why does it matter for DevSecOps?

Version control is the foundation of everything in DevSecOps. Without it, CI/CD pipelines don't have anything to trigger on, code reviews don't have diffs to check, and rollbacks are manual and risky.

Git also provides audit trails — every commit records the author, timestamp, and changes. For security compliance, that's huge. If a vulnerability gets introduced, I can trace exactly when and by whom. Branch protection rules (requiring PR reviews, blocking force pushes, requiring status checks) are where security gates get enforced before code merges.

## Key terminology

- **Repository (repo)** — A folder that Git is tracking, including the full change history. Example: `git init` creates a new repo in the current directory.
- **Commit** — A snapshot of the project at a point in time. Example: `git commit -m "fix: validate user input"` saves the current changes with a message explaining why.
- **Branch** — A parallel version of the code. The default branch is usually `main` or `master`. Example: `git checkout -b feature/add-login` creates a new branch to work on a login feature without touching the main code.
- **Merge** — Combining changes from one branch into another. Example: after finishing the login feature, `git checkout main && git merge feature/add-login`.
- **Pull request (PR) / Merge request** — A proposal to merge changes from one branch into another, usually with code review. Example: opening a PR in GitHub so teammates can review before the code goes to main.
- **Diff** — The difference between two versions of a file. Example: `git diff` shows what lines were added and removed since the last commit.
- **Remote** — A copy of the repo hosted on another server (GitHub, GitLab, self-hosted). Example: `git push origin main` sends my local commits to the remote repo named "origin".
- **Clone / Fork** — Clone: download a remote repo to work locally. Fork: create a copy of someone else's repo under my own account on the hosting platform.

## A concrete example

Here's the basic workflow I use to make a change and share it:

```bash
# Clone a repo and create a branch for my change
git clone https://github.com/user/project.git
cd project
git checkout -b fix/cve-1234

# Make and save the change
echo "allowlist=()" >> config.toml
git add config.toml
git commit -m "fix: add empty allowlist to prevent default-open config"

# Share it — push and open a PR on GitHub
git push origin fix/cve-1234
```

This shows the four core actions: branching, staging changes, committing, and pushing. The PR on GitHub is where security scanning runs before the code merges.

## How this connects to what's next

CI/CD pipelines run on Git events (push, PR open). Security scanners (Semgrep, Trivy, Checkov) scan the diff at PR time. Git tags are used to trigger deployments. Signing commits (Cosign, GPG) ties identity to changes. Understanding how Git works is the prerequisite for all of it.
