### Run Vault mounting the local data directory

```
[abc@foo 10:52:22 - vault]$docker run -p 8200:8200 -v /home/abc/github/ac427/vault/data:/data -v $(pwd):/root -it --cap-add IPC_LOCK --hostname 'foo.dev.home' --entrypoint /bin/sh vault
/ # cd
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

2020-10-02T14:53:28.981Z [INFO]  proxy environment: http_proxy= https_proxy= no_proxy=
2020-10-02T14:56:13.584Z [INFO]  core: security barrier not initialized
2020-10-02T14:56:13.649Z [INFO]  storage.raft: initial configuration: index=1 servers="[{Suffrage:Voter ID:node1 Address:foo.dev.home:8201}]"
2020-10-02T14:56:13.650Z [INFO]  storage.raft: entering follower state: follower="Node at node1 [Follower]" leader=
2020-10-02T14:56:20.101Z [WARN]  storage.raft: heartbeat timeout reached, starting election: last-leader=
2020-10-02T14:56:20.101Z [INFO]  storage.raft: entering candidate state: node="Node at node1 [Candidate]" term=2
2020-10-02T14:56:20.108Z [INFO]  storage.raft: election won: tally=1
2020-10-02T14:56:20.108Z [INFO]  storage.raft: entering leader state: leader="Node at node1 [Leader]"
2020-10-02T14:56:20.127Z [INFO]  core: security barrier initialized: stored=1 shares=5 threshold=3
2020-10-02T14:56:20.182Z [INFO]  core: post-unseal setup starting
2020-10-02T14:56:20.198Z [INFO]  core: loaded wrapping token key
2020-10-02T14:56:20.198Z [INFO]  core: successfully setup plugin catalog: plugin-directory=
2020-10-02T14:56:20.198Z [INFO]  core: no mounts; adding default mount table
2020-10-02T14:56:20.205Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2020-10-02T14:56:20.205Z [INFO]  core: successfully mounted backend: type=system path=sys/
2020-10-02T14:56:20.205Z [INFO]  core: successfully mounted backend: type=identity path=identity/
2020-10-02T14:56:20.222Z [INFO]  core: successfully enabled credential backend: type=token path=token/
2020-10-02T14:56:20.222Z [INFO]  core: restoring leases
2020-10-02T14:56:20.222Z [INFO]  rollback: starting rollback manager
2020-10-02T14:56:20.222Z [INFO]  expiration: lease restore complete
2020-10-02T14:56:20.225Z [INFO]  identity: entities restored
2020-10-02T14:56:20.225Z [INFO]  identity: groups restored
2020-10-02T14:56:20.225Z [INFO]  core: usage gauge collection is disabled
2020-10-02T14:56:20.228Z [INFO]  core: post-unseal setup complete
2020-10-02T14:56:20.236Z [INFO]  core: root token generated
2020-10-02T14:56:20.260Z [INFO]  core: pre-seal teardown starting
2020-10-02T14:56:20.260Z [INFO]  rollback: stopping rollback manager
2020-10-02T14:56:20.260Z [INFO]  core: pre-seal teardown complete
2020-10-02T15:00:37.971Z [INFO]  core.cluster-listener.tcp: starting listener: listener_address=172.17.0.2:8201
2020-10-02T15:00:37.971Z [INFO]  core.cluster-listener: serving cluster requests: cluster_listen_address=172.17.0.2:8201
2020-10-02T15:00:37.973Z [INFO]  storage.raft: initial configuration: index=1 servers="[{Suffrage:Voter ID:node1 Address:foo.dev.home:8201}]"
2020-10-02T15:00:37.973Z [INFO]  core: vault is unsealed
2020-10-02T15:00:37.973Z [INFO]  storage.raft: entering follower state: follower="Node at foo.dev.home:8201 [Follower]" leader=
2020-10-02T15:00:37.973Z [INFO]  core: entering standby mode
2020-10-02T15:00:43.479Z [WARN]  storage.raft: heartbeat timeout reached, starting election: last-leader=
2020-10-02T15:00:43.479Z [INFO]  storage.raft: entering candidate state: node="Node at foo.dev.home:8201 [Candidate]" term=3
2020-10-02T15:00:43.484Z [INFO]  storage.raft: election won: tally=1
2020-10-02T15:00:43.484Z [INFO]  storage.raft: entering leader state: leader="Node at foo.dev.home:8201 [Leader]"
2020-10-02T15:00:43.489Z [INFO]  core: acquired lock, enabling active operation
2020-10-02T15:00:43.541Z [INFO]  core: post-unseal setup starting
2020-10-02T15:00:43.543Z [INFO]  core: loaded wrapping token key
2020-10-02T15:00:43.543Z [INFO]  core: successfully setup plugin catalog: plugin-directory=
2020-10-02T15:00:43.543Z [INFO]  core: successfully mounted backend: type=system path=sys/
2020-10-02T15:00:43.543Z [INFO]  core: successfully mounted backend: type=identity path=identity/
2020-10-02T15:00:43.543Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2020-10-02T15:00:43.544Z [INFO]  core: successfully enabled credential backend: type=token path=token/
2020-10-02T15:00:43.544Z [INFO]  core: restoring leases
2020-10-02T15:00:43.544Z [INFO]  rollback: starting rollback manager
2020-10-02T15:00:43.544Z [INFO]  identity: entities restored
2020-10-02T15:00:43.544Z [INFO]  identity: groups restored
2020-10-02T15:00:43.544Z [INFO]  expiration: lease restore complete
2020-10-02T15:00:43.545Z [INFO]  core: usage gauge collection is disabled
2020-10-02T15:00:43.546Z [INFO]  core: post-unseal setup complete
````

### Init and unseal

```
[abc@foo 10:55:11 - vault]$docker exec -it admiring_jennings /bin/sh
/ # cd[abc@foo 07:00:16 - vault]$docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                    NAMES
4c0a78e1d235        vault               "/bin/sh"           About a minute ago   Up About a minute   0.0.0.0:8200->8200/tcp   pedantic_lichterman
[abc@foo 08:56:53 - vault]$docker exec -it pedantic_lichterman /bin/sh

