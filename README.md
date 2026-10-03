# RCKangaroo pool — worker release

GPU workers for the **RCKangaroo SOTA shared-DP pool** (Puzzle 140, dp=30).

The pool server merges distinguished points . Workers receive a JOB (pubkey/range/dp/herd) and upload DPs.

## Pool

| | |
|--|--|
| DP port | `72.62.76.118:17413` |
| Status | http://72.62.76.118:17490/ |
| Auth | open (no token) |

## Windows: double-click `Run.bat`

Open the `windows/` folder and double-click **`Run.bat`**.

That joins `72.62.76.118:17413` with no token, picks a worker name automatically, and uses all GPUs. **One GPU runs mixed herds** (same KangCnt / MK/s as stock solo). **Two or more GPUs** alternate tame/wild. Keep `RCKangaroo.exe` and the `.cubin` files in the same folder (cwd) so turbo kernels load.

**Speed:** on an RTX 4070 Laptop expect **~900–1100 MK/s** in the worker console (`Speed: N MKeys/s`) — matching stock RCKangaroo turbo. Status `dps_per_s` at dp=30 is only a few DPs/s; that is not GH/s.

Needs: recent NVIDIA Game Ready / Studio driver.

## Linux: `./run.sh`

```bash
cd linux
chmod +x run.sh RCKangaroo
./run.sh
```

Same open pool, no token, all GPUs / herd split. Keep `RCKangaroo` and the `.cubin` files in the same folder.

**GPU kernels:** Ada/Blackwell (sm89 / sm120) load turbo cubins when present. Ampere **A100 (sm_80)** and older GPUs use the **legacy CUDA** path embedded in the binary (no turbo cubin; `sm_80` gencode included). Expect a console line like `legacy CUDA kernels (no turbo cubin)` on A100 — that is normal.

## Protocol (summary)

1. Worker: `HELLO name=… [herd=0|1]` (token optional / empty)
2. Server: `JOB herd=… dp=… range=… start=… end=… pubkey=…` / `ENDJOB`
3. Worker: `DPS N` + N lines → Server: `ACK … solved=0|1` 


## License

Worker binary/cubins follow `windows/LICENSE.TXT` (upstream RCKangaroo license text).
