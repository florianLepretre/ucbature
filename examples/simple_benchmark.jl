using Ucbature

include("Integrands.jl")

const dim = 2
const nb_runs = 10
const nb_evals = 1e4
const xmin = fill(-1.0, dim)
const xmax = fill( 1.0, dim)
const nb_zones_per_dim = 5
const k_exploration = 0.01
const nb_init_evals_per_zone = 10

my_mc(integrand) = Ucbature.mc(integrand, xmin, xmax, nb_evals)
my_str(integrand) = Ucbature.str(integrand, xmin, xmax, nb_evals, nb_zones_per_dim)
my_ucb(integrand) = Ucbature.ucb(integrand, xmin, xmax, nb_evals, nb_zones_per_dim, 
                                 k_exploration, nb_init_evals_per_zone)

my_run(integrator, integrand) = mapreduce((x)->integrator(integrand), +, 1:nb_runs)/nb_runs

println("sphere, mc: ", my_run(my_mc, Integrands.sphere))
println("sphere, str: ", my_run(my_str, Integrands.sphere))
println("sphere, ucb: ", my_run(my_ucb, Integrands.sphere))

println("linear, mc: ", my_run(my_mc, Integrands.linear))
println("linear, str: ", my_run(my_str, Integrands.linear))
println("linear, ucb: ", my_run(my_ucb, Integrands.linear))

