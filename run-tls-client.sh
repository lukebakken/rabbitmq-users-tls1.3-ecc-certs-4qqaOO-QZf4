# shellcheck disable=SC2155
set -eux
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

echo 'FOO BAR BAZ' | openssl s_client -tls1_3 -ign_eof -connect localhost:9999 \
    -CAfile "$curdir/certs/rootCA.pem" \
    -cert "$curdir/certs/cert.pem" \
    -key "$curdir/certs/key.pem" -verify 8
