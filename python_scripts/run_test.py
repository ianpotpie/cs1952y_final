import subprocess
import sys
import time

# Boolean option to suppress output
suppress_output = True  # Set to False to print subprocess output

# List of programs
programs = ['bitonic_sort', 'graphic', 'fib_it', 'fib_rec']

# List of languages
languages = ['.py', '.bend']

# Function to run subprocess and optionally suppress output
def run_subprocess(command):
    if suppress_output:
        subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    else:
        subprocess.run(command)

for prog in programs:
    for language in languages:
        print(f"\nExecution of {prog}{language}")

        if language == '.py':
            start_time = time.time()
            run_subprocess(['python', f'{prog}.py'])
            end_time = time.time()
            print(f"Python: {end_time - start_time:.4f} seconds")

        elif language == '.bend':
            # Timing for running Bend with single processor
            start_time = time.time()
            run_subprocess(['bend', 'run-rs', f'{prog}.bend'])
            end_time = time.time()
            print(f"Bend (single processor): {end_time - start_time:.4f} seconds")

            # Timing for running Bend in parallel using the C interpreter
            start_time = time.time()
            run_subprocess(['bend', 'run', f'{prog}.bend'])
            end_time = time.time()
            print(f"Bend (parallel using C interpreter): {end_time - start_time:.4f} seconds")

            # Timing for generating C code and compiling with GCC
            start_time = time.time()
            with open("main.c", "w") as f: 
                subprocess.run(['bend', 'gen-c', f'{prog}.bend'], stdout=f)
            if sys.platform == 'linux':
                run_subprocess(['gcc', 'main.c', '-o', 'main', '-O2', '-lm', '-lpthread'])
            elif sys.platform == 'darwin':  # For OSX
                run_subprocess(['gcc', 'main.c', '-o', 'main', '-O2'])
            end_time = time.time()
            #print(f"Execution time for gcc compile {prog}: {end_time - start_time:.4f} seconds")

            # Timing for running the compiled executable
            start_time = time.time()
            run_subprocess(['./main'])
            end_time = time.time()
            print(f"Bend (parallel using C compiled): {end_time - start_time:.4f} seconds")

            # Timing running using CUDA/gpu resources
            start_time = time.time()
            run_subprocess(['bend', 'run-cu', f'{prog}.bend'])
            end_time = time.time()
            print(f"Bend (parallel using CUDA): {end_time - start_time:.4f} seconds")
