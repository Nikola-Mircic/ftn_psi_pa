include("crossover.jl")

function elitistSelection(elitePercent::Float64)
    function selectionMethod(population::Vector{Entity}, crossFunc!::Function)
        n = length(population)

        eliteNumber = Int(trunc(elitePercent*n));

        eliteNumber  = eliteNumber + (n-eliteNumber)%2

        elite = deepcopy(population[1:eliteNumber])

        population = crossover!(population[eliteNumber+1:end], crossFunc!)

        population = [population; elite]

        return population
    end
end