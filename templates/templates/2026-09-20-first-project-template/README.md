---
last_verified: 2026-09-20
tool_version: n/a
---

# My first project template

I scaffolded my first reusable project template today. Goal: stop copy-pasting
the same starter files every time I begin something small.

I made a folder with a `cookiecutter.json` for the variable defaults and one
starter `app.py` inside `{{cookiecutter.project_slug}}/`. Ran a test render by
copying the folder and swapping in a name by hand. Got tripped up once — I
named a placeholder inconsistently between the JSON and the folder, so the
render left a literal `{{...}}` in the path. Fixed by using the exact same key.

What I'd try next: add a second file (a README skeleton) and actually render
it with cookiecutter instead of by hand.
