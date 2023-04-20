# exports
export create, Disk, show

"""
    Disk

Disk shape.

# Fields
- `radius::Float64`: Radius of the disk.
- `thickness::Float64`: Thickness of the disk.

# Example
```julia
using PDMesh

# Create a disk
disk = Disk(1.0, 0.1)

# Create a mesh
mesh = create(disk, resolution=0.1)
```
"""
mutable struct Disk <: Shape
    radius::Float64
    thickness::Float64
end

function Base.show(io::IO, x::Disk)
    println(io, "Disk")
    println(io, "Radius: $(x.radius)")
    println(io, "Thickness: $(x.thickness)")
end


"""
    create(c::Disk; resolution=nothing, rand_=0.0, type::Int64=1)

Create a mesh from a disk.

# Arguments
- `c::Disk`: Disk object.
- `resolution=nothing`: Resolution of the mesh.
- `rand_=0.0`: Randomization factor.
- `type::Int64=1`: Type of the mesh.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the mesh data.

# Example
```julia
using PDMesh

# Create a disk
disk = Disk(1.0, 0.1)

# Create a mesh
mesh = create(disk, resolution=0.1)
```
"""
function create(c::Disk; resolution=nothing, rand_=0.0, type::Int64=1)
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
    mesh = Vector{Float64}[]
    vol = Float64[]
    total_vol = 0

    for i in 1:nm_thickness
        z = (i - 0.5)*et_size
        total_vol += et_size*pi*e_size^2
        push!(mesh, [0, 0.0, z + rand_*randn()*et_size])
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
                push!(mesh, [x, y, z + rand_*randn()*et_size])
                total_vol += e_area * et_size
            end
        end
    end

    mesh = hcat(mesh...)

    return Dict(
        :x => mesh,
        :v => zeros(size(mesh)),
        :y => copy(mesh),
        :volume => vol,
        :type => type*ones(Int64, length(vol)),
    )
end