import Pkg
Pkg.activate("./")

using PDMesh

obj = Cuboid([-10 10; 0 3; -2 2])

f = out -> begin 
x=out[1]; 
mask = (x[1, :] .< 0.1) .& (x[1, :] .> -0.1) .& (x[2, :] .> 2)
mask
end

obj = delete(obj,  f)

x, v, y, vol, type = create(obj, resolution=0.1, rand_=0.0, type=1)


write_data("./examples/ovito_ref.data", x, type, vol)

write_data("./examples/ovito.data", y, v, type, vol)