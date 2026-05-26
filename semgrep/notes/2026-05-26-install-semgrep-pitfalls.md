# 2026-05-26: Installing Semgrep — what tripped me up

First attempt installing Semgrep, I ran `pip install semgrep` and it worked fine. But when I tried to scan, nothing happened — just a blank output with no errors. Turns out I forgot to pass a target path. `semgrep --config=auto` doesn't default to `.`.

Then I got a `yaml.scanner.ScanError` on a custom YAML rule file. The issue was trailing whitespace in a key. Semgrep's YAML parser is stricter than I expected — it rejected the file silently unless I used `--verbose` to see the error.

Third gotcha: running `semgrep --config=auto` on a large monorepo took forever because it walked `node_modules`. Adding `--exclude=node_modules` helped, but I also had to exclude `__pycache__`, `.git`, and `venv`. Writing a `.semgrepignore` file would be cleaner.

Next time I'll create a `.semgrepignore` upfront and always pass `--verbose` when results don't appear.
