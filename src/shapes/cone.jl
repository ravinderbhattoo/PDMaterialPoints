# exports
export create, Cone, show

"""
    Cone

Cone shape.

# Fields
- `radius::Float64`: Radius of the cone.
- `length::Float64`: Length of the cone.

# Example
```julia
using PDMesh

# Create a cone
cone = Cone(1.0, 1.0)

# Create a mesh
mesh = create(cone)
```

# See also
- [`create`](@ref)

# References
- [Wikipedia](https://en.wikipedia.org/wiki/Cone)

"""
mutable struct Cone <: Shape
    radius::Float64
    length::Float64
end

function Base.show(io::IO, x::Cone)
    println(io, "Cone")
    println(io, "Radius: $(x.radius)")
    println(io, "Length: $(x.length)")
end

"""
    create(c::Cone; resolution=nothing, rand_=0.0, type::Int64=1)

Create a mesh of a cone.

# Arguments
- `c::Cone`: Cone shape.
- `resolution=nothing`: Resolution of the mesh.
- `rand_=0.0`: Randomization factor.
- `type::Int64=1`: Type of the mesh.

# Returns
- `Dict`: Mesh.

# Example
```julia
using PDMesh

# Create a cone
cone = Cone(1.0, 1.0)

# Create a mesh
mesh = create(cone)
```

# See also
- [`Cone`](@ref)

"""
function create(c::Cone; resolution=nothing, rand_=0.0, type::Int64=1)
    radius = c.radius
    length_ = c.length
    x, v, y, vol, type_ = unpack(create(Disk(radius, length_), resolution=resolution, rand_=rand_))
    X = @view x[1:2, :]
    z = @view x[3:3, :]

    mask = vec(sum(X.^2, dims=1) .<= ((length_ .- z)./length_.*radius).^2)
    mesh = x[:, mask]
    return Dict(:x => mesh, :v => zeros(size(mesh)), :y => copy(mesh), :volume => vol[mask], :type => type*ones(Int64, sum(mask)))
end