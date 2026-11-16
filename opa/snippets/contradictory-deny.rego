# last_verified: 2026-11-16 · OPA n/a
package k8s.debug

# BUG: this rule can never fire — no container can be named both "webapp"
# and "database" at the same time. The two conditions contradict each other.
deny[msg] {
  container := input.containers[_]
  container.name == "webapp"
  container.name == "database"
  msg := "contradictory deny rule — can never fire"
}
