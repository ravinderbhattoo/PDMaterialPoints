using PDMesh

println("Creating a composite...")
function rand_(a, b)
    return a + rand()*(b-a)
end

obj = Cuboid([-10 10; -10 10; 0 3])
for i in 1:100
    global obj
    center = [rand_(-10, 10), rand_(-10, 10), rand_(0, 3)]
    radius = 0.2 + 1.0*rand()
    obj = changetype(obj, out -> begin x=out[:x]; mask = sum((x .- vec(center)).^2, dims=1) .< radius^2; mask .& (sum(out[:type][mask[1,:]] .== 2) == 0)  end, 2)
end

out = create(obj, resolution=0.1, rand_=0.0, type=1)
write_data("./output/composite.data", out)


println("Creating rotating strip...")
c = Cuboid([-5 5; -10 10; 0 3])
obj = copy(c)

for i in 1:100
    global obj
    obj = changetype(obj, out -> begin x=out[:x]; sum(x[1:2, :].^2, dims=1) .< 3.0^2 end, 2)
    obj = changetype(obj, out -> begin x=out[:x]; sum(x[1:2, :].^2, dims=1) .< 2.0^2 end, 3)
    obj = move(obj, by=[10.0, 0.0, 0.0])
    obj = rotate(obj, angle=2, point=[0.0, 0.0, 0.0], vector_=[1.0, 1.0, 0.0])
    obj = combine(obj, c)
end

out = create(obj, resolution=1.0, rand_=0.0, type=1)
write_data("./output/strip.data", out)
