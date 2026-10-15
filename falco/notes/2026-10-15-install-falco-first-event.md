---
last_verified: 2026-10-15
tool_version: n/a
sources: []
---

# Installing Falco and waiting for my first event

I wanted to install Falco today and watch one runtime event land in the log. I did not get that far, but I mapped out why.

## What I tried

I checked for a `falco` binary on this box first — nothing there. Then I re-read the kit's earlier install note (`2026-06-10-install-falco-first-detection.md`): that path installs Falco as a DaemonSet with Helm, which needs a real cluster with nodes Falco can watch. I don't have one here, so running the install steps would just fail.

I also peeked at the kit's `falco/configs/` dir to see what a rule file looks like on disk, so the install isn't a total mystery when I do get a node.

## What tripped me up

Falco watches syscalls on a real node, so there is nothing to install inside a plain container with no privileged driver. I kept wanting to just run something and see output, but without a node there is nothing to watch — no event to log.

## What I'd try next

Get a throwaway VM I can install on, run the shell-in-container trigger from the earlier note, and save the raw event line next to this note so I can compare mine against it.
