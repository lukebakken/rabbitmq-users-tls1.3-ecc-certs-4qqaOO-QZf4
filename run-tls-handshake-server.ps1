$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Write-Host "[INFO] script directory: $PSScriptRoot"

$tls_handshake_src = Join-Path -Path $PSScriptRoot -ChildPath 'src' | Join-Path -ChildPath 'tls_handshake.erl'

& erlc +debug $tls_handshake_src

& erl -noinput -kernel logger_level debug -s tls_handshake start
