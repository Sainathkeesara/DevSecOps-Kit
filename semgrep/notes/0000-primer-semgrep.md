# Semgrep — quick primer

> First-day notes. Haven't installed it yet—just read through the docs.

I kept hearing "Semgrep" at security meetups and finally looked it up. It's like grep but for code structure—you write patterns and it finds matching code across your repo. Where `grep -r "password"` just finds strings, Semgrep knows if that string is in an assignment, a function call, or a comment.

It exists because regex can't understand code trees. Before Semgrep you'd write custom AST visitors per language. Now you write `$X == $X` and it catches tautology comparisons in Python, Java, Go, whatever.

Key terms I picked up:
- **Rule** — YAML file with `pattern`, `message`, `severity`. Like: "detect hardcoded passwords."
- **Pattern** — code snippet Semgrep matches. Uses `$X` metavariables as wildcards.
- **Metavariable** — `$X`, `$FUNC` etc. Matches any expression.
- **Community rules** — hundreds of ready-made rules in the Semgrep Registry.

Smallest example:

```yaml
rules:
  - id: no-hardcoded-passwords
    pattern: password = "..."
    message: hardcoded password found
    severity: ERROR
    languages: [python]
```

Save as `no-passwords.yml`, run `semgrep --config no-passwords.yml .`. Done.

Next I'll install it and scan one of our repos to see what fires.
