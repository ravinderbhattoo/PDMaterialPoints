export write_data, write_data_peridigm

"""
    fhandle(filename::String)

Create a file handle for a given filename.

# Arguments
- `filename::String`: Name of the file to create.

"""
function fhandle(filename::String)
    mkpath(dirname(filename))
    return open(filename, "w+")
end

function write_data(filename::String, args...; kwargs...)
    objs = sum(args...)
    write_data(filename, objs; kwargs...)
end


"""
    write_data(filename::String, obj::SuperShape; kwargs...)

Write data to a file in the following format:

        N
        # id, type, position, velocity, volume
        1, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        2, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        3, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        4, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        5, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0

    where N is the number of particles, id is the particle id, type is the particle type,
    position is the particle position, velocity is the particle velocity, and
    volume is the particle volume.

# Arguments
- `filename::String`: Name of the file to write to.
- `obj::SuperShape`: Shape or post operation object to write to file.

# Keyword Arguments
- `kwargs...`: Keyword arguments to pass to [`create`](@ref).

# Example
```julia
using PDMesh

# Create a cube
cube = Cube(1.0, 1.0, 1.0)

# Write the data to a file
write_data("data.txt", cube)
```

# See also
- [`write_data_peridigm`](@ref)
- [`write_data`](@ref)
"""
function write_data(filename::String, obj::SuperShape; kwargs...)
    out = create(obj; kwargs...)
    write_data(filename, out)
end


"""
    write_data(filename::String, out::Dict)

Write data to a file in the following format:

        N
        # id, type, position, velocity, volume
        1, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        2, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        3, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        4, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
        5, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0

    where N is the number of particles, id is the particle id, type is the particle type,
    position is the particle position, velocity is the particle velocity, and
    volume is the particle volume.

# Arguments
- `filename::String`: Name of the file to write to.
- `out::Dict`: Dictionary containing the following keys:
    - `:x`: Position of the particles.
    - `:v`: Velocity of the particles.
    - `:type`: Type of the particles.
    - `:volume`: Volume of the particles.

# Example
```julia
using PDMesh

# Create a cube
cube = Cube(1.0, 1.0, 1.0)

# Create a dictionary of the union
out = create(cube)

# Write the data to a file
write_data("data.txt", out)
```

# See also
- [`write_data_peridigm`](@ref)
- [`write_data`](@ref)
"""
function write_data(filename::String, out::Dict)
    write_data(filename, out[:x], out[:v], out[:type], out[:volume])
end


"""
    write_data_peridigm(filename::String, x::Matrix, type::Vector,  vol::Vector)

Write data to a file in the following format:

        N
        # position, type, volume
        0.0, 0.0, 0.0, 1, 1.0
        0.0, 0.0, 0.0, 1, 1.0
        0.0, 0.0, 0.0, 1, 1.0
        0.0, 0.0, 0.0, 1, 1.0
        0.0, 0.0, 0.0, 1, 1.0

where N is the number of particles, type is the particle type,
position is the particle position, and volume is the particle volume.

# Arguments
- `filename::String`: Name of the file to write to.
- `x::Matrix`: Position of the particles.
- `type::Vector`: Type of the particles.
- `vol::Vector`: Volume of the particles.

# see also
- [`write_data`](@ref)

"""
function write_data_peridigm(filename::String, x::Matrix, type::Vector,  vol::Vector)
    file = fhandle(filename)
    N = size(x, 2)
    write(file, "$N \n# position, type, volume\n")
    for j in 1:size(x, 2)
        t = type[j]
        v = vol[j]
        a,b,c = x[1,j],x[2,j],x[3,j]
        write(file, "$a, $b, $c, $t, $v ")
        write(file,"\n")
    end
    close(file)
end


"""
    write_data(filename::String, x::Matrix, v::Matrix, type::Vector,  vol::Vector)

Write data to a file in the following format:

    N
    # id, type, position, velocity, volume
    1, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
    2, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
    3, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
    4, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
    5, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0

where N is the number of particles, id is the particle id, type is the particle type,
position is the particle position, velocity is the particle velocity, and
volume is the particle volume.

# Arguments
- `filename::String`: Name of the file to write to.
- `x::Matrix`: Position of the particles.
- `v::Matrix`: Velocity of the particles.
- `type::Vector`: Type of the particles.
- `vol::Vector`: Volume of the particles.

# see also
- [`write_data`](@ref)

"""
function write_data(filename::String, x::Matrix, v::Matrix, type::Vector,  vol::Vector)
    file = fhandle(filename)
    N = size(x, 2)
    write(file, "$N \n# id, type, position, velocity, volume\n")
    for j in 1:size(x, 2)
        t = type[j]
        vol_ = vol[j]
        a,b,c = x[:, j]
        d,e,f = v[:, j]
        write(file, "$j, $t, $a, $b, $c, $d, $e, $f, $vol_")
        write(file,"\n")
    end
    close(file)
end