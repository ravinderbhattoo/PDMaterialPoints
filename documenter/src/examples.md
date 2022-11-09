# Examples

__Output files can be visualized using Ovito software.__

## Cone
```julia
using PDMesh
println("Creating Cone...")
out = create(Cone(10.0, 20.0), resolution=0.5, rand_=0.0)
write_data("./output/cone.data", out)
```

## Cylinder
```julia
using PDMesh
println("Creating Cylinder...")
out = create(Cylinder(10.0, 3.0, 100.0), resolution=0.5, rand_=0.0)
write_data("./output/cylinder.data", out)
```

## Sphere
```julia
using PDMesh
println("Creating Sphere...")
out = create(Sphere(10.0), resolution=0.5, rand_=0.0)
write_data("./output/sphere.data", out)
```

## Notched Bar
```julia
using PDMesh
println("Creating Notched Bar...")
obj = Cuboid([-10 10; 0 3; -2 2])
f = out -> begin
    x=out[:x];
    mask = (x[1, :] .< 0.1) .& (x[1, :] .> -0.1) .& (x[2, :] .> 2)
    mask
end
obj = delete(obj, f)

out = create(obj, resolution=0.1, rand_=0.0, type=1)
write_data("./output/notched_bar.data", out)
```

## Composite
```julia
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
```

## Rotating composite strip
```julia
println("Creating rotating strip...")
using PDMesh
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

out = create(obj, resolution=0.5, rand_=0.0, type=1)
write_data("./output/strip.data", out)
```