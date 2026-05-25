# 2026-05-25: Installing Semgrep and running my first SAST scan

I installed Semgrep today via pip. Ran:

```bash
pip install semgrep
semgrep --version
```

Got version 1.98.0. First scan was against a small Python script I had lying around — just wanted to see what it found with the default ruleset:

```bash
semgrep --config=auto test.py
```

It found 3 findings: one "subprocess shell true" issue, one request without timeout, and one bare `except:` clause. The `subprocess` one surprised me — I'd just written that yesterday.

Tried filtering by severity too:

```bash
semgrep --config=auto --severity=ERROR test.py
```

Only the subprocess one was tagged ERROR. I like that I can scope scans. Next I want to write a custom rule.
