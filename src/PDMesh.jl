module PDMesh
using CUDA
# Write your package code here.

const DEVICE = Ref{Symbol}(:cpu)

"""
    set_device(device::Symbol)

Set the device to use for computations. The device can be either `:cpu` or `:cuda`.

# Arguments
- `device::Symbol`: Device to use for computations.

# Example
```julia
using PDMesh

# Set the device to use for computations
set_device(:cuda)
```
"""
function set_device(device::Symbol)
    device = get_valid_device(device)
    DEVICE[] = device
    println("PeriDyn: DEVICE set to $(DEVICE[])")
end

"""
    get_valid_device(x::Symbol)

Get a valid device. If `x` is `:cuda` and CUDA is not available, then `:cpu` is returned.

# Arguments
- `x::Symbol`: Device to check.

"""
function get_valid_device(x::Symbol)
    out = x
    if x==:cuda
        if !CUDA.functional()
            out = :cpu
            println("PeriDyn: CUDA is not available.")
        end
    else
        out = :cpu
    end
    return out
end

"""
    reset_cuda()

Reset the device to `:cuda`. If CUDA is not available, then the device is set to `:cpu`.
"""
function reset_cuda()
    set_device(:cuda)
end

include("./shapes/shape.jl")
include("./operations/ops.jl")
include("./io.jl")

end
