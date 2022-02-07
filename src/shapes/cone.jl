# exports
export create, Cone, show

mutable struct Cone <: Shape
    radius::Float64
    length::Float64
end

function Base.show(io::IO, x::Cone)
    println(io, "Cone")
    println(io, "Radius: $(x.radius)")
    println(io, "Length: $(x.length)")
end

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