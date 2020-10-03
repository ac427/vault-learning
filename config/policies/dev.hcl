path "kv/data/dev" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/dev/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
