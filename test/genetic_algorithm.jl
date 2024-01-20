using FTN_PSI_PA.GeneticAlgorithm

@testset "GeneticAlgorithm" begin
    #=
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

    num_gen, best = getAverage(population, 
                                    elitistSelection(elitePercent), 
                                    mutationPercent, 
                                    makeCrossoverFunc([1;3]), 
                                    numOfIterations)

    @test best < 0.1 # Test if the absolute error is smaller than 0.1
end