/**
 * last_verified: 2026-09-18 · codeql n/a
 * @name Hardcoded credential in Python assignment
 * @description Flags string literals assigned to secret-like variable names.
 *              Pack scaffold example — extend with project-specific sinks.
 * @kind problem
 * @problem.severity warning
 * @id py/custom-hardcoded-credential
 * @tags security
 */

import python

predicate secretName(string name) {
  name.toLowerCase().matches("%password%")
  or name.toLowerCase().matches("%secret%")
  or name.toLowerCase().matches("%api_key%")
  or name.toLowerCase().matches("%apikey%")
  or name.toLowerCase().matches("%token%")
  or name.toLowerCase().matches("%credential%")
}

from AssignStmt stmt, string varName
where
  varName = stmt.getATarget().(Name).getId() and
  stmt.getAValue() instanceof StrConst and
  secretName(varName)
select stmt, "Hardcoded " + varName + " detected — read from environment or a vault instead"
