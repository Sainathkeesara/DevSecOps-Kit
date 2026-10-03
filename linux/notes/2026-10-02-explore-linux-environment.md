---
last_verified: 2026-10-02
tool_version: n/a
---

# Poking around my Linux box for the first time

I finally sat down and just looked at what's actually on this machine instead of
guessing. First thing I ran was `uname -a` and `cat /etc/os-release` so I know
what I'm even working with — I keep mixing up which distro this is.

Then I wandered around a bit. `ls /` showed me the usual layout (etc, var, home,
usr — the names I half-remember from tutorials). I checked `whoami` and `pwd`
because I got lost twice, and `df -h` told me how much disk I have free, which
was honestly more than I expected.

What tripped me up: I tried `ls /root` out of curiosity and got permission
denied, which makes sense now that I think about it — I'm not root. Also `ps
aux | head` printed way more running stuff than I thought a quiet box would
have. I recognised sshd and systemd but most of the lines are still a mystery.

What I'd try next: figure out what half those processes are, and learn how to
tell which ones are supposed to be there.
