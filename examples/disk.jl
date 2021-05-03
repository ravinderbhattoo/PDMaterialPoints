import Pkg
Pkg.activate("./")

using PDMesh

obj = Cuboid([-10 10; -10 10; 0 3])

obj = changetype(obj, out -> begin x=out[1]; sum(x[1:2, :].^2, dims=1) .< 3.0^2 end, 2)
obj = changetype(obj, out -> begin x=out[1]; sum(x[1:2, :].^2, dims=1) .< 2.0^2 end, 3)

obj = slide(obj, by=[10.0, 0.0, 0.0])
obj = rotate(obj, angle=45)
obj = velocity(obj, out -> begin type=out[5]; type.==1 end, [1.0, 0.0, 0.0])

x, v, y, vol, type = create(obj, resolution=0.1, rand_=0.0, type=1)


write_data("./examples/ovito_ref.data", x, type, vol)

write_data("./examples/ovito.data", y, v, type, vol)