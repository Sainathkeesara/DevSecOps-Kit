---
last_verified: 2026-10-14
tool_version: n/a
---

# Poking around the gitguardian interface

I signed into the GitGuardian dashboard today just to see what is actually there. I have only used ggshield from the CLI before.

I clicked through the dashboard sidebar. The incidents list is the first thing I landed on — each row shows the secret type, the repo and file it was found in, and whether someone already marked it reviewed. I opened one test incident and it showed the commit and line, plus buttons to mark it as reviewed or assign it.

Then I looked at the sources/integrations page. I could see where you hook up repos so incidents flow in on their own instead of only from local `ggshield scan` runs. I also found the teams/settings area where you invite people — makes sense for the handoff part, so one person triages and someone else revokes.

What tripped me up: I kept looking for a "scan now" button in the dashboard, but scanning seems to happen from the CLI or the repo connection, not from clicking something on the site. Not sure yet how the ignore rules look in the UI — that is what I want to click into next.
