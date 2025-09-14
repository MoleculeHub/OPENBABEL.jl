using Documenter
using OPENBABEL

makedocs(;
    modules=[OPENBABEL],
    authors="Your Name",
    repo="https://github.com/MoleculeHub/OPENBABEL.jl/blob/{commit}{path}#{line}",
    sitename="OPENBABEL.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MoleculeHub.github.io/OPENBABEL.jl",
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

deploydocs(; repo="github.com/MoleculeHub/OPENBABEL.jl", devbranch="main")
