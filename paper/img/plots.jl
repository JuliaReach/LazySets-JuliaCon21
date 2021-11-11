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

# -------------------
# Suport function
# -------------------

X = VPolygon([[0.8, 2.2], [2.1, 1], [1.9, -1], [0, -2],
              [-2, -2], [-3, 0.6], [-0.8, 1.8], [0.8, 2.2]])
d = [-1, 1]

sv = @show σ(d, X)

sf = @show ρ(d, X)

H = HalfSpace(d, sf)

dn = normalize(d)
sfn = ρ(dn, X)

fig = p(xlim=(-4.1, 2.5), ylim=(-2.5, 2.5), ratio=1, xlab=L"x_1", ylab=L"x_2",
           legendfontsize=25,
           tickfont=font(25, "Times"),
           guidefontsize=25,
           xguidefont=font(25, "Times"),
           yguidefont=font(25, "Times"),
           xtick = ([-4, -2, 0, 2], [L"-4", L"-2", L"0", L"2"]),
           ytick = ([-2, 0, 2], [L"-2", L"0", L"2"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=0mm, size=(500, 390))

p!(fig, H, alpha=0.5, color=:lightblue, lw=3.0, ls=:dash, lc=:black)
p!(fig, X, color=:orange, lab="")
#p!(fig, Singleton([0.0, 0.0]), color=:black, lab="")
p!(fig, [0, dn[1]*sfn], [0, dn[2]*sfn], linecolor=:red, arrow=:both,
   linestyle=:dot, width=4, annotations=(0.6, 1.4, text(L"\rho(d\prime, X)", 28)))
p!(fig, Singleton(sv), alpha=1, markersize=10, color=:green, lab="",
   annotations=(-2.5, 0, text(L"\sigma(d, X)", 28)))
savefig(fig, "supfunc.pdf")

fig = p(xlim=(-4.1, 2.5), ylim=(-2.5, 2.5), ratio=1, xlab=L"x_1", ylab=L"x_2",
           legendfontsize=25,
           tickfont=font(25, "Times"),
           guidefontsize=25,
           xguidefont=font(25, "Times"),
           yguidefont=font(25, "Times"),
           xtick = ([-4, -2, 0, 2], [L"-4", L"-2", L"0", L"2"]),
           ytick = ([-2, 0, 2], [L"-2", L"0", L"2"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=0mm, size=(500, 390))

Xoct = overapproximate(X, OctDirections(2))
p!(fig, Xoct, color=:lightblue, alpha=0.5, lw=3.0, ls=:dash, lc=:black)
p!(fig, X, color=:orange, lab="")
#p!(fig, Singleton([0.0, 0.0]), color=:black, lab="")
#p!(fig, [sv[1], sv[1] + d[1]], [sv[2], sv[2] + d[2]], linecolor=:red, arrow=:arrow,
#   linestyle=:dot, width=8, annotations=(-3.3, 1.5, text(L"d", 25)))
#p!(fig, Singleton(sv), alpha=1, markersize=10, color=:green, lab="")
savefig(fig, "supfunc_oct.pdf")

# --------------------------------------------
# Overapproximation example
# --------------------------------------------

X = VPolygon([[0.8, 2.2], [2.1, 1], [1.9, -1], [0, -2],
              [-2, -2], [-3, 0.6], [-0.8, 1.8], [0.8, 2.2]])
Y = box_approximation(X)
Z1 = overapproximate(X, Zonotope, PolarDirections(3))
Z2 = overapproximate(X, Zonotope, PolarDirections(5))

fig = p(xlim=(-4.1, 2.5), ylim=(-2.5, 2.5), ratio=1, xlab="", ylab="",
           legendfontsize=25,
           tickfont=font(25, "Times"),
           guidefontsize=25,
           xguidefont=font(25, "Times"),
           yguidefont=font(25, "Times"),
           xtick = ([-4, -2, 0, 2], [L"-4", L"-2", L"0", L"2"]),
           ytick = ([-2, 0, 2], [L"-2", L"0", L"2"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=0mm, size=(500, 360))

p!(Y, alpha=0.8)
p!(Z1, alpha=0.8)
p!(Z2, alpha=0.8)
p!(X, alpha=0.8)

savefig("overapproximate.pdf")

# -------------------
# Polar directions
# -------------------

# ball
fig = p(xlim=(-1.1, 1.1), ylim=(-1.1, 1.1), ratio=1, xlab="", ylab="",
           legendfontsize=25,
           tickfont=font(25, "Times"),
           guidefontsize=25,
           xguidefont=font(25, "Times"),
           yguidefont=font(25, "Times"),
           xtick = ([-1, 0, 1], [L"-1", L"0", L"1"]),
           ytick = ([-1, 0, 1], [L"-1", L"0", L"1"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=0mm, size=(380, 360))

plot!(fig, Ball2(zeros(2), 1.0), alpha=.5, ratio=1., lc=:black, lw=1, c=:lightblue)

# five directions
plot!(fig, map(p -> LineSegment(zeros(2), p), PolarDirections(5)), lw=5.,
               arrow=:true, alpha=1, markershape=:none, seriestype=:path, c=:green)

# three directions
plot!(fig, map(p -> LineSegment(zeros(2), p), PolarDirections(3)), lw=5.,
           arrow=:true, alpha=1, markershape=:none, seriestype=:path, c=:red, ls=:dot)

savefig(fig, "polardirs.pdf")

# --------------------------------------------
# Lazy set Ω₀ = CH(X₀, Φ*X₀ ⊕ Y) example
# --------------------------------------------

A = [0 1; -(4π)^2 0]
X₀ = BallInf([1.0, 0.0], 0.1)
δ = 0.025
Φ = exp(A*δ)

r = [0.05477208, 0.07676220]
Y = Hyperrectangle(zeros(2), r)

Ω₀ = CH(X₀, Φ*X₀ ⊕ Y)

# make boxes with rounded corners? (doesn't work)
# using TreeView: TikzGraphs # required to change plot aspects
#t = TikzGraphs.plot(t, node_style="draw, rounded corners, fill=blue!10")
#TikzGraphs.plot(g, ["α", "β", "γ", "α"], node_style="draw, rounded corners, # fill=blue!10", node_styles=Dict(1=>"fill=green!10",3=>"fill=yellow!10"))

# ----------------------------
# Plotting a 3D polyhedron
# ----------------------------

using LazySets, Symbolics
import Polyhedra, CDDLib, Plots

# projected polyhedron from symbolic constraints
vars = @variables x1, x2, x3  # create symbols
P = HPolyhedron([2*x1>=0, 3*x2+1.7*x3>=0], vars)
Q = project(P, [2, 3])  # 2D projection (x2 and x3)


fig = p(xlim=(-1.1, 1.1), ylim=(-1.1, 1.1), ratio=1, xlab="", ylab="",
           legendfontsize=25,
           tickfont=font(25, "Times"),
           guidefontsize=25,
           xguidefont=font(25, "Times"),
           yguidefont=font(25, "Times"),
           xtick = ([-1, 0, 1], [L"-1", L"0", L"1"]),
           ytick = ([-1, 0, 1], [L"-1", L"0", L"1"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=0mm, size=(500, 380))

plot!(fig, Q)  # plot the 2D projection

savefig("polyhedron2D.pdf")


# plot the 3D set directly
using GLMakie

# intersection with a bounding box
B = BallInf(zeros(3), 5.0)
R = intersection(P, B)

fig = plot3d(R)  # plot in three dimensions

# display(fig) # display in a pop-up window
Makie.save("polyhedron3D.png", fig)

# -----------------------
# Figures with VTK
# -----------------------

using LazySets, WriteVTK
import Polyhedra

# propagate sets
rot(θ) = [cos(θ) -sin(θ) 0; sin(θ) cos(θ) 0; 0 0 1]
H = Hyperrectangle(ones(3), fill(0.1, 3))
adom = range(0, 2pi, length=20)
X = [rot(θ) * H for θ in adom]

# convexify
R = [CH(X[i], X[i+1]) for i in 1:length(X)-1]
push!(R, CH(X[end], X[1]))
RCH = concretize.(R)

# save
writevtk(X, file="rotations")
writevtk(RCH, file="rotations_CH")

using ReachabilityAnalysis

@taylorize function lorenz!(dx, x, p, t)
    local σ = 10.0
    local β = 8.0 / 3.0
    local ρ = 28.0
    dx[1] = σ * (x[2] - x[1])
    dx[2] = x[1] * (ρ - x[3]) - x[2]
    dx[3] = x[1] * x[2] - β * x[3]
    return dx
end

X0 = Hyperrectangle(low=[0.9, 0.0, 0.0], high=[1.1, 0.0, 0.0])
prob = @ivp(x' = lorenz!(x), dim=3, x(0) ∈ X0);
alg = TMJets(abstol=1e-15, orderT=10, orderQ=2, maxsteps=50_000);

sol = solve(prob, T=20.0, alg=alg);

solZ = set.(overapproximate(sol, Zonotope))
writevtk(solZ, file="lorenz") # generates lorenz.vtu

# ----------------------------
# Linear taylor model
# ----------------------------

using TaylorModels

# In this example we show how to compute a zonotope which overapproximates
# the range of the given taylor model. It should be noted that evaluation
# that uses purely interval arithmetic methods is less precise, because
# it doesn't store the information about linear dependencies as in the case of the
# zonotope.

# If the polynomials are linear, this functions exactly transforms to a zonotope.
# However, the nonlinear case necessarily introduces overapproximation error.
# Consider the linear case first:

const IA = IntervalArithmetic;

I = IA.Interval(-0.5, 0.5) # interval remainder

x₀ = IA.Interval(0.0) # expansion point
D = IA.Interval(-3.0, 1.0)
p1 = Taylor1([2.0, 1.0], 2) # define a linear polynomial
p2 = Taylor1([0.9, 3.0], 2) # define another linear polynomial
vTM = [TaylorModel1(pi, I, x₀, D) for pi in [p1, p2]] # define vector of Taylor models

# Here, `vTM` is a taylor model vector, since each component is a taylor model in
# one variable (`TaylorModel1`). Using `overapproximate(vTM, Zonotope)` we can
# compute its associated zonotope in generator representation:

using LazySets.Approximations

Z = overapproximate(vTM, Zonotope);

# Note how the generators of this zonotope mainly consist of two pieces: one comes
# from the linear part of the polynomials, and another one that corresponds to the
# interval remainder. This conversion gives the same upper and lower bounds as the
# range evaluation using interval arithmetic:

X = box_approximation(Z)
Y = evaluate(vTM[1], vTM[1].dom) × evaluate(vTM[2], vTM[2].dom)
H = convert(Hyperrectangle, Y) # this IntevalBox is the same as X

# However, the zonotope returns better results if we want to approximate the `TM`,
# since it is not axis-aligned.

# d = [-0.35, 0.93];
# ρ(d, Z) < ρ(d, X)

fig =  p(xlim=(-2, 4), ylim=(-9, 5), ratio=.5,
           xlab=L"x_1", ylab=L"x_2",
           legendfontsize=25,
           tickfont=font(25, "Times"),
           guidefontsize=25,
           xguidefont=font(25, "Times"),
           yguidefont=font(25, "Times"),
           xtick = ([-2, 0, 2, 4], [L"-2", L"0", L"2", L"4"]),
           ytick = ([-8, -4, 0, 4, 8], [L"-8", L"-4", L"0", L"4", L"8"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=0mm, size=(380, 380))

plot!(fig, H, alpha=.5, lc=:black, lw=1., c=:lightblue)

plot!(fig, Z, lw=1., alpha=1, c=:green)

savefig(fig, "taylormodel_linear.pdf")

# ----------------------------
# Non-linear taylor model
# ----------------------------

# This function also works if the polynomials are non-linear; for example suppose
# that we add a third polynomial with a quadratic term:

p2nl = Taylor1([0.9, 3.0, 3.0], 3)
vTM = [TaylorModel1(pi, I, x₀, D) for pi in [p1, p2nl]]

Znl = overapproximate(vTM, Zonotope)
Ynl = evaluate(vTM[1], vTM[1].dom) × evaluate(vTM[2], vTM[2].dom)
Hnl = convert(Hyperrectangle, Ynl)

# evaluate using tiny boxes
dom_minced = mince(vTM[1].dom, 100)
Ynlsmall = [evaluate(vTM[1], dd) × evaluate(vTM[2], dd) for dd in dom_minced]

fig =  p(xlim=(-2, 4), ylim=(-9, 5), ratio=.1,
           xlab=L"x_1", ylab=L"x_2",
           legendfontsize=20,
           tickfont=font(20, "Times"),
           guidefontsize=20,
           xguidefont=font(20, "Times"),
           yguidefont=font(20, "Times"),
           xtick = ([-2, 0, 2, 4], [L"-2", L"0", L"2", L"4"]),
           ytick = ([0, 15, 30], [L"0", L"15", L"30"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=0mm, size=(380, 300))

plot!(fig, Hnl, alpha=.5, lc=:black, lw=1., c=:lightblue)

plot!(fig, Znl, lw=1., alpha=1, c=:green)

[plot!(fig, Yi, lw=1., alpha=.5, c=:red, lab="") for Yi in Ynlsmall]

savefig(fig, "taylormodel_nonlinear.pdf")
