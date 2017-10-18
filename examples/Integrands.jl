module Integrands

constant(x, c=1, varargs...) = c

linear(x, a=1, b=0) = mean(a.*x .+ b)

sphere(x, varargs...) = vecdot(x, x) < 1.0 ? 1.0 : 0.0

sinus(x, varargs...) = sum(sin.(x)) / length(x)

sinusc(x, varargs...) = sum(sinc.(x)) / length(x)

oscillatory(x, c=1, r=1) = cos(2.0*pi*r + sum(c.*x)) 

productpeak(x, c=1, w=0) = 1 / prod(c.^(-2.0) .+ (x .- w).^2)

cornerpeak(x, c=1, r=1) = 1 / (1 + sum(abs.(c.*x)))^(length(x)+r)

gaussian(x, c=1, w=0) = exp(- sum(c.^2 .* (x.-w).^2))

continuous(x, c=1, w=0) = exp(- sum(c.* abs.(x.-w)))

discontinuous(x, c=1, w=0) = all(x.<=w) ? exp(sum(c.*x)) : 0.0

end

