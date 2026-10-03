# Linux worker

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

## GPU support

- **Ada / Blackwell (sm89 / sm120):** turbo cubins (`kernel_sm89.cubin` / `kernel_sm120.cubin`) when kept next to the binary.
- **Ampere A100 (sm_80) and older:** legacy CUDA kernels built into `RCKangaroo` (no turbo). The binary includes `sm_80` gencode so A100 does not need a cubin.

## Files

- `RCKangaroo` — Linux GPU worker (legacy + turbo paths)
- `kernel_sm89.cubin` / `kernel_sm120.cubin` — turbo kernels for 4xxx/5xxx (optional on A100)
- `run.sh` — one-command join
- `JoinWorker.sh` — optional advanced join

Status: http://72.62.76.118:17490/
