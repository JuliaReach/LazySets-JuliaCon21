include("preamble.jl")

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
