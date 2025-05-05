import psutil
import time
import os

def get_memory_usage(pid):
    """Get the memory usage of a process given its PID."""
    process = psutil.Process(pid)
    memory_info = process.memory_info()
    return memory_info.rss 

def monitor_program(func):
    
    pid = os.getpid()
    
    memory_before = get_memory_usage(pid)
    print(f"Before execution - Memory: {memory_before / (1024 * 1024):.2f} MB")
    
    start_time = time.time()
    
    func()
    
    memory_after = get_memory_usage(pid)
    print(f"After execution - Memory: {memory_after / (1024 * 1024):.2f} MB")
    print(f"Time taken: {time.time() - start_time} seconds")

def execute_shell_script():
    
    os.system("./testing_bash.sh") 

monitor_program(execute_shell_script)
