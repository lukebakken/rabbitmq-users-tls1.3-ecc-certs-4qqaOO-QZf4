# shellcheck disable=SC2155
set -eu
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

readonly tlshost="${1:-localhost}"
readonly tlsport="${2:-9999}"

echo "[INFO] Connecting to TLS host: $tlshost, TLS port: $tlsport"

readonly password='4qqaOO-QZf4'
readonly certs_dir="$curdir/certs"
readonly client_truststore_pkcs12="$certs_dir/client-truststore.pkcs12"
readonly client_keystore_pkcs12="$certs_dir/client-keystore.pkcs12"

java -jar ssltest.jar -enabledprotocols 'TLSv1.3' -sslprotocol 'TLSv1.3' \
    -keystore "$client_keystore_pkcs12" -keystoretype PKCS12 -keystorepassword "$password" \
    -truststore "$client_truststore_pkcs12" -truststoretype PKCS12 -truststorepassword "$password" \
    "$tlshost:$tlsport"
