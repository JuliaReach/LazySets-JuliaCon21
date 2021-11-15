include("preamble.jl")

# ----------------------------
# Plotting a 3D polyhedron
# ----------------------------

using LazySets, Symbolics
import Polyhedra, CDDLib, Plots
using Colors

# projected polyhedron from symbolic constraints
vars = @variables x1, x2, x3  # create symbols
P = HPolyhedron([2*x1>=0, 3*x2+1.7*x3>=0], vars)
Q = project(P, [2, 3])  # 2D projection (x2 and x3)


fig = p(xlim=(-1.1, 1.1), ylim=(-1.1, 1.1), ratio=1, xlab=L"x_2", ylab=L"x_3",
           legendfontsize=25,
           tickfont=font(25, "Times"),
           guidefontsize=25,
           xguidefont=font(25, "Times"),
           yguidefont=font(25, "Times"),
           xtick = ([-1, 0, 1], [L"-1", L"0", L"1"]),
           ytick = ([-1, 0, 1], [L"-1", L"0", L"1"]),
           bottom_margin=5mm, left_margin=-5mm, right_margin=0mm, top_margin=0mm, size=(500, 380))

plot!(fig, Q)  # plot the 2D projection

savefig("polyhedron2D.pdf")


# plot the 3D set directly
using GLMakie

# intersection with a bounding box
B = BallInf(zeros(3), 5.0)
R = intersection(P, B)

# obtain the mesh
backend = LazySets.default_polyhedra_backend(R);
P_poly_mesh = LazySets._plot3d_helper(R, backend);

f = Figure()
ax = Axis3(f[1, 1], xlabel="x₁", xlabelsize=80, xticklabelsize=55,
                    ylabel="x₂", ylabelsize=80, yticklabelsize=55,
                    zlabel="x₃", zlabelsize=80, zticklabelsize=55)

mesh!(P_poly_mesh, alpha=1.0, color=:deepskyblue, colormap=:viridis, colorrange=Makie.Automatic(), interpolate=false,
                   linewidth=1, overdraw=false, shading=true, transparency=true, visible=true)

wireframe!(P_poly_mesh, color = :red, linewidth=1.5, linestyle=:dash, axis=(type=Axis3,))

Makie.save("polyhedron3D.png", f)

# f = Figure()
# fig = plot3d(R)  # plot in three dimensions
# current_figure()
# display(fig) # display in a pop-up window
