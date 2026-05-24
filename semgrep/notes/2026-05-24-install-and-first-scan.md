# Semgrep — first install and scan

Installed Semgrep with `pip install semgrep`. That's it — no dependencies to fight. Checked with `semgrep --version` and got 1.68.0.

Grabbed a small Python script with a few intentional issues and ran:

```
semgrep --config=auto --output=semgrep-report.txt
```

It auto-detected Python and matched rules from the registry. Found 3 items:

1. A `subprocess.call()` without sanitization — flagged as ERROR.
2. Hardcoded API key in a string — WARNING.
3. A bare `except:` clause — WARNING.

I liked the color output: red for ERROR, yellow for WARNING. The `--json` flag gave me structured output I could pipe to something else.

Tried `semgrep scan` (the newer subcommand) — same result as `semgrep --config=auto`. Not sure which is preferred yet, but both work.

Next I want to write a rule that catches something specific to our codebase — like `os.system()` calls.
