---
last_verified: 2026-10-20
tool_version: v1.32.0
sources: []
---

# Following the Kubernetes quickstart — what tripped me up

I went through the official "Kubernetes Basics" tutorial on kubernetes.io today. The six modules walk you through creating a cluster, deploying an app, exploring it, exposing it, scaling it, and updating it. Here's where I got stuck.

## Module 1: Create a cluster

Used `minikube start`. Worked first try. The tutorial also mentions kind and Docker Desktop — I stuck with minikube since it's what I had.

## Module 2: Deploy an app

`kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1` — this worked. Then `kubectl get deployments` showed 1/1 ready.

What tripped me up: the tutorial says "The deployment will create a Pod" but doesn't explain that there's a ReplicaSet in between. I ran `kubectl get pods` and saw a pod with a random suffix, then `kubectl get rs` and saw the ReplicaSet. The chain is Deployment → ReplicaSet → Pod. Wish the tutorial called that out explicitly.

## Module 3: Explore the app

`kubectl get pods` — fine. `kubectl describe pod <name>` — huge output, mostly noise for a beginner. The tutorial says "look at the Events section" but doesn't say what to look *for*. I saw a bunch of "Pulling", "Pulled", "Created", "Started" events and wasn't sure which ones matter.

`kubectl logs <pod-name>` worked. `kubectl exec -it <pod-name> -- /bin/bash` failed with "OCI runtime exec failed" — the container doesn't have bash. Had to use `sh` instead. Tutorial assumes the image has bash.

## Module 4: Expose the app

`kubectl expose deployment/kubernetes-bootcamp --type=NodePort --port=8080` created a Service. `kubectl get services` showed a NodePort in the 30000+ range.

What tripped me up: on minikube, `minikube service kubernetes-bootcamp` opens the browser automatically. But the tutorial says to use `curl $(minikube ip):<nodeport>` — that IP changes on every `minikube start`. I kept using an old IP from a previous session and got connection refused. `minikube ip` gives the current one.

Also: the tutorial doesn't explain *why* NodePort vs ClusterIP vs LoadBalancer. It just says "use NodePort for this tutorial." I had to look up the difference separately.

## Module 5: Scale the app

`kubectl scale deployment/kubernetes-bootcamp --replicas=4` — worked. `kubectl get pods` showed 4 pods.

What tripped me up: scaling down with `--replicas=2` terminates pods but the tutorial doesn't mention that `kubectl scale` is imperative. The declarative way is editing the Deployment YAML and re-applying. I wish the tutorial showed both.

## Module 6: Update the app

`kubectl set image deployment/kubernetes-bootcamp kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v2` — rolling update started. `kubectl rollout status deployment/kubernetes-bootcamp` blocked until done.

What tripped me up: the tutorial says "if something goes wrong, use `kubectl rollout undo`" but doesn't show what "something going wrong" looks like. I tried setting a bad image tag on purpose to see the failure — the rollout stuck at "Waiting for rollout to finish: 1 out of 4 new replicas have been updated..." and `kubectl get pods` showed `ImagePullBackOff`. `kubectl rollout undo` fixed it. That's the kind of concrete failure mode I want to see in a tutorial.

## What I'd try next

- Try the same flow with a local kind cluster instead of minikube — see if the NodePort behavior differs
- Write the Deployment/Service as YAML files instead of imperative commands, then `kubectl apply -f`
- Add a readiness probe to the Deployment so the rollout actually validates the app is healthy