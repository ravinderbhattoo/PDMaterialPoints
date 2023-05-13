# Operations

This section lists the operations that can be performed on [`Shape`](@ref) and [`PostOpObj`](@ref). These operations can be used to modify the shape and position of a mesh. For example, here is how to rotate a mesh:

```julia
using PDMesh
cube = create(Cube(10.0), resolution=0.5, rand_=0.0)
cube_rotated = rotate(cube, angle=45, point=[0, 0, 0], vector_=[1, 0, 0])
```

This will create a cube and then rotate it 45 degrees around the x-axis.

**Note that all the operations listed below are lazy and will be applied when create is called.**

- [`create`](@ref)
- [`changetype`](@ref)
- [`delete`](@ref)
- [`move`](@ref)
- [`rotate`](@ref)
- [`velocity`](@ref)
