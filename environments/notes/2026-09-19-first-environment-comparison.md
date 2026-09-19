---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# My first environment comparison

> I compared dev, staging, and prod folders to see what changed in my first setup.

## What I checked

I looked at the variable files in each environment folder and compared them with shared Terraform files. The folders give each environment its own place for values, while some configuration is shared.

## What changed

The environment files use different values for network settings, availability zones, NAT behavior, and tags. I treated those differences as the first things to understand before changing anything.

## What surprised me

Some shared files still refer to settings that look like they may need to match the folder they run from. I need to verify whether that is intentional and check the defaults before assuming the environments are isolated.

## Next

I want to trace each shared setting to the environment that uses it, then compare plans and record which values belong in each folder.