~ # export VAULT_SKIP_VERIFY=1
~ # export VAULT_ADDR=https://foo.dev.home:8200
~ # vault operator init -tls-skip-verify
Unseal Key 1: CkPymnNN/4dsgZ93fgGd5kYFPPk7UH8WFjNP92hqasd2
Unseal Key 2: rCBvZBAOALkHGWkvtGmARxwy35wq5h7c+4061wZd9hlT
Unseal Key 3: 4BWZTeXA5ll/QnrHubcDpNjJ2QDmQvjhzSlFmE3Yb1lF
Unseal Key 4: ET2Gsrl1/fLzBmdMVqJf8lfo+Iab80IT3c04BCcm2kqv
Unseal Key 5: fsbhZPSQRwg8l6z2vofVjO4xYYDkw45bQ3xbj3fgPMPc

Initial Root Token: s.6vAviCS1F7nNcESMXDtJES2c

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
~ # vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       a7e40d03-87b9-4c09-d1b8-59217f319df6
Version            1.5.4
HA Enabled         true
~ # vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       a7e40d03-87b9-4c09-d1b8-59217f319df6
Version            1.5.4
HA Enabled         true
~ # vault operator unseal
Unseal Key (will be hidden):
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            5
Threshold               3
Version                 1.5.4
Cluster Name            vault-cluster-cbc2958a
Cluster ID              09d32fd5-d29f-445f-5ae9-18996c655b49
HA Enabled              true
HA Cluster              https://foo.dev.home:8201
HA Mode                 active
Raft Committed Index    29
Raft Applied Index      29
~ # vault login s.6vAviCS1F7nNcESMXDtJES2c
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.6vAviCS1F7nNcESMXDtJES2c
token_accessor       CxcJu60pPczwc81mFsZcXyda
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```


### Enable userpass

```
~ # vault auth enable userpass
Success! Enabled userpass auth method at: userpass/

```

### Enable KV secrets version 2

```
~ # vault secrets enable -version=2 kv
Success! Enabled the kv secrets engine at: kv/

