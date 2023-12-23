using openbabel_jll

include("./config.jl")
include("./utils.jl")

run(addenv(`$(obabel()) -ismi -:"CCsdfsdC" -oinchi`,
          "BABEL_LIBDIR" => libdir,
          "BABEL_DATADIR" => datadir
          ));

io = IOBuffer()
cmd = addenv(`$(obabel()) -ismi -:"CaCC" -omol`,
          "BABEL_LIBDIR" => libdir,
          "BABEL_DATADIR" => datadir
          )
cmd = pipeline(cmd, stdout=io, stderr=devnull)
run(cmd)
String(take!(io))


using Chain
@chain 5 begin
    sqrt
    replace(_, "A" => "5")
end

5 |>
    x -> sqrt(x) |>
    x -> replace(x, "A" => "5")








run(addenv(`$(obabel()) -ismi test.smi -oxyz --gen3D`,
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
