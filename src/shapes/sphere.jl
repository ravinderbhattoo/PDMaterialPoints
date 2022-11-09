# exports
export create, Sphere, show, Shell

"""
    Sphere

Shape object of  type sphere.

## Args
    - radius : radius of sphere

## Returns
    - obj : Shape object **sphere**.
"""
mutable struct Sphere <: Shape
    radius::Float64
end

mutable struct Shell <: Shape
    outer_radius::Float64
    inner_radius::Float64
end

function Base.show(io::IO, x::Sphere)
    println(io, "Sphere")
    println(io, "Radius: $(x.radius)")
end

function create(c::Sphere; resolution=nothing, rand_=0.0, type::Int64=1)
    radius = c.radius
    bounds = [-radius radius; -radius radius; -radius radius]
    x, v, y, vol, type_ = unpack(create(Cuboid(bounds), resolution=resolution, rand_=rand_, type=type))
    mask = vec(sum(x.^2, dims=1) .<= radius^2)

    mesh = x[:, mask]
    vol = vol[mask]
    type_ = type_[mask]

    return Dict(
        :x => mesh,
        :v => zeros(size(mesh)),
        :y => copy(mesh),
        :volume => vol,
        :type => type_
    )
end