param([string]$RabbitMQHost='localhost')

$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Write-Host "[INFO] Connecting to RabbitMQ host: $RabbitMQHost"

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 'Tls12'

$perftest_version = '2.19.0.RC1'
$perftest_dir = Join-Path -Path $PSScriptRoot -ChildPath "rabbitmq-perf-test-$perftest_version"
$perftest_download_url = "https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v$perftest_version/perf-test-$perftest_version.jar"
$perftest_jar = Join-Path -Path $PSScriptRoot -ChildPath "perf-test-$perftest_version.jar"

if (!(Test-Path -Path $perftest_jar))
{
    Invoke-WebRequest -Verbose -UseBasicParsing -Uri $perftest_download_url -OutFile $perftest_jar
}

$password ='4qqaOO-QZf4'
$certs_dir = Join-Path -Path $PSScriptRoot -ChildPath 'certs'
$client_truststore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-truststore.pkcs12'
$client_keystore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-keystore.pkcs12'

& java "-Djavax.net.ssl.trustStore=$client_truststore_pkcs12" `
    "-Djavax.net.ssl.trustStorePassword=$password" `
    "-Djavax.net.ssl.trustStoreType=PKCS12" `
    "-Djavax.net.ssl.keyStore=$client_keystore_pkcs12" `
    "-Djavax.net.ssl.keyStorePassword=$password" `
    "-Djavax.net.ssl.keyStoreType=PKCS12" `
    -jar $perftest_jar `
    "--uri=amqps://${RabbitMQHost}:5671" --use-default-ssl-context `
    --rate=1 --producers=1 --consumers=3 --flag=persistent --flag=mandatory
