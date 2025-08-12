#!/bin/bash
set -e

# exit immediately if any command returns a non-zero/error status
# run in lightweight shell 

# set variables, ssl for nginx.key (private key) and nginx.crt (certification file)
mkdir -p /etc/ssl/private /etc/ssl/certs

# self-signed certification request, no DES encryption, not needed password to start, 1 year validity, RSA standard 2048 bits long, path
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx.key \
  -out /etc/ssl/certs/nginx.crt \
  -subj "/C=PT/ST=Lisbon/L=Lisbon/O=42/OU=Inception/CN=localhost"
