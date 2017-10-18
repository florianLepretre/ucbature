# ucbature in julia

## the julia language

- [julia homepage](https://julialang.org/)
- [julia documentation](https://docs.julialang.org/en/stable/)
- [julia editor support](https://github.com/JuliaEditorSupport)


## setup

- the standard way:

```
mkdir -p ~/opt/julia
git clone https://github.com/JuliaLang/julia ~/opt/julia
git -C ~/opt/julia checkout v0.6.0
make -C ~/opt/julia -j12
# wait a few hours until the compilation is complete...
echo 'alias julia="$HOME/opt/julia/julia"' >> ~/.bashrc
source ~/.bashrc
julia init.jl
```

- the nix way:

```
nix-shell
julia init.jl
```


## run

```
julia -p auto compare_integrators.jl
julia ucbature_benchmark.jl
julia plot_integrands.jl
...
```

## more...

- a C++/python version of ucbature is also available, contact us for more details