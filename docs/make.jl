using Openbabel
using Documenter

DocMeta.setdocmeta!(Openbabel, :DocTestSetup, :(using Openbabel); recursive=true)

makedocs(;
    modules=[Openbabel],
    authors="Victor Cano Gil <vcanogil@gmail.com> and contributors",
    repo="https://github.com/vcanogil/Openbabel.jl/blob/{commit}{path}#{line}",
    sitename="Openbabel.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://vcanogil.github.io/Openbabel.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/vcanogil/Openbabel.jl",
)
