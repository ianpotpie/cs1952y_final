# Program to calculate fibonacci numbers.

# Calculates fibonacci numbers recursively.
# Although branching recursion is usually a good idea to parallelize,
# it makes this code run in exponential time.
def fib_recursive(n: u24) -> u24:
  switch n:
    case 0:
      return 0
    case 1:
      return 1
    case _:
      return fib_recursive(n-2) + fib_recursive(n-2 + 1)

def main(n):
  # With the recursive version we create a tree with exponential size.
  # For numbers larger than ~45, this will hit the maximum HVM memory and crash.
  # Try uncommenting and running this line and compare the execution time.
  return fib_recursive(n)
