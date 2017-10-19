# Ucbature

[![Build Status](https://travis-ci.org/florianLepretre/ucbature.svg?branch=master)](https://travis-ci.org/florianLepretre/ucbature)

This package is a [Julia](http://julialang.org/) implementation of the
[Ucbature algorithm](TODO HAL). A C++/Python implementation of Ucbature is also
available, contact us for more details.

## Quick-start

```julia
Pkg.clone("https://github.com/florianLepretre/ucbature.git")

using ucbature

sphere(x) = vecdot(x, x) < 1.0 ? 1.0 : 0.0
const dim = 2
const xmin = fill(-1.0, dim)
const xmax = fill( 1.0, dim)
ucbature.mc(sphere, xmin, xmax, 1e6)
```

## Algorithms

- mc: TODO
- str: TODO
- ucb: TODO

## Examples

- `simple_benchmark.jl`: TODO
- `plot_integrators.jl`: TODO
- `plot_integrands.jl`: TODO


TODO write doc in Ucbature.jl

