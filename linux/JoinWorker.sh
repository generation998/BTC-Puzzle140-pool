#!/usr/bin/env bash
set -euo pipefail
POOL="${POOL:-72.62.76.118:17413}"
TOKEN="${1:-}"
WORKER="${2:-rck-$(hostname)}"
HERD="${HERD:-}"
GPU="${GPU:-}"
DIR="$(cd "$(dirname "$0")" && pwd)"
EXE="$DIR/rckangaroo"
if [[ -z "$TOKEN" ]]; then
  echo "Usage: $0 TOKEN [worker_name]"
  echo "Env: POOL=host:port HERD=tame|wild GPU=0"
  exit 1
fi
if [[ ! -x "$EXE" ]]; then
  echo "Linux worker binary not present: $EXE"
  echo "Build on a Linux host with CUDA 12.x toolkit:"
  echo "  cmake -S worker -B worker/build -DCMAKE_BUILD_TYPE=Release"
  echo "  cmake --build worker/build -j"
  echo "  cp worker/build/bin/rckangaroo linux/"
  echo "  cp worker/kernel_sm89.cubin worker/kernel_sm120.cubin linux/"
  exit 1
fi
ARGS=(-pool "$POOL" -token "$TOKEN" -worker "$WORKER")
[[ -n "$HERD" ]] && ARGS+=(-herd "$HERD")
[[ -n "$GPU" ]] && ARGS+=(-gpu "$GPU")
echo "EXE  $EXE"
echo "ARGS ${ARGS[*]}"
exec "$EXE" "${ARGS[@]}"
