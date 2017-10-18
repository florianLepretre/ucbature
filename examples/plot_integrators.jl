# run with: julia -p auto compare_integrators.jl

@everywhere begin

    include("integrands.jl")
    using ucbature
    using PyPlot

    function randomize_integrand(dim, integrand, xmin, xmax, difficulty)
        c = rand(dim)
        w = rand(dim)
        cd = c .* (difficulty / sum(c))
        rand_integrand(x) = integrand(x, c, w)
    end

    function run_integrator(dim, integrand, xmin, xmax, difficulty, nb_evals, integrator, nb_runs, nb_evals_gt)
        mae_sum = 0.0
        for _ = 1:nb_runs
            # randomize integrand
            rand_integrand = randomize_integrand(dim, integrand, xmin, xmax, difficulty)
            # estimate ground truth
            ground_truth = ucbature.mc(rand_integrand, xmin, xmax, nb_evals_gt)
            # compute mae sum
            mae_sum += abs(ground_truth - integrator(rand_integrand, xmin, xmax, nb_evals))
        end
        mae_sum / nb_runs
    end

    function run_plot(dim, integrand, xmin, xmax, difficulty, list_nb_evals, integrator, nb_runs, nb_evals_gt, integrator_name)
        integrals = [run_integrator(dim, integrand, xmin, xmax, difficulty, nb_evals, integrator, nb_runs, nb_evals_gt)
                     for nb_evals = list_nb_evals]
        plot(list_nb_evals, integrals, label=integrator_name)
    end

    function run_full(integrand, xmin, xmax, difficulty, list_nb_evals, nb_runs, nb_evals_gt, integrand_name, outdir)
        fig = figure()
        dim = length(xmin)
        println("computing $(integrand_name) $(dim)D...")
        # run integrators and plot results
        run_plot(dim, integrand, xmin, xmax, difficulty, list_nb_evals, ucbature.mc, nb_runs, nb_evals_gt, "mc")
        run_plot(dim, integrand, xmin, xmax, difficulty, list_nb_evals, ucbature.str, nb_runs, nb_evals_gt, "str")
        run_plot(dim, integrand, xmin, xmax, difficulty, list_nb_evals, ucbature.ucb, nb_runs, nb_evals_gt, "ucb")
        # finish plot
        xscale("log")
        yscale("log")
        grid("on")
        legend(loc="upper right")
        xlabel("nb evaluations")
        ylabel("mean absolute error")
        title("integration $(integrand_name) $(dim)D")
        savefig("$(outdir)/out_integration_$(integrand_name)_$(dim)D.png")
        close(fig)
    end

    # global parameters
    nb_runs = 10
    list_nb_evals = [2^expo for expo = 10:16]
    nb_evals_gt = 2^20
    outdir = "output"
    if ~isdir(outdir)
        mkdir(outdir)
    end

    # auxiliary function
    function aux_run(data)
        f, x0, x1, difficulty, integrand_name = data
        run_full(f, x0, x1, difficulty, list_nb_evals, nb_runs, nb_evals_gt, integrand_name, outdir)
    end

end # @everywhere

# parallel runs
aux_data = [# (integrands.sinus, fill(-8.0, 2), fill(8.0, 2), 1.0, "sinus"),
            # (integrands.sinusc, fill(-8.0, 2), fill(8.0, 2), 1.0, "sinusc"),
            (integrands.sphere, fill(-2.0, 2), fill(2.0, 2), 1.0, "sphere"),
            # (integrands.oscillatory, fill(-5.0, 2), fill(5.0, 2), 6.0, "oscillatory"),
            # (integrands.productpeak, fill(-4.0, 2), fill(4.0, 2), 18.0, "productpeak"),
            # (integrands.cornerpeak, fill(0.0, 2), fill(1.0, 2), 2.2, "cornerpeak"),
            (integrands.gaussian, fill(-4.0, 2), fill(4.0, 2), 15.2, "gaussian"),
            # (integrands.continuous, fill(-4.0, 2), fill(4.0, 2), 16.1, "continuous"),
            # (integrands.discontinuous, fill(-4.0, 2), fill(4.0, 2), 16.4, "discontinuous"),
           ]

map(aux_run, aux_data)

