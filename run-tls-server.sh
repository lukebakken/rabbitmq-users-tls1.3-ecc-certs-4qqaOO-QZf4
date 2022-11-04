#!/bin/sh
# shellcheck disable=SC2155
set -eu
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly logger_level="${1:-error}"
erlc +debug "$curdir/src/tls_server.erl"
erl -noinput -kernel logger_level "$logger_level" -s tls_server start
