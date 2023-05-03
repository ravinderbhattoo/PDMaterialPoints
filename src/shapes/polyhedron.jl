export Polyhedron

struct Polyhedron
    vertices::Array{Float64, 2}
    faces::Array{Int64, 2}
end

function inshape(x::Polyhedron, p::Array{Float64, 2})
    inpolyhedron(x, p)
end

function inpolyhedron(poly::Polyhedron, point::Array{Float64, 1})
    vertices = poly.vertices
    faces = poly.faces
    n_faces = size(faces, 1)
    n_vertices = size(vertices, 1)

    # Compute normals of all faces
    normals = zeros(n_faces, 3)
    for i in 1:n_faces
        v1 = vertices[faces[i, 1], :]
        v2 = vertices[faces[i, 2], :]
        v3 = vertices[faces[i, 3], :]
        normals[i, :] = cross(v2 - v1, v3 - v1)
    end

    # Check whether the point is on the right side of all faces
    for i in 1:n_faces
        v1 = vertices[faces[i, 1], :]
        if dot(normals[i, :], point - v1) > 0
            return false
        end
    end

    # Check whether the point is inside the polyhedron by shooting a ray
    # from the point to infinity and counting how many times it intersects
    # the faces of the polyhedron.
    count = 0
    for i in 1:n_faces
        v1 = vertices[faces[i, 1], :]
        normal = normals[i, :]
        if dot(normal, point - v1) < 0
            continue
        end
        intersect = true
        for j in 1:size(faces, 2)
            if j == size(faces, 2)
                v2 = vertices[faces[i, 1], :]
            else
                v2 = vertices[faces[i, j+1], :]
            end
            if dot(normal, v2 - point) < 0
                intersect = false
                break
            end
        end
        if intersect
            count += 1
        end
    end

    return count % 2 != 0
end
