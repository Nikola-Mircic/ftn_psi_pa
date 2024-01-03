mutable struct Particle
    currentVal::Vector{Int}
    currentFit::Int

    bestVal::Vector{Int}
    bestFit::Int

    velocity::Vector{Float64}
end

Base.show(io::IO, p::Particle) = println(io, "{$(p.bestFit)}[$(join(p.currentVal, ","))]")


function fitFunction(p::Particle)
    return abs(sum(p.currentVal) - 143)
end

mutable struct Swarm
    particles::Vector{Particle}

    bestVal::Vector{Int}
    bestFit::Int

    Swarm() = new(Vector{Particle}(), Vector{Int}(), typemax(Int))
end

function printSwarm(io::IO, s::Swarm)
    println(io, " --> $(join(s.bestVal, ",")) <--")
    for p in s.particles
        println(io, p)
    end
end

Base.show(io::IO, s::Swarm) = printSwarm(io, s)

function generateSwarm(n::Int, valuesLen::Int, minVal::Int, maxVal::Int, initFit::Int=0)
    swarm = Swarm()

    for i in 1:n
        particle = Particle(rand(minVal:maxVal, valuesLen),
                            0,
                            zeros(Int, valuesLen),
                            typemax(Int),
                            zeros(Float64, valuesLen) )

        updateParticleFitness!(particle)

        push!(swarm.particles, particle)
    end
    
    return swarm;
end

function updateParticleFitness!(p::Particle)
    p.currentFit = fitFunction(p)

    if p.currentFit < p.bestFit
        p.bestVal = copy(p.currentVal)
        p.bestFit = p.currentFit
    end
end

function updateSwarmFitness!(swarm::Swarm)
    for p in swarm.particles
        if p.bestFit < swarm.bestFit
            swarm.bestVal = copy(p.bestVal)
            swarm.bestFit = p.bestFit
        end
    end
end