$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$password ='4qqaOO-QZf4'
$certs_dir = Join-Path -Path $PSScriptRoot -ChildPath 'certs'
$client_truststore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-truststore.pkcs12'
$client_keystore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-keystore.pkcs12'

& javac $PSScriptRoot\src\TlsClient.java

& java "-Djavax.net.ssl.trustStore=$client_truststore_pkcs12" `
    "-Djavax.net.ssl.trustStorePassword=$password" `
    "-Djavax.net.ssl.trustStoreType=PKCS12" `
    "-Djavax.net.ssl.keyStore=$client_keystore_pkcs12" `
    "-Djavax.net.ssl.keyStorePassword=$password" `
    "-Djavax.net.ssl.keyStoreType=PKCS12" `
    "-Djavax.net.debug=ssl:handshake:verbose" `
    -cp $PSScriptRoot\src TlsClient
