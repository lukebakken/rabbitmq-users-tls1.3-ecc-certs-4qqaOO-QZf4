# shellcheck disable=SC2155
set -eu
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

openssl s_client -tls1_3 -connect localhost:5671 \
    -CAfile "$curdir/certs/rootCA.pem" \
    -cert "$curdir/certs/cert.pem" \
    -key "$curdir/certs/key.pem" -verify 8
