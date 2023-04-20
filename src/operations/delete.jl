export delete

"""
    delete(out, mask::BitArray)

Delete mesh particles for object using boolean array mask.

# Arguments
- `out`: Mesh data.
- `mask::BitArray`: Boolean array.

# Returns
- `out`: Mesh data.
"""
function delete(out, mask::BitArray)
    return repack(out[:x][:, mask], out[:v][:, mask], out[:y][:, mask], out[:volume][mask], out[:type][mask])
end

"""
    delete(obj::T, f::Function) where T <: Union{Shape, PostOpObj}

Delete mesh particles for object using function f.

# Arguments
- `obj::T`: Object.
- `f::Function`: Function that returns a boolean array.

# Returns
- `obj::T`: Object.

# Example
```julia
using PDMesh

# Create a disk
disk = Disk(1.0, 0.1)

# Create a mesh
mesh = create(disk, resolution=0.1)

# Delete particles
mesh = delete(mesh, out -> out['x'][:, 1] .> 0.0)
```

# See also
- [`delete(out, mask::BitArray)`](@ref)

"""
function delete(obj::T, f::Function) where T
    # x, v, y, vol, type
    function func(out)
        mask = vec(f(out)) .== false
        out = delete(out, mask)
        return out
    end
    if isa(obj, Shape)
        return PostOpObj(obj, func)
    elseif isa(obj, PostOpObj)
        push!(obj.operations, func)
        return obj
    else
        error("Not allowed.")
    end
end