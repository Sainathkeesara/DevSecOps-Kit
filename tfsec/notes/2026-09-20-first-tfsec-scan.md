---
last_verified: 2026-09-20
tool_version: n/a
---

# First tfsec security check

I tried to run my first tfsec scan today. First I checked whether tfsec was
already on this box (`which tfsec`) — it wasn't, and there's no local install
to point at either.

I didn't want to pull a random install script without reading it first, so I
stopped before downloading anything. I wrote a one-file Terraform sample
anyway so I have something to scan once the binary lands.

What I'd try next: install tfsec from the official release, then run
`tfsec .` in the folder with my sample file and see what it flags.
