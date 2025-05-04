# Program to calculate fibonacci numbers iteratively

# Calculates fibonacci numbers iteratively (tail-recursively).
# This function is inherently sequential, but runs in linear time.
def fib_iterative(n: u24) -> u24:
  bend a=0, b=1, n:
    when n != 0:
      return fork(b, a + b, n - 1)
    else:
      return a

def main() -> u24:
  # With the iterative version, we can calculate large fibonacci numbers
  # While with the recursive version, we will quickly run out of memory.
  # Note that for numbers larger than 36 the result will overflow the space of the 24-bit integer.
  # But we can run any number we want reasonably fast.
  return fib_iterative(30)
