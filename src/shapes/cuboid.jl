# exports
export create, Cuboid, show

mutable struct Cuboid <: Shape
    bounds::Array{Float64, 2}
end

function Base.show(io::IO, x::Cuboid)
    println(io, "Cuboid")
    for i in 1:size(x.bounds)[1]
        println(io, "Dimension $i: Low $(x.bounds[i, 1]) High $(x.bounds[i, 2])")
    end
end

function create(c::Cuboid; resolution=nothing, rand_=0.0, type::Int64=1)
    if isa(resolution, Nothing)
        N = [10 for i in 1:size(c.bounds)[1]]
    else
        N = Int64.(round.((c.bounds[:, 2] - c.bounds[:, 1])/resolution))
    end
    lattice = (c.bounds[:, 2] - c.bounds[:, 1]) ./ N
    mesh = zeros(3, prod(N))
    a = 1
    R = CartesianIndices(Tuple(N))
    for I in R
        I_ = Tuple(I)
        for i in eachindex(I_)
            mesh[i, a] = c.bounds[i, 1] - lattice[i]/2 + (I_[i] + rand_*randn())*lattice[i]
        end
        a += 1
    end
    # x, v, y, vol
    return mesh, zeros(size(mesh)), copy(mesh), ones(prod(N))*prod(lattice), type*ones(Int64, prod(N)) 
end