# README Layout audit: assets and Terrascan

## Purpose

This audit note records the README Layout gap found on 2026-06-16: root folders `assets/` and `terrascan/` existed on disk but were not described in the README Layout section.

## What changed

- Added `assets/` to README Layout as the static image and diagram storage folder.
- Added `terrascan/` to README Layout as the Terrascan notes, primer, and IaC snippet folder.
- Confirmed `cosign/` and `falco/` were already listed in README Layout, so this task did not duplicate their coverage.

## Verification

- Compared root folders from `ls` with README Layout entries.
- Confirmed `assets/images/.gitkeep`, `assets/diagrams/.gitkeep`, and the Terrascan primer, install note, and HCL snippet are present.
