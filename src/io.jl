export write_data

function write_data(filename::String, args...; kwargs...)
    objs = sum(args...)
    write_data(filename, objs; kwargs...)
end

function write_data(filename::String, obj::Union{Shape,PostOpObj}; kwargs...)
    out = create(obj; kwargs...)
    write_data(filename, out)
end

function write_data(filename::String, out::Dict)
    write_data(filename, out[:x], out[:v], out[:type], out[:volume])
end

function write_data_peridigm(filename::String, x::Matrix, type::Vector,  vol::Vector)
    file = open(filename, "w+")
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

function write_data(filename::String, x::Matrix, v::Matrix, type::Vector,  vol::Vector)
    file = open(filename, "w+")
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