export smiles_to_inchi
export inchi_to_smiles

#
# Base conversion function
#
function convert_molecule(input::String,
                          input_format::String,
                          output_format::String,
                          io::IOBuffer = IOBuffer())
    cmd = addenv(
        `$(obabel()) -i$input_format -:$input -o$output_format`,
        "BABEL_LIBDIR" => libdir,
        "BABEL_DATADIR" => datadir
                 )
    cmd = pipeline(cmd, stdout=io, stderr=devnull) |> run
    out = take!(io) |> String
    return replace(out, r"\s+" => "")
end

#
# SMILES conversion
#
function smiles_to_inchi(smiles_string::String)
    return convert_molecule(smiles_string, "smi", "inchi")
end

function smiles_to_inchikey(smiles_string::String)
    return convert_molecule(smiles_string, "smi", "inchikey")
end

#
# InChI conversion
#
function inchi_to_smiles(inchi_string::String)
    return convert_molecule(inchi_string, "inchi", "smi")
end

function inchi_to_inchikey(inchi_string::String)
    return convert_molecule(inchi_string, "inchi", "inchikey")
end
