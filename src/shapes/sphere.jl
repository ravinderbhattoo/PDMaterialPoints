# exports
export create, Sphere, Shell, StandardSphere

"""
    Sphere

Sphere shape.

# Fields
- `radius::QF`: Radius of the sphere.

# Example
```julia
using PDMaterialPoints

# Create a sphere
sphere = Sphere(1.0)

# Create a material-point-geometry.
mpg =create(sphere, resolution=0.1)
```
"""
mutable struct Sphere <: Shape
    radius::QF
end

Sphere() = Sphere(1.0)

"""
    StandardSphere()

Standard sphere shape. A special case of Sphere. Radius is 1.0.

# Example
```julia
using PDMaterialPoints

# Create a standard sphere
sphere = StandardSphere()

# Create a material-point-geometry.
mpg =create(sphere, resolution=0.1)
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
- `outer_radius::QF`: Outer radius of the shell.
- `inner_radius::QF`: Inner radius of the shell.

# Example
```julia
using PDMaterialPoints

# Create a shell
shell = Shell(1.0, 0.5)

# Create a material-point-geometry.
mpg =create(shell, resolution=0.1)
```
"""
mutable struct Shell <: Shape
    radius::QF
    inner_radius::QF
end

function Base.show(io::IO, x::Sphere)
    println(io, "Sphere")
    println(io, "Radius: $(x.radius)")
end

"""
    create(s::Sphere; resolution=nothing, rand_=0.0, type::Int=1)

Create a material-point-geometry from a sphere or shell.

# Arguments
- `s::Sphere`: Sphere object.
- `resolution=nothing`: Resolution of the material-point-geometry.
- `rand_=0.0`: Randomization factor.
- `type::Int=1`: Type of the material-point-geometry.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the material-point-geometry data.
"""
function create(c::Sphere; resolution=nothing, rand_=0.0, type::Int=1)
    radius = c.radius
    bounds = [-radius radius; -radius radius; -radius radius]
    x, v, y, vol, type_ = unpack(create(Cuboid(bounds), resolution=resolution, rand_=rand_, type=type))
    mask = vec(sum(x.^2, dims=1) .<= radius^2)
    mpg =x[:, mask]
    vol = vol[mask]
    type_ = type_[mask]

    return Dict(
        :x => mpg,
        :v => 0 * ( dimension(eltype(mpg))==dimension(1u"m") ? (mpg / 1u"s") : mpg),
        :y => copy(mpg),
        :volume => vol,
        :type => type_
    )
end

function create(c::Shell; resolution=nothing, rand_=0.0, type::Int=1)
    radius = c.radius
    inner_radius = c.inner_radius
    bounds = [-radius radius; -radius radius; -radius radius]
    x, v, y, vol, type_ = unpack(create(Cuboid(bounds), resolution=resolution, rand_=rand_, type=type))
    mask = vec(sum(x.^2, dims=1) .<= radius^2)

    if typeof(c) == Shell
        mask = mask .& vec(sum(x.^2, dims=1) .>= c.inner_radius^2)
    end

    mpg =x[:, mask]
    vol = vol[mask]
    type_ = type_[mask]

    mask = vec(sum(x.^2, dims=1) .>= inner_radius^2)
    mpg =mpg[:, mask]
    vol = vol[mask]
    type_ = type_[mask]

    return Dict(
        :x => mpg,
        :v => 0 * ( dimension(eltype(mpg))==dimension(1u"m") ? (mpg / 1u"s") : mpg),
        :y => copy(mpg),
        :volume => vol,
        :type => type_
    )
end