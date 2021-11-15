include("preamble.jl")

# ----------------------------
# Plotting a 3D polyhedron
# ----------------------------

# Note: in this figure we use non-latex fonts for the ticks labels because
# the Makie plot ignores L"x_3"

using LazySets, Symbolics
import Polyhedra, CDDLib, Plots
using Colors

# projected polyhedron from symbolic constraints
vars = @variables x1, x2, x3  # create symbols
P = HPolyhedron([2*x1>=0, 3*x2+1.7*x3>=0], vars)
Q = project(P, [2, 3])  # 2D projection (x2 and x3)


fig = p(xlim=(-4, 4), ylim=(-4, 4), ratio=1, xlab="x₂", ylab="x₃",
           legendfontsize=20,
           tickfont=font(20), # , "Times"),
           guidefontsize=20,
           xguidefont=font(20), # , "Times"),
           yguidefont=font(20), # , "Times"),
           xtick = ([-4, 0, 4], ["-4", "0", "4"]),
           ytick = ([-4, 0, 4], ["-4", "0", "4"]),
           bottom_margin=0mm, left_margin=0mm, right_margin=0mm, top_margin=2mm, size=(500, 380))

plot!(fig, Q, color=:deepskyblue)  # plot the 2D projection

savefig("polyhedron2D.pdf")


# plot the 3D set directly
using GLMakie

# intersection with a bounding box
B = BallInf(zeros(3), 5.0)
R = intersection(P, B)

# obtain the mesh
backend = LazySets.default_polyhedra_backend(R);
P_poly_mesh = LazySets._plot3d_helper(R, backend);

fig3d = Figure()
ax = Axis3(fig3d[1, 1], xlabel="x₁", xlabelsize=40, xticklabelsize=40,
                    ylabel="x₂", ylabelsize=40, yticklabelsize=40,
                    zlabel="x₃", zlabelsize=40, zticklabelsize=40,
                    aspect=:data,
                    height=400)

mesh!(P_poly_mesh, alpha=1.0, color=:deepskyblue, colormap=:viridis, colorrange=Makie.Automatic(), interpolate=false,
                   linewidth=1, overdraw=false, shading=true, transparency=true, visible=true)

wireframe!(P_poly_mesh, color = :red, linewidth=1.5, linestyle=:dash, axis=(type=Axis3,))

Makie.save("polyhedron3D.png", fig3d)

# f = Figure()
# fig = plot3d(R)  # plot in three dimensions
# current_figure()
# display(fig) # display in a pop-up window
