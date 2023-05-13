# Exports

export Shape, PostOpObj, create, make, combine, unpack, repack, repack!

"""
    SuperShape

Abstract type for supershapes.
"""
abstract type SuperShape end

"""
    Shape

Abstract type for shapes.
"""
abstract type Shape <: SuperShape end

"""
    PostOpObj

These objects are used to create a post operation object (lazy)
from object ( or post operation object)and an operation.
Operations will be applied while a create call.

# Fields
- `name::String`: Name of the object.
- `objs::Vector{Any}`: Objects to be operated on.
- `operations::Array{Function}`: Operations to be applied.

"""
mutable struct PostOpObj <: SuperShape
    name::String
    objs::Vector{Any}
    operations::Array{Function}
    function PostOpObj(obj, func; name="PostOpObj")
        if ~isa(obj, Vector)
            obj = [obj]
        end
        if ~isa(func, Vector)
                func = [func]
        end
        new(name, obj, func)
    end
end

Base.show(io::IO, obj::PostOpObj) = print(io, obj.name)

function Base.copy(x::T) where T<:SuperShape
    T(copy.([getfield(x, fn) for fn in fieldnames(T)])...)
end



"""
    create(shape::T; resolution=nothing, rand_=0.0, type::Int=1) where T <: Shape

Abstact function for creating **Shape** objects.

# Arguments
- `shape::T`: Shape object.
- `resolution=nothing`: Resolution of the material-point-geometry.
- `rand_=0.0`: Randomization factor.
- `type::Int=1`: Type of the material-point-geometry.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the material-point-geometry data.
"""
function create(shape::T; resolution=nothing, rand_=0.0, type::Int=1) where T <: Shape
    error("Not implemented for type **$(typeof(shape))** yet.")
end


"""
    make(shape::T) where T <: Shape

Create a material-point-geometry from a shape. This function is a wrapper for the create function. It is used to create a material-point-geometry from a shape with default arguments.

# Arguments
- `shape::T`: Shape object.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the material-point-geometry data.
"""
function make(shape::T) where T <: SuperShape
    create(shape; resolution=0.1, rand_=0.01, type=1)
end


"""
    create(pobj::PostOpObj, args...; kwargs...)

Create a material-point-geometry from a post operation object.

# Arguments
- `pobj::PostOpObj`: Post operation object.
- `args...`: Arguments to be passed to the create function.
- `kwargs...`: Keyword arguments to be passed to the create function.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the material-point-geometry data.
"""
function create(pobj::PostOpObj, args...; kwargs...)
    temp = nothing
    out = nothing
    for obj in pobj.objs
        temp = create(obj, args...; kwargs...)
        if isa(out, Nothing)
            out = temp
        else
            for (key, val) in out
                out[key] = mycat(out[key], temp[key])
            end
        end
    end
    for func in pobj.operations
        out = func(out)
    end
    out[:y] .= out[:x]
    return out
end

function Base.:+(obj1::T1, obj2::T2) where {T1<:SuperShape, T2<:SuperShape}
    PostOpObj([obj1, obj2], [])
end

function Base.:+(obj1::T1, obj2::Nothing) where {T1<:SuperShape}
    PostOpObj([obj1], [])
end


"""
    add(obj1::T1, obj2::T2) where {T1<:SuperShape, T2<:SuperShape}

Add two objects.

# Arguments
- `obj1::T1`: First object.
- `obj2::T2`: Second object.

"""
function add(obj1, obj2)
    obj1 + obj2
end

"""
    combine(obj1::T1, obj2::T2) where {T1<:SuperShape, T2<:SuperShape}

Combine two objects. Duplicate of add.
"""
function combine(obj1, obj2)
    obj1 + obj2
end

function Base.:+(obj1::Nothing, obj2::T1) where {T1<:SuperShape}
    obj2 + obj1
end


"""
    unpack(d::Dict)

Unpack a dictionary into its components.

# Arguments
- `d::Dict`: Dictionary to be unpacked.

# Returns
- `x::Array{Float64, 1}`: x coordinates.
- `v::Array{Float64, 1}`: v coordinates.
- `y::Array{Float64, 1}`: y coordinates.
- `volume::Array{Float64, 1}`: Volume of the material-point-geometry.
- `type::Array{Int, 1}`: Type of the material-point-geometry.
"""
function unpack(d::Dict)
    return d[:x], d[:v], d[:y], d[:volume], d[:type]
end

"""
    repack(args...; keys_ = (:x, :v, :y, :volume, :type))

Repack a dictionary from its components.

# Arguments
- `args...`: Components to be packed.
- `keys_ = (:x, :v, :y, :volume, :type)`: Keys of the dictionary.

# Returns
- `d::Dict`: Dictionary containing the components.
"""
function repack(args...; keys_ = (:x, :v, :y, :volume, :type))
    d = Dict()
    for i in 1:5
        d[keys_[i]] = args[i]
    end
    d
end

"""
    repack!(d::Dict, keys_, vals)

Repack a dictionary from its components inplace.

# Arguments
- `d::Dict`: Dictionary to be repacked.
- `keys_`: Keys of the dictionary.
- `vals`: Values of the dictionary.

# Returns
- `d::Dict`: Dictionary containing the components.
"""
function repack!(d::Dict, keys_, vals)
    if length(keys_)==length(vals)
        for i in 1:length(vals)
            d[keys_[i]] = vals[i]
        end
    else
        error("Lengths are not same.")
    end
    d
end

function mycat(a, b)
    if length(size(a))==1
        return vcat(a, b)
    else
        return hcat(a, b)
    end
end

include("./cone.jl")
include("./cuboid.jl")
include("./cylinder.jl")
include("./disk.jl")
include("./pyramid.jl")
include("./sphere.jl")


