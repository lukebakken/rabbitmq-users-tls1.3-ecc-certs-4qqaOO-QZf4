$ProgressPreference = 'Continue'
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

Write-Host "[INFO] script directory: $PSScriptRoot"

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 'Tls12'

$rabbitmq_version='3.11.2'
$rabbitmq_dir = Join-Path -Path $PSScriptRoot -ChildPath "rabbitmq_server-$rabbitmq_version"
$rabbitmq_etc = Join-Path -Path $rabbitmq_dir -ChildPath 'etc' | Join-Path -ChildPath 'rabbitmq'
$rabbitmq_sbin = Join-Path -Path $rabbitmq_dir -ChildPath 'sbin'
$rabbitmq_download_url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v$rabbitmq_version/rabbitmq-server-windows-$rabbitmq_version.zip"
$rabbitmq_zip_file = Join-Path -Path $PSScriptRoot -ChildPath "rabbitmq-server-windows-$rabbitmq_version.zip"

# readonly rabbitmq_etc="$curdir/rabbitmq_server-$rabbitmq_version/etc/rabbitmq"
# readonly rabbitmq_sbin="$curdir/rabbitmq_server-$rabbitmq_version/sbin"
# sed "s|@@PWD@@|$PWD|" "$curdir/advanced.config.in" > "$rabbitmq_etc/advanced.config"
# sed "s|@@PWD@@|$PWD|" "$curdir/rabbitmq.conf.in" > "$rabbitmq_etc/rabbitmq.conf"
# if [ ! -d rabbitmq_server-3.11.2 ]
# then
#     curl -LO "https://github.com/rabbitmq/rabbitmq-server/releases/download/v$rabbitmq_version/rabbitmq-server-generic-unix-$rabbitmq_version.tar.xz"
#     tar xf "rabbitmq-server-generic-unix-$rabbitmq_version.tar.xz"
#     "$rabbitmq_sbin/rabbitmq-plugins" enable rabbitmq_management
# fi
# 
# "$rabbitmq_sbin/rabbitmq-server"

if (!(Test-Path -Path $rabbitmq_dir))
{
    Invoke-WebRequest -Verbose -UseBasicParsing -Uri $rabbitmq_download_url -OutFile $rabbitmq_zip_file
    Expand-Archive -Path $rabbitmq_zip_file -DestinationPath $PSScriptRoot
}
