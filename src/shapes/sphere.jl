# exports
export create, Sphere, show

mutable struct Sphere <: Shape
    radius::Float64
end

function Base.show(io::IO, x::Sphere)
    println(io, "Sphere")
    println(io, "Radius: $(x.radius)")
end

function create(c::Sphere; resolution=nothing, rand_=0.0)
    radius = c.radius
    bounds = [-radius radius; -radius radius; -radius radius]
    x, v, y, vol = create(Cuboid(bounds), resolution=resolution, rand_=rand_)
    mask = vec(sum(x.^2, dims=1) .<= radius^2)
    mesh = x[:, mask]
    # x, v, y, vol
    return mesh, zeros(size(mesh)), copy(mesh), ones(size(mesh)[2])
end