Pkg.init()
Pkg.update()

Pkg.add("PyCall")
ENV["PYTHON"]=""
Pkg.build("PyCall")

Pkg.add("PyPlot")
using PyPlot
