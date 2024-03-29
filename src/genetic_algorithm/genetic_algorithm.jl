module GeneticAlgorithm

include("selection.jl")


export generatePopulation
export fitFunction

export makeCrossoverFunc

export elitistSelection
export rouletteWheelSelection

export geneticAlgorithm

export getAverage
export analyzeElitePercentage
export analyzeMutationPercentage
export analyzeNumberOfIteration
export analyzePopulationSize

export printResult

function geneticAlgorithm(population::Vector{Entity}, selectAndCross::Function, mutationPercent::Float64, crossoverFunc!::Function, iter::Int)
    bestFitnes = []
    
    updatePopulationFitness!(population, fitFunction)

    push!(bestFitnes, population[1].fitness)

    while !shouldStop(iter, bestFitnes)
        population = selectAndCross(population, crossoverFunc!)

        mutatePopulation!(population, mutationPercent)

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

# ANALYZATION

function getAverage(population::Vector{Entity}, selectAndCross::Function, mutationPercent::Float64, crossoverFunc!::Function, iter::Int)
    avg_gen = 0
    avg_best = 0

    for i in 1:100
        gen_i, best_i = geneticAlgorithm(population, 
                                        selectAndCross, 
                                        mutationPercent, 
                                        crossoverFunc!, 
                                        iter)
        avg_gen += gen_i
        avg_best += best_i.fitness
    end

    return (avg_gen/100, avg_best/100)
end

function analyzeElitePercentage(values::Array{Function})
    results = zeros(length(values), 2)

    for i in 1:length(values)
        population_i = generatePopulation(populationSize, genesLength, minGene, maxGene)

        gen_i, best_i = getAverage(population_i, 
                           values[i], 
                           mutationPercent, 
                           makeCrossoverFunc([1;3]), 
                           numOfIterations)
        
        results[i, 1] = gen_i
        results[i, 2] = best_i
    end

    return results
end

function analyzeMutationPercentage(values::Array{Float64})
    results = zeros(length(values), 2)

    for i in 1:length(values)
        population_i = generatePopulation(populationSize, genesLength, minGene, maxGene)

        gen_i, best_i = getAverage(population_i, 
                           elitistSelection(elitePercent), 
                           values[i], 
                           makeCrossoverFunc([1;3]), 
                           numOfIterations)
        
        results[i, 1] = gen_i
        results[i, 2] = best_i
    end

    return results
end

function analyzePopulationSize(values::Vector{Int})
    results = zeros(length(values), 2)

    for i in 1:length(values)
        population_i = generatePopulation(values[i], genesLength, minGene, maxGene)

        gen_i, best_i = getAverage(population_i, 
                                   elitistSelection(elitePercent), 
                                   mutationPercent, 
                                   makeCrossoverFunc([1;3]), 
                                   numOfIterations)
        
        results[i, 1] = gen_i
        results[i, 2] = best_i
    end

    return results
end

function analyzeNumberOfIteration(values::Vector{Int})
    results = zeros(length(values), 2)

    for i in 1:length(values)
        population_i = generatePopulation(populationSize, genesLength, minGene, maxGene)

        gen_i, best_i = getAverage(population_i, 
                                   elitistSelection(elitePercent), 
                                   mutationPercent, 
                                   makeCrossoverFunc([1;3]), 
                                   values[i])
        
        results[i, 1] = gen_i
        results[i, 2] = best_i
    end

    return results
end

using Printf

function printResult(values, results)
    for i in eachindex(values)
        @printf "%5.2f | %5.2f , %5.2f \n" values[i] results[i,1] results[i,2]
    end
end

end