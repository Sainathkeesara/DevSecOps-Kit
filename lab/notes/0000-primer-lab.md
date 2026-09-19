---
last_verified: 2026-09-19
tool_version: n/a
---

# lab — quick primer

> First-day notes for someone who's never used lab. Personal voice, plain language.

## What is it?

I just learned that `lab/` in this kit isn't a tool you install — it's our own scratch space for hands-on practice. It's like a workbench drawer where I keep small throwaway environments: a database server setup, a file-sharing box, a little Terraform project. Each one lives in its own folder under `lab/mini-projects/` with a README explaining what I was trying.

That clicked for me once I looked at what's already there — a postgres server walkthrough, a samba sharing walkthrough, a tiny Terraform layout with compute/network/storage modules. None of them are polished references; they're just dated notes-to-self from someone learning by doing.

## What does it do?

It lets me spin up a small practice environment, write down what I ran, and keep the config next to the notes so future-me can redo it. I pick one small thing (one server, one network), try to get it working, and save whatever config made it work. If it breaks, the notes say where it broke.

## Why does it exist?

Before I had a lab folder, every experiment lived in `/tmp` and vanished. I'd get something working on a Tuesday and have no idea how by Friday. The lab fixes that: each mini-project keeps its README and its config together, so I can rebuild the thing later or hand it to someone else. I think day-to-day it's mostly me — the learner — using it to practice without worrying about breaking anything shared.

## Key terminology

- **mini-project** — One self-contained practice setup under `lab/mini-projects/`. Example: the postgres database server folder.
- **README** — The short write-up inside each mini-project saying what I built and what tripped me up. Example: the samba sharing README.
- **Lab environment config** — A small file describing one practice machine or setup (name, what it runs, which ports). Example: my first lab env config in `lab/configs/`.
- **Scratch notes** — Dated first-person notes about what I tried. Example: what I write after setting up the lab directory.
- **Module** — A reusable chunk inside a bigger mini-project, like the compute/network/storage folders in the Terraform project. Example: the network module holding a tiny network layout.
- **Rebuild** — Tearing a practice setup down and recreating it from the saved config to prove the notes are honest. Example: re-running the postgres steps on a fresh box.

## A tiny example

The smallest lab thing I can picture — a one-machine practice box described in YAML:

```yaml
name: my-first-box
os: ubuntu
packages:
  - curl
ports:
  - 8080
```

That's it: one box, one package I actually use, one port. It says what I'd spin up if I wanted somewhere harmless to try things.

## What I'll cover next

After this primer I want to write my first real lab environment config and then a short note on what setting up the lab directory taught me — basically, turn this drawer from empty into something I actually practice in.
