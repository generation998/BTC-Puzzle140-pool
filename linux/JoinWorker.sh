#!/usr/bin/env bash
set -euo pipefail
POOL="${POOL:-72.62.76.118:17413}"
WORKER="${1:-rck-$(hostname)}"
HERD="${HERD:-}"
GPU="${GPU:-}"
TOKEN="${TOKEN:-}"
DIR="$(cd "$(dirname "$0")" && pwd)"
EXE=""
for cand in "$DIR/RCKangaroo" "$DIR/rckangaroo"; do
  if [[ -x "$cand" ]]; then EXE="$cand"; break; fi
done
if [[ -z "$EXE" ]]; then
  echo "Linux worker binary not present in $DIR (expected RCKangaroo or rckangaroo)"
  exit 1
fi
ARGS=(-pool "$POOL" -worker "$WORKER")
[[ -n "$TOKEN" ]] && ARGS+=(-token "$TOKEN")
[[ -n "$HERD" ]] && ARGS+=(-herd "$HERD")
[[ -n "$GPU" ]] && ARGS+=(-gpu "$GPU")
echo "EXE  $EXE"
echo "ARGS ${ARGS[*]}"
exec "$EXE" "${ARGS[@]}"
