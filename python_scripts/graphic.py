import numpy as np

def demo_shader(x, y):
    # Simulates some computation and returns a fixed color
    return 0x000001

def render(size):
    image = np.zeros((size, size), dtype=np.uint32)
    for y in range(size):
        for x in range(size):
            image[y, x] = demo_shader(x, y)
    return image


render(64)
