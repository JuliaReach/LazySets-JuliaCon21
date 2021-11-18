include("preamble.jl")

# -------------------
# Suport function
# -------------------

X = VPolygon([[0.8, 2.2], [2.1, 1], [1.9, -1], [0, -2],
              [-2, -2], [-3, 0.6], [-0.8, 1.8], [0.8, 2.2]])
d = [-1.0, 1.0]

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
