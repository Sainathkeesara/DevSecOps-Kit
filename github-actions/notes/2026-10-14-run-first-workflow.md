---
last_verified: 2026-10-14
tool_version: n/a
---

# GitHub Actions — run my first workflow and record what happened

I ran my first workflow and wrote down what happened.

## What I did

I had a starter workflow sitting in `.github/workflows/` already — a simple one with a push trigger, one job on the default Linux runner, and a couple of `run:` steps that echo text. I pushed it and opened the Actions tab to watch it go.

## What I saw

The run went queued, then running, then green. Each step showed up as its own row in the log, so I could see the checkout step and the echo steps separately. The whole thing took a minute or two.

## What tripped me up

The quiet failure still gets me. When the workflow file was at the repo root instead of under `.github/workflows/`, nothing ran — no runs, no errors, just silence. Moving it into the folder fixed it, but the lack of feedback was confusing the first time.

Indentation bit me too. I nested `steps:` one level too shallow under the job and the run failed with a message about an unexpected key. Re-indenting so `runs-on` and `steps` sat at the same level under the job cleared it.

## What I'd try next

I want to try a pull-request trigger so checks run on every PR, and pass a small output from one step to the next. After that I'd like to reuse one of the pre-built checkout actions instead of writing everything with shell commands.