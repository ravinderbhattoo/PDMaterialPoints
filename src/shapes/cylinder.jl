# exports
export create, Cylinder, show

mutable struct Cylinder <: Shape
    radius1::Float64
    thickness::Float64
    length::Float64
end

function Base.show(io::IO, x::Cylinder)
    println(io, "Cylinder")
    println(io, "Radius1: $(x.radius1)")
    println(io, "Thickness: $(x.thickness)")
    println(io, "Length: $(x.length)")
end

function create(c::Cylinder; resolution=nothing, rand_=0.0, type::Int64=1)
    if isa(resolution, Nothing)
        resolution = min(c.radius1/10, c.thickness/3)
    end
    radius=c.radius1
    thickness=c.thickness
    length_=c.length
    e_size=resolution
    nm_radial_ele = round(thickness/e_size)
    er_size = thickness/nm_radial_ele
    nm_length_ = round(length_/e_size)
    el_size = (length_/nm_length_)
    mesh = Vector{Float64}[]
    vol = Float64[]
    total_vol = 0.0
    for i in 1:nm_length_
        z = (i - 0.5)*el_size 
        for j in 1:nm_radial_ele
            r_in = radius + (j-1) * er_size
            r_out = radius + (j) * er_size

            nm_cir_ele = round(( pi * (r_in+r_out) ) / e_size )
            ec_size = ( pi * (r_in+r_out) ) / nm_cir_ele

            for k in 1:nm_cir_ele

                theta = 2*pi / nm_cir_ele
                e_area = pi* (r_out^2 - r_in^2) / nm_cir_ele
                r_g = (2 * pi * (r_out^3 - r_in^3) * sin(theta)/ 3 / theta ) / e_area / nm_cir_ele

                x = r_g * cos((k-1)*theta) + rand_*randn()*e_size
                y = r_g * sin((k-1)*theta) + rand_*randn()*e_size

                push!(vol, e_area * el_size)
                push!(mesh, [x, y, z + rand_*randn()*el_size])
                total_vol += e_area * el_size
            end
        end
    end
    mesh = hcat(mesh...)
    return Dict(
        :x => mesh, 
        :v => zeros(size(mesh)), 
        :y => copy(mesh), 
        :volume => vol, 
        :type => type*ones(Int64, length(vol))
        ) 
end