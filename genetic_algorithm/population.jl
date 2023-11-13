mutable struct Entity
    genes::Vector{Int}
    fitness::Float64
end

Base.show(io::IO, e::Entity) = print(io, "{$(e.fitness)}[$(join(e.genes, ","))]")


function  fitFunction(e::Entity)
    return abs(sum(e.genes) - 143)
end

"""
Funtion to generate the **initial** population.

### Arguments:
 - `n::Int` - number of entities in a population
 - `genesLength::Int` - length of a single chromosome
 - `minGene::Int` - minimum value of a single gene
 - `maxGene::Int` - maximum value of a single gene
 - `initFit::Int` - initial fitness for each entity ( 0 by default)

### Returns:
 - Population with **n** entities with **randomly** selected values of genes.
   Initial fitness for each entity is set to `initFit`
"""
function generatePopulation(n::Int, genesLength::Int, minGene::Int, maxGene::Int, initFit::Int=0)
    population = Vector{Entity}()

    for i in 1:n
        push!(population, Entity(rand(minGene:maxGene, genesLength), initFit))
    end

    return population;
end

"""
Updates fitness of each entity in `population` using `fitFunc`

### Arguments:
 - `population::Vector{Entity}` - selected population
 - `fitFunc::Function` - function used for calculating fitness of an entity
"""
function updatePopulationFitness!(population::Vector{Entity}, fitFunc::Function)
    for entity in population
        entity.fitness = fitFunc(entity)
    end

    # Sort all entities by thier distance from optimal solution
    sort!(population, by=e->e.fitness)
end


function mutatePopulation!(population::Vector{Entity}, mutationPercent::Float64)
    for entity in population
        if rand(Float64) < mutationPercent
            idx = rand(1:length(entity.genes))
            val = Int(trunc(rand(Float64) * 143))

            entity.genes[idx] = val
        end
    end
end