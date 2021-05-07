import Pkg
Pkg.activate("./")

using PDMesh

c = Cuboid([0 5; -10 10; 0 3])


# function rand_(a, b)
#     return a + rand()*(b-a)
# end 

# for i in 1:40
#     global obj
#     center = [rand_(-10, 10), rand_(-10, 10), rand_(0, 3)]
#     radius = 0.2 + 1.0*rand()
#     obj = changetype(obj, out -> begin x=out[1]; sum((x .- vec(center)).^2, dims=1) .< radius^2 end, 4)
#     obj = changetype(obj, out -> begin x=out[1]; sum((x .- vec(center)).^2, dims=1) .< (radius - 0.1)^2 end, 5)
# end

# obj = delete!(obj, out -> begin x=out[1]; sum(x[1:2, :].^2, dims=1) .> 4.0^2 end)
# obj = velocity(obj, out -> begin type=out[5]; type.==1 end, [1.0, 0.0, 0.0])

obj = copy(c)

for i in 1:1000
    global obj
    obj = changetype(obj, out -> begin x=out[1]; sum(x[1:2, :].^2, dims=1) .< 3.0^2 end, 2)
    obj = changetype(obj, out -> begin x=out[1]; sum(x[1:2, :].^2, dims=1) .< 2.0^2 end, 3)
    obj = move(obj, by=[5.0, 0.0, 0.0])
    obj = rotate(obj, angle=2, point=[0.0, 0.0, 0.0], vector_=[1.0, 1.0, 0.0])
    obj = combine(obj, c)
end

x, v, y, vol, type = create(obj, resolution=1, rand_=0.0, type=1)

write_data("./examples/ovito.data", y, v, type, vol)
write_data("./examples/ovito1.data", 1.1y, v, type, vol)