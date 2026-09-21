---
last_verified: 2026-09-21
tool_version: n/a
---

# GitHub Actions quickstart — what tripped me up

Following the official quickstart, here's what worked and where I got stuck setting up my first workflow.

## Steps I followed

I created a repo with a `.github/workflows/` folder and added a starter workflow file in it. I kept the trigger simple — run on every push — with one job on the default Linux runner and a couple of `run:` steps that just echo text. I committed it, pushed, then opened the Actions tab to watch the run go from queued to green.

My second pass added a manual trigger alongside push so I could re-run without pushing empty commits. I also split the steps into checkout plus two echo steps so I could see each step's log separately.

## Got stuck on

The first thing that tripped me up was the file location. I put the workflow at the repo root at first and nothing happened — no runs, no errors, just silence. Moving it under `.github/workflows/` fixed it, but the quiet failure was confusing.

Indentation bit me next. I nested `steps:` one level too shallow under the job and the run failed with a message about an unexpected key. Re-indenting so `runs-on` and `steps` sat at the same level under the job cleared it.

The last snag was the trigger. I pushed to a feature branch and wondered why nothing ran — my trigger only watched the default branch. Adding the manual trigger let me test from any branch from the Actions tab, which made iterating much faster.

## What I'd try next

I want to try a pull-request trigger so checks run on every PR, and pass a small output from one step to the next. After that I'd like to reuse one of the pre-built checkout steps instead of writing everything with shell commands.
