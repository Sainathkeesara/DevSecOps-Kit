---
last_verified: 2026-07-19
tool_version: n/a
sources: []
---

# Exploring the Falco CLI — list rules, capture events, and inspect output formats

> First-person notes from running Falco in a test cluster and learning the CLI surface after the first alert fired.

## List rules

`falco -L` prints every loaded rule. I ran it and saw about 90 rules organized by tag — shell, container, filesystem, network. `falco -L --rule=shell` filtered to shell-related rules. The output is a compact table with name, source, and description. I looked for the rule that caught my exec earlier and found it: "Shell Spawned In Container".

## Capture events

Running `falco` without flags starts the daemon and writes alerts to stdout. I exec'd into a test pod and Falco caught the shell spawn rule within seconds. The alert showed container, user, and the exact syscall. I also tried `falco -o json_output=true` and got structured JSON — one object per line. The text format is readable, but JSON is what I'd want if I were piping alerts into something else.

## Output formats

`falco -o webhook.url=http://localhost:3000` forwards alerts to an HTTP endpoint. I didn't have a listener running, so events silently dropped and I wasn't sure if Falco was working or buffering. I checked the logs and saw "connection refused" errors, which meant it was trying. Lowering the priority threshold with `falco -o priority=debug` flooded the output with every syscall, which was too noisy but confirmed Falco was alive.

## What I'd try next

I want to write a custom rule, test it with `falco -T`, and pipe alerts into a local webhook to see how they look in JSON.
