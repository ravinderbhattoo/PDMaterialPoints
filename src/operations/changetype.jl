export changetype

function changetype(type::Array{Int64,1}, mask, ntype::Int64)
    type[mask] .= ntype
    return type
end

"""
    changetype(obj::T, f::Function, ntype::Int64) where T

Change mesh particle type for object using boolean array from function f.
"""
function changetype(obj::T, f::Function, ntype::Int64) where T <: Union{Shape, PostOpObj}
    # x, v, y, vol, type
    function func(out)
        mask = vec(f(out))
        type = changetype(out[:type], mask, ntype)
        return repack!(out, [:type], [type])
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