export VAULT_SKIP_VERIFY=1
export VAULT_ADDR=https://foo.dev.home:8200
vault operator init -tls-skip-verify
