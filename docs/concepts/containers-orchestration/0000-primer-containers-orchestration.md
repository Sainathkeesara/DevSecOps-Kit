# Containers & Orchestration — quick primer

> First-day notes on Containers & Orchestration. What it is, why it matters, and the key ideas to know.

## What is it?

A container is a lightweight, standalone package that includes everything needed to run a piece of software — code, runtime, system tools, libraries, settings. Think of it like a shipping container for software: it has the same shape and works the same way whether it's on my laptop, a test server, or in the cloud.

Orchestration is what happens when you have lots of containers to manage. Instead of SSHing into each server and running containers manually, an orchestrator like Kubernetes decides where containers run, restarts them if they crash, scales them up or down based on demand, and handles networking between them.

## Why does it matter for DevSecOps?

Containers change the security model compared to virtual machines. VMs have their own kernel; containers share the host kernel. That makes them more efficient but also means a container escape can compromise the whole node.

In DevSecOps, containers are both the thing we secure and the mechanism we use to run security tools. Scanners like Trivy and Grype scan container images for vulnerabilities. Tools like Falco monitor container behavior at runtime. Orchestration platforms like Kubernetes are where admission controllers (OPA/Gatekeeper, Kyverno) enforce security policies before a pod starts. Understanding containers is necessary to understand most of the security tooling in this space.

## Key terminology

- **Image** — A read-only template with instructions for creating a container. Example: `docker pull nginx:alpine` downloads an image based on Alpine Linux with nginx installed.
- **Container** — A runnable instance of an image. Example: `docker run nginx:alpine` starts a container from the nginx image.
- **Registry** — A server that stores and distributes container images. Example: Docker Hub, GitHub Container Registry, or a private Harbor registry.
- **Dockerfile** — A text file with instructions for building an image. Example: `FROM python:3.12-slim` followed by `COPY . /app` and `CMD ["python", "app.py"]`.
- **Orchestrator** — A system that manages containers across multiple machines. Example: Kubernetes scheduling a pod to run on a node with available CPU.
- **Pod (Kubernetes)** — The smallest deployable unit in Kubernetes. One or more containers that share networking and storage. Example: a web app container and a sidecar logging container in the same pod.
- **Deployment (Kubernetes)** — A Kubernetes resource that declares the desired state for a set of pods. Example: `replicas: 3` tells Kubernetes to always keep three instances running.
- **Service Mesh** — A dedicated infrastructure layer for handling service-to-service communication, often with mTLS encryption. Example: Istio or Linkerd adding encrypted traffic between pods without changing application code.

## A concrete example

Here's a minimal Docker workflow — building an image and running it:

```bash
# Build an image from a Dockerfile
docker build -t myapp:1.0 .

# Run a container from that image, mapping port 8080
docker run -d -p 8080:8080 myapp:1.0

# See running containers
docker ps
```

For orchestration, the same app in Kubernetes would use a Deployment manifest:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:1.0
        ports:
        - containerPort: 8080
```

This tells Kubernetes to keep three copies of my container running. If one crashes, it starts another. If traffic increases, I can scale to more replicas.

## How this connects to what's next

Image scanners (Trivy, Grype, Syft) check images for vulnerabilities before deployment. Runtime monitors (Falco, Tetragon) watch container behavior. Admission controllers (OPA/Gatekeeper) enforce policies when pods are created. Container registries (Harbor, ECR) can be configured to only accept signed images. Understanding containers and orchestration is the foundation for all of those tools.
