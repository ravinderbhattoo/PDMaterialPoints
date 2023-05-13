# exports
export Pyramid, Indentor

"""
    Pyramid

Pyramid shape.

# Arguments
- `angle::AbstractFloat`: Apex angle of the Pyramid.

# Example
```julia
using PDMaterialPoints

# Create a Pyramid
Pyramid = Pyramid(60.0)

# Create a material-point-geometry.
mpg =create(Pyramid)
```

# See also
- [`create`](@ref)

# References
- [Wikipedia](https://en.wikipedia.org/wiki/Pyramid)

"""
function Pyramid(angle, height; sides=3)
    printstyled("\nPyramid use random rotatations to disalign particle with axes. Hence, results are not same everytime.\n\n", color=:yellow, bold=true)
    angle_ = angle * pi/180
    half_angle = angle_/2
    radius = 2 * height * tan(half_angle)
    obj = Cube(radius)
    rot_angle = 360.0 / sides
    func = out -> out[:x][3, :] .< out[:x][1, :] / tan(half_angle)
    obj = rotate(obj; angle=rand()*rot_angle, vector_=[0, 0, 1.0])
    for i in 1:sides
        obj = delete(obj, func)
        obj = rotate(obj; angle=rot_angle, vector_=[0, 0, 1.0])
    end
    obj.name = "Pyramid:$angle:$sides"
    return obj
end

Pyramid() = Pyramid(60.0, 1.0)

"""
    Indentor(angle, height; sides=3)

Indentor shape. A special case of Pyramid.

# Arguments
- `angle::AbstractFloat`: Apex angle of the Indentor.
- `height::AbstractFloat`: Height of the Indentor.

# Keyword Arguments
- `sides::Int`: Number of sides of the Indentor.

# Example
```julia
using PDMaterialPoints

# Create a Indentor
Indentor = Indentor(60.0, 1.0)

# Create a material-point-geometry.
mpg =create(Indentor)
```

# See also
- [`create`](@ref)
"""
function Indentor(angle, height; sides=3)
    obj = Pyramid(angle, height; sides=sides)
    obj.name = "Indentor:$angle:$sides"
    return obj
end

function Indentor()
    obj = Pyramid()
    obj.name = "Indentor:60:3"
    return obj
end
