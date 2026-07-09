---
last_verified: 2026-07-09
tool_version: n/a
sources: []
---

# Docker — quick primer

> First-day notes for someone who's never used Docker. Personal voice, plain language.

## What is it?

Docker is a tool that packages software and its dependencies into lightweight, portable containers. From what I've read, a container bundles the code, runtime, system tools, and libraries so the app runs the same way on my laptop as it does on a server. It's like a shipping container for code — standardized, stackable, and isolated from the host.

## What does it do?

Docker lets me build images from a Dockerfile, run containers from those images, and manage them with commands like `docker run`, `docker ps`, and `docker stop`. Each container shares the host kernel but has its own filesystem, networking, and process space. That means I can run five different apps that each need a different Python version without them stepping on each other.

## Why does it exist?

Before containers, I'd hear stories of "it works on my machine" disasters where dependencies, library versions, or environment variables differed between dev and prod. Virtual machines solved that but were heavy — each one needed its own full OS copy, taking gigabytes and minutes to boot. Docker containers share the host kernel and start in seconds, using megabytes instead of gigabytes. Developers, DevOps engineers, and security teams all use it daily because it makes shipping and running software far more predictable.

## Key terminology

- **Image** — A read-only template with the app code and dependencies, built from a Dockerfile. Example: `docker build -t myapp:1.0 .` creates an image I can run anywhere.
- **Container** — A running instance of an image with its own isolated environment. Example: `docker run -d -p 8080:80 myapp:1.0` starts a container in the background.
- **Dockerfile** — A text file with step-by-step instructions to assemble an image. Example: `FROM python:3.11`, `COPY app.py /app/`, and `CMD ["python", "app.py"]`.
- **Volume** — Persistent storage that lives outside a container's filesystem. Example: `docker run -v mydata:/app/data myapp:1.0` keeps data safe even if the container is deleted.
- **Network** — A virtual LAN that lets containers talk to each other and the outside world. Example: `docker network create mynet` then `docker run --network mynet ...`.
- **Registry** — A server that stores and distributes images. Example: Docker Hub is the default public registry; I can also run a private one.

## A tiny example

```dockerfile
FROM alpine:3.19
RUN apk add --no-cache curl
CMD ["curl", "-s", "https://ifconfig.me"]
```

This Dockerfile starts from a 5 MB Alpine base, installs `curl`, and runs a one-liner that prints the server's public IP. `docker build -t ip-check . && docker run --rm ip-check` shows the result and cleans up.

## What I'll cover next

I want to get comfortable running containers locally, mount a volume to persist data between runs, and then learn how Docker fits into a CI pipeline. After that I'll look at image hardening — removing the default `root` user, pinning base image digests, and scanning for vulnerabilities.
