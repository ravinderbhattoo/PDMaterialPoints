export velocity

"""
    velocity(v::Array{QF,2}; velocity=[0.0, 0.0, 0.0])

Change velocity of particles for object by given "velocity".

# Arguments
- `v::Array{QF,2}`: Array of material-point-geometry velocities.
- `velocity=[0.0, 0.0, 0.0]`: Velocity vector.

# Returns
- `v::Array{QF,2}`: Array of material-point-geometry velocities.

"""
function velocity(v::Array{QF,2}, mask, velocity::Array{QF,1})
    v[:, mask] .*= 0.0
    v[:, mask] .+= vec(velocity)
    return v
end

"""
    velocity(v::Array{QF,2}; velocity=[0.0, 0.0, 0.0])

Change velocity of particles for object by given "velocity".

# Arguments
- `v::Array{QF,2}`: Array of material-point-geometry velocities.
- `velocity=[0.0, 0.0, 0.0]`: Velocity vector.

# Returns
- `v::Array{QF,2}`: Array of material-point-geometry velocities.

"""
function velocity(v::Array{QF,2}, mask, velocity::Array{QF,2})
    v[:, mask] .= velocity
    return v
end

"""
    velocity(obj::T, f::Function, vel) where T <: SuperShape

Change velocity of particles for object using boolean array from function f.

# Arguments
- `obj::T`: Object.
- `f::Function`: Function that returns boolean array.
- `vel`: Velocity vector.

# Returns
- `obj::T`: Object.

"""
function velocity(obj::T, f::Function, vel) where T <: SuperShape
    # x, v, y, vol, type
    function func(out)
        v = out[:v]
        mask = vec(f(out))
        v = velocity(v, mask, vel)
        return repack!(out, [:v], [v])
    end
    return apply!(obj, func)
end