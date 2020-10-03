path "kv/data/ops" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/ops/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
