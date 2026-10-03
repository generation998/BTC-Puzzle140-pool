param(
  [string]$Pool = "72.62.76.118:17413",
  [string]$Token = "",
  [string]$Worker = "",
  [ValidateSet("", "tame", "wild", "0", "1")][string]$Herd = "",
  [string]$Gpu = ""
)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$Exe = Join-Path $PSScriptRoot "RCKangaroo.exe"
if (-not (Test-Path $Exe)) { throw "RCKangaroo.exe missing next to this script." }
if (-not $Worker) { $Worker = "rck-" + $env:COMPUTERNAME }
$arg = @("-pool", $Pool, "-worker", $Worker)
if ($Token) { $arg += @("-token", $Token) }
if ($Herd) { $arg += @("-herd", $Herd) }
if ($Gpu) { $arg += @("-gpu", $Gpu) }
Write-Host "EXE  $Exe"
Write-Host "ARGS $($arg -join ' ')"
& $Exe @arg
