include("Integrand.jl")
include("Integrator.jl")

using Integrand
using Integrator

const dim = 2
const nb_runs = 100
const nb_evals = 1e6
const xmin = fill(-1.0, dim)
const xmax = fill( 1.0, dim)
const nb_zones_per_dim = 5
const k_exploration = 0.01
const nb_init_evals_per_zone = 10

mc(integrand) = Integrator.mc(integrand, xmin, xmax, nb_evals)
str(integrand) = Integrator.str(integrand, xmin, xmax, nb_evals, nb_zones_per_dim)
ucb(integrand) = Integrator.ucb(integrand, xmin, xmax, nb_evals, nb_zones_per_dim, 
                                k_exploration, nb_init_evals_per_zone)

run(integrator, integrand) = mapreduce((x)->integrator(integrand), +, 1:nb_runs)/nb_runs

println("sphere, mc: ", run(mc, Integrand.sphere))
println("sphere, str: ", run(str, Integrand.sphere))
println("sphere, ucb: ", run(str, Integrand.sphere))
println("linear, mc: ", run(mc, Integrand.linear))
println("linear, str: ", run(str, Integrand.linear))
println("linear, ucb: ", run(ucb, Integrand.linear))

