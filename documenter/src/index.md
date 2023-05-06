# PDMesh

```@raw html
<img src="assets/logo.png" style="width:50%;background-color:white;display:block;margin:auto"/>
```

[![Coverage](https://codecov.io/gh/ravinderbhattoo/PDMesh.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/ravinderbhattoo/PDMesh.jl) [![Generic badge](https://img.shields.io/badge/docs-ghpages-blue.svg)](https://ravinderbhattoo.github.io/PDMesh)

## Functionality of PDMesh

PDMesh provides a set of tools to generate meshes of complex geometries and to perform various operations on them. Here are some of the main features:

### Shapes

PDMesh includes a variety of predefined shapes, such as Cuboid, Sphere, Cylinder, Cone, and more. These shapes can be created and modified using various parameters such as resolution, and randomness. For example, here is how to create a sphere:

```julia
using PDMesh
sphere = create(Sphere(10.0), resolution=0.5, rand_=0.0)
```

This will create a sphere with a radius of 10.0, a resolution of 0.5, and no randomness.

### Operations

PDMesh provides several operations that can be performed on meshes, such as rotation, translation, deletion, and more. These operations can be used to modify the shape and position of a mesh. For example, here is how to rotate a mesh:

```julia
using PDMesh
cube = create(Cube(10.0), resolution=0.5, rand_=0.0)
cube_rotated = rotate(cube, angle=45, point=[0, 0, 0], vector_=[1, 0, 0])
```

This will create a cube and then rotate it 45 degrees around the x-axis.

### Combining Shapes

PDMesh allows for combining different shapes together to create more complex geometries. This can be achieved using the `combine` function. For example, here is how to combine two cubes:

```julia
using PDMesh

cube1 = Cube(4.0)
cube2 = move(Cube(2.0), by=[3.0, 0.0, 0.0])

combined = cube1 + cube2

mesh = create(cube; resolution=0.5)
```

This will create two cubes and then combine them into one.
### Changing Mesh Types

PDMesh provides a `changetype` function to change the type of elements in a mesh. This can be used to modify the type of a mesh particle. For example, here is how to change the type of all elements in a mesh to 2:

```julia
using PDMesh
sphere = create(Sphere(10.0), resolution=0.5, rand_=0.0)
sphere_type2 = changetype(sphere, out -> out[:x][1, :] .> 0.0, 2)
```

This will create a sphere and then change the type of all half of particle to 2.

### Writing to File

Finally, PDMesh allows for writing meshes to file in xyz format, here is how to write a mesh to a XYZ file:

```julia
using PDMesh
sphere = create(Sphere(10.0), resolution=0.5, rand_=0.0)
write_data("./output/sphere.data", out)
```

This will create a sphere and then write it to a XYZ file.

## Examples

Here are some examples of PDMesh in action:

```@contents
Pages = [
            "examples.md",
        ]
Depth = 3
```