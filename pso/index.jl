include("pso.jl")

#=
|   Example:
|   Find four numbers that add up to 143.
|
|   x1 + x2 + x3 + x4 = 143
|   x1=?, x2=?, x3=?, x4=?
=#

swarmSize = 100
W = 1.0
Cc = 0.5
Cs = 0.3

swarm = generateSwarm(swarmSize, 4, -100, 100)

num_gen, best = pso(swarm, W, Cc, Cs)


println("$(num_gen) -> $best")