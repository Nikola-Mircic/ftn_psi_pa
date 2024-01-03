include("swarm.jl")

MAX_ITERATIONS = 100

function pso(swarm::Swarm, W::Float64, Cc::Float64, Cs::Float64)
    bestValues = [swarm.particles[1].bestFit]

    while !shouldStop(bestValues)
        for p in swarm.particles
            updateParticleFitness!(p)
        end

        updateSwarmFitness!(swarm)

        calculateVelocity!(swarm, W, Cc, Cs)

        updatePositions!(swarm)

        push!(bestValues, swarm.bestFit)
    end

    return length(bestValues), swarm.bestVal
end

function shouldStop(bestValues)
    n = length(bestValues)

    if bestValues[n] < 1
        return true
    elseif n > MAX_ITERATIONS
        return true
    elseif n > 2
        return bestValues[n-1] == bestValues[n]
    end

    return false
end

function calculateVelocity!(swarm::Swarm, W::Float64, Cc::Float64, Cs::Float64)
    for p in swarm.particles
        r1 = rand(Float64)
        r2 = rand(Float64)

        p.velocity = W*(p.velocity) + 
                     Cc*r1*(p.bestVal - p.currentVal) +
                     Cs*r2*(swarm.bestVal - p.currentVal) 
    end
end

function updatePositions!(swarm::Swarm)
    for p in swarm.particles
        p.currentVal = Int.(trunc.(p.currentVal + p.velocity))
    end
end