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

function findIdx(arr, x)
    l::Int = 1;
    r::Int = length(arr)
    
    
    s = l + div(r-l,2)
    idx = s
    while l <= r
        if x <= arr[s]
            idx = s
            r = s-1
        else
            l = s+1
        end

        s = l + div(r-l,2)
    end

    return idx
end

function rouletteWheelSelection()
    function selectionMethod(population::Vector{Entity}, crossFunc!::Function)
        n = length(population)

        px = population .|> fitFunction

        totalFit = sum(px)

        px = px .|> (x)->x/totalFit

        for i=2:length(px)
            px[i] = px[i] + px[i-1]
        end

        for i=1:div(n,2)
            idx1 = findIdx(px, rand())
            idx2 = findIdx(px, rand())

            crossFunc!(population[idx1], population[idx2])
        end

        return population
    end
end