export delete

function delete(out, mask::BitArray)
    return repack(out[:x][:, mask], out[:v][:, mask], out[:y][:, mask], out[:volume][mask], out[:type][mask])
end

"""
    delete(obj::T, f::Function) where T

Delete mesh particle for object using boolean array from function f.
"""
function delete(obj::T, f::Function) where T  
    # x, v, y, vol, type
    function func(out)
        mask = vec(f(out)) .== false
        out = delete(out, mask) 
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