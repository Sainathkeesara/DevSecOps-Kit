/**
 * @name Hardcoded credential via local data flow (Python)
 * @description Detects when a string literal flows into a credential-target variable
 *              or function argument. Uses local data flow instead of just the
 *              variable-name heuristic — catches more indirect assignments.
 * @kind problem
 * @problem.severity warning
 * @id py/hardcoded-credential-local-flow
 * @tags security
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

// Sources: string literals and simple concatenations
class StringLiteralSource extends DataFlow::Node {
  StringLiteralSource() {
    this.(DataFlow::ExprNode).getExpr() instanceof StrConst
    or
    this.(DataFlow::ExprNode).getExpr() instanceof BytesConst
  }
}

// Sinks: assignments to credential-named variables and calls to
// setter methods that look credential-related. This is one way to
// define the sink; the docs also suggest using a module-level
// configuration for reuse across queries.
class CredentialSink extends DataFlow::Node {
  CredentialSink() {
    exists(string name |
      name = this.(DataFlow::ExprNode).getExpr().(Name).getId() and
      name.toLowerCase().matches("%password%") or
      name.toLowerCase().matches("%secret%") or
      name.toLowerCase().matches("%token%") or
      name.toLowerCase().matches("%api_key%") or
      name.toLowerCase().matches("%credential%")
    )
    or
    exists(CallNode call |
      call.getArg(_) = this and
      call.getFunction().(Name).getId().toLowerCase().matches("%password%")
    )
  }
}

// Local flow: source to sink within the same function
class CredentialFlowConfig extends TaintTracking::Configuration {
  CredentialFlowConfig() { this = "CredentialFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof StringLiteralSource
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof CredentialSink
  }
}

from
  CredentialFlowConfig config,
  DataFlow::Node source,
  DataFlow::Node sink
where
  config.hasFlow(source, sink) and
  not source = sink
select sink, "Hardcoded value from $@ flows into credential target",
  source, source.toString()
