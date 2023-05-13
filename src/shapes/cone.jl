# exports
export create, Cone, StandardCone

"""
    Cone(radius::AbstractFloat, length::AbstractFloat)

Cone shape.

# Fields
- `radius::AbstractFloat`: Radius of the cone.
- `length::AbstractFloat`: Length of the cone.

# Example
```julia
using PDMaterialPoints

# Create a cone
cone = Cone(1.0, 1.0)

# Create a material-point-geometry.
mpg =create(cone; resolution=0.1, rand_=0.01, type=1)
```

# See also
- [`StandardCone()`](@ref)
- [`Cone()`](@ref)
- [`create`](@ref)

# References
- [Wikipedia](https://en.wikipedia.org/wiki/Cone)

"""
mutable struct Cone <: Shape
    radius::AbstractFloat
    length::AbstractFloat
end

function Base.show(io::IO, x::Cone)
    println(io, "Cone")
    println(io, "Radius: $(x.radius)")
    println(io, "Length: $(x.length)")
end

"""
    Cone()

Cone shape. Radius and length are 1.0.

# see also
- [`Cone`](@ref)
"""
function Cone()
    Cone(1.0, 1.0)
end

"""
    StandardCone()

Standard cone shape. A special case of Cone. Radius and length are 1.0.

# Example
```julia
using PDMaterialPoints

# Create a standard cone
cone = StandardCone()

# Create a material-point-geometry.
mpg =create(cone)
```

# See also
- [`Cone`](@ref)

"""
function StandardCone()
    create(Cone(); resolution=0.1, rand_=0.01, type=1)
end



"""
    create(c::Cone; resolution=nothing, rand_=0.0, type::Int=1)

Create a material-point-geometry of a cone.

# Arguments
- `c::Cone`: Cone shape.
- `resolution=nothing`: Resolution of the material-point-geometry.
- `rand_=0.0`: Randomization factor.
- `type::Int=1`: Type of the material-point-geometry.

# Returns
- `Dict`: Material point gemetry.

# Example
```julia
using PDMaterialPoints

# Create a cone
cone = Cone(1.0, 1.0)

# Create a material-point-geometry.
mpg =create(cone)
```

# See also
- [`Cone`](@ref)

"""
function create(c::Cone; resolution=nothing, rand_=0.0, type::Int=1)
    radius = c.radius
    length_ = c.length
    x, v, y, vol, type_ = unpack(create(Disk(radius, length_), resolution=resolution, rand_=rand_))
    X = @view x[1:2, :]
    z = @view x[3:3, :]

    mask = vec(sum(X.^2, dims=1) .<= ((length_ .- z)./length_.*radius).^2)
    mpg =x[:, mask]
    return Dict(:x => mpg, :v => 0*mpg, :y => copy(mpg), :volume => vol[mask], :type => type*ones(Int, sum(mask)))
end