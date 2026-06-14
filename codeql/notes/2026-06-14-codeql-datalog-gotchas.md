# CodeQL QL language tutorial: Datalog gotchas

I followed the CodeQL QL language tutorial with the goal of writing a custom query without treating QL like normal Python. The first pass worked, but only after I slowed down and treated a query like a small database question: declare the things I need, filter them with `where`, then return the rows with `select`.

## Steps I followed

The shape of a query is stricter than I expected:

```ql
from AssignStmt stmt
where
  stmt.getAValue() instanceof StrConst
select stmt, "String assignment found"
```

My first mistake was trying to assign values with `=` the way I would in Python. In QL, `=` is usually a comparison inside `where`, not a variable assignment. The variables are introduced in `from`, and the interesting work happens in the predicate chain after `where`.

## Got stuck on

**`from` is not just a loop.** I kept reading `from AssignStmt stmt` as "loop over assignments", which is close, but not the whole point. It also declares the variable and its type for the rest of the query. Once I thought of it as "these are the rows I can talk about", the rest of the query made more sense.

**Predicates are filters.** A call like `stmt.getAValue() instanceof StrConst` is not returning a value I store. It is a condition that must be true for the row to survive. This is the Datalog-style part: I describe the result set, and CodeQL figures out how to walk the database.

**Casts need parentheses.** I wanted to call `getAValue().getId()`, but that failed because the value is an `Expr`, not necessarily a `StrConst`. The tutorial pattern that worked for me was `stmt.getAValue().(StrConst).getValue()`. The `.(Type)` cast narrows the node before I call methods on it.

**`matches` is pattern matching, not regex.** I tried to make `matches` behave like a regular expression. CodeQL's string matching uses `%` wildcards, so `varName.toLowerCase().matches("%password%")` is the style that worked in my hardcoded credential query.

## What I'd try next

Next I want to turn the hardcoded credential query into a tiny CodeQL test, so I can edit the query and prove the expected result without rebuilding a whole database every time. I also want to compare a single `.ql` file with a `.qls` suite and see when each one is the better way to package a scan.
