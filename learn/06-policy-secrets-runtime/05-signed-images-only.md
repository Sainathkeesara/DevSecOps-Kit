---
last_verified: 2026-11-18
tool_version: "v3.1.4"
sources:
  - https://ratify.dev/docs/plugins/verifier/cosign/
  - https://github.com/sigstore/cosign-gatekeeper-provider/
  - https://github.com/sigstore/cosign/releases/tag/v3.1.4
  - https://open-policy-agent.github.io/gatekeeper/website/docs/install
  - https://open-policy-agent.github.io/gatekeeper/website/docs/constrainttemplates
---

# Admit only signed images

You can sign an image keylessly with Cosign (the signing lesson) and Gatekeeper can reject a pod before it runs (the Gatekeeper admission lesson). What is missing is the link between them: Gatekeeper sees the image reference in a pod spec, but it cannot verify a Cosign signature on its own. This lesson closes that gap by wiring Ratify — Sigstore's built-in Cosign verifier — into Gatekeeper as an external-data provider, so the cluster admits only digest-pinned, Cosign-signed images and rejects everything else.

## What you'll learn

- Enforce a signature check at admission with Gatekeeper + Ratify external data, because Gatekeeper cannot verify Cosign signatures natively
- Pin each image to its digest with `cosign triangulate`, then show an unsigned image is rejected and the signed one runs

## Before you start

