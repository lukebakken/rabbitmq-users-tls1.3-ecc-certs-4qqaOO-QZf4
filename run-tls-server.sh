#!/bin/sh
# shellcheck disable=SC2155
set -eux
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
erlc +debug "$curdir/src/tls_server.erl"
erl -noinput -s tls_server start
