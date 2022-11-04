param([string]$TlsHost='localhost', [int]$TlsPort=9999)

$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Write-Host "[INFO] Connecting to TLS host: $TlsHost, TLS port: $TlsPort"

$password ='4qqaOO-QZf4'
$certs_dir = Join-Path -Path $PSScriptRoot -ChildPath 'certs'
$client_truststore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-truststore.pkcs12'
$client_keystore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-keystore.pkcs12'

java -jar ssltest.jar -enabledprotocols 'TLSv1.3' -sslprotocol 'TLSv1.3' `
    -keystore $client_keystore_pkcs12 -keystoretype PKCS12 -keystorepassword $password `
    -truststore $client_truststore_pkcs12 -truststoretype PKCS12 -truststorepassword $password `
    ${TlsHost}:${TlsPort}
