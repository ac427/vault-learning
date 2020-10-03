storage "raft" {
  path    = "/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "foo.dev.home:8200"
  tls_cert_file =  "../cert/client.crt"
  tls_key_file  = "../cert/client.key"
}

api_addr = "https://foo.dev.home:8200"
cluster_addr = "https://foo.dev.home:8201"
ui = true
