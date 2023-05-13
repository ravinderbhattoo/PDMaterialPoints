export changetype

"""
    changetype(type::Array{Int,1}, mask, ntype::Int)

Change material point type for object using boolean array mask.

# Arguments
- `type::Array{Int,1}`: Array of particle types.
- `mask`: Boolean array.
- `ntype::Int`: New particle type.

# Returns
- `type::Array{Int,1}`: Array of particle types.

# See also
- [`changetype(obj::T, f::Function, ntype::Int) where T <: SuperShape`](@ref)
"""
function changetype(type::Array{Int,1}, mask, ntype::Int)
    type[mask] .= ntype
    return type
end

"""
    changetype(obj::T, f::Function, ntype::Int) where T <: SuperShape

Change material point type for object using function f.

# Arguments
- `obj::T`: Object.
- `f::Function`: Function that returns a boolean array.
- `ntype::Int`: New particle type.

# Returns
- `obj::T`: Object.

# See also
- [`changetype(type::Array{Int,1}, mask, ntype::Int)`](@ref)

# Example
```julia
using PDMaterialPoints

# Create a disk
disk = Disk(1.0, 0.1)

# Create a material-point-geometry.
mpg =create(disk, resolution=0.1)

# Change particle type
mpg =changetype(mpg, out -> out['x'][:, 1] .> 0.0, 2)
```
"""
function changetype(obj::T, f::Function, ntype::Int) where T <: SuperShape
    # x, v, y, vol, type
    function func(out)
        mask = vec(f(out))
        # change type
        type = changetype(out[:type], mask, ntype)
        return repack!(out, [:type], [type])
    end
    return apply!(obj, func)
end