#!/bin/sh
# shellcheck disable=SC2155
set -eux
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
erlc +debug "$curdir/src/tls_server.erl"
erl -noinput -kernel logger_level debug -s tls_server start
