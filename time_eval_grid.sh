#!/bin/bash

# Hard-coded lists
BEND_SCRIPTS=("fib_iterative" "fib_recursive" "bitonic_sort" "graphic")
GPU_TYPES=("a40" "geforce3090" "a5000" "a5500" "a6000" "titanrtx" "quadrortx" "v100")

# Ampere Architecture: "a40" "geforce3090" "a5000" "a5500" "a6000" "quadrortx"
# Turing Architecture: "titanrtx"
# Volta Architecture: "v100"

# Create the output directory if it doesn't exist
mkdir -p out

echo "====== Starting Grid Evaluation ======"
echo "Scripts: ${BEND_SCRIPTS[@]}"
echo "GPU Types: ${GPU_TYPES[@]}"
echo "===================================="

# Iterate over each script and GPU combination using a nested for-loop
for script in "${BEND_SCRIPTS[@]}"; do
    for gpu in "${GPU_TYPES[@]}"; do
        echo "Submitting: $script on $gpu"
        
        # Call the nsys_eval.sh script with the current script and GPU
        ./time_eval.sh "run-cu" "$script" "$gpu"
        
        # Check if submission was successful
        if [ $? -eq 0 ]; then
            echo "  Submission successful"
        else
            echo "  Submission failed"
        fi
        
        # Add a short delay between submissions
        sleep 1
    done
done

echo "====== Grid Evaluation Complete ======"
echo "To monitor your jobs, use: squeue -u $USER"
