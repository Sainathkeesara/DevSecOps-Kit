---
last_verified: 2026-10-10
tool_version: n/a
---

# Checking where the diagrams are actually used

> First-day notes on the three PNGs in `assets/`. I wanted to see who links to them.

## What I checked

I listed `assets/` and found the same three PNGs as the old notes: `architecture-overview.png`, `cicd-workflow.png`, and `devsecops-pipeline.png`. Then I searched every `.md` in the kit for an image link to any of them and got zero hits.

## What I found

Nobody embeds these diagrams. The README only mentions `assets/` as a layout bullet, it does not show any of the pictures. The old explore note from 2026-09-19 says docs reference the PNGs via relative links like `../assets/architecture-overview.png`, but I could not find a single such link, so that claim is wrong. The 2026-09-30 note repeats it, and the asset index marks all three as used by the README, which does not check out either. I even checked the environments note that says the comparison note references the overview diagram — that file has no file references at all.

## What I'd try next

The diagrams are orphaned right now. Either embed small thumbnails where they are discussed (the README bullet, the explore note) or drop the PNGs and fix the index entries that claim they are used. I would start by embedding one thumbnail in the README and re-running the link check to confirm it resolves, then decide on the other two.
