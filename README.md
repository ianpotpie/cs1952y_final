# CS1952Y FINAL

## How to get started on OSCAR

To use modules (like rust, python, cargo, etc) you may have to load the module.
For example:

```
module load python/3.11
module load rust
```

to get started with bend:

1. make sure the rust module is loaded (this gives you access to the 'cargo' command)
2. `cargo install hvm`
3. `cargo install bend-lang`
4. make sure that cargo binaries are in the system path by adding `export PATH=/users/igordon/.cargo/bin:$PATH` to ~/.bashrc

Take a look at the `test.sh` file to see what a batch script looks like.
The comments that start with `#SBATCH` set the configurations (including what gpu to use).
To run `test.sh` use `sbatch test.sh`.

Also, to check which nodes we have available to us, use the `nodes` command.
The values in the "features" column are what can be set using the "SBATCH -C" flag (this is what you would use to set the gpu). 
