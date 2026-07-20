/**
 * @name Hardcoded secret passed to a sink
 * @description Detects string literals assigned to secret-ish names AND
 *              string literals passed to functions that send them off-box
 *              (e.g. requests.get with an auth header, os.environ.set).
 * @kind problem
 * @problem.severity error
 * @id py/hardcoded-secret-from-scratch
 * @tags security
 *       secrets
 */

import python

/**
 * Heuristic for identifiers that strongly suggest a secret value,
 * e.g. password, api_key, token, secret.
 */
predicate secretName(string name) {
  name.toLowerCase().matches("%password%")
  or name.toLowerCase().matches("%secret%")
  or name.toLowerCase().matches("%api_key%")
  or name.toLowerCase().matches("%apikey%")
  or name.toLowerCase().matches("%token%")
  or name.toLowerCase().matches("%credential%")
}

/**
 * A hardcoded string literal assigned to a secret-ish variable.
 * Catches `db_password = "hunter2"` style assignments.
 */
from AssignStmt stmt, string varName
where
  varName = stmt.getATarget().(Name).getId() and
  stmt.getAValue() instanceof StrConst and
  secretName(varName)
select stmt, "Hardcoded " + varName + " detected — read from environment or a vault instead"

/**
 * A string literal passed as an argument to a call whose name hints at
 * sending data off-box. Catches `requests.get(url, headers={"Authorization": "Bearer <lit>"})`
 * where the literal never touches a variable.
 */
from Call call, StrConst lit, string fnName
where
  fnName = call.getFunc().(Name).getId() and
  (
    fnName.matches("%request%") or
    fnName.matches("%post%") or
    fnName.matches("%put%") or
    fnName.matches("%setenv%")
  ) and
  lit = call.getAnArg() and
  not lit.getParent() instanceof Name  // exclude references to other names
select call, "String literal passed to " + fnName + " — ensure it is not a hardcoded secret"
