export delete

"""
    keepit(out, mask::BitArray)

Keep material points for object using boolean array mask.

# Arguments
- `out`: Material point gemetry data.
- `mask::BitArray`: Boolean array.

# Returns
- `out`: Material point gemetry data.
"""
function keepit(out, mask::BitArray)
    return repack(out[:x][:, mask], out[:v][:, mask], out[:y][:, mask], out[:volume][mask], out[:type][mask])
end

"""
    delete(obj::T, f::Function) where T <: SuperShape

Delete material points for object using function f.

# Arguments
- `obj::T`: Object.
- `f::Function`: Function that returns a boolean array.

# Returns
- `obj::T`: Object.

# Example
```julia
using PDMaterialPoints

# Create a disk
disk = Disk(1.0, 0.1)

# Create a material-point-geometry.
mpg =create(disk, resolution=0.1)

# Delete particles
mpg =delete(mpg, out -> out['x'][:, 1] .> 0.0)
```

# See also
- [`delete(out, mask::BitArray)`](@ref)

"""
function delete(obj::T, f::Function) where T
    # x, v, y, vol, type
    function func(out)
        mask = vec(f(out)) .== false
        out = keepit(out, mask)
        return out
    end
    return apply!(obj, func)
end