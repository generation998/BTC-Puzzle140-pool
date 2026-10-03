# Linux turbo worker

This folder expects:

- `rckangaroo` (Linux binary, Release)
- `kernel_sm89.cubin` (Ada / sm_89 turbo)
- `kernel_sm120.cubin` (Blackwell turbo, optional)

## Build (Linux + CUDA Toolkit 12.8+)

From the full RCKangaroo-pool source tree (not this release repo):

`ash
cmake -S worker -B worker/build -DCMAKE_BUILD_TYPE=Release \
  -DCUDAToolkit_ROOT=/usr/local/cuda-12.8
cmake --build worker/build -j$(nproc)
cp worker/build/bin/rckangaroo linux/
cp worker/kernel_sm89.cubin worker/kernel_sm120.cubin linux/
chmod +x linux/rckangaroo linux/JoinWorker.sh
`

Requirements: NVIDIA GPU driver, CUDA toolkit matching CMakeLists, g++ with C++20.

## Join pool

`ash
chmod +x JoinWorker.sh
./JoinWorker.sh YOUR_TOKEN my-gpu0
# optional:
HERD=tame GPU=0 ./JoinWorker.sh YOUR_TOKEN tame0
HERD=wild GPU=1 ./JoinWorker.sh YOUR_TOKEN wild1
`

Pool: `72.62.76.118:17413`  
Status: `http://72.62.76.118:17490/`

Private keys are recovered only on the pool server. Workers never receive the key.
