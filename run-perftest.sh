#!/bin/sh

set -eu

readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

readonly host="${1:-localhost}"
readonly port="${2:-5671}"
readonly perftest_version='2.19.0.RC1'
readonly perftest_dir="$curdir/rabbitmq-perf-test-$perftest_version"
readonly perftest_download_url="https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v$perftest_version/perf-test-$perftest_version.jar"
readonly perftest_jar="$curdir/perf-test-$perftest_version.jar"

if [ ! -e "$perftest_jar" ]
then
    curl -LO "$perftest_download_url"
fi

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
    -jar "$perftest_jar" \
    "--uri=amqps://$host:$port" --use-default-ssl-context \
    --rate=1 --producers=1 --consumers=3 --flag=persistent --flag=mandatory
