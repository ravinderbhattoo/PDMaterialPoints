# Exports

export Shape, PostOpObj, create

abstract type Shape end

mutable struct PostOpObj 
    obj::Shape
    operations::Array{Function}
end

"""
    create(shape::T) where T <: Shape

Abstact function for creating **Shape** objects.

## Returns
    - X : Initial reference position 
    - V : Initial velocity 
    - Y : Initial position 
    - volume : Volume per particle point 

"""
function create(shape::T; resolution=nothing, rand_=0.0) where T <: Shape
    error("Not implemented for type **$(typeof(shape))** yet.")
end 

function create(obj::PostOpObj, args...; kwargs...)
    x, v, y, vol, type = create(obj.obj, args...; kwargs...)
    for func in obj.operations
        x, type = func(x, type)
    end
    return x, v, copy(x), vol, type
end


include("./cuboid.jl")
include("./sphere.jl")
include("./disk.jl")
include("./cylinder.jl")
include("./cone.jl")


