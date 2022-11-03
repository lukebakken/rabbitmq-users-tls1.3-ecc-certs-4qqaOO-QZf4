$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Write-Host "[INFO] script directory: $PSScriptRoot"

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 'Tls12'

$rabbitmq_version='3.11.2'
$rabbitmq_dir = Join-Path -Path $PSScriptRoot -ChildPath "rabbitmq_server-$rabbitmq_version"
$rabbitmq_sbin = Join-Path -Path $rabbitmq_dir -ChildPath 'sbin'
$rabbitmq_download_url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v$rabbitmq_version/rabbitmq-server-windows-$rabbitmq_version.zip"
$rabbitmq_zip_file = Join-Path -Path $PSScriptRoot -ChildPath "rabbitmq-server-windows-$rabbitmq_version.zip"
$rabbitmq_plugins_cmd = Join-Path -Path $rabbitmq_sbin -ChildPath 'rabbitmq-plugins.bat'
$rabbitmq_server_cmd = Join-Path -Path $rabbitmq_sbin -ChildPath 'rabbitmq-server.bat'

$rabbitmq_base = Join-Path -Path $PSScriptRoot -ChildPath 'rmq'
$advanced_config_in = Join-Path -Path $PSScriptRoot -ChildPath 'advanced.config.in'
$advanced_config_out = Join-Path -Path $rabbitmq_base -ChildPath 'advanced.config'
$rabbitmq_conf_in = Join-Path -Path $PSScriptRoot -ChildPath 'rabbitmq.conf.in'
$rabbitmq_conf_out = Join-Path -Path $rabbitmq_base -ChildPath 'rabbitmq.conf'

$env:RABBITMQ_BASE = $rabbitmq_base

if (!(Test-Path -Path $rabbitmq_dir))
{
    New-Item -Path $rabbitmq_base -ItemType Directory
    Invoke-WebRequest -Verbose -UseBasicParsing -Uri $rabbitmq_download_url -OutFile $rabbitmq_zip_file
    Expand-Archive -Path $rabbitmq_zip_file -DestinationPath $PSScriptRoot
    & $rabbitmq_plugins_cmd enable rabbitmq_management
}

(Get-Content -Raw -Path $advanced_config_in) -Replace '@@PWD@@', $pwd | Set-Content -Path $advanced_config_out
(Get-Content -Raw -Path $rabbitmq_conf_in) -Replace '@@PWD@@', $pwd | Set-Content -Path $rabbitmq_conf_out

& $rabbitmq_server_cmd
