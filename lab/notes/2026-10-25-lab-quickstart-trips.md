---
last_verified: 2026-10-25
tool_version: n/a
sources: []
---

# lab — following the quickstart and what tripped me up

> First-day notes. Personal voice, plain language.

## What I did

I opened the lab quickstart guide (the `lab/` directory structure and the primer) and tried to build my first real mini-project from scratch. The idea was to create a small practice environment that actually runs something, not just reads like a plan.

I picked a simple goal: a two-node setup where one node runs a web server and the other runs a database. Something I can curl against and see data come back. The quickstart says each mini-project gets its own folder under `lab/mini-projects/` with a README and whatever config it needs.

## What worked

Creating the folder structure was straightforward. I made `lab/mini-projects/two-node-web-db/` and dropped in a `README.md` that says what I'm trying to prove — that I can spin up two containers, wire them together, and hit an endpoint that queries the DB.

The environment config format from the primer (`name`, `purpose`, `machine` with `os`, `packages`, `ports`) mapped cleanly to what I needed. I wrote a config for each node:

```yaml
# web node
name: web-node
purpose: serves a simple API that talks to the db node
machine:
  os: ubuntu
  packages:
    - python3
    - python3-pip
  ports:
    - 8080
```

```yaml
# db node
name: db-node
purpose: postgres database for the web node
machine:
  os: ubuntu
  packages:
    - postgresql
  ports:
    - 5432
```

Running `docker compose up` (after I wrote a compose file by hand) brought both up and I could `curl localhost:8080/health` and get a response. That felt good — the config-to-running-box path works.

## Where I tripped up

**The config doesn't run itself.** I wrote the YAML configs and expected… something to read them and spin up the boxes. But the lab configs are just documentation — they describe what *should* exist. I had to manually write a `docker-compose.yml` that matches the config. The primer hints at this ("rebuild me from this file if the box gets messy") but I didn't internalize it until I stared at the YAML waiting for it to do something.

**Port mapping in compose vs. the config.** In my lab config I listed `ports: [8080]` for the web node. In docker-compose that becomes `ports: ["8080:8080"]` — host:container. I forgot the host side the first time and the container port was exposed but not reachable from localhost. Tiny thing, but it ate 20 minutes.

**Shared network isn't automatic.** The two containers need to talk to each other. In compose I added a `networks:` block and put both services on it. The db node's hostname inside that network is just the service name (`db-node`), so the web node connects to `postgresql://user:pass@db-node:5432/mydb`. The lab config has no field for "this node talks to that node" — I had to know to add the network in compose.

**Postgres initialization order.** The web node starts faster than postgres is ready to accept connections. My first Python script crashed on startup with "connection refused." I added a retry loop with `time.sleep(2)` and `psycopg2.connect()` in a try/except. The lab quickstart doesn't cover service readiness — it's a generic infrastructure problem, not a lab-specific one, but it bit me here.

**Where does the README live?** The primer says "each mini-project keeps its README and its config together." I put the README in the mini-project folder and the YAML configs in `lab/configs/` (following the existing pattern). But then the config is separated from the project that uses it. Next time I'll probably keep a copy of the config inside the mini-project folder so the whole thing is self-contained.

## What I'd try next

I want to make the "rebuild from config" idea real — write a small script that reads the lab YAML configs and generates a docker-compose file (or a shell script that spins up the boxes). That way the config *does* become the source of truth, not just a description.

Also, the two-node thing worked but it's still manual. I'd like to try the Terraform mini-project that's already in `lab/mini-projects/` — it has compute/network/storage modules. See if I can use that pattern to declare the two nodes in HCL and have Terraform create the actual resources (even if just local docker containers via the docker provider).

The lab directory is shaping up to be exactly what the primer promised: a drawer where I keep working examples I can come back to. This two-node project is now the third mini-project in there, and I can actually rebuild it from the notes.