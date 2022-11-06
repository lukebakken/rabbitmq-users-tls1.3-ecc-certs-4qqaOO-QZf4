#!/bin/sh

set -eu

readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

readonly password='4qqaOO-QZf4'
readonly certs_dir="$curdir/certs"
readonly client_truststore_pkcs12="$certs_dir/client-truststore.pkcs12"
readonly client_keystore_pkcs12="$certs_dir/client-keystore.pkcs12"

java "-Djavax.net.ssl.trustStore=$client_truststore_pkcs12" \
    "-Djavax.net.ssl.trustStorePassword=$password" \
    "-Djavax.net.ssl.trustStoreType=PKCS12" \
    "-Djavax.net.ssl.keyStore=$client_keystore_pkcs12" \
    "-Djavax.net.ssl.keyStorePassword=$password" \
    "-Djavax.net.ssl.keyStoreType=PKCS12" \
    "-Djavax.net.debug=ssl:handshake:verbose" \
    -cp "$curdir/src" TlsClient
