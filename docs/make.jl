using Documenter, DocThemeIndigo
using PDMesh

indigo = DocThemeIndigo.install(PDMesh)

makedocs(sitename="PDMesh", 
        modules=[PDMesh],
        format = Documenter.HTML(;
            prettyurls = false,
            assets=String[indigo]),
        pages = [
            "Home" => "pdmesh.md",
            "Table of contents" => "toc.md",
            "Shapes" => "shape.md",
            "Operations" => "operation.md",
            "Examples" => "examples.md",
            "Index" => "index.md",
            "Autodocs" => "autodocs.md"
        ]
        )