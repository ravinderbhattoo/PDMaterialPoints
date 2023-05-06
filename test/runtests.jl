using PDMesh
using Test

@testset "Shapes" begin
    @test !(any(isnan.(StandardCone()[:x])))
    @test !(any(isnan.(StandardCuboid()[:x])))
    @test !(any(isnan.(StandardCylinder()[:x])))
    @test !(any(isnan.(StandardDisk()[:x])))
    @test !(any(isnan.(StandardSphere()[:x])))
end


@testset "Operations" begin
    cube = Cuboid()
    out = create(cube, resolution=0.2)

    out2 = create(move(cube, by=[1.0, 1.0, 1.0]), resolution=0.2)
    @test out2[:x] ≈ out[:x] .+ [1.0, 1.0, 1.0]

    out2 = create(changetype(cube, out -> out[:type] .== 1, 2), resolution=0.2)
    @test out2[:type] ≈ ones(Int64, size(out[:type])) .* 2

    vrand = rand(3)
    out2 = create(velocity(cube, out -> out[:type] .== 1, vrand), resolution=0.2)
    @test out2[:v] ≈ out[:v] .+ vrand

    #   -------------------------   ---------------------------
    # 1 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 2 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 3 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 4 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 5 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 6 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 7 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 8 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    # 9 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    #10 || * * * * * * * * * * ||   || * * * * * | * * * * * ||
    #   -------------------------   ---------------------------
    #          10x10x10 cube    # 10x10x5 cuboid + 10x10x5 cuboid

    out2 = create(delete(cube, out -> out[:x][1, :] .> 0.0), resolution=0.1)
    @test size(out2[:x], 2) == 10*10*5
end


