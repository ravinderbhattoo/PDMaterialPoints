# exports
export create, Cube, Cuboid, StandardCuboid

"""
    Cuboid(bounds::Array{QF, 2})

Cuboid shape.

# Fields
- `bounds::Array{QF, 2}`: Bounds of the cuboid.

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
    bounds::Array{QF, 2}
end

function Base.show(io::IO, x::Cuboid)
    println(io, "Cuboid")
    for i in 1:size(x.bounds)[1]
        println(io, "Dimension $i: Low $(x.bounds[i, 1]) High $(x.bounds[i, 2])")
    end
    println(io,"""\n
     +-----------------------+ $(x.bounds[2, 2])
    /|                      /|
   / |                     / |
  /  |                    /  |
 +-----------------------+   |
 |   +-------------------|---+ $(x.bounds[2, 1])
 |  /                    |  / $(x.bounds[3, 2])
 | /                     | /
 |/                      |/
 +-----------------------+ $(x.bounds[3, 1])
$(x.bounds[1, 1])\t\t\t$(x.bounds[1, 2])
""")
end

"""
    Cube(L)

Cube shape. A special case of Cuboid.

# Arguments
- `L::QF`: Length of the cube.

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
        N = Int64.(round.((c.bounds[:, 2] - c.bounds[:, 1]) / resolution))
    end
    lattice = (c.bounds[:, 2] - c.bounds[:, 1]) ./ N
    mpg = zeros(typeof(resolution), 3, prod(N))

    if DEVICE[]==:cuda
        mpg = CuArray(mpg)
        culattice = CuArray(lattice)
        CuNb1 = CuArray([prod(N[1:j]) for j in 1:length(N)])
        CuNb2 = CuArray([prod(N[1:j-1]) for j in 1:length(N)])
        low = CuArray(1*c.bounds[:, 1])

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

        kernel = CUDA.@cuda launch=false fillarray(mpg, culattice, CuNb1, CuNb2, low)
        config = launch_configuration(kernel.fun)
        nthreads = Base.min(size(mpg, 2), config.threads)
        nblocks =  cld(size(mpg, 2), nthreads)

        CUDA.@sync kernel(mpg, culattice, CuNb1, CuNb2, low; threads=nthreads, blocks=nblocks)
        mpg = Array(mpg)

    else
        R = CartesianIndices(Tuple(N))
        Threads.@threads for j in 1:length(R)
            I = R[j]
            I_ = Tuple(I)
            for i in eachindex(I_)
                mpg[i, j] = c.bounds[i, 1] - lattice[i]/2 + I_[i]*lattice[i]
            end
        end
    end

    mpg = mpg.+ (resolution*rand_  * (randn(size(mpg)...) .- 1.0))
    volume = ones(typeof(resolution^3), prod(N))
    fill!(volume, prod(lattice))
    type = type*ones(Int, prod(N))
    v = 0 * ( dimension(eltype(mpg))==dimension(1u"m") ? (mpg / 1u"s") : mpg)

    return Dict(
        :x => mpg,
        :v => v,
        :y => copy(mpg),
        :volume => volume,
        :type => type
        )
end


#