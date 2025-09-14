# Core functions used in macros - not intended for direct use

#############################################################################
# obabel funcs
#############################################################################
function _read_file(; file_path::String, file_format::String)
    !ispath(file_path) &&
        throw(ArgumentError("Input file $(pwd())/$file_path does not exist"))
    return "-i$file_format $file_path"
end
_output_as(x; file_path::String, file_format::String) = x * " -o$file_format -O $file_path"

#
# Writing properties
#
_add_filename(x) = x * " --addfilename"
# Extended properties - now supporting all OpenBabel descriptors
_add_properties(x; props::Array{String}) = x * " --append $(join(props, ' '))"

# Convenience function to get all available descriptors
function get_available_descriptors()
    return [
        # Basic properties (already supported)
        "MW",
        "logP",
        "TPSA",

        # Hydrogen bonding
        "HBD",
        "HBA1",
        "HBA2",

        # Structural descriptors
        "atoms",
        "bonds",
        "abonds",
        "sbonds",
        "dbonds",
        "tbonds",
        "rotors",
        "nF",

        # Chemical identifiers
        "InChI",
        "InChIKey",
        "cansmi",
        "cansmiNS",
        "formula",

        # Advanced properties
        "MR",
        "MP",
        "L5",
    ]
end
_add_index(x::String) = x * " --addinindex"
_add_title(x; title::String) = x * " --addtotitle $title"
_gen_2D_coords(x) = x * " --gen2d"
_gen_3D_coords(x; speed::String) = x * " --gen3d"
_write_multiple_files(x::String) = x * " -m"

# Energy-related functions
_calculate_energy(x; forcefield::String="MMFF94") = x * " --energy --ff $forcefield"
_minimize_energy(x; forcefield::String="MMFF94") = x * " --minimize --ff $forcefield"
_add_partial_charges(x; method::String="gasteiger") = x * " --partialcharge $method"

# Canonical and conformer functions
_canonicalize(x) = x * " --canonical"
_generate_conformers(x) = x * " --conformer"

function search_conf_forcefield(
    x::String;
    n_conf::Int=50,
    forcefield::String="MMFF94",
    search_method::String="systematic",
    write::Bool=false,
)
    x *= " --conformer --nconf $n_conf --ff $forcefield --$search_method"
    if write
        x *= " --writeconformers"
    end
    return x
end

#
# Filtering, matching, setting conditions
#
_center_coords_at_zero(x::String) = x * " -c"
_convert_dative_bonds(x::String) = x * " -b"
_ignore_bad_molecules(x::String) = x * " -e"
_match_smarts_string(x::String; pattern::String) = x * " -s $pattern"
_dont_match_smarts_string(x::String; pattern::String) = x * " -v $pattern"
_remove_hydrogens(x::String) = x * " -d"
_remove_duplicate_mols(x::String) = x * " --unique"
_set_atom_order_canonical(x::String) = x * " --canonical"
_separate_fragments(x::String) = x * " --separate"
_start_with_index(x::String, idx::Int) = x * " -f $idx"
_sort_by(x; property::String) = x * " --sort $property"
_sort_by_reverse(x; property::String) = x * " --sort ~$property"

#TODO error level not working?

#
# Run obabel command
#
function _execute(x::String)
    io = IOBuffer()
    io_err = IOBuffer()
    cmd = `$(obabel()) $(split(x, " "))`
    cmd = addenv(cmd, "BABEL_LIBDIR" => LIBDIR, "BABEL_DATADIR" => DATADIR)
    cmd = run(pipeline(cmd; stdout=io, stderr=io_err))
    @info String(take!(io_err))
end

function get_supported_formats()
    io = IOBuffer()
    cmd = `$(obabel()) -L formats`
    cmd = addenv(cmd, "BABEL_LIBDIR" => LIBDIR, "BABEL_DATADIR" => DATADIR)
    run(pipeline(cmd; stdout=io))
    output = String(take!(io))

    # Parse output to extract format codes
    formats = String[]
    for line in split(output, '\n')
        if occursin(r"^\s*\w+\s+--", line)
            format_match = match(r"^\s*(\w+)", line)
            if format_match !== nothing
                push!(formats, format_match.captures[1])
            end
        end
    end
    return formats
end

function count_molecules(file_path::String, file_format::String)
    !ispath(file_path) && throw(ArgumentError("Input file $file_path does not exist"))

    io = IOBuffer()
    cmd = `$(obabel()) -i$file_format $file_path -onul`
    cmd = addenv(cmd, "BABEL_LIBDIR" => LIBDIR, "BABEL_DATADIR" => DATADIR)
    run(pipeline(cmd; stderr=io))

    output = String(take!(io))
    # Parse the count from OpenBabel's output
    count_match = match(r"(\d+) molecules converted", output)
    return count_match !== nothing ? parse(Int, count_match.captures[1]) : 0
end

function validate_smiles(smiles::String)
    # Empty or whitespace-only strings are invalid
    if isempty(strip(smiles))
        return false
    end

    try
        temp_file = tempname() * ".smi"
        write(temp_file, smiles)

        io = IOBuffer()
        io_err = IOBuffer()
        cmd = `$(obabel()) -ismi $temp_file -onul`
        cmd = addenv(cmd, "BABEL_LIBDIR" => LIBDIR, "BABEL_DATADIR" => DATADIR)
        process = run(pipeline(cmd; stdout=io, stderr=io_err); wait=false)
        wait(process)

        rm(temp_file; force=true)

        stdout_output = String(take!(io))
        error_output = String(take!(io_err))

        # Check for explicit errors in stderr
        has_error =
            occursin("error", lowercase(error_output)) ||
            occursin("failed", lowercase(error_output)) ||
            occursin("invalid", lowercase(error_output))

        # Check if any molecules were successfully converted
        molecules_converted =
            occursin(r"\d+ molecules? converted", stdout_output) ||
            occursin(r"\d+ molecules? converted", error_output)

        # Extract number of converted molecules
        converted_count = 0
        for output in [stdout_output, error_output]
            match_result = match(r"(\d+) molecules? converted", output)
            if match_result !== nothing
                converted_count = max(converted_count, parse(Int, match_result.captures[1]))
            end
        end

        # Valid if no errors and at least one molecule was converted
        return !has_error && converted_count > 0
    catch
        return false
    end
end

function get_molecule_info(
    file_path::String, file_format::String; properties::Vector{String}=["MW"]
)
    !ispath(file_path) && throw(ArgumentError("Input file $file_path does not exist"))

    temp_file = tempname() * ".txt"

    try
        cmd_string = _read_file(; file_path=file_path, file_format=file_format)
        cmd_string = _add_properties(cmd_string; props=properties)
        cmd_string = _output_as(cmd_string; file_path=temp_file, file_format="txt")
        _execute(cmd_string)

        if isfile(temp_file)
            content = read(temp_file, String)
            rm(temp_file; force=true)
            return Dict(
                "file" => file_path,
                "format" => file_format,
                "molecule_count" => count_molecules(file_path, file_format),
                "properties" => properties,
                "sample_output" => content[1:min(500, length(content))],  # First 500 chars
            )
        else
            return Dict("error" => "Failed to process file")
        end
    catch e
        rm(temp_file; force=true)
        return Dict("error" => string(e))
    end
end