- [Sign the image and attach the SBOM with Cosign](../03-shift-left/12-cosign-sign.md) — you can sign an image keylessly and verify it with `cosign verify`.
- [Reject privileged and root pods with Gatekeeper](02-gatekeeper-admission.md) — Gatekeeper is installed with its admission CRDs, and you can apply a ConstraintTemplate + Constraint to a cluster.
- [Cosign — quick primer](../../cosign/notes/0000-primer-cosign.md) — Cosign's signing and verification model, including keyless OIDC signing.
- `cosign` v3.1.4 installed: `cosign version` reports the release [source: https://github.com/sigstore/cosign/releases/tag/v3.1.4]
- Gatekeeper installed in a reachable cluster with `--enable-external-data`, which Ratify requires [source: https://open-policy-agent.github.io/gatekeeper/website/docs/install]
- Ratify installed with the Cosign verifier [source: https://ratify.dev/docs/plugins/verifier/cosign/]
- `kubectl version --client` prints a client version

## Walkthrough

### 1. Confirm Gatekeeper's CRDs are established before applying anything

Gatekeeper registers its own CRDs (`ConstraintTemplate`, `Constraint` kinds). Applying a Constraint before the CRD is established fails with "no matches for kind" — wait for `Established` first [source: https://open-policy-agent.github.io/gatekeeper/website/docs/constrainttemplates].

```bash
kubectl get crds | grep gatekeeper
```

You should see `constrainttemplates.gatekeeper.sh` and `constraints.gatekeeper.sh` listed. If they are absent or not yet `Established`, install Gatekeeper first (cluster-admin required) and wait for the controller pods to be `Running` in `gatekeeper-system`.

### 2. Understand why Gatekeeper needs Ratify for Cosign signatures

Gatekeeper's admission webhook sees the image reference, but it has no built-in Cosign verification — it cannot check whether that image was signed, by whom, or against which key. Ratify is Sigstore's built-in Cosign verifier and runs as a Gatekeeper external-data provider: Gatekeeper sends the image to Ratify, Ratify evaluates its trust policy (keyless OIDC identity, issuer/subject pinning), and returns a signed/unsigned decision [source: https://ratify.dev/docs/plugins/verifier/cosign/]. The archived `cosign-gatekeeper-provider` must not be used [source: https://github.com/sigstore/cosign-gatekeeper-provider/].

Ratify performs tag-to-digest mutation by default, so a tag-based trust scope won't match reliably — scope your Ratify trust policy to a digest, or use a wildcard scope [source: https://ratify.dev/docs/plugins/verifier/cosign/].

### 3. Write the ConstraintTemplate: digest-pin check first, then signature check

Create `opa/manifests/signed-images-only.yaml` with a ConstraintTemplate wrapping two Rego rules, plus a Constraint scoped to all Pods:

```yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8ssignedimagesonly
spec:
  crd:
    spec:
      names:
        kind: K8sSignedImagesOnly
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8s.signedimagesonly

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          image := container.image
          # Digest-pin check (the fix): tags are mutable, so require image@sha256:...
          # contains(image, "@") matches a digest reference; endswith(image, "@")
          # never matches one, which previously let unsigned tagged images through.
          not contains(image, "@")
          msg := sprintf("Container %v uses a mutable tag (%v); pin to a digest before admission", [container.name, image])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          image := container.image
          contains(image, "@")
          # Gate the allowlist on digest-pinned images: only a verified, signed image
          # is admitted. Ratify external data returns the verification decision; match
          # the response field to Ratify's external-data contract for your deployment.
          not data.external.ratify[image].verified
          msg := sprintf("Container %v image %v is not a verified signed image — admission denied", [container.name, image])
        }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sSignedImagesOnly
metadata:
  name: block-unsigned-images
spec:
  enforcementAction: deny
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces:
      - kube-system
      - gatekeeper-system
```

Apply it:

```bash
kubectl apply -f opa/manifests/signed-images-only.yaml
```

You should see `constrainttemplate.templates.gatekeeper.sh/k8ssignedimagesonly created` and `k8ssignedimagesonly.constraints.gatekeeper.sh/block-unsigned-images created`.

### 4. Sign an image and pin it to its digest

Sign your image keylessly (as in the signing lesson), then resolve the tag to its immutable digest with `cosign triangulate` [source: ../../cosign/docs/cosign-verification-patterns.md]:

```bash
IMAGE="ghcr.io/myorg/myapp:latest"
cosign sign --yes "$IMAGE"
DIGEST="$(cosign triangulate "$IMAGE")"
echo "$DIGEST"
```

You should see: a digest reference like `ghcr.io/myorg/myapp@sha256:...` — the immutable artifact that was actually signed.

Confirm the signed digest verifies (exit 0):

```bash
cosign verify \
  --certificate-identity-regexp '^https://github\.com/myorg/myapp/\.github/workflows/ci\.yml@refs/heads/main$' \
  --certificate-oidc-issuer-regexp '^https://token\.actions\.githubusercontent\.com$' \
  "ghcr.io/myorg/myapp@${DIGEST#*@}"
```

You should see: verification succeeds (exit 0) and lists the OIDC certificate issuer and subject.

### 5. Reject an unsigned image, admit the signed one

Plant a pod that runs an unsigned, tag-referenced image:

```bash
kubectl run unsigned-pod --image=ghcr.io/myorg/myapp:latest
```

You should see: Gatekeeper denies the request — the image is not digest-pinned (no "@"), so the first Rego rule fires and the pod is not created.

Now deploy the digest-pinned, signed image:

```bash
kubectl run signed-pod --image="ghcr.io/myorg/myapp@${DIGEST#*@}"
```

You should see: `pod/signed-pod created` — Ratify's external-data decision reports the image as verified signed, so Gatekeeper admits it.

Finally, confirm a signed image from a different identity is rejected too: Ratify's trust policy pins the issuer/subject, so a signature from another CI workflow fails verification and the pod is denied.

## Exercise

Working alone, with Gatekeeper + Ratify still running:

1. Create a Ratify trust policy that requires keyless verification from your own CI identity (`certificateIdentityRegExp` / `certificateOIDCIssuerRegExp`), scoped to a digest.
2. Sign an image you control with `cosign sign --yes`, triangulate it to a digest, and confirm `cosign verify` exits 0 against `image@sha256:...`.
3. Apply the `K8sSignedImagesOnly` Constraint and deploy an unsigned image — confirm Gatekeeper rejects it.
4. Deploy the same image pinned to its signed digest — confirm Gatekeeper admits it.
5. Deploy an image signed by a different identity — confirm Gatekeeper rejects it.

Do not paste your solution into the lesson file.

## Check your work

```bash
kubectl get constrainttemplate k8ssignedimagesonly
```
lists the template, and
```bash
kubectl get k8ssignedimagesonly block-unsigned-images -o yaml
```
shows the enforced Constraint with `enforcementAction: deny`.

- `cosign triangulate` returns a digest reference containing "@" (`image@sha256:...`).
- `cosign verify image@sha256:...` exits 0 for the signed image and non-zero for an unsigned one — gate your pipeline on the exit code (`set -e` or check `$?`) so unsigned images can't slip through.
- An unsigned pod is rejected with `validation.gatekeeper.sh`, while the digest-pinned signed pod is created.

## Common mistakes

- **Verifying a tag instead of the digest signed at build time.** A tag can be re-pointed after signing, so a signature against a tag may no longer match what runs. Always `cosign triangulate` then verify `image@sha256:...` [source: ../../cosign/docs/cosign-verification-patterns.md].
- **Using `endswith(image, "@")` for the digest-pin check.** A digest reference `image@sha256:abc...` contains "@" but does not end with it — that check never matches and lets unsigned tagged images through. Use `contains(image, "@")`.
- **Applying the Constraint before the ConstraintTemplate CRD is established** → "no matches for kind"; wait for `Established` first [source: https://open-policy-agent.github.io/gatekeeper/website/docs/constrainttemplates].
- **Treating a non-zero `cosign verify` exit as a warning** — gate CI on the exit code so unsigned images can't slip through [source: ../../cosign/docs/cosign-verification-patterns.md].

## Next

[Container and runtime security — concepts](../../docs/concepts/container-runtime-security/0000-primer-container-runtime-security.md)
