# Generate self signed root CA cert
openssl req -nodes -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -subj "/C=US/ST=MA/L=Boston/O=IT/OU=root/CN=foo.dev.home/emailAddress=root@foo.com"


# Generate server cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/C=US/ST=MA/L=Boston/O=IT/OU=root/CN=foo.dev.home/emailAddress=root@foo.com"


# Sign the server cert
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt

# Create server PEM file
cat server.key server.crt > ../cert/server.pem


# Generate client cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout client.key -out client.csr -subj "/C=US/ST=MA/L=Boston/O=IT/OU=root/CN=foo.dev.home/emailAddress=root@foo.com"

# Sign the client cert
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAserial ca.srl -out client.crt

# Create client PEM file
cat client.key client.crt > ../cert/client.pem
