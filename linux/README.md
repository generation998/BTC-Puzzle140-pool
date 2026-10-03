# Linux turbo worke

## Run (one command)

```bash
chmod +x run.sh RCKangaroo
./run.sh
```

That joins the open pool `72.62.76.118:17413` with no token, uses all GPUs, and splits tame/wild when more than one GPU is present.

Manual equivalent:

```bash
./RCKangaroo -pool 72.62.76.118:17413 -worker my-gpu0
```

## Files

- `RCKangaroo` — Linux GPU worke
- `kernel_sm89.cubin` / `kernel_sm120.cubin` — turbo kernels (keep next to the binary)
- `run.sh` — one-command join
- `JoinWorker.sh` — optional advanced join

Status: http://72.62.76.118:17490/

Private keys are recovered only on the pool server. Workers never receive the key.
