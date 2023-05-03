export rotate

"""
    rotate(x::Array{Float64,2}; angle=0.0, point=[0.0, 0.0, 0.0], vector_=[1.0, 0.0, 0.0])

Rotate mesh particles for object by given angle about given vector and point.

# Arguments
- `x::Array{Float64,2}`: Array of mesh particles.
- `angle=0.0`: Rotation angle.
- `point=[0.0, 0.0, 0.0]`: Rotation point.
- `vector_=[1.0, 0.0, 0.0]`: Rotation vector.

# Returns
- `x::Array{Float64,2}`: Array of mesh particles.

# Example
```julia
using PDMesh

# Create a disk
disk = Disk(1.0, 0.1)

# Create a mesh
mesh = create(disk, resolution=0.1)

# Rotate particles
mesh = rotate(mesh, angle=90.0)
```
"""
function rotate(x::Array{Float64,2}; angle=0.0, point=[0.0, 0.0, 0.0], vector_=[1.0, 0.0, 0.0])
    t = angle/180*pi
    x = x .- vec(point)
    vector_ = vec(vector_)
    unit_vector = vector_/(sqrt(sum(vector_.^2)))
    l, m, n = unit_vector
    c, s = cos(t), sin(t)
    rot = [l*l*(1-c)+c     m*l*(1-c)-n*s   n*l*(1-c)+m*s;
           l*m*(1-c)+n*s   m*m*(1-c)+c     n*m*(1-c)-l*s;
           l*n*(1-c)-m*s   m*n*(1-c)+l*s   n*n*(1-c)+c;]
    x = rot * x
    x = x .+ vec(point)
    return x
end



"""
    rotate(obj::T; angle=0.0, point=[0.0, 0.0, 0.0], vector_=[1.0, 0.0, 0.0]) where T <: Union{Shape, PostOpObj}

Rotate shape object by given angle about given vector and point.
"""
function rotate(obj::T; angle=0.0, point=[0.0, 0.0, 0.0], vector_=[1.0, 0.0, 0.0]) where T <: Union{Shape, PostOpObj}
    # x, v, y, vol, type
    function func(out)
        x = out[:x]
        x = rotate(x; angle=angle, point=point, vector_=vector_)
        return repack!(out, [:x], [x])
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