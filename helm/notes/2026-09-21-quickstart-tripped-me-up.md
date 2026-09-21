---
last_verified: 2026-09-21
tool_version: n/a
---

# Helm quickstart — what tripped me up

Following the official quickstart, here's what worked and where I got stuck getting my first chart installed and upgraded.

## Steps I followed

I started by creating a starter chart locally and rendering it without installing anything, just to see what the templates turn into. Then I installed it into a throwaway namespace with a custom release name and listed releases to confirm it was there. Finally I changed one value, ran an upgrade, and checked the release history to see the new revision appear.

Rendering before installing made everything else click — I could see which values fed which fields before anything touched the cluster.

## Got stuck on

The first thing that tripped me up was the release-versus-chart confusion. I thought installing twice would update the existing deploy, but the second install failed because the release name was already taken. I learned install creates a named release and upgrade changes it — two different commands.

Values overrides confused me next. I passed a single override on the command line and then a values file on a later run, and I wasn't sure which one won or whether the file replaced the defaults. Comparing the rendered output before and after showed me the file merges over the defaults, and the command-line flag wins over the file.

The last snag was forgetting which namespace I installed into. I ran the list command with no flags, saw nothing, and assumed the install failed. Listing across all namespaces showed my release sitting in the throwaway namespace where I had put it.

## What I'd try next

I want to practice rolling back to an earlier revision after a bad upgrade, and keep per-environment values files for dev versus staging. After that I'd like to try packaging a chart and searching a local repo for it.
