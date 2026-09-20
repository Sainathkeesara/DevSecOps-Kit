---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# nuclei — first template scan attempt

> First-day notes about trying to run a template-based scan without guessing the result.

## What I checked

I checked the workspace for a Nuclei executable before starting the scan. It was not available on the current path, so there was no scan output to record. I stopped there instead of inventing a target, template, or finding.

## What I learned

The existing primer made the workflow clear enough to plan the first run: pick a practice target I control, use one template, keep the result, and inspect what matched. The important lesson from this attempt is that a useful scan note needs the actual tool response, not just a command I expect to work.

I also learned to keep the first attempt small. One target and one template will make it easier to tell whether a finding comes from the template, the target, or my setup.

## What I'll do next

I'll install Nuclei in an isolated practice environment, run one template against a target I own, and save the output beside this note. Then I'll write down what the result fields meant and what I would change before scanning anything broader.
