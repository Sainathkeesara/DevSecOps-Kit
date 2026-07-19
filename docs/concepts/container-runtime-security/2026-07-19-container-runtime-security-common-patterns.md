---
last_verified: 2026-07-19
tool_version: n/a
---

# Container & Runtime Security — common patterns

> Following the quickstart, here's what worked and where it broke.

## Dropping capabilities

I started by running an nginx container with default settings, then tightened it with `--cap-drop ALL`. The container kept restarting because nginx needs `CAP_NET_BIND_SERVICE` to bind to port 80. I ended up doing `--cap-drop ALL --cap-add NET_BIND_SERVICE` and that worked. The lesson is: drop everything, then add back only what the process actually needs.

I later tried the same approach with a Python Flask app and discovered it needs no special capabilities at all — it listens on an unprivileged port by default. That contrast between nginx (needs one capability) and Flask (needs none) is exactly why I can't use a one-size-fits-all capability drop; every base image and entrypoint is different.

## Read-only root filesystem

Next I tried `--read-only`. Most application containers need somewhere to write temp files, so a completely read-only root breaks them. The fix is mounting a tmpfs at `/tmp` and setting writable directories explicitly. I found that setting `TMPDIR=/tmp` in the environment plus `--mount type=tmpfs,dst=/tmp` covers most cases.

But I also ran into a subtle issue: some apps write to `/var/run` or `/var/log` even when they don't need to. Adding `--tmpfs /var/run:size=64m` fixed that. The pattern is: start fully read-only, let the app crash, read the error, mount a tmpfs for that specific path, repeat until it runs cleanly.

## seccomp profiles

I used the default Docker seccomp profile and it blocked a few things my app needed (like `clone` with certain flags). I generated a custom profile with `--seccomp-profile default.json`, then allowed the specific syscall. The workflow was: run the app, capture the audit log, whitelist the missing syscall, retest.

The tricky part was that seccomp violations don't always surface as loud errors. Sometimes the app just hangs or returns garbage data. I learned to check `dmesg` or `journalctl -u docker` for `seccomp` violation messages to see what was actually being blocked.

## User namespaces and non-root users

Running as root inside the container is common and convenient, but it means a container escape gives the attacker root on the host too. I added `--user 1000:1000` to shift to an unprivileged user inside the container. The catch is that the image must have a user with that UID and writable working directory, otherwise you get permission denied on startup.

## Got stuck on

- Default seccomp profile being too restrictive for some language runtimes
- Figuring out which capabilities nginx actually needs vs what the base image adds
- Volume mounts and read-only root filesystems interacting in unexpected ways
- Non-root user UID not existing in the base image, causing silent permission failures

## What I'd try next

I want to explore eBPF-based monitoring with Tetragon next — watching syscalls without modifying the container at all seems cleaner than maintaining custom seccomp profiles.
