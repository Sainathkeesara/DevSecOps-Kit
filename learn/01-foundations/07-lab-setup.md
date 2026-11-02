---
last_verified: 2026-11-02
tool_version: n/a
sources:
  - https://docs.docker.com/engine/install/ubuntu/
  - https://docs.docker.com/engine/release-notes/29/
  - https://kind.sigs.k8s.io/docs/user/quick-start/
  - https://kind.sigs.k8s.io/docs/user/local-registry/
  - https://github.com/kubernetes-sigs/kind/releases
  - https://kind.sigs.k8s.io/docs/user/known-issues/
---
# Set up the lab and the sample app

You can read structured scanner output. Now you'll build the lab environment that the rest of the path runs in: Docker, a local Kubernetes cluster with kind, and a private image registry. You'll also copy in the sample app and take an inventory of its planted security issues — the secrets and weak configurations that later lessons will scan and fix.

## What you'll learn

- Install Docker, kind and a local registry and confirm each works
- Clone the sample app and list its planted security issues to find later

## Before you start

- [Branch, merge and rebase safely](04-git-branch-merge-rebase.md) — you should be comfortable creating branches, merging, and resolving conflicts
- Docker must be installed on a supported 64-bit Ubuntu release (Jammy 22.04, Noble 24.04, Resolute 26.04, or Stonking 26.10). Confirm your architecture with `uname -m` (expects `x86_64`).
- `curl` must be installed to download kind. Confirm it with `curl --version`.

## Walkthrough

1. Install Docker from the apt repository.

   First remove any conflicting packages, then add Docker's GPG key and package source, then install the engine and the Compose plugin:

   ```bash
   sudo apt-get remove -y docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc || true
   sudo install -m 0755 -d /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt-get update
   sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

   You should see the packages set up without errors.

   Confirm Docker works:

   ```bash
   sudo docker run hello-world
   ```

   You should see `Hello from Docker!` and a message explaining that the command pulled and ran the `hello-world` image.

   *(Docker Engine 29.9.2 is the latest stable release as of this writing.)*

2. Install kind.

   kind (Kubernetes IN Docker) runs local Kubernetes clusters inside Docker containers. Download the v0.33.0 release for Linux AMD64:

   ```bash
   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.33.0/kind-linux-amd64
   chmod +x ./kind
   sudo mv ./kind /usr/local/bin/kind
   ```

   Confirm the install:

   ```bash
   kind version
   ```

   You should see `kind v0.33.0` (kind defaults to Kubernetes 1.37.0 node images).

3. Run a local image registry and create a kind cluster wired to it.

   Start a registry container on port 5001:

   ```bash
   docker run -d --restart=always -p 5001:5000 --name kind-registry registry:3
   ```

   Create a kind cluster config that tells containerd to use the local registry:

   ```yaml
   kind: Cluster
   apiVersion: kind.x-k8s.io/v1alpha4
   containerdConfigPatches:
   - |-
     [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:5000"]
       endpoint = ["http://kind-registry:5000"]
   nodes:
   - role: control-plane
   ```

   Then create the cluster:

   ```bash
   kind create cluster --config kind-config.yaml
   ```

   Confirm the cluster and the registry are both running:

   ```bash
   kubectl cluster-info
   docker ps --filter name=kind-registry
   ```

   You should see the Kubernetes control-plane URL and the `kind-registry` container in the list.

4. Copy the sample app into a working directory.

   The kit ships a multi-service sample app under `docker/templates/multi-service-setup/` — a static web front end, a Python API, and a Postgres database. Copy it out of the kit so your edits stay separate:

   ```bash
   cp -r docker/templates/multi-service-setup ~/devsecops-lab
   cd ~/devsecops-lab
   cp .env.example .env
   ```

   Open `.env` and replace the placeholder `DB_PASSWORD=change-me-before-use` with a real password.

5. List the sample app's planted security issues.

   Open `compose.yaml` and the two `Dockerfile`s and note the issues you will want to fix or scan for later:

   - `db` uses `image: postgres` with no pinned tag — it pulls whatever `latest` is, so rebuilds are not reproducible.
   - `api/Dockerfile` and `web/Dockerfile` both use `FROM python` with no pinned tag — the same reproducibility problem.
   - `.env.example` ships a placeholder database password (`change-me-before-use`), and `compose.yaml` reads `DB_PASSWORD` straight from `.env` — a default secret waiting to be committed.

   These are the planted security issues later lessons will find with secret scanners and image scanners.

## Exercise

1. From your `~/devsecops-lab` directory, confirm Docker is healthy with `docker ps`.
2. Confirm kind is reachable with `kubectl cluster-info`.
3. Confirm the local registry is reachable on port 5001.
4. List every image reference in `compose.yaml` and mark each one as pinned (has a version tag or digest) or unpinned.
5. List every secret or password reference in `compose.yaml` and `.env`.

Do not paste the solution into the lesson file.

## Check your work

```bash
cd ~/devsecops-lab
docker ps
kubectl cluster-info | head -1
curl -s http://localhost:5001/v2/ | head -1
grep -nE 'image:|FROM' compose.yaml web/Dockerfile api/Dockerfile
grep -nE 'password|PASSWORD|secret|SECRET' compose.yaml .env.example
```

`docker ps` lists running containers with no error; `kubectl cluster-info` prints the Kubernetes control-plane URL; the registry returns `{}`, an empty JSON object; the image grep shows `postgres` and `python` without version tags; the secret grep shows `DB_PASSWORD` and `change-me-before-use`.

## Common mistakes

- Forgetting that `docker run hello-world` needs `sudo` unless you've set up Docker for non-root use — run the post-install steps if you get a permission denied error.
- Using `image: postgres` without a tag pulls `latest` silently, so two machines can end up with different database versions.
- Committing `.env` with a real password — add it to `.gitignore` before you commit the sample app.

## Next

[First win: find a secret and a vulnerable package](08-first-scan.md)