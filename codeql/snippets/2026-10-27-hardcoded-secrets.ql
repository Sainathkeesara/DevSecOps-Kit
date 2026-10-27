// last_verified: 2026-10-27 · codeql n/a
/**
 * @name Hardcoded database connection string
 * @description Flags string literals that look like database URLs with embedded credentials.
 * @kind problem
 * @id py/hardcoded-db-connection-string
 * @tags security
 *       secrets
 */

import python

// not sure if `://.*:.*@` catches every connection-string shape — worth tuning later
from StrConst lit
where lit.getValue().matches(".*://.*:.*@.*")
select lit, "Hardcoded database connection string with embedded credentials — use a secret store instead"
