---
last_verified: 2026-09-25
tool_version: n/a
---

# Cosign key rotation and migration patterns

## Purpose

Define a release-neutral way to rotate signing trust and migrate Cosign workflows without leaving unsigned or unverifiable images behind. The central idea is to treat signing material, verification policy, and already-published images as one migration set: change the trust material, re-sign the images that must remain available, update every verifier, and only then remove the old path.

This guide focuses on the workflow and decision points rather than release-specific syntax. Use the command reference for the installed Cosign release when converting each step into an executable pipeline.

## When to use

Use this pattern when a team is changing a signing key, moving between key-based and identity-based signing, changing the identity or repository covered by verification, or moving signed images and their verification material between registries. It also applies when a verification policy is being tightened, split by environment, or transferred to a new ownership boundary.

The pattern is especially useful when old images must remain deployable during the transition. A key change alone does not make previously signed artifacts match the new trust path; the migration plan needs to account for those artifacts explicitly.

## Prerequisites

- An inventory of image references that are currently signed and the environments that consume them.
- A recorded verification policy for each environment, including the trusted key or signing identity it accepts.
- Access to the old and new signing paths, with private material kept out of logs and image layers.
- A test image and a known-good verification fixture for each migration stage.
- A rollback owner who can restore the previous verification policy while the overlap window is still open.

## Steps

### 1. Rotate a key-based signing key

Create the replacement key before changing any pipeline configuration. Keep its public verification material available to every consumer, then sign a small test image and verify it through the same path used by deployment. This proves that the new key is usable before the pipeline starts producing release images with it.

Run an overlap window in which verifiers accept the old and new public material. During that window, re-sign the image references that still need to be available. Prioritize images used by active environments, then retain or retire older references according to the team's retention policy.

After verification succeeds with the new key, switch signing and verification to the new key as one coordinated change. Keep the old private key available only for the rollback window, then remove it from active pipeline access. Remove the old public material from verifiers only after no supported image depends on it.

### 2. Migrate from key-based to identity-based signing

Begin by defining the exact identity that the new signing workflow should present. Test that identity with a non-release image before allowing it to sign a deployable reference. Update the verification policy to require the intended identity and issuer rather than accepting any identity that happens to be present.

During migration, keep the key-based path available as a fallback while the identity-based path is exercised end to end. Sign the same test image through the new path, verify it with the new identity constraints, and compare the result with the old path. Once the new path is reliable, stop creating new signatures with the old private key and move supported images to signatures made by the new identity.

The important distinction is between a signing migration and a verification migration. A pipeline can sign with the new identity while consumers still trust the old key, but that state is temporary and must have a named end condition. Do not declare the migration complete until the consumers enforce the new identity policy.

### 3. Migrate from identity-based to key-based signing

Provision the replacement key in the approved secret store and distribute its public verification material before changing the signing job. Test the private-key access path without exposing the key, then sign and verify a test image. Confirm that every consumer can retrieve the correct public material and that the policy rejects an image signed by an unrelated identity.

Keep the identity-based path available during the overlap window. Re-sign images that must survive the cutover, update deployment verification to accept the new key, and observe at least one complete build-to-deploy cycle. Only after that cycle succeeds should the pipeline stop using the old identity path.

This direction adds a long-lived secret-management responsibility. The migration record should therefore include key custody, access review, backup and recovery expectations, and the procedure for revoking the key if access is lost or suspected to be compromised.

### 4. Move signed images between registries

Treat the destination as a new signing boundary until its signatures and verification policy have been tested. Inventory the source references, copy the image content and the associated verification material according to the chosen migration method, and verify the destination references before changing consumers.

Do not assume that an image reference and its verification record move as one object in every registry workflow. For each migration cohort, record the source reference, destination reference, signing identity or key version, and verification result. If the destination cannot preserve the existing verification record, re-sign the image at the destination using the target trust path and update consumers accordingly.

Cut over one environment or one image cohort at a time. Keep the source available until the destination has passed verification and deployment checks for the agreed observation period.

### 5. Tighten or split a verification policy

Version the policy as a migration artifact instead of editing the only active policy in place. Start with the current accepted set, add the narrower rule alongside it, and test both a matching image and a deliberately non-matching image. The matching test proves that legitimate traffic still passes; the non-matching test proves that the new rule actually rejects unexpected trust.

Roll the stricter policy out by environment or workload cohort. Record which consumers use which policy version so a failed rollout can be reversed without guessing. Once every cohort uses the stricter rule, remove the broader acceptance condition and retain the test fixtures as regression evidence.

## Verification checklist

A migration is ready to close when all of the following are true:

- A test image signed through the new path passes verification with the intended policy.
- Every active environment has a recorded policy version and a named owner.
- Images that must remain available have been re-signed or have a documented exception.
- A non-matching key or identity fails verification during the final policy test.
- The old signing path is disabled after the overlap window, not merely ignored.
- Rollback has been exercised or rehearsed while the old path is still recoverable.
- The migration record identifies the image cohorts, trust material, policy versions, and cutover dates without recording private key material.

## Rollback

Keep the previous verification policy and its public trust material available throughout the overlap window. If a new signature fails verification, first confirm whether the failure came from signing, image selection, or policy configuration. Restore the previous policy only when the old path is still authorized and the affected images are known.

Rollback does not mean re-enabling an unreviewed private key in every pipeline. Limit the restoration to the affected cohort, investigate the failed transition, and repeat the test-image verification before reopening the cutover. Once the overlap window ends and old signatures are no longer supported, rollback must use a new migration rather than silently reviving retired trust.

## Common errors

- **Rotating the key without re-signing supported images.** The new verifier rejects images that were valid under the old key. Inventory the retained image set before retiring the old trust material.
- **Changing signing before changing verification.** The pipeline produces images that consumers cannot accept. Use a test image and an explicit overlap state to expose this mismatch early.
- **Using a broad identity rule during migration.** A permissive rule can make the transition appear healthy while accepting unrelated signers. Add a negative test and narrow the rule before cutover.
- **Treating a registry copy as a verified migration.** Content movement and trust movement are separate checks. Verify the destination reference and record the result.
- **Removing rollback material too early.** A failed policy rollout is difficult to reverse after the old trust path is deleted. Keep the rollback window visible in the migration record.
- **Mixing migration states indefinitely.** Dual acceptance is a transition control, not a permanent policy. Give each overlap window an owner, an end condition, and a cleanup step.

## References

- Pipeline ordering and signing choices: `container-signing-pipeline.md` in this directory.
- Verification-side policy patterns: `cosign-verification-patterns.md` in this directory.
- Existing key-management workflow: `../scripts/cosign-key-management-workflow.sh`.
- Existing signature configuration: `../configs/cosign-signature-configuration.yaml`.
