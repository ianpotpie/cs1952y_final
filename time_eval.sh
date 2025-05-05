#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <run_flag> <bend_script> <graphics_card>"
    exit 1
fi

FLAG=$1
BEND_SCRIPT=$2
GRAPHICS_CARD=$3

# The pre-script ends
sbatch << EOF
#!/bin/bash
#SBATCH -p gpu --gres=gpu:1
#SBATCH -n 1
#SBATCH --mem=12G
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -o out/time-${FLAG}-${BEND_SCRIPT}-on-${GRAPHICS_CARD}-%j.out
#SBATCH -e out/time-${FLAG}-${BEND_SCRIPT}-on-${GRAPHICS_CARD}-%j.err
#SBATCH -C ${GRAPHICS_CARD}

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
time bend $FLAG bend_scripts/${BEND_SCRIPT}.bend
EOF
