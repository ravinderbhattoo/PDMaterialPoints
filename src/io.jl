export write_data

function write_data(filename::String, x::Array{Float64,2}, type::Array{T,1},  vol::Array{Float64,1}) where T 
    file = open(filename, "w+")
    N = size(x, 2)
    write(file, "$N \n\n")
    for j in 1:size(x, 2)
        t = type[j]
        v = vol[j]
        a,b,c = x[1,j],x[2,j],x[3,j]
        write(file, "$a, $b, $c, $t, $v ")
        write(file,"\n")
    end
    close(file)
end