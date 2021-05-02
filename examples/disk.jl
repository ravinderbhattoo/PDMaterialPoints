import Pkg
Pkg.activate("./")

using PDMesh

obj = Cuboid([-10 10; -10 10; 0 3])
opobj = changetype(obj, x -> sum(x[1:2, :].^2, dims=1) .< 3.0^2, 2)
opobj = changetype(opobj, x -> sum(x[1:2, :].^2, dims=1) .< 2.0^2, 3)

x, v, y, vol, type = create(opobj, resolution=0.1, rand_=0.0)

write_data("./examples/ovito.data", x, type, vol)