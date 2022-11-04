# shellcheck disable=SC2155
set -eu
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

readonly tlshost="${1:-localhost}"
readonly tlsport="${2:-9999}"

echo "[INFO] Connecting to TLS host: $tlshost, TLS port: $tlsport"

echo 'FOO BAR BAZ' | openssl s_client -tls1_3 -ign_eof -connect "$tlshost:$tlsport" \
    -CAfile "$curdir/certs/rootCA.pem" \
    -cert "$curdir/certs/cert.pem" \
    -key "$curdir/certs/key.pem" -verify 8
