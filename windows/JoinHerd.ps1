param(
  [Parameter(Mandatory = $true)][string]$Token,
  [string]$Pool = "72.62.76.118:17413",
  [string]$Gpus = "0,1"
)
$ErrorActionPreference = "Stop"
$gpus = $Gpus.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
if ($gpus.Count -lt 2) { throw "Need at least two GPU ids, e.g. -Gpus 0,1" }
$root = $PSScriptRoot
$jobs = @()
$jobs += Start-Process -FilePath "powershell" -ArgumentList @(
  "-NoProfile","-ExecutionPolicy","Bypass","-File",(Join-Path $root "JoinWorker.ps1"),
  "-Pool",$Pool,"-Token",$Token,"-Herd","tame","-Gpu",$gpus[0],"-Worker","tame-gpu$([0])"
) -PassThru -WorkingDirectory $root
$jobs += Start-Process -FilePath "powershell" -ArgumentList @(
  "-NoProfile","-ExecutionPolicy","Bypass","-File",(Join-Path $root "JoinWorker.ps1"),
  "-Pool",$Pool,"-Token",$Token,"-Herd","wild","-Gpu",$gpus[1],"-Worker","wild-gpu$([1])"
) -PassThru -WorkingDirectory $root
Write-Host "Started tame on GPU $($gpus[0]) and wild on GPU $($gpus[1]). Press Ctrl+C here does not stop them; close their windows or taskkill."
$jobs | ForEach-Object { Write-Host "PID $($_.Id)" }
