#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// CUDA kernel for recursive Fibonacci with exactly the same pattern as your Bend code
__device__ unsigned int fib_recursive_device(unsigned int n) {
    if (n == 0) return 0;
    if (n == 1) return 1;
    // Matching the exact pattern in your Bend code: fib_recursive(n-2) + fib_recursive(n-2 + 1)
    return fib_recursive_device(n-2) + fib_recursive_device(n-2 + 1);
}

__global__ void fib_recursive_kernel(unsigned int n, unsigned int *result) {
    *result = fib_recursive_device(n);
}

int main(int argc, char *argv[]) {
    // Print the number of arguments received
    printf("Number of arguments: %d\n", argc);
    
    // Default to calculating Fibonacci of 5 if no argument is provided
    unsigned int n = 5;  // Default to a smaller number for testing
    
    if (argc > 1) {
        n = atoi(argv[1]);
        printf("Argument received: '%s', converted to: %u\n", argv[1], n);
    } else {
        printf("No argument received, using default value: %u\n", n);
    }
    
    // Allocate memory on the host and device
    unsigned int *d_result;
    unsigned int h_result;
    
    cudaMalloc((void**)&d_result, sizeof(unsigned int));
    
    // Initialize device memory to a known value
    unsigned int init_value = 0;
    cudaMemcpy(d_result, &init_value, sizeof(unsigned int), cudaMemcpyHostToDevice);
    
    // Measure time for both methods
    clock_t start, end;
    double cpu_time_used;
    
    // Run recursive method first to match the Bend program
    start = clock();
    fib_recursive_kernel<<<1, 1>>>(n, d_result);
    cudaError_t err = cudaDeviceSynchronize();
    end = clock();
    
    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
    }
    
    cudaMemcpy(&h_result, d_result, sizeof(unsigned int), cudaMemcpyDeviceToHost);
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    
    printf("Fibonacci(%u) = %u (Recursive method)\n", n, h_result);
    printf("Time taken: %f seconds\n", cpu_time_used);
    
    // Clean up
    cudaFree(d_result);
    
    return 0;
}
