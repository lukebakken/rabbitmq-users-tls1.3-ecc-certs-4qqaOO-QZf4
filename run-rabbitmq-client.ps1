$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Write-Host "[INFO] script directory: $PSScriptRoot"

$ca_file = Join-Path -Path $PSScriptRoot -ChildPath 'certs' | Join-Path -ChildPath 'rootCA.pem'
$cert_file = Join-Path -Path $PSScriptRoot -ChildPath 'certs' | Join-Path -ChildPath 'cert.pem'
$key_file = Join-Path -Path $PSScriptRoot -ChildPath 'certs' | Join-Path -ChildPath 'key.pem'

& openssl s_client -tls1_3 -connect localhost:5671 -CAfile $ca_file -cert $cert_file -key $key_file -verify 8
