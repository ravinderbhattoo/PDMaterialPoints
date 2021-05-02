export delete

function delete(x::Array{Float64,2}, type, func::Function)
    mask = vec(func(x)) .== false
    return x[:, mask], type[mask]
end

function delete(obj::T, f::Function) where T <: Union{Shape, PostOpObj}
    function func(x::Array{Float64,2}, type)
        return delete(x, type, f)
    end
    if isa(obj, Shape)
        return PostOpObj(obj, [func])
    elseif isa(obj, PostOpObj)
        return push!(PostOpObj.operations, func)         
    else
        error("Not allowed.")
    end
end