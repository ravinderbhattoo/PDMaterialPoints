using PDMesh

# cone
println("Creating Cone...")
out = create(Cone(10.0, 20.0), resolution=0.5, rand_=0.0)
write_data("./output/cone.data", out)

# cylinder
println("Creating Cylinder...")
out = create(Cylinder(10.0, 3.0, 100.0), resolution=0.5, rand_=0.0)
write_data("./output/cylinder.data", out)

# Sphere
println("Creating Sphere...")
out = create(Sphere(10.0), resolution=0.5, rand_=0.0)
write_data("./output/sphere.data", out)

# notched bar
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

println("Finished")
