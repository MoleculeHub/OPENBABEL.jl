using openbabel_jll

include("./config.jl")
include("./utils.jl")

run(addenv(`$(obabel()) -ismi -:"CCC" -oxyz`,
          "BABEL_LIBDIR" => libdir,
          "BABEL_DATADIR" => datadir
          ));

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
