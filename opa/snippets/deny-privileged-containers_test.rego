# last_verified: 2026-11-16 · OPA n/a
package k8s.pod_security.test

import data.k8s.pod_security

test_denies_privileged_container {
  data.k8s.pod_security.deny["Container web runs privileged — not allowed"] with input as {
    "containers": [{"name": "web", "securityContext": {"privileged": true}}]
  }
}

test_allows_unprivileged_container {
  not data.k8s.pod_security.deny[_] with input as {
    "containers": [{"name": "web", "securityContext": {"privileged": false}}]
  }
}
