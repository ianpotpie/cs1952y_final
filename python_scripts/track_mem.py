import subprocess
import time
import re

def get_ps_output():
    result = subprocess.run(['ps', '-o', '%mem,%cpu,command'], stdout=subprocess.PIPE, text=True)
    return result.stdout

def extract_max_cpu_process(ps_output):
    max_cpu_process = None
    max_cpu_usage = 0.0
    
    
    for line in ps_output.splitlines()[1:]:
        
        parts = line.split()
        
        if len(parts) >= 3:
            mem_usage = float(parts[0])
            cpu_usage = float(parts[1]) 
            command = " ".join(parts[2:]) 
            
            
            if cpu_usage > max_cpu_usage:
                max_cpu_usage = cpu_usage
                max_cpu_process = (mem_usage, cpu_usage, command)
    
    return max_cpu_process

def track_memory_usage():
    memory_usages = [] 
    
    for _ in range(8):
        
        ps_output = get_ps_output()
        
        
        max_cpu_process = extract_max_cpu_process(ps_output)
        
        if max_cpu_process:
            mem_usage, cpu_usage, command = max_cpu_process
            print(f"Process with max CPU: {command} | %CPU: {cpu_usage} | %MEM: {mem_usage}")
            memory_usages.append(mem_usage)
        else:
            print("No processes found.")
        
        
        time.sleep(0.5)
    
   
    if memory_usages:
        avg_memory_usage = sum(memory_usages) / len(memory_usages)
        print(f"\nAverage memory usage over 24 iterations: {avg_memory_usage:.2f}%")
    else:
        print("No memory usage data available.")


track_memory_usage()
