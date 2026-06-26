// vault/configs/2026-06-26-dev-test-policies.hcl
// First attempt at Vault policy + secrets engine configuration for dev/test
//
// I followed the Vault policy quickstart and the secret engines tutorial.
// This file covers the two KV v2 engines I set up: one for dev (full access)
// and one for test (read-mostly). I also learned that policy paths depend on
// the mount path of the engine, not just the logical path.

// ---------------------------------------------------------------------------
// Dev policy — full CRUD on everything under dev/
// ---------------------------------------------------------------------------
// I mounted the KV v2 engine at "dev-kv" with:
//   vault secrets enable -path=dev-kv kv-v2
//
// The /data/ prefix is required for KV v2 because the actual secret data lives
// under data/ and metadata under metadata/. I tripped on this for way too long.
path "dev-kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

// Same for metadata — needed for listing and deletion
path "dev-kv/metadata/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

// Allow deleting old versions and undeleting
path "dev-kv/delete/*" {
  capabilities = ["update"]
}

path "dev-kv/undelete/*" {
  capabilities = ["update"]
}

// Destroy permanently removes versions — keeping this here but it's risky
path "dev-kv/destroy/*" {
  capabilities = ["update"]
}

// ---------------------------------------------------------------------------
// Test policy — read-only except for a fixture sub-path
// ---------------------------------------------------------------------------
// I mounted a separate engine at "test-kv" for the test environment.
// The CI runner uses this policy — I don't want tests accidentally wiping data.
// But test fixtures need to be created/deleted dynamically, so I carved out
// a specific sub-path with write access.
path "test-kv/data/*" {
  capabilities = ["read", "list"]
}

path "test-kv/metadata/*" {
  capabilities = ["read", "list"]
}

// Test fixtures — write access for setup/teardown
path "test-kv/data/fixtures/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "test-kv/metadata/fixtures/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

// ---------------------------------------------------------------------------
// What I'd try next
// ---------------------------------------------------------------------------
// - Add a transit engine policy for encryption-as-a-service in dev
// - Try wrapping policy paths with "deny" and "required_parameters" for tighter
//   control over the fixture paths
// - Wire these into a Terraform Vault provider config so policies are code too

// Got stuck on:
// - /data/ vs /metadata/ path split — the docs mention it but don't highlight
//   that your read grant doesn't work without the data/ prefix
// - kv-v2 vs kv-v1 — I created a kv-v1 engine first and the /data/ prefix
//   silently returned empty data instead of erroring
