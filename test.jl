using openbabel_jll
using BenchmarkTools
using ProgressBars

include("./config.jl")
include("./utils.jl")
include("./single_transform.jl")

function test(input_smiles, io::IOBuffer=IOBuffer())
    temp_file = "temp_file.smi"
    file = open(temp_file, "w")
    for smile in input_smiles
        write(file, "$smile\n")
    end
    close(file)
    cmd = addenv(`$(obabel()) -ismi $temp_file -oinchi`,
            "BABEL_LIBDIR" => libdir,
            "BABEL_DATADIR" => datadir);
    cmd = pipeline(cmd, stdout=io, stderr=devnull) |> run
    rm(temp_file)
    out = take!(io) |> String
    return out
end

smiles = repeat(["CNCCSCCOC(O)CC(=O)"], 10^5)
@time begin
    test(smiles)
end

##############################3



run(addenv(`$(obabel()) -ismi -:"CCCCC" -oinchi`,
          "BABEL_LIBDIR" => libdir,
          "BABEL_DATADIR" => datadir
          ));

$run(addenv(`$(obabel()) -ismi test.smi -oxyz --gen3D`,
          "BABEL_LIBDIR"=>joinpath(openbabel_jll.find_artifact_dir(),"lib","openbabel","3.1.0"),
          "BABEL_DATADIR"=>joinpath(openbabel_jll.find_artifact_dir(),"share","openbabel","3.1.0"),
          ));

run(addenv(`$(obabel()) filterset.sdf -osmi --filter "s='CN' s!='[N+]'"`,
          "BABEL_LIBDIR"=>joinpath(openbabel_jll.find_artifact_dir(),"lib","openbabel","3.1.0"),
          "BABEL_DATADIR"=>joinpath(openbabel_jll.find_artifact_dir(),"share","openbabel","3.1.0"),
          ));

run(addenv(`$(obabel()) test.smi -ofpt`,
          "BABEL_LIBDIR"=>joinpath(openbabel_jll.find_artifact_dir(),"lib","openbabel","3.1.0"),
          "BABEL_DATADIR"=>joinpath(openbabel_jll.find_artifact_dir(),"share","openbabel","3.1.0"),
          ));

run(addenv(`$(obabel()) test.smi -ofpt`,
          "BABEL_LIBDIR" => libdir,
          "BABEL_DATADIR" => datadir
          ));
