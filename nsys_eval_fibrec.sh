#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <num>"
    exit 1
fi

NUM=$1

# The pre-script ends
sbatch << EOF
#!/bin/bash
#SBATCH -p gpu --gres=gpu:1
#SBATCH -n 1
#SBATCH --mem=12G
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -o out/nsys-fib_recursive${NUM}-on-a5000-%j.out
#SBATCH -e out/nsys-fib_recursive${NUM}-on-a5000-%j.err
#SBATCH -C a5000

module load openssl/1.1.1t-u2rkdft
module load python/3.11.0s-ixrhc3q
module load zlib/1.2.13-jv5y5e7
module load rust/1.81.0-3qqoayc
module load cuda/12.2.0-4lgnkrh

cargo install hvm --force

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

echo -e "\n====== Program Output ======"
python set_fibrec_arg.py $NUM
nsys profile --stats=true -o out/fib_recursive${NUM} bend run-cu bend_scripts/fib_recursive.bend -s
EOF
