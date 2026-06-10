# Falco — quick primer

> First-day notes for someone who's never used Falco. Personal voice, plain language.

## What is it?
Falco is a Kubernetes-native runtime security tool. It watches what's happening inside containers and hosts in real time. Think of it like a security camera for your running workloads — it catches weird behavior as it happens, not after the fact.

## What does it do?
Falco uses eBPF to monitor system calls. When something suspicious occurs — like a shell spawning inside a container — it fires an alert. You can send those alerts to Slack, PagerDuty, or wherever your team watches for incidents.

## Why does it exist?
Before Falco, you'd rely on image scanning tools that only check for known vulnerabilities. Those tools miss zero-days, compromised credentials, or attackers who've already gotten in. Falco watches the running system and catches live threats.

## Key terminology
- **eBPF** — Linux kernel feature that lets Falco attach tiny probes to run safely inside the kernel. No agent modifications needed.
- **Rules** — YAML files that define what counts as suspicious. Example: `shell_spawned_in_container`.
- **Syscall** — A request from a program to the kernel. Example: `execve` fires when any process runs a command.
- **Priority** — Alert severity level (emergency, alert, warning, info). Example: set shell-in-container to `warning`.
- **Output** — Where Falco sends alerts (stdout, file, webhook). Example: POST to a Slack channel.

## A tiny example
```yaml
# A minimal Falco rule that fires when bash is executed inside a container
- rule: Shell in Container
  desc: Detect bash shell execution in any container
  condition: container and spawned_process and proc.name = bash
  output: Shell ran in container (user=%user.name command=%proc.cmdline)
  priority: WARNING
```
This watches for any `bash` process started inside a container and writes the alert to stdout.

## What I'll cover next
Next I want to get Falco actually running, install the driver, and trigger my first real alert against a test container. Then I'll start writing rules that match my actual cluster policy.
