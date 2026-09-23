---
last_verified: 2026-09-23
tool_version: n/a
---

# Docker multi-service setup — project scaffold

## Purpose

This template gives you a starting layout for a small multi-service application managed with Docker Compose: a static web front end, a Python API, and a Postgres database. It is one way to structure such a project; the docs also show single-service and externally-managed-database patterns, so treat this as a local-learning scaffold rather than the only layout.

## When to use

Reach for this scaffold when you want to practise how services find each other on a Compose network, how one service can wait on another's health check, and how named volumes keep database data across restarts. If you only need a single container, the simpler starting point in `../../scripts/build-multi-service-compose-app.sh` is probably enough.

## Prerequisites

- Docker with the Compose plugin available (`docker compose version` should print a version).
- A copy of this directory to work in, plus a `.env` file created from `.env.example` with a real `DB_PASSWORD`.

## Steps

1. Copy the template out of the kit so your edits stay separate from the original:

   ```bash
   cp -r docker/templates/multi-service-setup ~/my-multi-service-app
   cd ~/my-multi-service-app
   cp .env.example .env
   ```

2. Open `.env` and replace the placeholder password. Compose refuses to start without it because the compose file requires `DB_PASSWORD` to be set.

3. Build and start the stack:

   ```bash
   docker compose -f compose.yaml up --build -d
   ```

4. Confirm all three services are running:

   ```bash
   docker compose -f compose.yaml ps
   ```

## Verify

- Open `http://localhost:8080` — you should see the "Multi-service setup is running" page from the web container.
- Query the API health endpoint — you should get a JSON status reply:

  ```bash
  curl http://localhost:8000/health
  ```

- Check the API can reach the database through the Compose network (the `depends_on` health condition already gates startup on this, so a running API implies the database answered `pg_isready`).

## Common errors

- **Compose exits complaining about `DB_PASSWORD`.** You skipped the `.env` step or left the variable empty. Copy `.env.example` to `.env` and set a value.
- **The API container restarts in a loop.** The database is probably still initialising. Wait a minute and re-run `ps`; the health-gated dependency means the API only starts once the database reports healthy.
- **Port already in use.** Something else on your machine holds 8080 or 8000. Either stop it or change the left-hand side of the port mapping in `compose.yaml`.

## References

- Sibling learner script for a smaller two-service variant: `../../scripts/build-multi-service-compose-app.sh`
- Template files in this directory: `compose.yaml`, `web/Dockerfile`, `api/Dockerfile`, `api/app.py`, `.env.example`
