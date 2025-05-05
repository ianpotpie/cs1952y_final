#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <bend_script> <graphics_card>"
    exit 1
fi

BEND_SCRIPT=$1
GRAPHICS_CARD=$2

# The pre-script ends
sbatch << EOF
#!/bin/bash
#SBATCH -p gpu --gres=gpu:1
#SBATCH -n 1
#SBATCH --mem=12G
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH -o out/ncu-${BEND_SCRIPT}-on-${GRAPHICS_CARD}-%j.out
#SBATCH -e out/ncu-${BEND_SCRIPT}-on-${GRAPHICS_CARD}-%j.err
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
# Create output directory if it doesn't exist
mkdir -p out

# Run with Nsight Compute (NCU) profiler
# Using metrics for memory, compute, utilization, and occupancy
# ncu --set full --target-processes all --metrics launched__threads,sm__warps_active.avg.pct_of_peak_sustained_active,sm__pipe_fma_cycles_active.avg.pct_of_peak_sustained_active,dram__throughput.avg.pct_of_peak_sustained_elapsed,sm__sass_thread_inst_executed_op_fadd_pred_on.sum,sm__sass_thread_inst_executed_op_fmul_pred_on.sum,sm__sass_thread_inst_executed_op_ffma_pred_on.sum,l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum,l1tex__t_sectors_pipe_lsu_mem_global_op_st.sum,lts__t_sectors_op_read.sum,lts__t_sectors_op_write.sum,gpu__time_duration.sum --export out/${BEND_SCRIPT}-on-${GRAPHICS_CARD} bend run-cu bend_scripts/${BEND_SCRIPT}.bend
# ncu --support-32bit true -o profile --target-processes all --set full bend run-cu bend_scripts/${BEND_SCRIPT}.bend

ncu --target-processes all \
    --set full \
    --replay-mode kernel \
    --cache-control all \
    --clock-control base \
    --import-source yes \
    -o "out/${BEND_SCRIPT}-on-${GRAPHICS_CARD}" \
    bend run-cu bend_scripts/${BEND_SCRIPT}

EOF
