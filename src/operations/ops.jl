# Description: This file contains the main operations that are used in the program.
# These operations are called by the main program and are used to perform the operations on the objects.

function apply!(obj::T, func::Function) where T <: Shape
    return PostOpObj(obj, func)
end

function apply!(obj::T, func::Vector{Function}) where T <: Shape
    for f in func
        obj = apply!(obj, f)
    end
    return obj
end

function apply!(obj::T, func::Function) where T <: PostOpObj
    push!(obj.operations, func)
    return obj
end

function apply!(obj::T, func::Vector{Function}) where T <: PostOpObj
    for f in func
        push!(obj.operations, f)
    end
    return obj
end

include("./move.jl")
include("./rotate.jl")
include("./delete.jl")
include("./changetype.jl")
include("./velocity.jl")