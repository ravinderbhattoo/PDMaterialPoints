# using Pkg; Pkg.activate(".")
# Pkg.add(["Documenter", "DocThemeIndigo", "Dates"])
# Pkg.develop(path="../")
# Pkg.instantiate()

# using Documenter, DocThemeIndigo, PDMaterialPoints, Dates

indigo = DocThemeIndigo.install(PDMaterialPoints)

format = Documenter.HTML(;
    footer="Updated: $(mapreduce(x-> " "*x*" ", *, split(string(now()), "T")))",
    #. "*string(Documenter.HTML().footer),
    prettyurls = get(ENV, "CI", nothing) == "true",
    # assets = [indigo],
    # assets = ["assets/font.css", "assets/color.css"],
    size_threshold = 1024 * 1024 * 1 # MB

)

function doit()
    makedocs(
        sitename="PDMaterialPoints",
        # remotes=nothing,
        build="../docs",
        format = format,
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
end

doit()
