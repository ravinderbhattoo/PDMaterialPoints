# exports
export create, Disk, StandardDisk

"""
    Disk

Disk shape.

# Fields
- `radius::AbstractFloat`: Radius of the disk.
- `thickness::AbstractFloat`: Thickness of the disk.

# Example
```julia
using PDMaterialPoints

# Create a disk
disk = Disk(1.0, 0.1)

# Create a material-point-geometry.
mpg =create(disk, resolution=0.1)
```
"""
mutable struct Disk <: Shape
    radius::AbstractFloat
    thickness::AbstractFloat
end

Disk() = Disk(1.0, 0.3)

"""
    StandardDisk()

Standard disk shape. A special case of Disk. Radius is 1.0. Thickness is 0.3.

# Example
```julia
using PDMaterialPoints

# Create a standard disk
disk = StandardDisk()

# Create a material-point-geometry.
mpg =create(disk)
```

# See also
- [`create`](@ref)
"""
function StandardDisk()
    create(Disk(); resolution=0.1, rand_=0.01, type=1)
end


function Base.show(io::IO, x::Disk)
    println(io, "Disk")
    println(io, "Radius: $(x.radius)")
    println(io, "Thickness: $(x.thickness)")
end


"""
    create(c::Disk; resolution=nothing, rand_=0.0, type::Int=1)

Create a material-point-geometry from a disk.

# Arguments
- `c::Disk`: Disk object.
- `resolution=nothing`: Resolution of the material-point-geometry.
- `rand_=0.0`: Randomization factor.
- `type::Int=1`: Type of the material-point-geometry.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the material-point-geometry data.

# Example
```julia
using PDMaterialPoints

# Create a disk
disk = Disk(1.0, 0.1)

# Create a material-point-geometry.
mpg =create(disk, resolution=0.1)
```
"""
function create(c::Disk; resolution=nothing, rand_=0.0, type::Int=1)
    if isa(resolution, Nothing)
        resolution = min(c.radius/10, c.thickness/3)
    end
    radius=c.radius
    thickness=c.thickness
    e_size=resolution
    nm_radial_ele = round((radius-e_size/2)/e_size)
    er_size = (radius-e_size/2) / nm_radial_ele
    nm_thickness = round(thickness/e_size)
    et_size = (thickness/nm_thickness)
    mpg =Vector{Float64}[]
    vol = Float64[]
    total_vol = 0

    for i in 1:nm_thickness
        z = (i - 0.5)*et_size
        total_vol += et_size*pi*e_size^2
        push!(mpg, [0, 0.0, z + rand_*randn()*et_size])
        push!(vol, et_size*pi*e_size^2)
        for j in 1:nm_radial_ele
            r_in = e_size/2 + (j-1) * er_size
            r_out = e_size/2 + (j) * er_size

            nm_cir_ele = round(( pi * (r_in+r_out) ) / e_size )
            ec_size = ( pi * (r_in+r_out) ) / nm_cir_ele

            for k in 1:nm_cir_ele

                theta = 2*pi / nm_cir_ele
                e_area = pi* (r_out^2 - r_in^2) / nm_cir_ele
                r_g = (2 * pi * (r_out^3 - r_in^3) * sin(theta)/ 3 / theta ) / e_area / nm_cir_ele

                x = r_g * cos((k-1)*theta) + rand_*randn()*e_size
                y = r_g * sin((k-1)*theta) + rand_*randn()*e_size

                push!(vol, e_area * et_size)
                push!(mpg, [x, y, z + rand_*randn()*et_size])
                total_vol += e_area * et_size
            end
        end
    end

    mpg = hcat(mpg...)

    return Dict(
        :x => mpg,
        :v => 0*mpg,
        :y => copy(mpg),
        :volume => vol,
        :type => type*ones(Int, length(vol)),
    )
end