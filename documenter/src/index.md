# PDMaterialPoints.jl

```@raw html
<img src="assets/logo.png" style="width:50%;background-color:white;display:block;margin:auto"/>
```

[![Coverage](https://codecov.io/gh/ravinderbhattoo/PDMaterialPoints.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/ravinderbhattoo/PDMaterialPoints.jl) [![Generic badge](https://img.shields.io/badge/docs-ghpages-blue.svg)](https://ravinderbhattoo.github.io/PDMaterialPoints)

## Functionality of PDMaterialPoints

PDMaterialPoints provides a set of tools to generate material-point-geometries of complex geometries and to perform various operations on them. Here are some of the main features:

### Shapes

PDMaterialPoints includes a variety of predefined shapes, such as Cuboid, Sphere, Cylinder, Cone, and more. These shapes can be created and modified using various parameters such as resolution, and randomness. For example, here is how to create a sphere:

```julia
using PDMaterialPoints
sphere = create(Sphere(10.0), resolution=0.5, rand_=0.0)
```

This will create a sphere with a radius of 10.0, a resolution of 0.5, and no randomness.

### Operations

PDMaterialPoints provides several operations that can be performed on material-point-geometries, such as rotation, translation, deletion, and more. These operations can be used to modify the shape and position of a material-point-geometry. For example, here is how to rotate a material point geometry:

```julia
using PDMaterialPoints
cube = create(Cube(10.0), resolution=0.5, rand_=0.0)
cube_rotated = rotate(cube, angle=45, point=[0, 0, 0], vector_=[1, 0, 0])
```

This will create a cube and then rotate it 45 degrees around the x-axis.

### Combining Shapes

PDMaterialPoints allows for combining different shapes together to create more complex geometries. This can be achieved using the [`combine`](@ref) function. For example, here is how to combine two cubes:

```julia
using PDMaterialPoints

cube1 = Cube(4.0)
cube2 = move(Cube(2.0), by=[3.0, 0.0, 0.0])

combined = cube1 + cube2

mpg =create(cube; resolution=0.5)
```

This will create two cubes and then combine them into one.
### Changing Material point gemetry Types

PDMaterialPoints provides a [`changetype`](@ref) function to change the type of elements in a material-point-geometry. This can be used to modify the type of a material point. For example, here is how to change the type of all elements in a material-point-geometry to 2:

```julia
using PDMaterialPoints
sphere = create(Sphere(10.0), resolution=0.5, rand_=0.0)
sphere_type2 = changetype(sphere, out -> out[:x][1, :] .> 0.0, 2)
```

This will create a sphere and then change the type of all half of particle to 2.

### Writing to File

Finally, PDMaterialPoints allows for writing material-point-geometries to file in xyz format, here is how to write a material-point-geometry to a XYZ file:

```julia
using PDMaterialPoints
sphere = create(Sphere(10.0), resolution=0.5, rand_=0.0)
write_data("./output/sphere.data", out)
```

This will create a sphere and then write it to a XYZ file.

## Examples

Here are some examples of PDMaterialPoints in action:

```@contents
Pages = [
            "examples.md",
        ]
Depth = 3
```