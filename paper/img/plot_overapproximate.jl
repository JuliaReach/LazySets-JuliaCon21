include("preamble.jl")

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
p!(X, color=:orange, alpha=0.8)

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
               arrow=:simple, alpha=1, markershape=:none, seriestype=:path, c=:green)

# three directions
plot!(fig, map(p -> LineSegment(zeros(2), p), PolarDirections(3)), lw=5.,
           arrow=:simple, alpha=1, markershape=:none, seriestype=:path, c=:red, ls=:dot)

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
