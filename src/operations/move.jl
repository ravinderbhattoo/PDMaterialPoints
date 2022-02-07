export move

function move(x::Array{Float64,2}; by=[0.0, 0.0, 0.0])
    x .+= vec(by)
    return x
end

function move(obj::T; by=[0.0, 0.0, 0.0]) where T <: Union{Shape, PostOpObj}
    # x, v, y, vol, type
    function func(out)
        x = out[:x]
        x = move(x, by=by)
        return repack!(out, [:x], [x])
    end
    if isa(obj, Shape)
        return PostOpObj(obj, func)
    elseif isa(obj, PostOpObj)
        push!(obj.operations, func)       
        return obj 
    else
        error("Not allowed.")
    end
end