# exports
export create, Cuboid, show

"""
    Cuboid

Shape object of  type cuboid.

## Args
    - bounds : min, max of cuboid for e.g. [-10 10; 0 3; -2 2]

## Returns
    - obj : Shape object **Cuboid**.
"""
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

    if DEVICE[]==:cuda
        mesh =  CUDA.CuArray(mesh)
        culattice = CuArray(lattice)
        CuNb1 = CuArray([prod(N[1:j]) for j in 1:length(N)])
        CuNb2 = CuArray([prod(N[1:j-1]) for j in 1:length(N)])

        function fillarray(mesh, lattice, N1, N2, low);
            index = (blockIdx().x - 1) * blockDim().x + threadIdx().x
            stride = blockDim().x * gridDim().x
            for k in index:stride:size(mesh, 2)
                for j in 1:length(N1)
                    b1 = N1[j]
                    b2 = N2[j]
                    indexj = fld( (rem(k-1, b1) + 1) - 1, b2) + 1
                    mesh[j, k] = low[j] - lattice[j] / 2 + indexj * lattice[j]
                end
            end

            return nothing
        end

        kernel = CUDA.@cuda launch=false fillarray(mesh, culattice, CuNb1, CuNb2, CuArray(c.bounds[:, 1]))
        config = launch_configuration(kernel.fun)
        nthreads = Base.min(size(mesh, 2), config.threads)
        nblocks =  cld(size(mesh, 2), nthreads)

        CUDA.@sync kernel(mesh, culattice, CuNb1, CuNb2, CuArray(c.bounds[:, 1]); threads=nthreads, blocks=nblocks)
        mesh = Array(mesh)

    else
        a = 1
        R = CartesianIndices(Tuple(N))
        for I in R
            I_ = Tuple(I)
            Threads.@threads for i in eachindex(I_)
                mesh[i, a] = c.bounds[i, 1] - lattice[i]/2 + I_[i]*lattice[i]
            end
            a += 1
        end
    end

    mesh = mesh .+ (resolution*rand_  * (randn(size(mesh)...) .- 1.0))
    volume = ones(eltype(mesh), prod(N))
    fill!(volume, prod(lattice))
    type = type*ones(Int64, prod(N))

    return Dict(
        :x => mesh,
        :v => similar(mesh),
        :y => copy(mesh),
        :volume => volume,
        :type => type
        )
end


#