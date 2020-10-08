#### Mount $(pwd)/data as /data and run vault server  

```
$docker run -p 8200:8200 -v /home/abc/github/ac427/vault/data:/data -v $(pwd):/root -it --cap-add IPC_LOCK --hostname 'foo.dev.home' -w /root/config --entrypoint /bin/sh vault
~/config # vault server --config=config.hcl
==> Vault server configuration:

             Api Address: https://foo.dev.home:8200
                     Cgo: disabled
         Cluster Address: https://foo.dev.home:8201
              Go Version: go1.14.7
              Listener 1: tcp (addr: "foo.dev.home:8200", cluster address: "172.17.0.2:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "enabled")
               Log Level: info
                   Mlock: supported: true, enabled: true
           Recovery Mode: false
                 Storage: raft (HA available)
                 Version: Vault v1.5.4
             Version Sha: 1a730771ec70149293efe91e1d283b10d255c6d1

==> Vault server started! Log data will stream in below:

```

#### connect to the running container. This is where we do most of the work

```
[abc@foo 16:18:22 - ~]$docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                    NAMES
f865b9e4e316        vault               "/bin/sh"           About a minute ago   Up About a minute   0.0.0.0:8200->8200/tcp   bold_cartwright
[abc@foo 16:18:25 - ~]$docker exec  -w /root/config -it bold_cartwright /bin/sh
~/config # cat ../scripts/user.sh
export VAULT_SKIP_VERIFY=1
export VAULT_ADDR=https://foo.dev.home:8200
~/config # . ../scripts/user.sh

```

#### One time thing. initialize

```
~/config # vault operator init -tls-skip-verify
Unseal Key 1: TrskDMY01eMEemBlSRbdMt3AeptA2Br3rMIp7qkSsvTd
Unseal Key 2: /HwvkofJu07efPRMlMm6cIa2WcxDVFN19xwJcz0ehSMC
Unseal Key 3: OHiB6yWl/mMtth6x/tJ5tJclQtwhJVWh/iU5yztT9AHn
Unseal Key 4: RIIzuOOSV2qZdKrexN7ML7dXFFUs2U1EJeuh8VB9N4JH
Unseal Key 5: iWcUevGzI35LhDlTUfYO6N54uyOHoFNoU3lqsWRBqwwU

Initial Root Token: s.ix4a42gWLNAS1aiSX8YYyh2t

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.

```

#### Unseal vault

```
~/config # vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       3955a2d4-a8d9-ce5f-93c2-9bc4d11bae70
Version            1.5.4
HA Enabled         true
~/config # vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       3955a2d4-a8d9-ce5f-93c2-9bc4d11bae70
Version            1.5.4
HA Enabled         true
~/config # vault operator unseal
Unseal Key (will be hidden):
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            5
Threshold               3
Version                 1.5.4
Cluster Name            vault-cluster-ff9f3176
Cluster ID              633de624-d683-b0cf-eae0-2901cbdb9187
HA Enabled              true
HA Cluster              n/a
HA Mode                 standby
Active Node Address     <none>
Raft Committed Index    24
Raft Applied Index      24

```

#### Create users and Github authentication

```
~/config # vault login s.ix4a42gWLNAS1aiSX8YYyh2t
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.ix4a42gWLNAS1aiSX8YYyh2t
token_accessor       sVtcgM5OXl45X6hQtFdoWB4X
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
~/config # vault auth enable userpass
Success! Enabled userpass auth method at: userpass/
~/config # vault write auth/userpass/users/abc password=foo
Success! Data written to: auth/userpass/users/abc
~/config # vault auth enable github
Success! Enabled github auth method at: github/
~/config # vault write auth/github/config organization=hpcsquare
Success! Data written to: auth/github/config

```

#### Test authentication as user abc and also with github id ac427 in a different shell

```
[abc@foo 16:24:24 - scripts]$cat user.sh
export VAULT_SKIP_VERIFY=1
export VAULT_ADDR=https://foo.dev.home:8200
[abc@foo 16:24:28 - scripts]$. user.sh
[abc@foo 16:24:30 - scripts]$vault login -method=userpass username=abc
Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.lb3FC9GGVhsOuoM51WoXD9tr
token_accessor         OKYedpooZYzg868OjOW7CfSJ
token_duration         768h
token_renewable        true
token_policies         ["default"]
identity_policies      []
policies               ["default"]
token_meta_username    abc
[abc@foo 16:24:34 - scripts]$

```
```
[abc@foo 16:25:20 - scripts]$vault login -method=github token=$GITHUB_TOKEN
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.Ss2bxMbBIUjwKg4D5IDHnoqz
token_accessor         oJ7ORq2HokoZmGuwCS2hpk4Y
token_duration         768h
token_renewable        true
token_policies         ["default"]
identity_policies      []
policies               ["default"]
token_meta_org         hpcsquare
token_meta_username    ac427

```

