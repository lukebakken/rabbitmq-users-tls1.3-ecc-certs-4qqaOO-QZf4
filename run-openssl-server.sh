#!/bin/sh

set -eu

readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly tlshost="${1:-*}"
readonly tlsport="${2:-9999}"

readonly certs_dir="$curdir/certs"
readonly ca_file="$certs_dir/rootCA.pem"
readonly cert_file="$certs_dir/cert.pem"
readonly key_file="$certs_dir/key.pem"

openssl s_server -accept "$tlshost:$tlsport" \
    -tls1_3 -verify 8 \
    -CAfile "$ca_file" -cert "$cert_file" -key "$key_file"
