# exports
export create, Cylinder, StandardCylinder

"""
    Cylinder

Cylinder shape.

# Fields
- `radius::Float64`: Radius of the cylinder.
- `thickness::Float64`: Thickness of the cylinder.
- `length::Float64`: Length of the cylinder.

# Example
```julia
using PDMesh

# Create a cylinder
cylinder = Cylinder(1.0, 0.1, 2.0)

# Create a mesh
mesh = create(cylinder, resolution=0.1)
```
"""
mutable struct Cylinder <: Shape
    radius::Float64
    thickness::Float64
    length::Float64
end

Cylinder() = Cylinder(1.0, 0.3, 1.0)

"""
    StandardCylinder()

Standard cylinder shape. A special case of Cylinder. Radius is 1.0. Thickness is 0.3. Length is 1.0.

# Example
```julia
using PDMesh

# Create a standard cylinder
cylinder = StandardCylinder()

# Create a mesh
mesh = create(cylinder)
```

# See also
- [`create`](@ref)
"""
function StandardCylinder()
    create(Cylinder(); resolution=0.1, rand_=0.01, type=1)
end


function Base.show(io::IO, x::Cylinder)
    println(io, "Cylinder")
    println(io, "Radius: $(x.radius)")
    println(io, "Thickness: $(x.thickness)")
    println(io, "Length: $(x.length)")
end


"""
    create(c::Cylinder; resolution=nothing, rand_=0.0, type::Int64=1)

Create a mesh from a cylinder.

# Arguments
- `c::Cylinder`: Cylinder object.
- `resolution=nothing`: Resolution of the mesh.
- `rand_=0.0`: Randomization factor.
- `type::Int64=1`: Type of the mesh.

# Returns
- `out::Dict{Symbol, Any}`: Dictionary containing the mesh data.

# Example
```julia
using PDMesh

# Create a cylinder
cylinder = Cylinder(1.0, 0.1, 2.0)

# Create a mesh
mesh = create(cylinder, resolution=0.1)
```
"""
function create(c::Cylinder; resolution=nothing, rand_=0.0, type::Int64=1)
    if isa(resolution, Nothing)
        resolution = min(c.radius/10, c.thickness/3)
    end
    radius=c.radius
    thickness=c.thickness
    length_=c.length
    e_size=resolution
    nm_radial_ele = round(thickness/e_size)
    er_size = thickness/nm_radial_ele
    nm_length_ = round(length_/e_size)
    el_size = (length_/nm_length_)
    total_vol = 0.0
    N = 0

    for i in 1:nm_length_
        for j in 1:nm_radial_ele
            r_in = radius + (j-1) * er_size
            r_out = radius + (j) * er_size
            N += Int64(round(( pi * (r_in+r_out) ) / e_size ))
        end
    end

    mesh = zeros(Float64, (3, N))
    vol = zeros(Float64, N)

    ind = 0
    for i in 1:nm_length_
        z = (i - 0.5)*el_size
        for j in 1:nm_radial_ele
            r_in = radius + (j-1) * er_size
            r_out = radius + (j) * er_size
            nm_cir_ele = Int64(round(( pi * (r_in+r_out) ) / e_size ))
            ec_size = ( pi * (r_in+r_out) ) / nm_cir_ele
            Threads.@threads for k in 1:nm_cir_ele
                index = ind + k
                theta = 2*pi / nm_cir_ele
                e_area = pi* (r_out^2 - r_in^2) / nm_cir_ele
                r_g = (2 * pi * (r_out^3 - r_in^3) * sin(theta)/ 3 / theta ) / e_area / nm_cir_ele

                x = r_g * cos((k-1)*theta) + rand_*randn()*e_size
                y = r_g * sin((k-1)*theta) + rand_*randn()*e_size

                vol[index] = e_area * el_size
                mesh[1, index] = x
                mesh[2, index] = y
                mesh[3, index] = z + rand_*randn()*el_size
                total_vol += e_area * el_size
            end
            ind += nm_cir_ele
        end
    end

    return Dict(
        :x => mesh,
        :v => 0*mesh,
        :y => copy(mesh),
        :volume => vol,
        :type => type*ones(Int64, length(vol))
        )
end