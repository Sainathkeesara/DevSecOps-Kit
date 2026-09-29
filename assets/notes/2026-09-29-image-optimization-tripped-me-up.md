---
last_verified: 2026-09-29
tool_version: n/a
---

# Image optimization quickstart — what tripped me up

> Following a basic image-optimization walkthrough against the PNGs in `assets/`. First-person lab notes, nothing polished.

## Steps I followed

I started by listing what was actually in `assets/` — three diagrams plus a placeholder README:

- `architecture-overview.png` (5116 bytes, 500x350)
- `cicd-workflow.png` (3267 bytes, 600x250)
- `devsecops-pipeline.png` (3926 bytes, 400x300)

Then I worked through the quickstart flow: inspect the files, try shrinking one, and reference it from a note with a relative link like `../assets/architecture-overview.png`.

I wrote a tiny Python check to read each PNG header and print its dimensions (the `struct` unpack of the IHDR chunk). That part worked first try and gave me the sizes above, which was a nice confidence boost.

## Got stuck on

Two things tripped me up. First, I tried resizing `cicd-workflow.png` without keeping the aspect ratio and ended up with a squished 600x250 banner — I had passed width and height independently instead of scaling from one side. I threw that copy away and redid it by computing the height from the width ratio, which kept the diagram readable.

Second, my first relative link from a note was wrong — I wrote `assets/architecture-overview.png` instead of `../assets/architecture-overview.png` because I forgot notes live one level deeper in `assets/notes/`. The image showed as broken until I compared it with the working link style in the existing explore-assets note and fixed the prefix.

## What I'd try next

I want to retry the resize step properly and save the smaller copies next to the originals with a `-small` suffix, then compare byte sizes to see if the savings are even worth it for files this small. I also want to double-check every PNG referenced from the docs so none of them point at a filename that does not exist.
