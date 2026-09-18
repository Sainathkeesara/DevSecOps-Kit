#!/usr/bin/env bash
# last_verified: 2026-09-18 · infrastructure-as-code (concept, n/a)

# I wrote this to practice the validate-then-plan loop before I ever run
# apply — fmt first because style noise hides real diffs, then validate,
# then plan so I can read what would change while it is still cheap to stop.
terraform fmt -check
terraform init
terraform validate
# I read the plan output here and only continue to apply on another day
# if every proposed change matches what I intended — the plan is the review.
terraform plan
