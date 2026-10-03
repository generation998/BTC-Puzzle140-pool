@echo off
REM Usage: JoinWorker.bat TOKEN [WORKER_NAME]
if "%~1"=="" (
  echo Usage: JoinWorker.bat YOUR_TOKEN [worker_name]
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0JoinWorker.ps1" -Pool 72.62.76.118:17413 -Token "%~1" -Worker "%~2"
