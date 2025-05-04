import numpy as np

def bitonic_sort(arr, ascending=True):
    n = len(arr)
    k = 2
    while k <= n:
        for j in range(k // 2, 0, -1):
            for i in range(n):
                ix = i ^ j
                if ix > i:
                    if (arr[i] > arr[ix]) == ascending:
                        arr[i], arr[ix] = arr[ix], arr[i]
        k *= 2
    return arr

d = 14
n = 2 ** d
arr = list(reversed(range(n)))  # Generates [2^d - 1, ..., 0]
sorted_arr = bitonic_sort(arr)
sum(sorted_arr)
