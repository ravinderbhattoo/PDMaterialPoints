import Pkg
Pkg.activate("./")

using PDMesh

x, v, y, vol = create(Cylinder(10.0, 3.0, 10.0), resolution=0.5, rand_=0.0)

write_data("./examples/ovito.data", x, vol, ones(Int64, size(x)[2]))