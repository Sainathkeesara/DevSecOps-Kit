---
last_verified: 2026-10-20
tool_version: n/a
sources: []
---

# Follow the official OpenTofu test quickstart — what tripped me up

I followed the OpenTofu testing documentation to learn how `tofu test` works for validating modules. This is what worked and where I got stuck.

## What I followed

I created a minimal module — a single `null_resource` with a `local-exec` provisioner that echoes a string — and wrote a test file that asserts the output. I kept everything in one directory so I could focus on the test command flow rather than module structure.

The test file uses the `run` block with `command = plan` (and later `apply`) and `assert` blocks to check conditions. This is different from Terratest or kitchen-terraform where tests are external Go/Python scripts; here the test lives alongside the module as `.tftest.hcl` files.

## What worked

- `tofu test` discovered the `*.tftest.hcl` files automatically without any extra flags. I did not need to name the test file specifically — any file matching the pattern in the module directory was picked up.
- The `run "plan"` block executed a plan phase and made the planned values available to `assert` blocks. I could check that the resource count was correct and that the `local-exec` provisioner was present in the plan.
- `tofu test -verbose` printed each assert evaluation with pass/fail status, which made it easy to see which condition failed when I intentionally broke one.
- The `mock_provider` block let me stub out the `null` provider so the test did not actually execute the `local-exec` command — it only validated the plan structure. This keeps tests fast and side-effect-free.

## Got stuck on

- **Assert syntax for nested attributes** — I tried `assert { condition = run.plan.resource.null_resource.example.provisioners[0].local_exec.command == "echo hello" }` and it failed with "attribute not found". The provisioner block in the plan output uses a different nesting than the config. I had to use `run.plan.resource.null_resource.example.provisioners[0].local_exec["command"]` with bracket notation for the map lookup.
- **No apply-phase output in plan-only runs** — My first test used `command = plan` but asserted on `run.apply.output.example.value`. The test errored because `run.apply` does not exist when the command is `plan`. I needed a separate `run "apply"` block (or change the command) to access apply outputs.
- **Variable interpolation in assert conditions** — I defined a variable `test_message` and tried to use `var.test_message` inside the assert condition. It did not resolve — variables in test files are scoped to the `run` block inputs, not globally available in asserts. I had to pass it through `run { variables = { test_message = var.test_message } }` and then reference it as `run.variables.test_message`.
- **Test file naming confusion** — I initially named my test `test_main.tftest.hcl` and it worked, but when I added a second file `test_edge.tftest.hcl`, both ran. The docs say "all files matching *.tftest.hcl" — there is no way to run a single test file without renaming the others or using a subdirectory. This matters when one test is slow (uses `apply`) and others are fast (plan-only).

## What I'd try next

Split the test file into plan-only and apply suites in separate subdirectories so `tofu test` can target one suite at a time. Then add a `mock_provider` for the AWS provider and test a real module that creates an S3 bucket, asserting on the bucket name prefix and versioning configuration in the plan output.