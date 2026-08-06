---
last_verified: 2026-08-06
tool_version: n/a
---

# Semgrep Rule Performance Optimization — Combining Patterns for Efficient Scanning

## Purpose

This guide covers techniques for optimizing Semgrep rules by combining patterns to reduce scan time and improve detection accuracy. When scanning large codebases, inefficient rules can significantly slow down CI pipelines and produce excessive noise. Combining patterns allows practitioners to narrow the scope of each rule so that Semgrep evaluates only the code paths that matter.

## When to Use

Use pattern-combination techniques when:

- A codebase has thousands of files and full scans take longer than acceptable in CI
- Individual rules produce high false-positive rates because they match too broadly
- Multiple related patterns need to be evaluated together (e.g., detecting both the source and sink of a data flow)
- Rules target specific frameworks or language features that can be isolated with `pattern-inside` or `pattern-either`

## Prerequisites

- Semgrep CLI installed
- A codebase to scan (Python, JavaScript, Go, or other supported language)
- Basic familiarity with Semgrep rule YAML structure (`rules`, `pattern`, `message`, `languages`, `severity`)

## Steps

### 1. Start with `pattern` for simple matches

The `pattern` combinator matches a single code structure. Use it as the baseline and only add combinators when the rule is too broad or too slow.

```yaml
rules:
  - id: dangerous-subprocess
    pattern: subprocess.Popen(..., shell=True, ...)
    message: shell=True can lead to command injection
    languages: [python]
    severity: ERROR
```

### 2. Narrow scope with `pattern-inside`

`pattern-inside` restricts the match to code within a specific surrounding structure. This reduces the number of candidate nodes Semgrep must evaluate and cuts false positives by requiring context.

```yaml
rules:
  - id: sql-injection-in-django
    pattern-inside: |
      def $FUNC(...):
        ...
    pattern: $X.execute($SQL, ...)
    message: Potential SQL injection in Django view
    languages: [python]
    severity: ERROR
```

### 3. Match alternatives with `pattern-either`

`pattern-either` evaluates multiple patterns and reports a match for any one of them. Use it when the same vulnerability class can appear in several syntactically distinct forms, but you want a single rule to catch all of them.

```yaml
rules:
  - id: hardcoded-secret
    pattern-either:
      - pattern: $SECRET = "..."
      - pattern: $SECRET = '...'
      - pattern: $SECRET = """..."""
    message: Hardcoded secret detected
    languages: [python]
    severity: WARNING
```

### 4. Combine `pattern-inside` and `pattern-either` for targeted multi-pattern rules

Nesting `pattern-either` inside a `pattern-inside` scope gives the best of both: the outer scope limits where Semgrep looks, and the inner alternatives handle syntactic variation.

```yaml
rules:
  - id: insecure-crypto-internal
    pattern-inside: |
      class $CLASS:
        ...
    pattern-either:
      - pattern: $CIPHER = AES.MODE_ECB
      - pattern: $CIPHER = DES.new(...)
    message: Insecure cryptographic mode detected
    languages: [python]
    severity: ERROR
```

### 5. Use `metavariable-regex` for value-level constraints

When a pattern matches too many nodes, add a `metavariable-regex` constraint to filter matches by the value of a captured metavariable.

```yaml
rules:
  - id: weak-hash-algorithm
    pattern: hashlib.$FUNC(...)
    metavariable-regex:
      metavariable: $FUNC
      regex: ^(md5|sha1)$
    message: Use of weak hash function
    languages: [python]
    severity: WARNING
```

## Verify

Run the optimized rule against a known codebase and compare scan metrics:

```bash
semgrep scan --config optimized-rule.yaml --json scan-results.json .
```

Check the output for:
- Number of matches (should be relevant, not excessive)
- Scan duration (should be lower than the unoptimized equivalent)
- False-positive rate (should decrease as patterns become more specific)

## Common errors

- **Over-nesting `pattern-inside`**: Deeply nested scopes can cause Semgrep to skip matches entirely. Keep nesting to one or two levels.
- **`pattern-either` with too many alternatives**: Each alternative adds evaluation cost. If a rule has more than 5-6 alternatives, consider splitting it into separate rules.
- **`metavariable-regex` with overly broad patterns**: A regex like `.*` negates the filtering benefit and can slow the scan. Keep regexes specific and anchored where possible.
- **Mixing `pattern` and `pattern-inside` at the same level**: Semgrep evaluates `pattern` and `pattern-inside` as separate constraints that must both match. If they target different code structures, the rule will never fire.