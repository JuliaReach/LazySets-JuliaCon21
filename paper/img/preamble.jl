# -------------------
# Preamble
# -------------------

using LazySets
import Plots
using Plots: plot, plot!, text, lens!, bbox, font, savefig
using LaTeXStrings
using Plots.PlotMeasures

# custom plot shorthands
p(args...; kwargs...) = plot(xlims=(0, 4), ylims=(0, 4), ratio=1, lab="", xlab="x₁", ylab="x₂", args...; kwargs...)
p!(args...; kwargs...) = plot!(lab="", args...; kwargs...);

# utils for plots
__toL(x, digits) = L"%$(round(x, digits=digits))"
xticklatex(vec, digits) = (vec, __toL.(vec, Ref(digits)))
Plots.GR.setarrowsize(3)  # larger arrow heads
