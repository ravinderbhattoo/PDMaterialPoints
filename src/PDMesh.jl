module PDMesh
using CUDA
# Write your package code here.

const DEVICE = Ref{Symbol}(:cpu)

function set_device(device)
    device = get_valid_device(device)
    DEVICE[] = device
    println("PDMesh: DEVICE set to $(DEVICE[])")
end

function get_valid_device(x)
    out = x
    if x==:cuda
        if !CUDA.functional()
            out = :cpu
            println("PDMesh: CUDA is not available.")
        end
    else
        out = :cpu
    end
    return out
end

function reset_cuda()
    set_device(:cuda)
end




include("./shapes/shape.jl")
include("./operations/ops.jl")
include("./io.jl")

end
