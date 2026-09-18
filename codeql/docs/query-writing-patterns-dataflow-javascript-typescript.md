---
last_verified: 2026-09-18
tool_version: n/a
---

# CodeQL query writing patterns — data flow analysis for JavaScript/TypeScript

## Purpose

This guide describes reusable patterns for writing CodeQL queries that track
untrusted data through JavaScript and TypeScript code, from where it enters
the program to where it is used unsafely. It covers how to frame a query as
source, sink, and sanitizer, and how to arrange small queries so each one
checks a single data flow path.

## When to use

Use these patterns when the built-in query suites do not cover a
project-specific flow — for example, a custom request handler, an internal
HTML rendering helper, or a bespoke database access wrapper. Prefer the
default suites for standard coverage; write custom data flow queries only for
flows that are unique to the codebase.

## Prerequisites

- A CodeQL database built for the JavaScript/TypeScript codebase under review.
- A directory for custom queries, kept next to the workflow that runs them
  (see `codeql/manifests/multi-language-codeql-analysis.yaml` in this kit for
  the multi-language scan shape).
- Familiarity with the three data flow roles below; no additional services
  are required.

## Steps

**1. Name the source, sink, and sanitizer for one flow.**

Before writing query code, write one sentence for each role:

- *Source:* where untrusted data enters (request parameter, message body
  field, query string value).
- *Sink:* where that data is used unsafely (HTML rendering call, database
  query string, command construction).
- *Sanitizer:* what makes the data safe (encoding function, validation
  routine, allowlist check).

Keeping one flow per query makes results easier to triage than a query that
mixes several sinks.

**2. Sketch the flow as a small end-to-end example.**

Write a short vulnerable snippet and its fixed counterpart first, so the
query has a concrete target. For example, a handler that reads a request
field and passes it straight into a rendering helper is the vulnerable case;
the same handler passing the field through the team's encoding helper is the
fixed case. The query should flag the first and stay silent on the second.

**3. Model the source narrowly.**

Match only the entry points the flow actually uses. A source that matches
"any function argument" produces noise; a source scoped to the project's
request handling layer (the framework's request object, the message handler
signature) keeps findings actionable. When in doubt, start narrow and widen
only after reviewing missed findings.

**4. Model the sink at the dangerous call.**

Place the sink on the argument position that carries attacker-controlled
data, not on the whole call. For a rendering helper, the sink is the HTML
string argument; for a database wrapper, it is the query text argument. This
keeps the query from flagging calls where only a safe option flag flows
through.

**5. List sanitizers explicitly.**

Enumerate the encoding and validation helpers the codebase actually uses and
treat them as barriers that stop the flow. Common cases: HTML encoders for
rendering sinks, parameter binding for database sinks, and allowlist checks
for redirect targets. An unknown helper should not be assumed safe — either
add it to the sanitizer list after review or let the query flag through it.

**6. Handle TypeScript wrappers and re-exports.**

TypeScript code often passes data through thin wrappers, interface methods,
or re-exported helpers. Trace one hop at a time: confirm the flow reaches
the wrapper, then extend the model through it. Adding wrapper hops
incrementally avoids a query that silently stops at the first abstraction
boundary.

**7. Keep query packs small and named by flow.**

Store each query with a short name that states the flow (for example,
`request-field-to-html-render` rather than `security-check`). Group related
queries in a suite file so CI runs the pack as a unit. The existing custom
query wiring in `codeql/docs/wired-custom-queries-into-ci.md` shows one way
to reference such a pack from a workflow.

## Verify

- Run the new query against the CodeQL database for a sample that contains
  the vulnerable snippet and confirm it reports a finding on the sink line.
- Run it against the fixed snippet (data passed through the listed
  sanitizer) and confirm it reports nothing.
- Run the full custom pack alongside the default suite and confirm the
  result set contains both default and custom findings without duplicates.

## Common errors

- *Overly broad source:* matching every function parameter floods results.
  Narrow the source to the request handling layer first.
- *Missing sanitizer:* the team's encoding helper is not listed, so fixed
  code keeps flagging. Add reviewed helpers to the barrier list.
- *Sink on the wrong argument:* flagging a call because an options object
  flows through, while the dangerous string argument is safe. Move the sink
  to the exact argument position.
- *Wrapper gap:* the flow stops at a TypeScript wrapper because the model
  does not step through it. Extend the model one hop and re-test.
- *One query per many flows:* a single query covering rendering, database,
  and redirect sinks is hard to tune. Split it so each query owns one sink.

## References

- In-repo multi-language scan workflow: `codeql/manifests/multi-language-codeql-analysis.yaml`
- In-repo custom query CI wiring: `codeql/docs/wired-custom-queries-into-ci.md`
