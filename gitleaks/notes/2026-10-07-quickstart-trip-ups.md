---
last_verified: 2026-10-07
tool_version: n/a
---

# Following the gitleaks quickstart — what tripped me up

> I worked through the gitleaks quickstart path with what I had on this box and wrote down where I got stuck.

## Steps I actually ran

I started by checking whether gitleaks was already on this machine. I ran `which gitleaks` and `gitleaks --help`, and both came back empty — the binary is not installed here, so I could not do a verbatim install-then-scan run.

Since I could not install, I re-read the kit pieces I do have: the primer at `gitleaks/notes/0000-primer-gitleaks.md`, my earlier first-scan note, the helper at `gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh`, and the rules draft at `gitleaks/configs/2026-10-07-detection-rules.yaml`. That gave me the two commands the quickstart revolves around — a full-history scan and a staged-changes check — so I rehearsed them without executing.

Next I built a tiny throwaway repo to be ready for a real run. I made `/tmp/gitleaks-quickstart-test`, ran `git init`, added a `notes.txt` file plus a fake `.env` holding an obviously fake value like `TEST_EXAMPLE_KEY=AKIAIOSFODNN7EXAMPLE`, and committed it. I kept the value fake on purpose so this exercise never stores anything that looks like a real credential. My plan was to point the scanner at that directory and write the findings to a JSON report I could inspect afterwards:

```bash
gitleaks detect --source /tmp/gitleaks-quickstart-test --report-path gitleaks-report.json
```

I also lined up the staged-changes variant from the primer for the second try:

```bash
gitleaks protect --staged
```

Neither command ran because there is no binary here, but staging the repo first meant I know exactly what I will run once I am on a box where I am allowed to install tools.

## Got stuck on

The first snag was the install assumption. The quickstart flow reads like the binary is one download away, but on this box there is nothing to download from and no package manager path I trust for a security scanner, so the whole flow stops at step one. I spent a while double-checking my `PATH` and the kit scripts before accepting the binary really is absent.

The second snag was `detect` versus `protect`. I initially thought they were two names for the same scan. Reading the primer and the helper script side by side cleared it up: `detect` looks back over history or a directory tree and writes a report, while `protect` looks at what I have staged right now and blocks the commit or push. I had them backwards for the first half hour and would have wired the wrong one into a hook.

The third snag was config format. The primer talks about TOML custom rules, but the kit's own rules draft is a YAML sketch with authored regexes and an allowlist section. I got confused about which file the scanner would actually read. Re-reading the YAML header comments helped: the YAML is my working draft for this kit, and I would need to translate it into the scanner's native TOML shape before a real run. I did not attempt that translation yet because I cannot validate it without the binary.

## What I'd try next

First I want to install gitleaks in an approved environment and re-run the exact `detect` command above against my throwaway repo, then read the JSON report and confirm the fake key is flagged with the file, line, and rule name. Then I want to try `protect --staged` with a staged fake secret to feel the block in action. After that I want to practice the allowlist part — marking my fake example as allowed and re-running to watch it go quiet — because that seems like the skill that decides whether the tool stays useful or just gets noisy.
