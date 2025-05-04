#!/bin/bash

# Request a partition node with 1 GPU
#SBATCH -p gpu --gres=gpu:1

# Request 1 CPU core and 4G of memory for 1 hour
#SBATCH -n 1
#SBATCH --mem=4G
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -C quadrortx|intel
#SBATCH -o test.txt

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

echo -e "\n====== Storage Information ======"
df -h

echo -e "\n====== Environment Modules ======"
module list

echo -e "\n====== Current Working Directory ======"
pwd

python ./cs1952y_final/run_test.py
