@echo off
REM Optional advanced join. Prefer Run.bat for one-click start.
REM Usage: JoinWorker.bat [worker_name]
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0JoinWorker.ps1" -Pool 72.62.76.118:17413 -Worker "%~1"
