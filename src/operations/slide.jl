export slide

function slide(x::Array{Float64,2}; by=[0.0, 0.0, 0.0])
    x .+= vec(by)
    return x
end

function slide(obj::T; by=[0.0, 0.0, 0.0]) where T <: Union{Shape, PostOpObj}
    function func(x::Array{Float64,2}, type)
        return slide(x, by=by), type
    end
    if isa(obj, Shape)
        return PostOpObj(obj, [func])
    elseif isa(obj, PostOpObj)
        return push!(PostOpObj.operations, func)         
    else
        error("Not allowed.")
    end
end