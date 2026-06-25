# Linux & Shell Fundamentals — quick primer

> First-day notes on Linux & Shell Fundamentals. What it is, why it matters, and the key ideas to know.

## What is it?

Linux is an open-source operating system kernel that powers a huge portion of the internet, from the web servers hosting your favorite sites to the container runtimes in your Kubernetes cluster. But when people talk about "Linux" in a devops context, they usually mean the entire ecosystem: the kernel, a distribution like Ubuntu or RHEL, the GNU userland tools, and the command-line shell through which you interact with it all.

The shell is the program that interprets the commands I type. Bash (Bourne Again SHell) is the most common default on Linux systems, though alternatives like Zsh and Fish exist. Shell scripting lets me string together sequences of commands, control flow with if statements and loops, and automate repetitive tasks. It's the glue layer that connects all the other tools in a devops workflow — pulling code from Git, running builds, checking service health, rotating logs, and handling error conditions.

## Why does it matter for devops?

If I had to pick one skill that separates a junior from a mid-level devops engineer, it's comfort at the Linux command line. Servers don't usually have graphical interfaces — they have SSH and a shell prompt. Everything I need to investigate, troubleshoot, or fix lives behind that prompt. Shell scripting lets me codify repeatable operational work so it can be version controlled, peer reviewed, and run unattended. Whether I'm writing a deployment script, building a Dockerfile, or debugging a running system, I'm going to spend most of the time typing commands into a terminal.

## Key terminology

- **Kernel** — The core of the operating system that manages hardware resources and system calls. Example: the Linux kernel handles memory allocation for running processes.
- **Distribution (distro)** — A packaged version of the Linux kernel plus utilities and package manager. Example: Ubuntu, Debian, CentOS, Alpine.
- **Shell** — The command-line interpreter that takes my input and executes programs. Example: Bash reads the line `ls -la` and runs the `ls` program with those flags.
- **Pipeline (`|`)** — A mechanism to pass the output of one command as input to another. Example: `cat app.log | grep ERROR | wc -l` counts error lines in a log file.
- **Redirection (`>`, `>>`, `<`)** — Sending command output to a file or reading input from a file. Example: `echo "started" >> deploy.log` appends a timestamped marker to a log.
- **Exit code** — A numeric value a process returns when it finishes, where 0 means success and anything else means failure. Example: `$?` in Bash tells me the exit code of the last command.
- **Shebang (`#!/bin/bash`)** — The `#!` sequence at the top of a script that tells the system which interpreter to use. Example: `#!/bin/bash` at line one of a script makes Bash the default runner.
- **Variable** — A named container for data in a shell script. Example: `DEPLOY_ENV="staging"` stores an environment name I can reference later.
- **Process** — A running instance of a program. Each shell command I run spawns at least one process.

## A concrete example

```bash
#!/bin/bash
set -euo pipefail

SERVICES=("nginx" "postgres" "redis")
LOG_DIR="/var/log/myapp/health"

for svc in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$svc"; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') $svc healthy" >> "$LOG_DIR/health.log"
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S') $svc DOWN — attempting restart" >> "$LOG_DIR/health.log"
    systemctl restart "$svc" || echo "Restart failed for $svc" >> "$LOG_DIR/health.log"
  fi
done
```

This script checks whether a list of services are running, logs the result with a timestamp, and attempts a restart if something is down.

## How this connects to what's next

Linux and shell skills are the baseline for almost every other tool in this kit. With these fundamentals solid, I can write effective Dockerfiles, create CI/CD pipeline scripts, manage infrastructure through Terraform remote-exec provisioners, debug applications running inside containers, and interact with Kubernetes nodes. Most of the "glue" work in devops is just well-crafted shell scripts.
