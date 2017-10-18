module Integrator

rand_min_max(xmin, xmax) = xmin .+ rand(length(xmin)).*(xmax.-xmin)

volume(xmin, xmax) = prod(xmax .- xmin)

function mc(integrand, xmin, xmax, nb_evals)
    f_val(i) = integrand(rand_min_max(xmin, xmax))
    mean_val = mapreduce(f_val, +, 1:nb_evals) / nb_evals
    volume(xmin, xmax) * mean_val
end

function make_x_cube(i_zone, nb_zones_per_dim, dim)
    # compute position i_zone in [0, nb_zones_per_dim]^dim
    x_cube = Array{Int}(dim)
    q = nb_zones_per_dim^(dim-1)
    for d = 1:dim
        x_cube[d] = div(i_zone, q)
        i_zone -= x_cube[d] * q
        q = div(q, nb_zones_per_dim)
    end
    x_cube
end

function make_zones(xmin, xmax, nb_zones_per_dim)
    dim = length(xmin)
    nb_zones = nb_zones_per_dim ^ dim
    xstep = (xmax .- xmin) / nb_zones_per_dim
    zones = [xmin .+ xstep.*make_x_cube(i, nb_zones_per_dim, dim) 
             for i = 0:(nb_zones-1)]
    dim, nb_zones, xstep, zones
end

function str(integrand, xmin, xmax, nb_evals, nb_zones_per_dim=3)
    dim, nb_zones, xstep, zones = make_zones(xmin, xmax, nb_zones_per_dim)
    if nb_evals < nb_zones
        warn("Integrator.str, nb_evals < $(nb_zones)")
        return mc(integrand, xmin, xmax, nb_evals)
    end
    nb_evals_per_zone = div(nb_evals, nb_zones)
    f_mc(z) = mc(integrand, z, z.+xstep, nb_evals_per_zone)
    mapreduce(f_mc, +, zones)
end

ucb1(R, k, kn, Vn) = Vn ./ sqrt.(kn) .+ R .* sqrt.(log(k) ./ kn)

ucb_vars(s1, s2, k) = (s2./k) .- (s1./k).^2

function ucb_strat(integrand, xstep, zones, nb_init_evals_per_zone)
    nb_zones = length(zones)
    zones_sum1 = zeros(nb_zones)
    zones_sum2 = zeros(nb_zones)
    for (n, zmin) = enumerate(zones)
        zmax = zmin .+ xstep
        for _ = 1:nb_init_evals_per_zone
            y = integrand(rand_min_max(zmin, zmax))
            zones_sum1[n] += y
            zones_sum2[n] += y^2
        end
    end
    zones_evals = fill(nb_init_evals_per_zone, nb_zones)
    zones_sum1, zones_sum2, zones_evals
end

function ucb_mab(integrand, nb_init_evals, nb_evals, k_exploration, zones, 
                 xstep, zones_sum1, zones_sum2, zones_evals, zones_vars)
    for k=nb_init_evals:nb_evals
        scores = ucb1(k_exploration, k, zones_evals, zones_vars)
        n = indmax(scores)
        zmin = zones[n]
        zmax = zmin .+ xstep
        y = integrand(rand_min_max(zmin, zmax))
        zones_sum1[n] += y
        zones_sum2[n] += y^2
        zones_evals[n] += 1
        zones_vars[n] = ucb_vars(zones_sum1[n], zones_sum2[n], zones_evals[n])
    end
    zones_sum1, zones_evals
end

function ucb(integrand, xmin, xmax, nb_evals, nb_zones_per_dim=3, 
             k_exploration=0.01, nb_init_evals_per_zone=10)
    # init
    dim, nb_zones, xstep, zones = make_zones(xmin, xmax, nb_zones_per_dim)
    nb_init_evals = nb_zones * nb_init_evals_per_zone
    if nb_evals < nb_init_evals
        warn("nb_evals < $(nb_init_evals)")
        return mc(integrand, xmin, xmax, nb_evals)
    end
    # stratified sampling
    zones_sum1, zones_sum2, zones_evals = ucb_strat(integrand, xstep, zones, 
                                                    nb_init_evals_per_zone)
    zones_vars = ucb_vars(zones_sum1, zones_sum2, zones_evals)
    # multi-armed bandit
    zones_sum1, zones_evals = 
    ucb_mab(integrand, nb_init_evals, nb_evals, k_exploration, zones, 
            xstep, zones_sum1, zones_sum2, zones_evals, zones_vars)
    # final result
    prod(xstep) * sum(zones_sum1 ./ zones_evals)
end

end