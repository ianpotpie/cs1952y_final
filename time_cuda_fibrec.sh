#!/bin/bash
#SBATCH -p gpu --gres=gpu:1
#SBATCH -n 1
#SBATCH --mem=12G
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -o out/time-cuda-fibrec-on-a5000-%j.out
#SBATCH -e out/time-cuda-fibrec-on-a5000-%j.err
#SBATCH -C a5000

module load openssl/1.1.1t-u2rkdft
module load python/3.11.0s-ixrhc3q
module load zlib/1.2.13-jv5y5e7
module load rust/1.81.0-3qqoayc
module load cuda/12.2.0-4lgnkrh

cargo install hvm --force

echo -e "\n====== GPU Information (if available) ======"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi
else
    echo "No NVIDIA GPU available or nvidia-smi not found"
fi

echo -e "\n====== Program Output ======"

nvcc -o cuda_scripts/fib_recursive cuda_scripts/fib_recursive.cu -O3 -arch=sm_80 -Xptxas -O3
# nvcc -o cuda_scripts/fib_recursive cuda_scripts/fib_recursive.cu
for val in {1..43}; do
    time  ./cuda_scripts/fib_recursive $val
done
