#!/bin/sh
# https://stackoverflow.com/a/1710543
# shellcheck disable=SC2155

set -e
set -u

readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly password='4qqaOO-QZf4'
readonly certs_dir="$curdir/certs"
readonly ca_cert="$certs_dir/rootCA.pem"
readonly ca_cert_der="$certs_dir/rootCA.der"
readonly client_cert="$certs_dir/cert.pem"
readonly client_key="$certs_dir/key.pem"
readonly client_pfx="$certs_dir/client.pfx"

readonly client_truststore_pkcs12="$certs_dir/client-truststore.pkcs12"
readonly client_keystore_pkcs12="$certs_dir/client-keystore.pkcs12"

rm -f "$client_truststore_pkcs12"
rm -f "$client_keystore_pkcs12"

keytool -genkey -dname "cn=client-truststore" -alias client-truststore -keyalg RSA -keystore "$client_truststore_pkcs12" -storetype pkcs12 -keypass "$password" -storepass "$password"

openssl x509 -outform der -in "$ca_cert" -out "$ca_cert_der"

keytool -noprompt -import -keystore "$client_truststore_pkcs12" -storepass "$password" -trustcacerts -file "$ca_cert_der" -alias tls-gen_basic_ca

keytool -genkey -dname "cn=client-keystore" -alias client-keystore -keyalg RSA -keystore "$client_keystore_pkcs12" -storetype pkcs12 -keypass "$password" -storepass "$password"

openssl pkcs12 -export -out "$client_pfx" -passout "pass:$password" -inkey "$client_key" -in "$client_cert"

keytool -importkeystore -srckeystore "$client_pfx" -srcstoretype pkcs12 -srcstorepass "$password" -destkeystore "$client_keystore_pkcs12" -destkeypass "$password" -deststorepass "$password" -deststoretype pkcs12
