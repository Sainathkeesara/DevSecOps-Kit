---
last_verified: 2026-07-12
tool_version: n/a
sources: []
---

# Explore the Docker CLI

I installed Docker Desktop and started poking around the CLI to see what each command actually does. `docker images` listed the base images I'd pulled, and `docker ps -a` showed every container I'd ever run — even the ones that exited immediately after printing "Hello".

The first thing that tripped me up was `docker run` vs `docker create`. I kept using `run` and wondering why my container disappeared after the command finished. Turns out `run` creates AND starts, so if the command exits, the container stops. Adding `-d` keeps it running in the background, and `--rm` cleans it up when it stops — useful for quick one-off tasks.

Volumes were confusing at first. I tried mounting a host directory with `-v` and accidentally overwrote the container's working directory. Now I always double-check the path order: `-v /host/path:/container/path`, not the other way around.

Networks made more sense once I listed them with `docker network ls`. The default `bridge` network works for single-container setups, but I had to create a custom network with `docker network create` when I wanted two containers to talk to each other by name.
