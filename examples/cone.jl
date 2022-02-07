import Pkg
Pkg.activate("./")

using PDMesh

x, v, y, vol, type_ = unpack(create(Cone(10.0, 20.0), resolution=0.5, rand_=0.0)

write_data("./examples/ovito.data", x, vol, ones(Int64, size(x)[2]))