export velocity

function velocity(v::Array{Float64,2}, mask, velocity::Array{Float64,1})
    v[:, mask] .*= 0.0
    v[:, mask] .+= vec(velocity)
    return v
end

function velocity(v::Array{Float64,2}, mask, velocity::Array{Float64,2})
    v[:, mask] .= velocity
    return v
end

function velocity(obj::T, f::Function, vel) where T <: Union{Shape, PostOpObj}
    # x, v, y, vol, type
    function func(out)
        v = out[2]
        mask = vec(f(out))
        return out[1], velocity(v, mask, vel), out[3:end]...
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