---
last_verified: 2026-08-17
tool_version: n/a
---

# Install Linux in a VM and run my first commands — what tripped me up

I installed Linux in a virtual machine before touching real hardware. Picked Ubuntu, downloaded the ISO, and worked through the VirtualBox setup. The whole install took maybe twenty minutes.

First surprise: the installer wanted me to set a root password and create a regular user — I almost made them the same thing. Second: after the first reboot I landed on a text login prompt, not a desktop, because the VM was using the default display driver. Logging in at the TTY and running `sudo apt update && sudo apt upgrade` was where my first real commands happened.

What tripped me up:

- `ls` alone was fine, but I kept needing `ls -la` to see hidden files and permissions.
- `cd` did nothing visible and I thought it was broken — no, it just doesn't print anything.
- I used `sudo` for everything at first, then wondered why I'd created root-owned files. Lesson: use `sudo` only when a command actually needs it.
- Tab completion saved me; I relied on it constantly.

The first commands that stuck: `pwd`, `ls -la`, `cd`, `mkdir`, `touch`, `cat`, `man`. Getting comfortable with `man ls` instead of guessing was a small win.

Next I want to get comfortable with file permissions (`chmod`, `chown`) and moving files around, then write my first shell script.