@echo off
cd /d "%~dp0"
title RCKangaroo pool worker
echo Joining open pool 72.62.76.118:17413 (no token)
echo 1 GPU = mixed herds (same MK/s as stock). 2+ GPUs = tame/wild split.
echo Keep this folder as cwd so kernel_sm89.cubin / kernel_sm120.cubin load (turbo).
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0JoinHerd.ps1" -Pool 72.62.76.118:17413
if errorlevel 1 pause
