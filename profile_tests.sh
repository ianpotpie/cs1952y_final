#!/bin/bash

#SBATCH -p gpu --gres=gpu:1
#SBATCH -n 1
#SBATCH --mem=64G
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -C quadrortx|intel
#SBATCH -o profile_tests_%j.out
#SBATCH -e profile_tests_%j.err

echo "====== Job and Node Information ======"
echo "Job ID: $SLURM_JOB_ID"
echo "Node List: $SLURM_JOB_NODELIST"
echo "Number of Nodes: $SLURM_JOB_NUM_NODES"
echo "Number of Tasks: $SLURM_NTASKS"
echo "CPUs per Task: $SLURM_CPUS_PER_TASK"

echo -e "\n====== CPU Information ======"
lscpu

echo -e "\n====== Memory Information ======"
free -h

echo -e "\n====== GPU Information (if available) ======"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi
else
    echo "No NVIDIA GPU available or nvidia-smi not found"
fi

module load cuda/12.4.0-piq32fy
module load python/3.11.0s-ixrhc3q
module load rust/1.81.0-3qqoayc

cargo install hvm # --force
cargo install bend-lang # --force

# nvprof --log-file test.log \
#	--csv \
#	python ./run_test.py

# ncu --version
# 
# # Setup profiling environment variables
# export CUDA_LAUNCH_BLOCKING=1
# 
# # Disable kernel timeouts if possible
# export CUDA_DISABLE_KERNEL_TIMEOUT=1
# export NSIGHT_COMPUTE_VERBOSE=1
# 
# # Try basic profiling first
# echo "=== Attempt 1: Basic profiling with simple program ==="
# timeout 60s ncu --set base -o fib_iterative_profile bend run-cu fib_it.bend
# echo "Exit code: $?"
# 
# # Try with minimal metrics
# echo "=== Attempt 2: Minimal metrics with simple program ==="
# timeout 60s ncu --metrics sm__cycles_elapsed.avg -o minimal_profile bend run-cu fib_it.bend
# echo "Exit code: $?"
# 
# # Try with kernel replay disabled
# echo "=== Attempt 3: Kernel replay disabled with simple program ==="
# timeout 60s ncu --kernel-replay-mode disabled -o no_replay_profile bend run-cu fib_it.bend
# echo "Exit code: $?"

nsys profile -o profile_report bend run-cu fib_it.bend
