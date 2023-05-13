# exports
export create, Cube, Cuboid, StandardCuboid

"""
    Cuboid(bounds::Array{Float64, 2})

Cuboid shape.

# Fields
- `bounds::Array{Float64, 2}`: Bounds of the cuboid.

# Example
```julia
using PDMaterialPoints

# Create a cuboid
cuboid = Cuboid([0.0 1.0; 0.0 1.0; 0.0 1.0])

# Create a material-point-geometry.
mpg =create(cuboid)
```

# See also
- [`create`](@ref)

# References
- [Wikipedia](https://en.wikipedia.org/wiki/Cuboid)

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

"""
    Cube(L)

Cube shape. A special case of Cuboid.

# Arguments
- `L::AbstractFloat`: Length of the cube.

# Example
```julia
using PDMaterialPoints

# Create a cube
cube = Cube(1.0)

# Create a material-point-geometry.
mpg =create(cube)
```

# See also
- [`create`](@ref)
- [`Cuboid`](@ref)

"""
function Cube(L)
    Cuboid([-L/2 L/2; -L/2 L/2; -L/2 L/2])
end

"""
    Cube()

Cube shape. A special case of Cuboid. Length is 1.0.

# see also
- [`create`](@ref)
- [`StandardCuboid`](@ref)

"""
function Cube()
    Cube(1.0)
end

"""
    Cuboid()

Cuboid shape. Bounds are [-0.5 0.5; -0.5 0.5; -0.5 0.5]. Length is 1.0.

# see also
- [`create`](@ref)
- [`StandardCuboid`](@ref)

"""
function Cuboid()
    Cube()
end


"""
    StandardCuboid()

Standard cuboid shape. A special case of Cuboid. Bounds are [-0.5 0.5; -0.5 0.5; -0.5 0.5]. Length is 1.0.

# Example
```julia
using PDMaterialPoints

# Create a standard cuboid
cuboid = StandardCuboid()

# Create a material-point-geometry.
mpg =create(cuboid)
```

# See also
- [`create`](@ref)
- [`Cuboid`](@ref)

"""
function StandardCuboid()
    create(Cuboid(); resolution=0.1, rand_=0.01, type=1)
end


"""
    create(c::Cuboid; resolution=nothing, rand_=0.0, type::Int=1)

Create a material-point-geometry of a cuboid.

# Arguments
- `c::Cuboid`: Cuboid shape.
- `resolution=nothing`: Resolution of the material-point-geometry.
- `rand_=0.0`: Randomization factor.
- `type::Int=1`: Type of the material-point-geometry.

# Returns
- `Dict`: Material point gemetry.

# Example
```julia
using PDMaterialPoints

# Create a cuboid
cuboid = Cuboid([0.0 1.0; 0.0 1.0; 0.0 1.0])

# Create a material-point-geometry.
mpg =create(cuboid)
```

# See also
- [`Cuboid`](@ref)

"""
function create(c::Cuboid; resolution=nothing, rand_=0.0, type::Int=1)
    if isa(resolution, Nothing)
        N = [10 for i in 1:size(c.bounds)[1]]
    else
        N = Int64.(round.((c.bounds[:, 2] - c.bounds[:, 1])/resolution))
    end
    lattice = (c.bounds[:, 2] - c.bounds[:, 1]) ./ N
    mpg =zeros(3, prod(N))

    if DEVICE[]==:cuda
        mpg = CUDA.CuArray(mpg)
        culattice = CuArray(lattice)
        CuNb1 = CuArray([prod(N[1:j]) for j in 1:length(N)])
        CuNb2 = CuArray([prod(N[1:j-1]) for j in 1:length(N)])

        function fillarray(mpg, lattice, N1, N2, low);
            index = (blockIdx().x - 1) * blockDim().x + threadIdx().x
            stride = blockDim().x * gridDim().x
            for k in index:stride:size(mpg, 2)
                for j in 1:length(N1)
                    b1 = N1[j]
                    b2 = N2[j]
                    indexj = fld( (rem(k-1, b1) + 1) - 1, b2) + 1
                    mpg[j, k] = low[j] - lattice[j] / 2 + indexj * lattice[j]
                end
            end

            return nothing
        end

        kernel = CUDA.@cuda launch=false fillarray(mpg, culattice, CuNb1, CuNb2, CuArray(c.bounds[:, 1]))
        config = launch_configuration(kernel.fun)
        nthreads = Base.min(size(mpg, 2), config.threads)
        nblocks =  cld(size(mpg, 2), nthreads)

        CUDA.@sync kernel(mpg, culattice, CuNb1, CuNb2, CuArray(c.bounds[:, 1]); threads=nthreads, blocks=nblocks)
        mpg =Array(mpg)

    else
        a = 1
        R = CartesianIndices(Tuple(N))
        for I in R
            I_ = Tuple(I)
            Threads.@threads for i in eachindex(I_)
                mpg[i, a] = c.bounds[i, 1] - lattice[i]/2 + I_[i]*lattice[i]
            end
            a += 1
        end
    end

    mpg =mpg.+ (resolution*rand_  * (randn(size(mpg)...) .- 1.0))
    volume = ones(eltype(mpg), prod(N))
    fill!(volume, prod(lattice))
    type = type*ones(Int, prod(N))

    return Dict(
        :x => mpg,
        :v => 0*mpg,
        :y => copy(mpg),
        :volume => volume,
        :type => type
        )
end


#