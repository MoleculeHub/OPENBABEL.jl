export LIBDIR
export DATADIR

const LIBDIR = joinpath(openbabel_jll.find_artifact_dir(), "lib", "openbabel", "3.1.0")
const DATADIR = joinpath(openbabel_jll.find_artifact_dir(), "share", "openbabel", "3.1.0")
const SUPPORTED_READ_FORMATS = ["smi", "sdf", "mol", "pdb", "inchi"]
const SUPPORTED_WRITE_FORMATS = ["smi", "sdf", "mol", "pdb", "inchi"]
