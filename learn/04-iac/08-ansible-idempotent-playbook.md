---
last_verified: 2026-11-11
tool_version: "v2.22.0"
sources:
  - https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html
  - https://shoreup.co.uk/harden-ssh-with-ansible/
  - https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html
  - https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_privilege_escalation.html
---

# Harden a host with an idempotent Ansible playbook

You saw how configuration management keeps servers in a known state, and you practiced writing valid YAML and filtering JSON with jq. This lesson takes the next step: you will write an Ansible playbook that hardens SSH on a target host, organize it as a reusable role, and prove that running it twice changes nothing the second time — the core idea of idempotence.

## What you'll learn
- Write a playbook with a role that hardens SSH — role directory structure and the `template`/`sshd -t` validation pattern
- Show that `ansible-playbook --check` reports no changes on a second run — idempotence and `changed_when: false`

## Before you start
- [Configuration management — concepts](../../docs/concepts/configuration-management/0000-primer-configuration-management.md) — defines idempotency, desired state, and drift, which this lesson puts into practice with Ansible.
- [Navigate and script on Linux](../01-foundations/02-shell-scripting.md) — you will be writing files and running commands from the shell.
- [YAML, JSON, jq and regex for security tooling](../01-foundations/06-yaml-json-jq-regex.md) — the playbook and role files are YAML; this lesson assumes you can write valid YAML.
- Ansible must be installed on your control node. Confirm it with `ansible --version` (this lesson was written against Ansible v2.22.0) [source: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html].
- A managed node reachable over SSH, with a user that can run `sudo`. The control node needs a UNIX-like OS with Python; the managed node needs Python and an SSH-reachable user with an interactive POSIX shell [source: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html].

## Walkthrough

1. Create an inventory file with one target host. Save it as `inventory.yml`:

   ```yaml
   all:
     hosts:
       target-01:
         ansible_user: deploy
         ansible_host: 192.0.2.10
   ```

   You should see: a valid YAML inventory with one host. Confirm it parses with `ansible-inventory -i inventory.yml --list` — it prints the host as JSON without error.

2. Create the role directory structure. An Ansible role keeps its work in conventional directories; a role needs only the directories it actually uses [source: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html]. Create:

   ```
   roles/ssh-harden/
     tasks/
     handlers/
     templates/
     vars/
   ```

   You should see: four directories under `roles/ssh-harden/`.

3. Write the SSH hardening template. Save it as `roles/ssh-harden/templates/sshd_config.d/99-hardening.conf.j2`:

   ```
   PermitRootLogin no
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```

   You should see: a Jinja2 template with three SSH hardening directives — disable root login, disable password authentication, require public-key auth [source: https://shoreup.co.uk/harden-ssh-with-ansible/].

4. Write the role's tasks. Save as `roles/ssh-harden/tasks/main.yml`:

   ```yaml
   ---
   - name: Ensure sshd hardening drop-in directory exists
     ansible.builtin.file:
       path: /etc/ssh/sshd_config.d
       state: directory
       mode: '0755'
     become: true

   - name: Install SSH hardening drop-in
     ansible.builtin.template:
       src: 99-hardening.conf.j2
       dest: /etc/ssh/sshd_config.d/99-hardening.conf
       mode: '0644'
     become: true
     notify: Validate sshd config

   - name: Validate sshd configuration
     ansible.builtin.command: sshd -t
     become: true
     changed_when: false
   ```

   You should see: three tasks — create the directory, deploy the template, and validate with `sshd -t`. `become: true` runs the tasks with elevated privileges [source: https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_privilege_escalation.html]. `changed_when: false` on the validation task means it never reports a change, which is what makes a validation step idempotent [source: https://shoreup.co.uk/harden-ssh-with-ansible/].

5. Add a handler that validates the sshd config only when the template changes. Save as `roles/ssh-harden/handlers/main.yml`:

   ```yaml
   ---
   - name: Validate sshd config
     ansible.builtin.command: sshd -t
     become: true
     changed_when: false
   ```

   You should see: a handler that runs `sshd -t` (also available as `sshd -T` for the effective configuration) [source: https://shoreup.co.uk/harden-ssh-with-ansible/]. It is triggered by the `notify` in the template task above.

6. Write the playbook that applies the role. Save as `site.yml`:

   ```yaml
   ---
   - name: Harden SSH on target hosts
     hosts: target-01
     become: true
     roles:
       - ssh-harden
   ```

   You should see: a playbook that targets `target-01`, escalates privileges with `become: true`, and applies the `ssh-harden` role. Role entries under `roles:` run before the play's `tasks:` [source: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html].

7. Check the playbook's syntax without running it:

   ```bash
   ansible-playbook -i inventory.yml site.yml --syntax-check
   ```

   You should see: no output and exit code 0 — the playbook parses as valid YAML [source: https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html].

8. Run the playbook in check mode against one host:

   ```bash
   ansible-playbook -i inventory.yml site.yml --check --limit target-01
   ```

   You should see: a summary listing the changes Ansible would make (create the directory, copy the template, run validation) but none applied — `--check` predicts changes without making them [source: https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html]. Keep an interactive SSH session open to the target while testing, so a configuration mistake cannot lock you out [source: https://shoreup.co.uk/harden-ssh-with-ansible/].

9. Run the same check-mode command a second time:

   ```bash
   ansible-playbook -i inventory.yml site.yml --check --limit target-01
   ```

   You should see: `changed=0` for every task — the directory already exists, the template content already matches, and the validation task reports no change thanks to `changed_when: false`. The second run converges to the same desired state: that is idempotence.

## Exercise

On your own, extend the `ssh-harden` role so it also:
- Sets `MaxAuthTries 3` and `ClientAliveInterval 300` in the same `99-hardening.conf.j2` template
- Adds a second validation task that runs `sshd -T` and greps for `permitrootlogin no` (use `changed_when: false`)
- Creates a `roles/ssh-harden/vars/main.yml` that defines `sshd_port: 22` and references it in the template with `{{ sshd_port }}`

Do not paste your solution into the lesson file. Test with `ansible-playbook --syntax-check` and `--check`.

## Check your work

```bash
ansible-playbook -i inventory.yml site.yml --syntax-check
ansible-playbook -i inventory.yml site.yml --check --limit target-01
```

`syntax-check` prints nothing and exits 0. The check-mode run shows `changed=0` across all tasks on the second invocation, proving idempotence.

## Common mistakes

- **Editing `/etc/ssh/sshd_config` directly instead of a drop-in file** — use `/etc/ssh/sshd_config.d/99-hardening.conf` so package upgrades to the main config do not overwrite your hardening [source: https://shoreup.co.uk/harden-ssh-with-ansible/].
- **Disabling password authentication before key login works** — you can lock yourself out. Verify SSH key login first, keep a session open, and test one host with `--limit` [source: https://shoreup.co.uk/harden-ssh-with-ansible/].
- **Forgetting `become: true`** on tasks that write to `/etc/ssh/` — you will get a permission error [source: https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_privilege_escalation.html].
- **Omitting `changed_when: false` on validation tasks** — `sshd -t` reports `changed` every run even when nothing changed, breaking idempotence [source: https://shoreup.co.uk/harden-ssh-with-ansible/].

## Next

[Kubernetes — quick primer](../../kubernetes/notes/0000-primer-kubernetes.md)
