module OPENBABEL

using openbabel_jll
using Chain
using Reexport

@reexport using Chain

# Core macros
export @read_file, @output_as

# Writing properties macros
export @add_filename,
    @add_properties,
    @add_index,
    @add_title,
    @gen_2D_coords,
    @gen_3D_coords,
    @write_multiple_files,
    @execute

# Filtering, matching, setting conditions macros
export @center_coords_at_zero,
    @convert_dative_bonds,
    @ignore_bad_molecules,
    @match_smarts_string,
    @dont_match_smarts_string,
    @remove_hydrogens,
    @remove_duplicate_mols,
    @set_atom_order_canonical,
    @separate_fragments,
    @start_with_index,
    @sort_by,
    @sort_by_reverse

# Energy and advanced calculation macros
export @calculate_energy,
    @minimize_energy, @add_partial_charges, @canonicalize, @generate_conformers

# Utility functions
export search_conf_forcefield,
    get_supported_formats,
    get_available_descriptors,
    count_molecules,
    validate_smiles,
    get_molecule_info

include("./config.jl")
include("./helpers.jl")
include("./macros.jl")

end