#### Lets enable KV2 engine and write some secrets and policies

```
~/config/policies # vault secrets enable -version=2 kv
Success! Enabled the kv secrets engine at: kv/
~/config/policies # cat dev.hcl
path "kv/data/dev" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/dev/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
~/config/policies # cat ops.hcl
path "kv/data/ops" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/ops/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
~/config/policies # vault policy write dev dev.hcl
Success! Uploaded policy: dev
~/config/policies # vault policy write ops ops.hcl
Success! Uploaded policy: ops
```

#### Assign policies to user

```
~/config/policies # vault write auth/userpass/users/abc policies=ops
Success! Data written to: auth/userpass/users/abc
~/config/policies # vault write auth/github/map/users/ac427 value=dev
Success! Data written to: auth/github/map/users/ac427
```


#### Write secrets in ops and dev path

```
~/config/policies # vault kv put kv/ops/password root=root_ops_password
Key              Value
---              -----
created_time     2020-10-07T20:29:10.505628696Z
deletion_time    n/a
destroyed        false
version          1
~/config/policies # vault kv put kv/dev/password root=root_dev_password
Key              Value
---              -----
created_time     2020-10-07T20:29:20.496320972Z
deletion_time    n/a
destroyed        false
version          1

```

#### Test reading secrets

```
[abc@foo 16:30:14 - scripts]$vault login -method=userpass username=abc
Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.9dky2v23h1frBnYM59xIR2QD
token_accessor         mID6EPDUwz3GKd5ZWPWxL0T2
token_duration         768h
token_renewable        true
token_policies         ["default" "ops"]
identity_policies      []
policies               ["default" "ops"]
token_meta_username    abc
[abc@foo 16:30:20 - scripts]$vault kv get kv/ops/password
====== Metadata ======
Key              Value
---              -----
created_time     2020-10-07T20:29:10.505628696Z
deletion_time    n/a
destroyed        false
version          1

==== Data ====
Key     Value
---     -----
root    root_ops_password
[abc@foo 16:30:42 - scripts]$vault kv get kv/dev/password
Error reading kv/data/dev/password: Error making API request.

URL: GET https://foo.dev.home:8200/v1/kv/data/dev/password
Code: 403. Errors:

* 1 error occurred:
	* permission denied

```

```
[abc@foo 16:30:47 - scripts]$$vault login -method=github token=$GITHUB_TOKEN
login: invalid option -- 'm'
Try 'login --help' for more information.
[abc@foo 16:31:32 - scripts]$vault login -method=github token=$GITHUB_TOKEN
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.HCcYPqBRHhpVyb2zB2gTc2sz
token_accessor         USwlC63LWDbvkug3pnnIIhxg
token_duration         768h
token_renewable        true
token_policies         ["default" "dev"]
identity_policies      []
policies               ["default" "dev"]
token_meta_org         hpcsquare
token_meta_username    ac427
[abc@foo 16:31:37 - scripts]$vault kv get kv/dev/password
====== Metadata ======
Key              Value
---              -----
created_time     2020-10-07T20:29:20.496320972Z
deletion_time    n/a
destroyed        false
version          1

==== Data ====
Key     Value
---     -----
root    root_dev_password
[abc@foo 16:31:43 - scripts]$vault kv get kv/ops/password
Error reading kv/data/ops/password: Error making API request.

URL: GET https://foo.dev.home:8200/v1/kv/data/ops/password
Code: 403. Errors:

* 1 error occurred:
	* permission denied

```
#### Enable App roles

```
~/config/policies # vault auth enable approle
Success! Enabled approle auth method at: approle/

```
### create app roles and polices
```
~/scripts/app_roles # cat jobs
bin
crawler
github_scripts
~/scripts/app_roles # cat travis_*.hcl
path "kv/data/travis/bin" {
  capabilities = ["read"]
}
path "kv/data/travis/crawler" {
  capabilities = ["read"]
}
path "kv/data/travis/github_scripts" {
  capabilities = ["read"]
}
~/scripts/app_roles # cat create_approle.sh
#!/bin/sh

vault policy write travis travis.hcl

for job in $(cat jobs)
do
    vault write auth/approle/role/$job \
        secret_id_ttl=10m \
        token_num_uses=10 \
        token_ttl=20m \
        token_max_ttl=30m \
        secret_id_num_uses=40

    vault policy write travis_$job travis_$job.hcl
done
~/scripts/app_roles # ./create_approle.sh
Success! Uploaded policy: travis
Success! Data written to: auth/approle/role/bin
Success! Uploaded policy: travis_bin
Success! Data written to: auth/approle/role/crawler
Success! Uploaded policy: travis_crawler
Success! Data written to: auth/approle/role/github_scripts
Success! Uploaded policy: travis_github_scripts
~/scripts/app_roles # cat travis.hcl
path "auth/token/create" {
  capabilities = [ "create","update"]
}

```

