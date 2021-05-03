export slide

function slide(x::Array{Float64,2}; by=[0.0, 0.0, 0.0])
    x .+= vec(by)
    return x
end

function slide(obj::T; by=[0.0, 0.0, 0.0]) where T <: Union{Shape, PostOpObj}
    # x, v, y, vol, type
    function func(out)
        x = out[1]
        x = slide(x, by=by)
        return x, out[2], copy(x), out[4:end]...
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