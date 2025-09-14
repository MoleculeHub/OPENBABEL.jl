using Documenter
using OpenBabel

makedocs(;
    modules=[OpenBabel],
    authors="Renée Gil",
    repo="https://github.com/MoleculeHub/OpenBabel.jl/blob/{commit}{path}#{line}",
    sitename="OpenBabel.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MoleculeHub.github.io/OpenBabel.jl",
        edit_link="main",
        assets=String[],
    ),
    checkdocs=:none,
    warnonly=true,
    pages=[
        "Home" => "index.md",
        "Examples" => "examples.md",
        "API Reference" => [
            "Core I/O Macros" => "api/io.md",
            "Property & Coordinate Macros" => "api/properties.md",
            "Filtering & Matching Macros" => "api/filtering.md",
            "Energy & Advanced Macros" => "api/energy.md",
        ],
    ],
)

deploydocs(; repo="github.com/MoleculeHub/OpenBabel.jl", devbranch="main")
