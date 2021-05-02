export changetype

function changetype(x::Array{Float64,2}, type::Array{Int64,1}, func::Function, ntype::Int64)
    mask = vec(func(x))
    type[mask] .= ntype
    return x, type
end

function changetype(obj::T, f::Function, ntype::Int64) where T <: Union{Shape, PostOpObj}
    function func(x::Array{Float64,2}, type)
        return changetype(x, type, f, ntype)
    end
    if isa(obj, Shape)
        return PostOpObj(obj, [func])
    elseif isa(obj, PostOpObj)
        push!(obj.operations, func)
        return obj         
    else
        error("Not allowed.")
    end
end