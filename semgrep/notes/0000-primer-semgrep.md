# Semgrep — quick primer

> First-day notes for someone who's never used Semgrep. Personal voice, plain language.

## What is it?

Semgrep is a static analysis tool that finds bugs and security issues in source code. Think of it like `grep` but for code patterns — it understands syntax, not just text. So instead of regex-searching for `print\(`, Semgrep lets you search for `print(...)` and it actually knows what a function call looks like in Python (or JavaScript, Go, Java, etc.).

## What does it do?

You write a YAML rule describing a pattern you want to find (like `eval(...)` or `subprocess.call(...)`), point Semgrep at a codebase, and it returns every matching location with the surrounding context. It also ships with hundreds of pre-built rules for security, correctness, and performance — so you can just run `semgrep --config=auto .` on a project and get findings immediately.

## Why does it exist?

Before Semgrep, if you wanted custom static analysis, you either used heavyweight tools like SonarQube (slow, complex) or regex grepping (brittle, misses nested patterns). Semgrep sits in the middle — fast, language-aware, and declarative. You define rules in YAML, not Java or Python. It's designed for developer workflows, especially CI/CD gating and pre-commit hooks.

People use it day-to-day for: catching security antipatterns in code reviews, enforcing coding standards across a team, scanning PRs for dangerous patterns before merge, and migrating codebases (find all uses of a deprecated API in one command).

## Key terminology

- **Rule** — A YAML file that describes what pattern to match and what to report. Example: `rules: [{id: no-eval, pattern: eval(...), language: python, message: "Don't use eval", severity: ERROR}]`
- **Pattern** — The code fragment to search for. Semgrep parses this as code, not text, so `print(...)` matches `print("hi")` but not `printer()`.
- **Metavariable** — A placeholder like `$X` or `$ARG` that matches any expression. Useful for catching patterns where part varies. Example: `open($FILE)` matches `open("foo.txt")` and binds `$FILE` to `"foo.txt"`.
- **`--config`** — Which rules to use. Can be a local file, a directory, a registry path (`r/python`), or `auto` to auto-detect based on languages in the project.
- **Severity** — `INFO`, `WARNING`, or `ERROR`. Controls how findings are displayed and can gate CI/CD.
- **SAST** — Static Application Security Testing. Analyzing source code without running it. Semgrep is a SAST tool.
- **Registry** — Semgrep's community rule hub at semgrep.dev. Over 2000 rules organized by language and category (security, correctness, etc.).
- **`--json`** — Output results as JSON for programmatic consumption (CI/CD pipelines).
- **`semgrep scan`** — The main command (replaces the older `semgrep --config` syntax).

## A tiny example

This rule catches Python `eval()` calls, which can run arbitrary code:

```yaml
rules:
  - id: no-eval
    pattern: eval(...)
    language: python
    message: Using eval is a security risk — avoid it
    severity: ERROR
```

Save it as `no-eval.yaml`, then run `semgrep --config no-eval.yaml my_code.py`. It'll print every `eval(...)` call it finds.

## What I'll cover next

I want to install Semgrep properly, run a full scan on a real project, and then write a few custom rules for patterns I keep seeing in code reviews. After that I'll look at integrating it into a GitHub Actions pipeline.
