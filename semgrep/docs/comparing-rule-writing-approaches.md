# Comparing Semgrep Rule-Writing Approaches

## Purpose

This guide compares the three core Semgrep pattern combinators: `pattern`, `pattern-inside`, `pattern-either`, and their role in writing effective security rules. Each serves different use cases when targeting code structures.

## When to Use Each Approach

### `pattern`
The simplest form — matches a single code structure. Use when you need to find one specific pattern.

```yaml
rules:
  - id: dangerous-subprocess
    pattern: subprocess.Popen(..., shell=True, ...)
    message: shell=True can lead to command injection
    languages: [python]
    severity: ERROR
```

### `pattern-inside`
Restricts matching to code inside a specific context. Use when you need to find patterns only within certain scopes (e.g., inside a handler, function, or conditional).

```yaml
rules:
  - id: insecure-deserialization-inside-handler
    patterns:
      - pattern-inside: |
          @app.route(...)
          def $FUNC(...):
            ...
      - pattern: pickle.loads(...)
    message: Insecure deserialization in request handler
    languages: [python]
    severity: ERROR
```

### `pattern-either`
Matches if ANY of the provided patterns match. Use when the same issue can appear in multiple forms.

```yaml
rules:
  - id: hardcoded-secret-any-form
    patterns:
      - pattern-either:
          - pattern: password = "..."
          - pattern: api_key = "..."
          - pattern: secret = "..."
    message: Hardcoded credential detected
    languages: [python]
    severity: ERROR
```

## Key Differences

| Combinator | Matches | Use Case | Example |
|------------|---------|----------|---------|
| `pattern` | Single pattern | Direct, explicit match | `subprocess.Popen(..., shell=True)` |
| `pattern-inside` | Pattern + context constraint | Scoped detection | SQL injection only in request handlers |
| `pattern-either` | Any of multiple patterns | Multiple forms of same issue | Hardcoded credential in various variable names |

## Prerequisites

- Semgrep installed (see primer at `semgrep/notes/0000-primer-semgrep.md`)
- Basic understanding of metavariables (`$X`, `$FUNC`, etc.)
- Familiarity with YAML syntax

## Steps

### 1. Identify Pattern Scope

Start by asking: is this a single-pattern issue, does it need context, or does it have multiple forms?

### 2. Choose the Combinator

- **Single pattern**: Use `pattern` directly
- **Context needed**: Add `pattern-inside` with the enclosing structure
- **Multiple forms**: Use `pattern-either` to group alternatives

### 3. Write the Rule

Combine with `patterns` array when using multiple combinators:

```yaml
rules:
  - id: sql-injection-in-handler
    patterns:
      - pattern-inside: |
          def $HANDLER(request):
            ...
      - pattern-either:
          - pattern: cursor.execute($SQL % request)
          - pattern: cursor.execute(f"...{request}...")
          - pattern: cursor.execute("..." + request)
    message: SQL injection via user input
    languages: [python]
    severity: ERROR
```

### 4. Verify the Rule

Run against target code:

```bash
semgrep --config rule.yaml /path/to/code
```

## Verify

After writing your rule, test against both positive and negative cases:

- Does it match intended vulnerabilities?
- Does it produce false positives on safe code?
- Is the message actionable?

Refine metavariable constraints or add `pattern-not` to reduce noise.

## Common Errors

### Missing Context
If `pattern-inside` fails, check indentation — Semgrep requires exact structural matching. Use `...` ellipses to skip irrelevant lines.

### Overly Broad Matches
`pattern-either` can catch too much. Narrow with additional constraints:
```yaml
- pattern-not: string == "..."  # Exclude comparisons
```

### Metavariable Scope
Each `pattern` in a `patterns` array has its own scope. Use `$X` consistently if you need variables to match across patterns.

## References

- [Semgrep Rule Schema](https://semgrep.dev/docs/writing-rules/overview)
- [Pattern Combinators](https://semgrep.dev/docs/writing-rules/pattern-combinators)