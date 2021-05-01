# Exports

export Shape, create

abstract type Shape end

"""
    create(shape::T) where T <: Shape

Abstact function for creating **Shape** objects.

## Returns
    - X : Initial reference position 
    - V : Initial velocity 
    - Y : Initial position 
    - volume : Volume per particle point 

"""
function create(shape::T) where T <: Shape
    error("Not implemented yet.")
end 

include("./cuboid.jl")
