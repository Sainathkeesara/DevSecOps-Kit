---
last_verified: 2026-11-03
tool_version: n/a
sources:
  - https://docs.docker.com/engine/release-notes/29/
  - https://docs.docker.com/reference/dockerfile/
---

# Build the sample app image

The lab is set up and the sample app is cloned. Now you'll package it as a container image with a Dockerfile, then run it together with its database using a network and a volume.

## What you'll learn

- Write a Dockerfile for the sample app and build it
- Use networks and volumes to run it with its database

## Before you start

- [Docker — quick primer](../../docker/notes/0000-primer-docker.md) — you should know the difference between an image and a container
- [Containers and orchestration — concepts](../../docs/concepts/containers-orchestration/0000-primer-containers-orchestration.md) — you should understand what a container is
- [Set up the lab and the sample app](../01-foundations/07-lab-setup.md) — Docker installed, sample app cloned
- Confirm Docker works: `docker --version`

## Walkthrough

1. Create a Dockerfile for the sample app.

   The sample app ships a small web service. Write a `Dockerfile` in the app directory:

   ```dockerfile
   FROM python:3.12-slim

   WORKDIR /app

   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt

   COPY . .

   EXPOSE 8000

   CMD ["python", "app.py"]
   ```

   You should see the file written to disk.

2. Build the image.

   ```bash
   docker build -t sample-app:dev .
   ```

   You should see `Successfully built` and a image ID in the output.

3. Create a network so the app and database can talk.

   ```bash
   docker network create sample-app-net
   ```

   You should see the network name printed.

4. Start the database with a named volume for persistence.

   ```bash
   docker volume create sample-app-db
   docker run -d --name db \
     --network sample-app-net \
     -v sample-app-db:/var/lib/postgresql/data \
     -e POSTGRES_PASSWORD=secret \
     postgres:16
   ```

   You should see a container ID printed.

5. Run the sample app on the same network.

   ```bash
   docker run -d --name app \
     --network sample-app-net \
     -p 8000:8000 \
     -e DATABASE_URL=postgres://postgres:secret@db:5432/postgres \
     sample-app:dev
   ```

   You should see a container ID printed.

6. Verify the app responds.

   ```bash
   curl http://localhost:8000
   ```

   You should see the app's greeting or health-check response.

## Exercise

Build the sample app image yourself, then run it with a database using a dedicated network and a named volume. Confirm both containers are running and the app can reach the database.

## Check your work

Run `docker ps` and confirm both `app` and `db` containers show `Up`. Run `curl http://localhost:8000` and confirm a successful response.

## Common mistakes

- Forgetting to put both containers on the same network, so the app cannot resolve the `db` hostname.
- Using an anonymous volume and losing data when the container is removed; use a named volume instead.

## Next

[CI/CD pipeline concepts](../../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md)