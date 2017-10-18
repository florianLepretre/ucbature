using ucbature

include("integrands.jl")

const dim = 2
const nb_runs = 10
const nb_evals = 1e4
const xmin = fill(-1.0, dim)
const xmax = fill( 1.0, dim)
const nb_zones_per_dim = 5
const k_exploration = 0.01
const nb_init_evals_per_zone = 10

my_mc(integrand) = ucbature.mc(integrand, xmin, xmax, nb_evals)
my_str(integrand) = ucbature.str(integrand, xmin, xmax, nb_evals, nb_zones_per_dim)
my_ucb(integrand) = ucbature.ucb(integrand, xmin, xmax, nb_evals, nb_zones_per_dim, 
                                 k_exploration, nb_init_evals_per_zone)

my_run(integrator, integrand) = mapreduce((x)->integrator(integrand), +, 1:nb_runs)/nb_runs

println("sphere, mc: ", my_run(my_mc, integrands.sphere))
println("sphere, str: ", my_run(my_str, integrands.sphere))
println("sphere, ucb: ", my_run(my_ucb, integrands.sphere))

println("linear, mc: ", my_run(my_mc, integrands.linear))
println("linear, str: ", my_run(my_str, integrands.linear))
println("linear, ucb: ", my_run(my_ucb, integrands.linear))

