using Pkg; Pkg.activate("."); Pkg.instantiate()

Pkg.add(["Documenter", "DocThemeIndigo", "Dates"])
Pkg.develop(PackageSpec(path=".."))

using Documenter, DocThemeIndigo, PDMaterialPoints, Dates

indigo = DocThemeIndigo.install(PDMaterialPoints)

makedocs(sitename="PDMaterialPoints.jl";
    build="../docs",
    format = Documenter.HTML(
    footer="Updated: $(now()). "*string(Documenter.HTML().footer),
    prettyurls = get(ENV, "CI", nothing) == "true",
    assets=String[]
    ),
    modules=[PDMaterialPoints],
    pages = [
        "Home" => "index.md",
        "Table of contents" => "toc.md",
        "Examples" => "examples.md",
        "Shapes" => "shapes.md",
        "Operations" => "operations.md",
        "Index" => "indexlist.md",
        "Autodocs" => "autodocs.md",
    ]

)