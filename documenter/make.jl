push!(LOAD_PATH,"../src/")

using Documenter, DocThemeIndigo, PDMesh
using Dates

indigo = DocThemeIndigo.install(PDMesh)

makedocs(sitename="PDMesh";
    build="../docs",
    sidebar_sitename=nothing,
    format = Documenter.HTML(
    footer="Updated: $(now()). "*string(Documenter.HTML().footer),
    prettyurls = get(ENV, "CI", nothing) == "true",
    assets=String[indigo]
    ),
    modules=[PDMesh],
    pages = [
        "Home" => "index.md",
        "Table of contents" => "toc.md",
        "Examples" => "examples.md",
        "Shapes" => "shapes.md",
        "Operations" => "operations.md",
        "Index" => "list.md",
        "Autodocs" => "autodocs.md",
    ]

)