function Base.delete!(out, mask::BitArray)
    return out[1][:, mask], out[2][:, mask], out[3][:, mask], out[4][mask], out[5][mask]
end

"""
    Base.delete!(obj::T, f::Function) where T

Delete mesh particle for object using boolean array from function f.
"""
function Base.delete!(obj::T, f::Function) where T  
    # x, v, y, vol, type
    function func(out)
        mask = vec(f(out)) .== false
        out = Base.delete!(out, mask) 
        return out
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