---
last_verified: 2026-07-04
tool_version: n/a
---

# Following a Git branching and merging tutorial — my confusions

> First-person notes from working through the branching and merging tutorial. Where it clicked, where it didn't, and what I'd try next.

## What I followed

I started with the official Git branching and merging tutorial. The basic flow is straightforward: `git checkout -b new-feature` creates a branch, `git add .` and `git commit -m "..."` saves work, then `git checkout main` and `git merge new-feature` combines the changes. I walked through this twice with a dummy repo to get the motions into muscle memory. The tutorial showed three scenarios: fast-forward, explicit merge commit, and conflict.

## What worked

- Creating a branch felt familiar — it's just a lightweight pointer.
- The `git log --oneline --graph --all` command made the branch structure visible. Seeing the lines fork and then merge back together clarified what a merge commit actually looks like.
- Fast-forward merges were the simplest case: when main hasn't moved, Git just moves the main pointer forward. That felt like the "aha" moment.

## Got stuck on

- **Merge conflicts.** The tutorial flashes through conflict resolution in a few sentences. When I deliberately edited the same line in `README.md` on both branches, the merge failed and I didn't immediately know what to do. The conflict markers (`<<<<<<< HEAD`, `=======`, `>>>>>>> branch`) were confusing at first, and I froze before choosing which line to keep.
- **Merge strategies.** The tutorial mentions that there are different merge strategies but doesn't explain when to use which. After my first conflict, I realized the strategy matters for complex histories. I still don't know how to choose one or how it affects the final commit.
- **Rebase after merge.** I tried `git rebase` after I had already merged a feature branch. The result was duplicate commits and a messy graph. I had to use `git reflog` to find the old HEAD and `git reset --hard` to recover, which was stressful but educational.

## What I'd try next

- I want to practice with a three-branch scenario (feature A, feature B, hotfix) to see how Git handles multiple concurrent merges and how the graph looks when you rebase one branch onto another.
- I should learn the `git mergetool` workflow instead of editing conflict markers by hand.
- I want to run through the same changes with both merge and rebase in a clean repo so I can decide which visual history I prefer before using either in real projects.
