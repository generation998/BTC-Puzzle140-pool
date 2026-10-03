# RCKangaroo pool — worker release

GPU workers for the **RCKangaroo SOTA shared-DP pool** (Puzzle 140, dp=30).

The pool server merges distinguished points and recovers the private key **only on the server**. Workers receive a JOB (pubkey/range/dp/herd) and upload DPs. They are never given the private key.

## Pool

| | |
|--|--|
| DP port | `72.62.76.118:17413` |
| Status | http://72.62.76.118:17490/ |
| Auth | token required (ask the pool operator; do not commit real tokens) |

## Windows (turbo ready)

Files in `windows/`:

- `RCKangaroo.exe`
- `kernel_sm89.cubin` (Ada / RTX 40-series turbo)
- `kernel_sm120.cubin` (newer GPUs)
- `JoinWorker.ps1` / `JoinWorker.bat`
- `JoinHerd.ps1` (2-GPU tame/wild split)

`powershell
cd windows
.\JoinWorker.ps1 -Pool 72.62.76.118:17413 -Token YOUR_TOKEN -Worker gpu0
`

Two GPUs:

`powershell
.\JoinHerd.ps1 -Token YOUR_TOKEN -Gpus 0,1
`

Expect JOB `dp=30 range=139`. Keep cubins next to the exe (already in this folder).

Needs: recent NVIDIA Game Ready / Studio driver. No Visual Studio required to run.

## Linux

See `linux/README.md`. Turbo cubins are included; the Linux executable must be built on a machine with CUDA Toolkit (not shipped in this release if no Linux build host was available).

`ash
cd linux
./JoinWorker.sh YOUR_TOKEN gpu0
`

## Protocol (summary)

1. Worker: `HELLO token=… name=… [herd=0|1]`
2. Server: `JOB herd=… dp=… range=… start=… end=… pubkey=…` / `ENDJOB`
3. Worker: `DPS N` + N lines → Server: `ACK … solved=0|1` (never includes the key)

## Safety

- Do not ship or sync a `secrets/` folder to workers.
- Status JSON does not include private keys.
- Replace `YOUR_TOKEN` with the operator-issued token; keep tokens out of public forks.

## License

Worker binary/cubins follow `windows/LICENSE.TXT` (upstream RCKangaroo license text).
