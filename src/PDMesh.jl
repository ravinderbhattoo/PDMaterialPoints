module PDMesh
using CUDA
# Write your package code here.

const IF_CUDA = Ref{Bool}(false)

function set_cuda(x)
    function fn()
        IF_CUDA[] = x
        println("PDMesh: CUDA set to $x")
    end
    if x
        if CUDA.functional()
            fn()
        else
            println("PDMesh: CUDA is not available.")
        end
    else
        fn()
    end
end

function reset_cuda()
    set_cuda(CUDA.functional())
end

set_cuda(false)


include("./shapes/shape.jl")
include("./operations/ops.jl")
include("./io.jl")

end
