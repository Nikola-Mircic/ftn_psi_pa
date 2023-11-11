include("population.jl")
include("crossover.jl")

bestFitnes = []

function geneticAlgorithm(population::Vector{Entity}, elitePercent::Float64, mutationPercent::Float64, crossoverFunc!::Function, iter::Int)
    updatePopulationFitness!(population, fitFunction)

    push!(bestFitnes, population[1].fitness)

    while !shouldStop(iter)
        n = length(population)

        eliteNumber = Int(elitePercent*n);

        eliteNumber += (eliteNumber % 2 == 1) ? 1 : 0

        elite = population[1:eliteNumber]

        population = crossover!(population[eliteNumber+1:end], crossoverFunc!)

        mutatePopulation!(population, mutationPercent)

        population = [population; elite]

        updatePopulationFitness!(population, fitFunction)

        push!(bestFitnes, population[1].fitness)
    end

    return length(bestFitnes), population[1]
end

function shouldStop(iter::Int)
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

