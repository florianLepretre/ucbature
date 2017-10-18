using Base.Test

using Ucbature

const my_tol = 1e-2

const dim = 2
const nb_evals = 1e6
const xmin = fill(-1.0, dim)
const xmax = fill( 1.0, dim)
const nb_zones_per_dim = 5
const k_exploration = 0.01
const nb_init_evals_per_zone = 10

sphere(x) = vecdot(x, x) < 1.0 ? 1.0 : 0.0

res_mc = Ucbature.mc(sphere, xmin, xmax, nb_evals)
@test isapprox(res_mc, pi, atol=my_tol)

res_str = Ucbature.str(sphere, xmin, xmax, nb_evals, nb_zones_per_dim)
@test isapprox(res_str, pi, atol=my_tol)

res_ucb = Ucbature.ucb(sphere, xmin, xmax, nb_evals, nb_zones_per_dim, 
                       k_exploration, nb_init_evals_per_zone)
@test isapprox(res_ucb, pi, atol=my_tol)

