# RCKangaroo pool — worker release

GPU workers for the **RCKangaroo SOTA shared-DP pool** (Puzzle 140, dp=30).

The pool server merges distinguished points and recovers the private key **only on the server**. Workers receive a JOB (pubkey/range/dp/herd) and upload DPs. They are never given the private key.

## Pool

| | |
|--|--|
| DP port | `72.62.76.118:17413` |
| Status | http://72.62.76.118:17490/ |
| Auth | open (no token) |

## Windows: double-click `Run.bat`

Open the `windows/` folder and double-click **`Run.bat`**.

That joins `72.62.76.118:17413` with no token, picks a worker name automatically, and uses all GPUs (tame/wild herd split when more than one GPU is present). Keep `RCKangaroo.exe` and the `.cubin` files in the same folder.

Needs: recent NVIDIA Game Ready / Studio driver.

## Linux: `./run.sh`

```bash
cd linux
chmod +x run.sh RCKangaroo
./run.sh
```

Same open pool, no token, all GPUs / herd split. Keep `RCKangaroo` and the `.cubin` files in the same folder.

## Protocol (summary)

1. Worker: `HELLO name=… [herd=0|1]` (token optional / empty)
2. Server: `JOB herd=… dp=… range=… start=… end=… pubkey=…` / `ENDJOB`
3. Worker: `DPS N` + N lines → Server: `ACK … solved=0|1` (never includes the key)

## Safety

- Do not ship or sync a `secrets/` folder to workers.
- Status JSON does not include private keys.
- Keys remain server-only.

## License

Worker binary/cubins follow `windows/LICENSE.TXT` (upstream RCKangaroo license text).
