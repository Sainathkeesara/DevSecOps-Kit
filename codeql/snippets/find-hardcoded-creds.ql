/**
 * @name Hardcoded credential in Python
 * @description Detects hardcoded passwords, tokens, and API keys assigned as string literals.
 *              Variable-name heuristic — flags any string assigned to a name containing
 *              "password", "secret", "api_key", "token", or "credential".
 * @kind problem
 * @problem.severity warning
 * @id py/hardcoded-credential
 * @tags security
 */

import python

// L2 first attempt — using a simple target-name heuristic.
// CodeQL tracks data flow through assignments. Here I'm just checking
// whether the assigned value is a string literal (StrConst).

from AssignStmt stmt, string varName
where
  // Grab the target name if it's a simple variable (Name node)
  varName = stmt.getATarget().(Name).getId() and
  // Value must be a plain string, not a function call or expression
  stmt.getAValue() instanceof StrConst and
  // Heuristic: variable name hints at a secret
  (varName.toLowerCase().matches("%password%") or
   varName.toLowerCase().matches("%secret%") or
   varName.toLowerCase().matches("%api_key%") or
   varName.toLowerCase().matches("%token%") or
   varName.toLowerCase().matches("%credential%"))
select stmt, "Hardcoded " + varName + " detected — consider using environment variables or a vault"
