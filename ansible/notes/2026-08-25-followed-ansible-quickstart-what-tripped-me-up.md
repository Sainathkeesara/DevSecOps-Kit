---
last_verified: 2026-08-25
tool_version: n/a
sources:
  - https://betterstack.com/community/guides/linux/ansible-errors/
---

# Followed the official Ansible quickstart — what tripped me up

> Walking through the official quickstart, plus the gotchas the docs skip.

## What I did

I followed the official Ansible quickstart: installed with `pip install ansible`, made a fresh `ansible_quickstart` directory, and wrote a minimal inventory with one test host. Then I ran `ansible all -i inventory -m ping` to verify connectivity.

That first ping failed. Here's the sequence of things that broke and how I got past each one.

## Got stuck on

**1. YAML indentation**
My inventory file looked right to me, but Ansible complained with `Syntax Error while loading YAML. mapping values are not allowed in this context`. I had mixed tabs and spaces, plus a few lines indented with 3 spaces instead of 2. Switching to spaces-only and running `yamllint inventory` caught it immediately.

**2. Host key verification**
Once YAML was fixed, `ansible all -m ping` returned `UNREACHABLE! => {"msg": "Host key verification failed", ...}`. The quickstart never mentions `ansible.cfg`. I created one with `[defaults] host_key_checking = False` just to get moving, but I know that's a test-only setting. The real fix is `ssh-keyscan` on the target first.

**3. Missing sudo privileges**
My first task tried to install `htop` with `apt` and got `Missing sudo password`. I forgot `become: true` at the task level. Adding that made it work — or it would have, once I also passed `--ask-become-pass` on the command line because the target user has no NOPASSWD sudoers entry.

**4. Inventory group typo**
I wrote `[prod:children]` in my inventory but targeted the `webservers` group in my playbook. Ansible silently ran against zero hosts. `ansible-inventory --graph` revealed the mismatch immediately.

**5. Variable precedence surprise**
I set a variable in `group_vars/all.yml` but `ansible-playbook` with `--extra-vars` overrode it without warning. The docs say `--extra-vars` wins over everything, but seeing it in practice is different from accepting it in theory.

## What I'd try next

I want to experiment with `serial: 1` for rolling updates and `throttle` to limit concurrent SSH connections. I also want to try `async`/`poll` for a long-running task so my terminal doesn't sit blocked. After that, I'll move the inventory into a proper project structure with `group_vars/` and `host_vars/`.
