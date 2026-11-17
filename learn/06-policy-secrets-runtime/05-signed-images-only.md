---
last_verified: 2026-11-17
tool_version: "n/a"
sources:
  - https://open-policy-agent.github.io/gatekeeper/website/docs/install
  - https://open-policy-agent.github.io/gatekeeper/website/docs/constrainttemplates
  - https://open-policy-agent.github.io/gatekeeper/website/docs/howto
---

# Admit only signed images

You've signed images with Cosign and you've run Gatekeeper as a Kubernetes admission webhook. Now combine them: make Gatekeeper reject any pod whose container image isn't a signed, digest-pinned image. That proves "the image that runs is the image you signed" before a single container starts.

## What you'll learn

- Enforce a signature check at admission
- Show an unsigned image is rejected and the signed one runs

## Before you start

- [Sign the image and attach the SBOM with Cosign](../03-shift-left/12-cosign-sign.md) — you can sign an image keylessly and confirm a digest is signed with `cosign verify`.
- [Reject privileged and root pods with Gatekeeper](02-gatekeeper-admission.md) — Gatekeeper is installed in `gatekeeper-system`, its admission webhook rejects violating pods, and you know how to author a ConstraintTemplate + Constraint.
- `kubectl` pointed at a cluster with Gatekeeper running: `kubectl version --client` prints a client version and `kubectl -n gatekeeper-system get pods` shows the controller pods.

## Walkthrough

### 1. Sign an image and record its signed digest

Cosign signs the image keylessly (OIDC) and pushes the signature alongside the image in the registry:

```bash
IMAGE="ghcr.io/myorg/myapp:latest"
cosign sign --yes "$IMAGE"
```

You should see: Cosign confirms the image was signed and pushed the signature, with no key or password prompt because `--yes` skips the interactive confirmation in CI.

Now capture the digest Cosign verifies against this image — Gatekeeper will admit only this exact pinned reference:

```bash
cosign verify "$IMAGE"
```

You should see: verification passes and the output names the image reference with a digest, e.g. `ghcr.io/myorg/myapp@sha256:0123abcd...`. Set that value to `SIGNED_DIGEST` for the next step:

```bash
SIGNED_DIGEST="ghcr.io/myorg/myapp@sha256:0123abcd..."
```

### 2. Write a Gatekeeper policy that admits only signed images

Gatekeeper's admission webhook runs a Rego ConstraintTemplate against every pod before it's created. The template below requires each container image to be (a) digest-pinned, not a mutable tag, and (b) present in a signed-digest allowlist that you populate from `cosign verify` output. Cosign provides the signatures; Gatekeeper enforces that only signed images run.

Create the companion manifest `cosign/manifests/require-signed-image.yaml`:

```yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8srequiresignedimage
spec:
  crd:
    spec:
      names:
        kind: K8sRequiresSignedImage
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8s.requiresignedimage

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          image := container.image
          not endswith(image, "@")
          msg := sprintf("Container %v must use a pinned image digest, got %v", [container.name, image])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          image := container.image
          endswith(image, "@")
          not parameters.signedDigests[_] == image
          msg := sprintf("Container %v image %v is not in the signed-digest allowlist", [container.name, image])
        }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiresSignedImage
metadata:
  name: require-signed-image
spec:
  enforcementAction: deny
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces:
      - kube-system
      - gatekeeper-system
  parameters:
    signedDigests:
      - "PLACEHOLDER_REPLACE_WITH_SIGNED_DIGEST"
```

Apply it:

```bash
kubectl apply -f cosign/manifests/require-signed-image.yaml
```

You should see: `constrainttemplate.templates.gatekeeper.sh/k8srequiresignedimage created` and `k8srequiresignedimage.constraints.gatekeeper.sh/require-signed-image created`, and the `K8sRequiresSignedImage` CRD becomes available.

Populate the allowlist with your signed digest:

```bash
kubectl patch k8srequiresignedimage require-signed-image --type merge -p "{\"spec\":{\"parameters\":{\"signedDigests\":[\"$SIGNED_DIGEST\"]}}}"
```

### 3. Show an unsigned image is rejected, then the signed one runs

Try an unsigned image (a mutable tag that isn't in the allowlist):

```bash
kubectl run unsigned-pod --image=nginx:latest --restart=Never
```

You should see: `Error from server (Forbidden): admission webhook "validation.gatekeeper.sh" denied the request: ... Container unsigned-pod must use a pinned image digest ...`. Gatekeeper blocks the pod before the image is ever pulled.

Now run the signed, digest-pinned image:

```bash
kubectl run signed-pod --image="$SIGNED_DIGEST" --restart=Never
```

You should see: `pod/signed-pod created`. Gatekeeper admits the pinned, signed image. (The placeholder image may not pull, but admission — what this policy controls — has succeeded.)

Clean up:

```bash
kubectl delete pod unsigned-pod signed-pod --ignore-not-found
```

## Exercise

Working alone, with Gatekeeper still running:

1. Sign a second image of your own with `cosign sign --yes`, capture its digest from `cosign verify`, and add it to the `require-signed-image` constraint's `signedDigests` parameter.
2. Deploy that second image as a pod and confirm Gatekeeper admits it.
3. Deploy any unsigned image (a mutable tag not in the allowlist) and confirm Gatekeeper rejects it.
4. Remove your test digests and delete the test pods.

Do not paste the solution into the lesson file.

## Check your work

```bash
kubectl get constrainttemplate k8srequiresignedimage
kubectl get k8srequiresignedimage require-signed-image -o yaml
```

The template exists, and the constraint shows `enforcementAction: deny` with your signed digests in `spec.parameters.signedDigests`.

```bash
kubectl run <your-signed-image@digest> --restart=Never   # admitted
kubectl run <unsigned-image:tag> --restart=Never          # rejected by validation.gatekeeper.sh
```

## Common mistakes

- Relying on a mutable tag (`:latest`) instead of a pinned digest: Gatekeeper admits the tag reference, but the image behind the tag can change after you signed it, so the running image may no longer match what Cosign verified. Always pin `@sha256:...`.
- Forgetting `excludedNamespaces`: Gatekeeper audits `kube-system` and `gatekeeper-system` too, and system components that legitimately run images outside your allowlist get blocked.
- Setting `enforcementAction: dryrun` (or `warn`): violations are audited but not blocked, so an unsigned image still runs.
- Testing Gatekeeper rules with top-level `input` instead of `input.review.object`: a rule that passes locally never fires under Gatekeeper, because Gatekeeper nests the reviewed object under `input.review.object.spec`.

## Next

[Container and runtime security — concepts](../../docs/concepts/container-runtime-security/0000-primer-container-runtime-security.md)
