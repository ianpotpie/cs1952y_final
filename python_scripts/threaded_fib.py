import threading

# Define a thread-safe result storage
class FibonacciThread(threading.Thread):
    def __init__(self, n, result):
        super().__init__()
        self.n = n
        self.result = result

    def run(self):
        """Run the Fibonacci calculation in the thread."""
        if self.n == 0:
            self.result[0] = 0
        elif self.n == 1:
            self.result[0] = 1
        else:
            # Create two results for the two recursive calls
            result1 = [None]
            result2 = [None]
            
            # Create threads for the recursive calls
            thread1 = FibonacciThread(self.n - 1, result1)
            thread2 = FibonacciThread(self.n - 2, result2)
            
            # Start the threads
            thread1.start()
            thread2.start()
            
            # Wait for threads to finish
            thread1.join()
            thread2.join()
            
            # Combine the results
            self.result[0] = result1[0] + result2[0]

def fib_recursive_threaded(n):
    result = [None]
    thread = FibonacciThread(n, result)
    thread.start()
    thread.join()  # Wait for the thread to finish
    return result[0]

# Test the function
n = 31
print(f"Fibonacci({n}) = {fib_recursive_threaded(n)}")
