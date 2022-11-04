$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Write-Host "[INFO] script directory: $PSScriptRoot"

$password    ='4qqaOO-QZf4'
$certs_dir   = Join-Path -Path $PSScriptRoot -ChildPath 'certs'
$ca_cert     = Join-Path -Path $certs_dir -ChildPath 'rootCA.pem'
$ca_cert_der = Join-Path -Path $certs_dir -ChildPath 'rootCA.der'
$client_cert = Join-Path -Path $certs_dir -ChildPath 'cert.pem'
$client_key  = Join-Path -Path $certs_dir -ChildPath 'key.pem'
$client_pfx  = Join-Path -Path $certs_dir -ChildPath 'client.pfx'

$client_truststore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-truststore.pkcs12'
$client_keystore_pkcs12 = Join-Path -Path $certs_dir -ChildPath 'client-keystore.pkcs12'

Remove-Item -Force $client_truststore_pkcs12
Remove-Item -Force $client_keystore_pkcs12

& keytool -genkey -dname 'cn=client-truststore' -alias client-truststore -keyalg RSA -keystore $client_truststore_pkcs12 -storetype pkcs12 -keypass $password -storepass $password

& openssl x509 -outform der -in $ca_cert -out $ca_cert_der

& keytool -noprompt -import -keystore $certs_dir/client-truststore.pkcs12 -storepass $password -trustcacerts -file $ca_cert_der -alias tls-gen_basic_ca

& keytool -genkey -dname cn=client-keystore -alias client-keystore -keyalg RSA -keystore $client_keystore_pkcs12 -storetype pkcs12 -keypass $password -storepass $password

& openssl pkcs12 -export -out $client_pfx -passout pass:$password -inkey $client_key -in $client_cert

& keytool -importkeystore -srckeystore $client_pfx -srcstoretype pkcs12 -srcstorepass $password -destkeystore $client_keystore_pkcs12 -destkeypass $password -deststorepass $password -deststoretype pkcs12
