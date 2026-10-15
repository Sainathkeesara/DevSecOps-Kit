---
last_verified: 2026-10-15
tool_version: n/a
sources: []
---

# Following the nuclei quickstart — what tripped me up

I followed the official nuclei quickstart order as far as this box lets me: install, fetch templates, pick a target, run one template, read the output. Here's what worked and where it broke for me.

## Steps I actually ran through

First I checked whether nuclei is even on this machine — it isn't, so every step below is read-and-rehearsed, not executed. I read the kit's primer (`0000-primer-nuclei.md`) and the earlier first-scan note to get the mental model straight: one small YAML file per check, each with an `id` and an `info` block carrying the severity, pointed at a target I control, with the matches saved somewhere I can re-read.

The install step itself looks simple — grab the binary for my platform and put it somewhere on my path. The template step is where I slowed down: the quickstart pulls a big shared template collection, and I decided I don't want hundreds of checks on my first run. My plan is one template, one target, one output file.

## Got stuck on

**The template download assumes network and a home for the files.** The quickstart fetches templates into a local directory, but I haven't decided where mine should live or which single template to start from, so I stopped instead of pulling the whole set blindly. I wrote a minimal template of my own next (see `nuclei/configs/2026-10-15-minimal-scan-template.yaml`) so my first run has exactly one check in it.

**Picking a target felt risky.** Pointing a scanner at anything I don't own is off the table, so my first target will be a throwaway page I serve myself locally. I haven't stood that page up yet — that's the blocker for the actual run.

**Output handling is still fuzzy.** I've seen examples that save matches to a file for later diffing, but since I haven't run anything I won't quote an exact flag spelling here. What I do know is what I want in the file: which template fired, against which URL, and the matched snippet — enough to re-check the finding by hand.

## What I'd try next

Install nuclei in an isolated practice environment, serve a tiny local page I control, run my one minimal template against it, and save the raw output beside this note. Then I'll write down what each result field meant and only after that try a second template.
