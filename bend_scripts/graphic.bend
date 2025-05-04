# Full context of this comment on: https://github.com/HigherOrderCO/Bend/blob/main/GUIDE.md

# It emulates an OpenGL fragment shader by building an "image" as a perfect binary tree, 
# and then calling the demo_shader function on each pixel. Since the tree has a depth of 16,
#  we have 2^16 = 65536 pixels, which is enough to fill all cores of an RTX 4090. 
# Moreover, since demo_shader isn't doing many allocations, 
# it can operate entirely inside the GPU's "shared memory" (L1 cache). 
# Each GPU thread has a local space of 64 IC nodes. Functions that don't need more than that, 
# like demo_shader, can run up to 5x faster!
# On my GPU, it performs 22,000 MIPS out of the box, and 40000+ MIPS with a tweak on the generated CUDA file
#  (doubling the TPC, which doubles the number of threads per block). 
# In the near future, we plan to add immutable textures, allowing for single-interaction sampling. 
# With some napkin math, this should be enough to render 3D games in real-time. 
# Imagine a future where game engines are written in Python-like languages? 
# That's the future we're building, with Bend!
# You can see your programs total cost (number of interactions) 
# and performance (MIPS) by adding the -s flag. 
# This is a good way to check if your algorithm is parallelizing. 
# For example, on my Apple M3 Max, sequential algorithms will perform about 100 MIPS on interpreted mode, 
# and 130 MIPS on compiled mode (remember our compiler is still very immature, 
# which is why it isn't much faster than the interpreter). 
# A well-parallelizable program, though, will easily reach 1000+ MIPS.

# given a shader, returns a square image
def render(depth: u24) -> Any:
  bend d = 0, i = 0:
    when d < depth:
      color = (fork(d+1, i*2+0), fork(d+1, i*2+1))
    else:
      width = depth / 2
      color = demo_shader(i % width, i / width)
  return color

# given a position, returns a color
# for this demo, it just busy loops
def demo_shader(x: Any, y: Any) -> Any:
  bend i = 0:
    when i < 100000:
      color = fork(i + 1)
    else:
      color = 0x000001
  return color

# renders a 8*8x8*8 image using demo_shader
def main() -> Any:
  return render(8, demo_shader)