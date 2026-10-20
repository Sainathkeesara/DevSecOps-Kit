---
last_verified: 2026-10-20
tool_version: "n/a"
sources: []
---
# Follow the official OpenTofu quickstart and write up what tripped me up

## What I did
I followed the OpenTofu quickstart to spin up a simple resource. I initialized, planned, and applied following the basic workflow.

## What worked
- `tofu init` pulled providers as expected
- `tofu plan` showed the planned changes clearly
- The workflow felt familiar coming from Terraform

## Where I tripped
- **Backend config**: I forgot that some backends need extra configuration; had to double-check required args
- **Provider versions**: Version constraints matter - without constraints I got a version that didn't match expectations
- **State locking**: When testing in parallel, state locking behavior caught me off guard

## What I'd try next
I'd experiment with modules and remote backends to understand state management better.
