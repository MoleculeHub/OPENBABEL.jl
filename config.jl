export libdir
export datadir

const libdir = joinpath(openbabel_jll.find_artifact_dir(), "lib", "openbabel", "3.1.0")
const datadir = joinpath(openbabel_jll.find_artifact_dir(), "share", "openbabel", "3.1.0")