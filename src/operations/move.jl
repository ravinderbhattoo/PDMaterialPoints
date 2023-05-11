export move

"""
    move(x::Array{Float64,2}; by=[0.0, 0.0, 0.0])

Move mesh particles for object by given "by".

# Arguments
- `x::Array{Float64,2}`: Array of mesh particles.
- `by=[0.0, 0.0, 0.0]`: Translation vector.

# Returns
- `x::Array{Float64,2}`: Array of mesh particles.

# See also
- [`move`](@ref)

"""
function move(x::Array{Float64,2}; by=[0.0, 0.0, 0.0])
    x .+= vec(by)
    return x
end

"""
    move(obj::T; by=[0.0, 0.0, 0.0]) where T

Move mesh particles for object by given "by".

# Arguments
- `obj::T`: Object.
- `by=[0.0, 0.0, 0.0]`: Translation vector.

# Returns
- `obj::T`: Object.

# Example
```julia
using PDMesh

# Create a disk
disk = Disk(1.0, 0.1)

# Create a mesh
mesh = create(disk, resolution=0.1)

# Move particles
mesh = move(mesh, by=[0.0, 0.0, 0.1])
```

# See also
- [`move`](@ref)

"""
function move(obj::T; by=[0.0, 0.0, 0.0]) where T <: Union{Shape, PostOpObj}
    # x, v, y, vol, type
    function func(out)
        x = out[:x]
        x = move(x, by=by)
        return repack!(out, [:x], [x])
    end
    return apply!(obj, func)
end