# Exports

export Shape, PostOpObj, create

abstract type Shape end

mutable struct PostOpObj 
    obj::Shape
    operations::Array{Function}
end

"""
    create(shape::T; resolution=nothing, rand_=0.0, type::Int64=1) where T <: Shape

Abstact function for creating **Shape** objects.

## Returns
    - X : Initial reference position 
    - V : Initial velocity 
    - Y : Initial position 
    - volume : Volume per particle point 
    - type: Type of particle point

"""
function create(shape::T; resolution=nothing, rand_=0.0, type::Int64=1) where T <: Shape
    error("Not implemented for type **$(typeof(shape))** yet.")
end 

function create(obj::PostOpObj, args...; kwargs...)
    out = create(obj.obj, args...; kwargs...)
    for func in obj.operations
        out = func(out)
    end
    return out
end


include("./cuboid.jl")
include("./sphere.jl")
include("./disk.jl")
include("./cylinder.jl")
include("./cone.jl")


