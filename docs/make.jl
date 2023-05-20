using QDScan
using Documenter

DocMeta.setdocmeta!(QDScan, :DocTestSetup, :(using QDScan); recursive=true)

makedocs(;
    modules=[QDScan],
    authors="Chen Huang",
    repo="https://github.com/chenspc/QDScan.jl/blob/{commit}{path}#{line}",
    sitename="QDScan.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://chenspc.github.io/QDScan.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/chenspc/QDScan.jl",
    devbranch="main",
)
