@echo off
cd /d "%~dp0"
title RCKangaroo pool worker
echo Joining open pool 72.62.76.118:17413 (no token)
echo Using all GPUs with tame/wild herd split when multiple GPUs are present.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0JoinHerd.ps1" -Pool 72.62.76.118:17413
if errorlevel 1 pause
