# README Layout audit: Dependabot root folder

## Purpose

I checked the root folder list against README Layout for gen-010/gen-011. `dependabot/` exists on disk, but README Layout did not mention it.

## What changed

- Added `dependabot/` to README Layout as the Dependabot primer, notes, and dependency update config folder.
- Confirmed the existing Dependabot primer and npm update config are the files that should be discoverable from the README.

## Verification

- Compared `dependabot/notes/0000-primer-dependabot.md` and `dependabot/configs/tried-npm-dependabot.yaml` with README Layout.
- Added matching quick link and changelog entries.