```
~/scripts/app_roles # cat myapp.hcl
path "kv/data/myapp/*" {
  capabilities = [ "read" ]
}
~/scripts/app_roles #  vault policy write  myapp myapp.hcl
Success! Uploaded policy: myapp
~/scripts/app_roles # vault write auth/approle/role/myapp token_policies="myapp"
Success! Data written to: auth/approle/role/myapp
~/scripts/app_roles # vault read auth/approle/role/myapp
Key                        Value
---                        -----
bind_secret_id             true
local_secret_ids           false
secret_id_bound_cidrs      <nil>
secret_id_num_uses         0
secret_id_ttl              0s
token_bound_cidrs          []
token_explicit_max_ttl     0s
token_max_ttl              0s
token_no_default_policy    false
token_num_uses             0
token_period               0s
token_policies             [myapp]
token_ttl                  0s
token_type                 default

~/scripts/app_roles # vault read auth/approle/role/myapp/role-id
Key        Value
---        -----
role_id    ac797686-5816-e7a8-fd18-f5aca9a3e0ca

~/scripts/app_roles # vault write -f auth/approle/role/myapp/secret-id
Key                   Value
---                   -----
secret_id             4181a769-6bc5-49dd-68fd-6f13b28b5a43
secret_id_accessor    40e6e04f-bd13-ebaf-e077-943334551973

## write some secrets
~/scripts/app_roles # vault kv put kv/myapp/password root=myapprootpassword
Key              Value
---              -----
created_time     2020-10-08T00:51:36.430508163Z
deletion_time    n/a
destroyed        false
version          1
~/scripts/app_roles
```

#### On a different shell try to read secrets with app role info
```
[abc@foo 20:51:40 - ~]$rm ~/.vault-token
[abc@foo 20:52:48 - ~]$vault write auth/approle/login role_id=ac797686-5816-e7a8-fd18-f5aca9a3e0ca secret_id=4181a769-6bc5-49dd-68fd-6f13b28b5a43
Key                     Value
---                     -----
token                   s.TIsHk019gPm8pjUrU2JLhWtO
token_accessor          w26HMdlqTqZpbh0u5c4DJsRJ
token_duration          768h
token_renewable         true
token_policies          ["default" "myapp"]
identity_policies       []
policies                ["default" "myapp"]
token_meta_role_name    myapp
[abc@foo 20:53:05 - ~]$VAULT_TOKEN=s.TIsHk019gPm8pjUrU2JLhWtO vault kv get kv/myapp/password
====== Metadata ======
Key              Value
---              -----
created_time     2020-10-08T00:51:36.430508163Z
deletion_time    n/a
destroyed        false
version          1

==== Data ====
Key     Value
---     -----
root    myapprootpassword

```

#### Tokens
```
~/scripts/app_roles # vault write auth/userpass/users/abc policies=ops,travis,travis_bin,travis_crawler,travis_github_scripts
Success! Data written to: auth/userpass/users/abc
```


#### Now travis admin can generate parent token

```
#### Login as user abc
abc@foo 18:21:51 - vault]$vault login -method=userpass username=abc
Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.o9wx94vRMddFtYYD1Xmfp8QE
token_accessor         82opuwLFFhvVvZfmUvUbmpM4
token_duration         768h
token_renewable        true
token_policies         ["default" "ops" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
identity_policies      []
policies               ["default" "ops" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
token_meta_username    abc

```

```
[abc@foo 20:20:13 - vault]$vault token create -policy=travis_bin -policy=travis_crawler -policy=travis_bin
Key                  Value
---                  -----
token                s.Fe2WBYSPTGpxYolWwYNM3iVv
token_accessor       QaraXOOgCxKt8hlZMBxJPTOL
token_duration       768h
token_renewable      true
token_policies       ["default" "travis_bin" "travis_crawler"]
identity_policies    []
policies             ["default" "travis_bin" "travis_crawler"]
```

#### Now we can use the token to create child tokens and use that for requests from jobs

```
[abc@foo 20:35:18 - vault]$vault token create -policy=travis_bin -policy=travis_crawler -policy=travis_github_scripts
Key                  Value
---                  -----
token                s.GOcUnDZK9HgX0LMy83ikKUjY
token_accessor       MJuY6SSoDSC4GiYQ9bRpwoO0
token_duration       768h
token_renewable      true
token_policies       ["default" "travis_bin" "travis_crawler" "travis_github_scripts"]
identity_policies    []
policies             ["default" "travis_bin" "travis_crawler" "travis_github_scripts"]
[abc@foo 20:35:26 - vault]$

```

