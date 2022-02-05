import Pkg
Pkg.activate("./")

using PDMesh

x, v, y, vol = create(Sphere(10.0), resolution=0.1, rand_=0.2)

write_data("./examples/ovito.data", x, vol, ones(Int64, size(x)[2]))