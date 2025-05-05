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
// CUDA kernel for iterative Fibonacci
__global__ void fib_iterative_kernel(unsigned int n, unsigned int *result) {
    if (n <= 1) {
        *result = n;
        return;
    }
    
    unsigned int a = 0, b = 1, c;
    for (unsigned int i = 2; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    
    *result = b;
}
int main(int argc, char *argv[]) {
    // Default to calculating Fibonacci of 5 if no argument is provided
    unsigned int n = 43;
    if (argc > 1) {
        n = atoi(argv[1]);
    }
    
    // Allocate memory on the host and device
    unsigned int *d_result;
    unsigned int h_result;
    
    cudaMalloc((void**)&d_result, sizeof(unsigned int));
    
    // Measure time for both methods
    clock_t start, end;
    double cpu_time_used;
    
    // Run recursive method first to match the Bend program
    start = clock();
    fib_recursive_kernel<<<1, 1>>>(n, d_result);
    cudaDeviceSynchronize();
    end = clock();
    
    cudaMemcpy(&h_result, d_result, sizeof(unsigned int), cudaMemcpyDeviceToHost);
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    
    printf("Fibonacci(%u) = %u (Recursive method)\n", n, h_result);
    printf("Time taken: %f seconds\n", cpu_time_used);
    
    // Clean up
    cudaFree(d_result);
    
    return 0;
}
