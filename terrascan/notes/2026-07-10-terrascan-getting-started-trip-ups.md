---
last_verified: 2026-07-10
tool_version: n/a
---

# Following the Terrascan getting-started tutorial — what tripped me up

> L2 notes: what worked, what broke, and what I'd try next.

## Steps

### 1. Install Terrascan with Docker

I ran Terrascan as a container instead of installing the binary locally. The image pulled cleanly and the scan command worked the same way, except I had to mount the IaC directory as a volume.

### 2. Scan a Terraform plan

Instead of pointing Terrascan at raw configuration files, I generated a deployment plan from my Terraform code and fed the plan output to Terrascan. Scanning the plan means Terrascan evaluates what will actually be created after variables and modules are resolved, rather than catching issues in resources that might never be used.

### 3. Review the output

The scan found violations and printed rule IDs, severity levels, and short descriptions to the terminal. The output was readable without any extra formatting flags.

### 4. Try CI mode

I ran Terrascan in the mode that returns a non-zero exit code when violations are found. My shell reflected the error status, which is the behavior I'd want in a CI pipeline.

## Got stuck on

1. **Volume mount paths inside the container.** I kept getting "no IaC files found" until I realized the container's working directory was different from my host project root. I had to mount the directory to the exact path the container expected.

2. **Plan generation is an extra step.** The tutorial assumed I already knew how to produce a Terraform plan. I spent time looking for the right workflow and then debugging why the mounted path didn't match what Terrascan was scanning.

3. **Plan-based scanning misses unused resources.** I had a resource in my Terraform that wasn't referenced by any module, so it didn't show up in the plan. Terrascan didn't flag it, and I almost missed it until I ran a raw-file scan for comparison.

## What I'd try next

- Mount both the Terraform source and the generated plan so I can run both scan modes in the same job.
- Write a wrapper script that handles plan generation and the container mount in one step.
- Compare Terrascan's plan-mode findings against raw-file-mode findings on a larger codebase to see which catches more real issues.