```
[abc@foo 20:36:57 - vault]$vault login -method=userpass username=abc
Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.xAtm7ypHSy85nE8uQdqRmBFJ
token_accessor         AwLonEKc8h0YDzSic91su572
token_duration         768h
token_renewable        true
token_policies         ["default" "ops" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
identity_policies      []
policies               ["default" "ops" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
token_meta_username    abc
[abc@foo 20:37:40 - vault]$vault token create -policy=travis -policy=travis_crawler -policy=travis_bin -policy=travis_github_scripts
Key                  Value
---                  -----
token                s.6XDiKUJXgyg93GL0mt2Lmz1M
token_accessor       reEmSuiRyEWfg2QYs56z1KLM
token_duration       768h
token_renewable      true
token_policies       ["default" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
identity_policies    []
policies             ["default" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
[abc@foo 20:37:49 - vault]$rm ~/.vault-token
[abc@foo 20:38:04 - vault]$vault login s.6XDiKUJXgyg93GL0mt2Lmz1M
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.6XDiKUJXgyg93GL0mt2Lmz1M
token_accessor       reEmSuiRyEWfg2QYs56z1KLM
token_duration       767h59m36s
token_renewable      true
token_policies       ["default" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
identity_policies    []
policies             ["default" "travis" "travis_bin" "travis_crawler" "travis_github_scripts"]
[abc@foo 20:38:11 - vault]$vault token create -policy=travis_bin
Key                  Value
---                  -----
token                s.9MNCKgKEMmIcxq5bS82wJ4Yb
token_accessor       m3y7Kc3XlMB2j0MZ8Df0Hkhj
token_duration       768h
token_renewable      true
token_policies       ["default" "travis_bin"]
identity_policies    []
policies             ["default" "travis_bin"]
[abc@foo 20:38:17 - vault]$vault login s.9MNCKgKEMmIcxq5bS82wJ4Yb
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.9MNCKgKEMmIcxq5bS82wJ4Yb
token_accessor       m3y7Kc3XlMB2j0MZ8Df0Hkhj
token_duration       767h59m48s
token_renewable      true
token_policies       ["default" "travis_bin"]
identity_policies    []
policies             ["default" "travis_bin"]
[abc@foo 20:38:29 - vault]$vault kv get  kv/travis/bin
====== Metadata ======
Key              Value
---              -----
created_time     2020-10-08T00:34:02.149495245Z
deletion_time    n/a
destroyed        false
version          1

=== Data ===
Key    Value
---    -----
abc    bingghjj
[abc@foo 20:38:37 - vault]$vault kv get  kv/travis/crawler
Error reading kv/data/travis/crawler: Error making API request.

URL: GET https://foo.dev.home:8200/v1/kv/data/travis/crawler
Code: 403. Errors:

* 1 error occurred:
	* permission denied


[abc@foo 20:38:51 - vault]$
```
#### Token roles

```
~/scripts/app_roles # vault policy write travis-admin travis-admin-role.hcl
Success! Uploaded policy: travis-admin
~/scripts/app_roles # vault policy read  travis-admin
path "auth/token/roles/travis-admin" { capabilities = ["read"] }
path "auth/token/create/travis-admin" { capabilities = ["sudo", "create", "update"] }
path "auth/token/roles/travis-admin" { capabilities = ["read"] }
~/scripts/app_roles # vault write auth/token/roles/travis-admin allowed_policies=travis_crawler,travis_bin,travis_github_scripts
Success! Data written to: auth/token/roles/travis-admin
~/scripts/app_roles # vault token create -policy=travis-admin
Key                  Value
---                  -----
token                s.NyRLA4Yu7zPLavGNXyVeWxV6
token_accessor       tVRDPUZyWMn5iap4g9VaoPWs
token_duration       768h
token_renewable      true
token_policies       ["default" "travis-admin"]
identity_policies    []
policies             ["default" "travis-admin"]
```
#### Now we can use the token above to create child tokens to individual policies and return them on request by individual travis job ( you obviously have to write some kind of verification request that it is legit)

```
[abc@foo 08:26:05 - app_roles]$vault login s.NyRLA4Yu7zPLavGNXyVeWxV6
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.NyRLA4Yu7zPLavGNXyVeWxV6
token_accessor       tVRDPUZyWMn5iap4g9VaoPWs
token_duration       767h59m34s
token_renewable      true
token_policies       ["default" "travis-admin"]
identity_policies    []
policies             ["default" "travis-admin"]

[abc@foo 08:43:23 - app_roles]$vault token create -role=travis-admin -policy=travis_bin -period=5m -renewable=false
Key                  Value
---                  -----
token                s.FxzFMqnbMxw0jRyXZ3VGJeM8
token_accessor       8yVZDQvp2reIDzShHkLfXxsg
token_duration       5m
token_renewable      false
token_policies       ["default" "travis_bin"]
identity_policies    []
policies             ["default" "travis_bin"]

```