```

### create user abc with admins policy

```
foo:~$ ~ # vault write auth/userpass/users/abc password=foo policies=admins
Success! Data written to: auth/userpass/users/abc
~ # su - abc
foo:~$ export VAULT_ADDR=https://foo.dev.home:8200
foo:~$ export VAULT_SKIP_VERIFY=1
foo:~$ vault login -method=userpass username=abc
Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.uJwzhr7Wh5ipqCrTdwM2v568
token_accessor         yYPWdLShaI5wbAMQRA8Plump
token_duration         768h
token_renewable        true
token_policies         ["admins" "default"]
identity_policies      []
policies               ["admins" "default"]
token_meta_username    abc
```

### Enable github auth

```
foo:~$ ~ # vault auth enable github
Success! Enabled github auth method at: github/
~ # vault write auth/github/config organization=hpcsquare
Success! Data written to: auth/github/config
```


### Test login

```
[abc@foo 17:36:42 - scripts]$vault login -method=github token=$GITHUB_TOKEN
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.Y7suyU5ygPBrmSfcxiwuB1hN
token_accessor         oy8a5he6i5RVzxp6jW4qOKlH
token_duration         768h
token_renewable        true
token_policies         ["default"]
identity_policies      []
policies               ["default"]
token_meta_org         hpcsquare
token_meta_username    ac427
```

### Generate policies and syntax check

```
[abc@foo 17:57:34 - policies]$vault policy fmt ops.hcl
failed to parse policy: path "secret/ops/*": invalid capability "write"
[abc@foo 17:57:52 - policies]$vi ops.hcl
[abc@foo 17:58:09 - policies]$vault policy fmt ops.hcl
Success! Formatted policy: ops.hcl
[abc@foo 17:58:10 - policies]$vi dev.hcl
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

~/config/policies # vault policy write ops ops.hcl
Success! Uploaded policy: ops
~/config/policies # vault policy write dev dev.hcl
Success! Uploaded policy: dev
```

### add user to dev and ops policies

```
~/config/policies # vault write auth/userpass/users/abc policies="dev,ops"
Success! Data written to: auth/userpass/users/abc
```

### verify as user abc
```
[abc@foo 21:41:38 - vault]$vault login -method=userpass username=abc
Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.G2f0xVRTVaKGqKTC0gGD8wAG
token_accessor         SwDSjVDQEe8K4i5n6uqvvSEF
token_duration         768h
token_renewable        true
token_policies         ["default" "dev" "ops"]
identity_policies      []
policies               ["default" "dev" "ops"]
token_meta_username    abc
[abc@foo 21:42:05 - vault]$vault kv put kv/dev/foo foo=bar
Key              Value
---              -----
created_time     2020-10-03T01:42:09.764525194Z
deletion_time    n/a
destroyed        false
version          2
```

### Give github user ac427 access to dev policy

```
~/config/policies # vault write auth/github/map/users/ac427 value=dev
Success! Data written to: auth/github/map/users/ac427
```

### Verify as user ac427

```
[abc@foo 21:43:02 - vault]$vault login -method=github token=$GITHUB_TOKEN
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  s.EiCGz7JOCFWi60K2xyhhwZUR
token_accessor         AyUQibKCEW3NdHpwYeZSBFBG
token_duration         768h
token_renewable        true
token_policies         ["default" "dev"]
identity_policies      []
policies               ["default" "dev"]
token_meta_org         hpcsquare
token_meta_username    ac427

### permission denined to the policy ops ( as expected )
[abc@foo 21:46:57 - vault]$vault kv put kv/ops/foo foo=bar
Error writing data to kv/data/ops/foo: Error making API request.

URL: PUT https://foo.dev.home:8200/v1/kv/data/ops/foo
Code: 403. Errors:

* 1 error occurred:
	* permission denied

### write to path in dev policy

[abc@foo 21:47:05 - vault]$vault kv put kv/dev/foo foo=bar
Key              Value
---              -----
created_time     2020-10-03T01:47:09.853215004Z
deletion_time    n/a
destroyed        false
version          3

```
