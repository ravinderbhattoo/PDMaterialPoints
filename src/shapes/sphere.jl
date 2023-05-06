# exports
export create, Sphere, Shell, StandardSphere

"""
    Sphere

Sphere shape.

# Fields
- `radius::Float64`: Radius of the sphere.

# Example
```julia
using PDMesh

# Create a sphere
sphere = Sphere(1.0)

# Create a mesh
mesh = create(sphere, resolution=0.1)
```
"""
mutable struct Sphere <: Shape
    radius::Float64
end

Sphere() = Sphere(1.0)

"""
    StandardSphere()

Standard sphere shape. A special case of Sphere. Radius is 1.0.

# Example
```julia
using PDMesh

# Create a standard sphere
sphere = StandardSphere()

# Create a mesh
mesh = create(sphere, resolution=0.1)
```

# See also
- [`create`](@ref)
"""
function StandardSphere()
    create(Sphere(); resolution=0.1, rand_=0.01, type=1)
end


"""
    Shell

Shell shape.

# Fields
- `outer_radius::Float64`: Outer radius of the shell.
- `inner_radius::Float64`: Inner radius of the shell.

# Example
```julia
using PDMesh

# Create a shell
shell = Shell(1.0, 0.5)

# Create a mesh
mesh = create(shell, resolution=0.1)
```
"""
mutable struct Shell <: Shape
    radius::Float64
    inner_radius::Float64
end

function Base.show(io::IO, x::Sphere)
    println(io, "Sphere")
    println(io, "Radius: $(x.radius)")
end

"""
    create(s::Union{Sphere,Shell}; resolution=nothing, rand_=0.0, type::Int64=1)

Create a mesh from a sphere or shell.

# Arguments
- `s::Union{Sphere,Shell}`: Sphere or shell object.
- `resolution=nothing`: Resolution of the mesh.
- `rand_=0.0`: Randomization factor.
- `type::Int64=1`: Type of the mesh.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the mesh data.
"""
function create(c::Union{Sphere,Shell}; resolution=nothing, rand_=0.0, type::Int64=1)
    radius = c.radius
    bounds = [-radius radius; -radius radius; -radius radius]
    x, v, y, vol, type_ = unpack(create(Cuboid(bounds), resolution=resolution, rand_=rand_, type=type))
    mask = vec(sum(x.^2, dims=1) .<= radius^2)

    if typeof(c) == Shell
        mask = mask .& vec(sum(x.^2, dims=1) .>= c.inner_radius^2)
    end

    mesh = x[:, mask]
    vol = vol[mask]
    type_ = type_[mask]

    return Dict(
        :x => mesh,
        :v => 0*mesh,
        :y => copy(mesh),
        :volume => vol,
        :type => type_
    )
end