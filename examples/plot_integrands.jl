include("Integrand.jl")

using PyPlot

function plot_1d(integrand, xmin, xmax, xdivs, name, outdir)
    println("plotting 1D ", name, "...")
    xs = linspace(xmin, xmax, xdivs)
    ys = [integrand(x) for x = xs]
    fig = figure(figsize=(8, 6))
    plot(xs, ys)
    title("integrand 1D $(name)")
    savefig("$(outdir)/out_integrand_1D_$(name).png")
    close(fig)
end

function plot_2d(integrand, xmin, xmax, xdivs, name, outdir)
    println("plotting 2D ", name, "...")
    x1 = linspace(xmin, xmax, xdivs)
    x2 = linspace(xmin, xmax, xdivs)
    x1grid = repmat(x1', xdivs, 1)
    x2grid = repmat(x2 , 1, xdivs)
    z = [integrand([x1[i] x2[j]]) for i in 1:xdivs, j in 1:xdivs]
    fig = figure(figsize=(8, 6))
    ax = fig[:add_subplot](1, 1, 1,  projection = "3d")
    ax[:plot_surface](x1grid, x2grid, z, edgecolors="k", cmap=ColorMap("jet"), 
                      alpha=0.8, linewidth=0.25)
    title("integrand 2D $(name)")
    tight_layout()
    savefig("$(outdir)/out_integrand_2D_$(name).png")
    close(fig)
end

function plot_1d_2d(integrand, xmin, xmax, xdivs, name)
    plot_1d(integrand, xmin, xmax, xdivs, name, outdir)
    plot_2d(integrand, xmin, xmax, xdivs, name, outdir)
end

outdir = "output"
if ~isdir(outdir)
    mkdir(outdir)
end

plot_1d_2d(Integrand.constant, -2, 2, 100, "constant")
plot_1d_2d(Integrand.linear, -2, 2, 100, "linear")
plot_1d_2d(Integrand.sinus, -8, 8, 100, "sinus")
plot_1d_2d(Integrand.sinusc, -8, 8, 100, "sinusc")
plot_1d_2d(Integrand.sphere, -2, 2, 100, "sphere")
plot_1d_2d(Integrand.oscillatory, -5, 5, 100, "oscillatory")
plot_1d_2d(Integrand.productpeak, -1, 1, 100, "productpeak")
plot_1d_2d(Integrand.cornerpeak, 0, 1, 100, "cornerpeak")
plot_1d_2d(Integrand.gaussian, -4, 4, 100, "gaussian")
plot_1d_2d(Integrand.continuous, -4, 4, 100, "continuous")
plot_1d_2d(Integrand.discontinuous, -4, 4, 100, "discontinuous")

