include("population.jl")

function crossover!(population::Vector{Entity}, crossoverFunc!::Function)
    n::Int = length(population)/2

    for i in 1:n
        crossoverFunc!(population[i], population[i+1])
    end

    return population
end

function makeCrossoverFunc(idx::Int)
    function crossoverFunc(entity1::Entity, entity2::Entity)
        for i in 1:idx
            entity1.genes[i], entity2.genes[i] = entity2.genes[i], entity1.genes[i]
        end
    end

    return crossoverFunc
end

function makeCrossoverFunc(indices::Vector{Int})
    function crossoverFunc(entity1::Entity, entity2::Entity)
        gl = length(entity1.genes)
        swap = true

        cp_idx = [indices; gl]
        i = 1

        for idx in cp_idx
            while i <= idx
                if swap
                    entity1.genes[i], entity2.genes[i] = entity2.genes[i], entity1.genes[i]
                end

                i += 1
            end

            swap = !swap
        end
    end

    return crossoverFunc
end