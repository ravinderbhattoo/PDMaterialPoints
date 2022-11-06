push!(LOAD_PATH,"../src/")

using Documenter, DocThemeIndigo, PDMesh

indigo = DocThemeIndigo.install(PDMesh)

makedocs(sitename="PDMesh";
    build="../docs",
    sidebar_sitename=nothing,
    format = Documenter.HTML(
    prettyurls = get(ENV, "CI", nothing) == "true",
    assets=String[indigo]
    ),
    modules=[PDMesh],
    pages = [
        "Home" => "index.md",
        "Table of contents" => "toc.md",
        "Examples" => "examples.md",
        "Index" => "list.md",
        "Shapes" => "shapes.md",
        "Autodocs" => "autodocs.md"
    ]

)