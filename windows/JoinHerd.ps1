# Launch one worker per GPU. 1 GPU = mixed herds (stock path). 2+ = tame/wild split.
param(
  [string]$Pool = "72.62.76.118:17413",
  [string]$Token = "",
  [string]$Gpus = "",
  [string]$WorkerPrefix = ""
)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Get-GpuIndexes {
  if ($Gpus) {
    return @($Gpus.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })
  }
  $out = & nvidia-smi --query-gpu=index --format=csv,noheader 2>$null
  if ($LASTEXITCODE -ne 0 -or -not $out) {
    throw "Could not list GPUs (nvidia-smi). Pass -Gpus 0,1 explicitly."
  }
  return @($out | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' })
}

$indexes = @(Get-GpuIndexes)
if ($indexes.Count -lt 1) { throw "No GPUs selected." }
if (-not $WorkerPrefix) { $WorkerPrefix = "rck-" + $env:COMPUTERNAME }

$join = Join-Path $PSScriptRoot "JoinWorker.ps1"
$multi = $indexes.Count -gt 1
Write-Host "Pool  $Pool"
Write-Host ("GPUs  {0}" -f ($indexes -join ', '))
Write-Host ("Mode  {0}" -f $(if ($multi) { "herd-split (even=tame, odd=wild)" } else { "mixed herds (matches stock solo MK/s)" }))

for ($i = 0; $i -lt $indexes.Count; $i++) {
  $gpu = $indexes[$i]
  $herd = ""
  if ($multi) { $herd = if (($i % 2) -eq 0) { "tame" } else { "wild" } }
  $name = if ($herd) { "{0}-{1}-g{2}" -f $WorkerPrefix, $herd, $gpu } else { "{0}-g{1}" -f $WorkerPrefix, $gpu }
  $herdLabel = if ($herd) { $herd } else { "mixed" }

  if ($i -eq 0 -and $indexes.Count -eq 1) {
    Write-Host ("[1/1] GPU {0} herd={1} worker={2}" -f $gpu, $herdLabel, $name)
    if ($herd) { & $join -Pool $Pool -Worker $name -Herd $herd -Gpu "$gpu" -Token $Token }
    else { & $join -Pool $Pool -Worker $name -Gpu "$gpu" -Token $Token }
    return
  }

  if ($i -eq 0) {
    for ($j = 1; $j -lt $indexes.Count; $j++) {
      $gpu2 = $indexes[$j]
      $herd2 = if (($j % 2) -eq 0) { "tame" } else { "wild" }
      $name2 = "{0}-{1}-g{2}" -f $WorkerPrefix, $herd2, $gpu2
      $args2 = @(
        "-NoProfile", "-ExecutionPolicy", "Bypass",
        "-File", $join,
        "-Pool", $Pool,
        "-Worker", $name2,
        "-Herd", $herd2,
        "-Gpu", "$gpu2"
      )
      if ($Token) { $args2 += @("-Token", $Token) }
      Write-Host ("[{0}/{1}] GPU {2} herd={3} worker={4} (background)" -f ($j + 1), $indexes.Count, $gpu2, $herd2, $name2)
      $null = Start-Process -FilePath "powershell.exe" -ArgumentList $args2 -WorkingDirectory $PSScriptRoot -WindowStyle Minimized
    }
    Write-Host ("[1/{0}] GPU {1} herd={2} worker={3}" -f $indexes.Count, $gpu, $herdLabel, $name)
    if ($herd) { & $join -Pool $Pool -Worker $name -Herd $herd -Gpu "$gpu" -Token $Token }
    else { & $join -Pool $Pool -Worker $name -Gpu "$gpu" -Token $Token }
    return
  }
}
