include("genetic_algorithm.jl")

#=
|   Example:
|   Find four numbers that add up to 143.
|
|   x1 + x2 + x3 + x4 = 143
|   x1=?, x2=?, x3=?, x4=?
=#

populationSize = 100
genesLength = 4
minGene = 0
maxGene = 143

elitePercent = 0.15
mutationPercent = 0.2
numOfIterations = 100

population = generatePopulation(populationSize, genesLength, minGene, maxGene)

num_gen, best = geneticAlgorithm(population, 
                                 elitePercent, 
                                 mutationPercent, 
                                 makeCrossoverFunc([1;3]), 
                                 numOfIterations)

println("$(num_gen) -> $best")

# ANALYZATION

function getAverage(population::Vector{Entity}, elitePercent::Float64, mutationPercent::Float64, crossoverFunc!::Function, iter::Int)
    avg_gen = 0
    avg_best = 0

    for i in 1:100
        gen_i, best_i = geneticAlgorithm(population, 
                                       elitePercent, 
                                       mutationPercent, 
                                       crossoverFunc!, 
                                       numOfIterations)
        avg_gen += gen_i
        avg_best += best_i.fitness
    end

    return (avg_gen/100, avg_best/100)
end

function analyzeElitePercentage(values::Array{Float64})
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
                           elitePercent, 
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
                                   elitePercent, 
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
                                   elitePercent, 
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

println("Elite percentage analysis: \n")
printResult(collect(0.0:0.05:0.5), analyzeElitePercentage(collect(0.0:0.05:0.5)))

println("\nMutation percentage analysis: \n")
printResult(collect(0.0:0.05:0.5), analyzeMutationPercentage(collect(0.0:0.05:0.5)))

println("\nPopulation size analysis: \n")
printResult(collect(50:10:150), analyzePopulationSize(collect(50:10:150)))

println("\nNumber of iterations analysis: \n")
printResult(collect(50:10:150), analyzeNumberOfIteration(collect(50:10:150)))