# Installing Syft and generating my first SBOM

Installed Syft today via the official install script. Ran `curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin` — worked first try, binary landed at `/usr/local/bin/syft`.

First scan was `syft alpine:latest`. Pulled the image, printed a table of all packages (about 20 apk packages). Nice and fast.

## Steps

1. Installed with the shell script above.
2. Ran `syft alpine:latest` — got a table with Name, Version, Type columns.
3. Tried `syft alpine:latest -o json` — dumped a big JSON object with a top-level `artifacts` array. Each entry has `name`, `version`, `type`, `locations`, `licenses`, etc.
4. Ran `syft dir:.` in a Python project dir — picked up `pip` packages from site-packages.

## Got stuck on

When I tried `syft dir:.` in a project that uses a virtualenv, it picked up all the venv packages too — not just the project deps. That's expected behavior (Syft scans the whole tree), but I need to remember to use `--exclude` next time.

Also, `syft alpine:latest -o cyclonedx` defaulted to XML. Had to use `-o cyclonedx-json` to get JSON. The `-o spdx` flag gives SPDX (also XML by default, use `-o spdx-json` for JSON).

## What I'd try next

Next I want to try piping Syft output into Grype for vulnerability scanning, and also test the `--exclude` flag to trim virtualenv noise.
