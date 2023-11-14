include("population.jl")
include("crossover.jl")


function geneticAlgorithm(population::Vector{Entity}, elitePercent::Float64, mutationPercent::Float64, crossoverFunc!::Function, iter::Int)
    bestFitnes = []
    
    updatePopulationFitness!(population, fitFunction)

    push!(bestFitnes, population[1].fitness)

    while !shouldStop(iter, bestFitnes)
        n = length(population)

        eliteNumber = Int(trunc(elitePercent*n));

        eliteNumber  = eliteNumber + (n-eliteNumber)%2

        elite = deepcopy(population[1:eliteNumber])

        population = crossover!(population[eliteNumber+1:end], crossoverFunc!)

        mutatePopulation!(population, mutationPercent)

        population = [population; elite]

        updatePopulationFitness!(population, fitFunction)

        push!(bestFitnes, population[1].fitness)
    end

    return length(bestFitnes), population[1]
end

function shouldStop(iter::Int, bestFitnes)
    n = length(bestFitnes)

    if bestFitnes[n] < 0.01
        return true
    elseif n > iter
        return true
    elseif n > 3
        return abs(bestFitnes[n-3] - bestFitnes[n]) < 0.1
    end
    
    return false
end

