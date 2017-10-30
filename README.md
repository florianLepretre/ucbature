# Ucbature

[![Build Status](https://travis-ci.org/florianLepretre/ucbature.svg?branch=master)](https://travis-ci.org/florianLepretre/ucbature)

This package is a [Julia](http://julialang.org/) implementation of the
[Ucbature algorithm]. 
A C++/Python implementation of Ucbature is also available, contact us for more
details.

## Quick-start

```julia
Pkg.clone("https://github.com/florianLepretre/ucbature.git")

using ucbature

sphere_func(x) = vecdot(x, x) < 1.0 ? 1.0 : 0.0
dim = 2
xmin = fill(-1.0, dim)
xmax = fill( 1.0, dim)
nb_evals = 1e6
ucbature.mc(sphere_func, xmin, xmax, nb_evals)
```

## Algorithms

- `mc`: Monte-Carlo
- `str`: stratified Monte-Carlo
- `ucb`: Upper Confidence Bound (multi-armed bandit)

## Examples

- `simple_benchmark.jl`: run the algorithms on some integrand functions

- `plot_integrators.jl`: run and plot the algorithms

![](examples/plot_integrators.png)

- `plot_integrands.jl`: plot the example integrand functions

![](examples/plot_integrands.png)


