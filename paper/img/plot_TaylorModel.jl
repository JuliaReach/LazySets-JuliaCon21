include("preamble.jl")

# ----------------------------
# Linear Taylor model
# ----------------------------

using TaylorModels

# In this example we show how to compute a zonotope which overapproximates
# the range of the given Taylor model. It should be noted that evaluation
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

# Here, `vTM` is a Taylor model vector, since each component is a Taylor model in
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

# However, the zonotope returns better results if we want to approximate the TM,
# since it is not axis-aligned.

# d = [-0.35, 0.93]  # d ≈ normalize(d)
# sfZ = ρ(d, Z)
# sfH = ρ(d, X)

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

plot!(fig, Z, lw=3., alpha=1, c=:green, linecolor=:red)

savefig(fig, "taylormodel_linear.pdf")

# ----------------------------
# Non-linear Taylor model
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

[plot!(fig, Yi, lw=0., alpha=0.5, c=:red, lab="") for Yi in Ynlsmall]

savefig(fig, "taylormodel_nonlinear.pdf")
