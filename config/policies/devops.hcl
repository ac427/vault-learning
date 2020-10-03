path "secret/data/devops/*" {
   capabilities = ["create", "read", "update", "delete"]
}

path "secret/metadata/*" {
   capabilities = ["list"]
}
