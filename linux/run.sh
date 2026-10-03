#!/usr/bin/env bash
# One-command join: open pool, all GPUs, herd split when multiple GPUs.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
POOL="${POOL:-72.62.76.118:17413}"
PREFIX="${WORKER_PREFIX:-rck-$(hostname)}"

EXE=""
for cand in "$DIR/RCKangaroo" "$DIR/rckangaroo"; do
  if [[ -x "$cand" ]]; then EXE="$cand"; break; fi
done
if [[ -z "$EXE" ]]; then
  echo "Missing executable: $DIR/RCKangaroo (or rckangaroo)"
  exit 1
fi

mapfile -t GPUS < <(nvidia-smi --query-gpu=index --format=csv,noheader 2>/dev/null | tr -d ' ' | grep -E '^[0-9]+$' || true)
if [[ ${#GPUS[@]} -eq 0 ]]; then
  echo "No GPUs found via nvidia-smi; starting single worker without -gpu"
  exec "$EXE" -pool "$POOL" -worker "$PREFIX"
fi

echo "Joining open pool $POOL (no token)"
MULTI=0
if (( ${#GPUS[@]} > 1 )); then MULTI=1; fi
if (( MULTI )); then
  echo "GPUs: ${GPUS[*]}  (even=tame, odd=wild)"
else
  echo "GPUs: ${GPUS[*]}  (mixed herds — matches stock solo MK/s)"
fi

PIDS=()
cleanup() {
  for p in "${PIDS[@]:-}"; do kill "$p" 2>/dev/null || true; done
}
trap cleanup EXIT INT TERM

for i in "${!GPUS[@]}"; do
  gpu="${GPUS[$i]}"
  if (( ${#GPUS[@]} == 1 )); then
    name="${PREFIX}-g${gpu}"
    echo "[1/1] GPU $gpu herd=mixed worker=$name"
    # No -herd: worker runs 1/3 tame + 2/3 wild like stock solo (same KangCnt / MK/s).
    exec "$EXE" -pool "$POOL" -worker "$name" -gpu "$gpu"
  fi
  if (( i % 2 == 0 )); then herd=tame; else herd=wild; fi
  name="${PREFIX}-${herd}-g${gpu}"
  if (( i == 0 )); then
    continue
  fi
  echo "[$((i+1))/${#GPUS[@]}] GPU $gpu herd=$herd worker=$name (background)"
  "$EXE" -pool "$POOL" -worker "$name" -herd "$herd" -gpu "$gpu" &
  PIDS+=($!)
done

gpu0="${GPUS[0]}"
herd0=tame
name0="${PREFIX}-${herd0}-g${gpu0}"
echo "[1/${#GPUS[@]}] GPU $gpu0 herd=$herd0 worker=$name0"
"$EXE" -pool "$POOL" -worker "$name0" -herd "$herd0" -gpu "$gpu0"
