---
last_verified: 2026-07-06
tool_version: n/a
sources:
  - https://argo-cd.readthedocs.io/en/latest/getting_started/
  - https://www.guvi.in/blog/argocd-gitops-tutorial/
  - https://markaicode.com/howto/argocd-setup-and-configuration-guide/
---

# Install ArgoCD on a local cluster and deploy my first app

I finally got ArgoCD running locally. Here's what worked and where I tripped.

## What I did

First, the hard requirement nobody mentioned up front: **I needed a running Kubernetes cluster**. I grabbed Kind since I already had it. Without a cluster (or with a broken `kubectl` context) the first `kubectl apply` of the install manifest just errors cryptically.

```bash
kind create cluster --name argocd-lab
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Then I forwarded the API server port so I could log in:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
argocd login localhost:8080 --username admin --insecure
```

## What tripped me up

- **The x509 cert warning.** `argocd login` printed `x509: cannot validate certificate`. I thought the install was broken. It's just the self-signed cert — `--insecure` is fine for a local lab. (Saw this called out on a setup guide; expected behavior, not a failure.)
- **The admin password isn't what I expected.** It's auto-generated and stored in a Secret. I had to decode it:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d; echo
  ```
- **The `.git` suffix trap.** I added my repo URL without `.git` and `argocd repo add` accepted it happily — no error. The failure only showed up later when the Application tried to sync ("repository not found"). Add the `.git` suffix.
- **Port-forward timed out** after a while and I thought ArgoCD died. It's just the tunnel; re-run the `port-forward` and you're back.

## Deploying the first app

I created an Application pointing at a public guestbook repo, then synced it:

```bash
argocd app create guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path guestbook --dest-server https://kubernetes.default.svc \
  --dest-namespace default
argocd app sync guestbook
```

## What I'd try next

Look at `prune`/`selfHeal` behavior and write my own Application manifest by hand instead of using `argocd app create`.
