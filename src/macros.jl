# Macros used in OpenBabel pipelines

#############################################################################
# Core input/output macros
#############################################################################

"""
    @read_file(file_path, file_format)

Read molecules from an input file.

# Arguments
- `file_path`: Path to the input file
- `file_format`: File format code (e.g., "smi", "mol", "sdf")

# Examples
```julia
@read_file("molecules.smi", "smi")
@read_file("database.sdf", "sdf")
```
"""
macro read_file(file_path, file_format)
    return :(_read_file(; file_path=($file_path), file_format=($file_format)))
end

"""
    @output_as(expr, file_path, file_format)

Specify output file and format for the pipeline.

# Arguments
- `expr`: Previous command in the chain
- `file_path`: Output file path
- `file_format`: Output file format code

# Examples
```julia
@chain begin
    @read_file("input.smi", "smi")
    @output_as("output.mol", "mol")
    @execute
end
```
"""
macro output_as(expr, file_path, file_format)
    return :(_output_as($(esc(expr)); file_path=($file_path), file_format=($file_format)))
end

#
# Writing properties and coordinate generation
#

"""
    @add_properties(expr, props)

Add calculated molecular properties to the output.

# Arguments
- `expr`: Previous command in the chain
- `props`: Vector of property names (e.g., ["MW", "logP", "TPSA"])

# Example
```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @add_properties(["MW", "logP", "HBD", "HBA"])
    @output_as("molecules_with_props.sdf", "sdf")
    @execute
end
```
"""
macro add_properties(expr, props)
    return :(_add_properties($(esc(expr)); props=($props)))
end

"""
    @gen_3D_coords(expr, speed)

Generate 3D coordinates for molecules.

# Arguments
- `expr`: Previous command in the chain
- `speed`: Generation speed ("fast", "med", "slow")

# Example
```julia
@chain begin
    @read_file("input.smi", "smi")
    @gen_3D_coords("fast")
    @output_as("output_3d.mol", "mol")
    @execute
end
```
"""
macro gen_3D_coords(expr, speed)
    return :(_gen_3D_coords($(esc(expr)); speed=($speed)))
end

"""
    @gen_2D_coords(expr)

Generate 2D coordinates for molecules.

# Example
```julia
@chain begin
    @read_file("input.smi", "smi")
    @gen_2D_coords()
    @output_as("output_2d.mol", "mol")
    @execute
end
```
"""
macro gen_2D_coords(expr)
    return :(_gen_2D_coords($(esc(expr))))
end

"""
    @add_filename(expr)

Add the original filename as a property to each molecule in the output.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @add_filename()
    @output_as("output_with_filenames.sdf", "sdf")
    @execute
end
```
"""
macro add_filename(expr)
    return :(_add_filename($(esc(expr))))
end

"""
    @add_index(expr)

Add a sequential index number to each molecule in the output.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("database.sdf", "sdf")
    @add_index()
    @output_as("indexed_molecules.sdf", "sdf")
    @execute
end
```
"""
macro add_index(expr)
    return :(_add_index($(esc(expr))))
end

"""
    @add_title(expr, title)

Add a custom title to each molecule in the output.

# Arguments
- `expr`: Previous command in the chain
- `title`: Title string to add to molecules

# Example
```julia
@chain begin
    @read_file("compounds.smi", "smi")
    @add_title("Processed Compounds")
    @output_as("titled_compounds.sdf", "sdf")
    @execute
end
```
"""
macro add_title(expr, title::String)
    return :(_add_title($(esc(expr)); title=($title)))
end

"""
    @write_multiple_files(expr)

Write each molecule to a separate output file instead of one combined file.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @write_multiple_files()
    @output_as("molecule", "mol")  # Creates molecule1.mol, molecule2.mol, etc.
    @execute
end
```
"""
macro write_multiple_files(expr)
    return :(_write_multiple_files($(esc(expr))))
end

"""
    @execute(expr)

Execute the constructed OpenBabel pipeline.

# Arguments
- `expr`: Complete command chain to execute

# Examples
```julia
@chain begin
    @read_file("input.smi", "smi")
    @gen_3D_coords("fast")
    @output_as("output.mol", "mol")
    @execute
end
```
"""
macro execute(expr)
    return :(_execute($(esc(expr))))
end

#
# Filtering, matching, setting conditions
#

"""
    @match_smarts_string(expr, pattern)

Filter molecules that match a SMARTS pattern.

# Arguments
- `expr`: Previous command in the chain
- `pattern`: SMARTS pattern string

# Example
```julia
# Keep only molecules with benzene rings
@chain begin
    @read_file("database.smi", "smi")
    @match_smarts_string("c1ccccc1")
    @output_as("benzene_compounds.smi", "smi")
    @execute
end
```
"""
macro match_smarts_string(expr, pattern)
    return :(_match_smarts_string($(esc(expr)); pattern=($pattern)))
end

"""
    @dont_match_smarts_string(expr, pattern)

Exclude molecules that match a SMARTS pattern.

# Example
```julia
# Remove molecules with benzene rings
@chain begin
    @read_file("database.smi", "smi")
    @dont_match_smarts_string("c1ccccc1")
    @output_as("no_benzene.smi", "smi")
    @execute
end
```
"""
macro dont_match_smarts_string(expr, pattern)
    return :(_dont_match_smarts_string($(esc(expr)); pattern=($pattern)))
end

"""
    @sort_by(expr, property)

Sort molecules by a property in ascending order.

# Arguments
- `expr`: Previous command in the chain
- `property`: Property name ("MW", "logP", "TPSA", etc.)

# Example
```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @add_properties(["MW"])
    @sort_by("MW")
    @output_as("sorted_by_mw.sdf", "sdf")
    @execute
end
```
"""
macro sort_by(expr, property)
    return :(_sort_by($(esc(expr)); property=($property)))
end

"""
    @sort_by_reverse(expr, property)

Sort molecules by a property in descending order.

# Example
```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @add_properties(["logP"])
    @sort_by_reverse("logP")  # Highest logP first
    @output_as("sorted_by_logp_desc.sdf", "sdf")
    @execute
end
```
"""
macro sort_by_reverse(expr, property)
    return :(_sort_by_reverse($(esc(expr)); property=($property)))
end

"""
    @remove_duplicate_mols(expr)

Remove duplicate molecules from the dataset.

# Example
```julia
@chain begin
    @read_file("database.smi", "smi")
    @remove_duplicate_mols()
    @output_as("unique_molecules.smi", "smi")
    @execute
end
```
"""
macro remove_duplicate_mols(expr)
    return :(_remove_duplicate_mols($(esc(expr))))
end

"""
    @center_coords_at_zero(expr)

Center the molecular coordinates at the origin (0,0,0).

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("molecules.mol", "mol")
    @center_coords_at_zero()
    @output_as("centered_molecules.mol", "mol")
    @execute
end
```
"""
macro center_coords_at_zero(expr)
    return :(_center_coords_at_zero($(esc(expr))))
end

"""
    @convert_dative_bonds(expr)

Convert dative bonds (coordinate covalent bonds) to normal bonds in the molecular representation.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("coordination_compounds.mol", "mol")
    @convert_dative_bonds()
    @output_as("converted_bonds.mol", "mol")
    @execute
end
```
"""
macro convert_dative_bonds(expr)
    return :(_convert_dative_bonds($(esc(expr))))
end

"""
    @ignore_bad_molecules(expr)

Skip molecules that cannot be parsed or contain errors, continuing with valid molecules.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("mixed_quality_data.smi", "smi")
    @ignore_bad_molecules()
    @gen_3D_coords("fast")
    @output_as("valid_molecules.sdf", "sdf")
    @execute
end
```
"""
macro ignore_bad_molecules(expr)
    return :(_ignore_bad_molecules($(esc(expr))))
end

"""
    @remove_hydrogens(expr)

Remove explicit hydrogen atoms from the molecular structure.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("explicit_h_molecules.mol", "mol")
    @remove_hydrogens()
    @output_as("implicit_h_molecules.mol", "mol")
    @execute
end
```
"""
macro remove_hydrogens(expr)
    return :(_remove_hydrogens($(esc(expr))))
end

"""
    @set_atom_order_canonical(expr)

Reorder atoms in molecules to follow a canonical (standardized) ordering.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("unordered_molecules.smi", "smi")
    @set_atom_order_canonical()
    @output_as("canonical_molecules.smi", "smi")
    @execute
end
```
"""
macro set_atom_order_canonical(expr)
    return :(_set_atom_order_canonical($(esc(expr))))
end

"""
    @separate_fragments(expr)

Separate multi-fragment molecules into individual fragments as separate molecules.

# Arguments
- `expr`: Previous command in the chain

# Example
```julia
@chain begin
    @read_file("salt_complexes.smi", "smi")
    @separate_fragments()
    @output_as("individual_fragments.smi", "smi")
    @execute
end
```
"""
macro separate_fragments(expr)
    return :(_separate_fragments($(esc(expr))))
end

"""
    @start_with_index(expr, idx)

Start processing molecules from a specific index in the input file.

# Arguments
- `expr`: Previous command in the chain
- `idx`: Starting index (1-based indexing)

# Example
```julia
@chain begin
    @read_file("large_database.sdf", "sdf")
    @start_with_index(100)  # Start from the 100th molecule
    @add_properties(["MW"])
    @output_as("subset_molecules.sdf", "sdf")
    @execute
end
```
"""
macro start_with_index(expr, idx)
    return :(_start_with_index($(esc(expr)), $idx))
end

#
# Energy and Advanced Calculation Macros
#

"""
    @calculate_energy(expr, forcefield="MMFF94")

Calculate the energy of molecules using a specified forcefield.

## Arguments
- `expr`: The expression to chain with
- `forcefield`: Forcefield to use for energy calculation. Available: "MMFF94" (default), "MMFF94s", "UFF", "GAFF", "Ghemical"

## Example
```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @calculate_energy("MMFF94")
    @output_as("energies.sdf", "sdf")
    @execute
end
```
"""
macro calculate_energy(expr, forcefield="MMFF94")
    return :(_calculate_energy($(esc(expr)); forcefield=$forcefield))
end

"""
    @minimize_energy(expr, forcefield="MMFF94")

Minimize the energy of molecules using a specified forcefield.

## Arguments
- `expr`: The expression to chain with
- `forcefield`: Forcefield to use for energy minimization. Available: "MMFF94" (default), "MMFF94s", "UFF", "GAFF", "Ghemical"

## Example
```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @minimize_energy("MMFF94")
    @output_as("minimized.sdf", "sdf")
    @execute
end
```
"""
macro minimize_energy(expr, forcefield="MMFF94")
    return :(_minimize_energy($(esc(expr)); forcefield=$forcefield))
end

"""
    @add_partial_charges(expr, method="gasteiger")

Add partial charges to molecules using specified method.

## Arguments
- `expr`: The expression to chain with
- `method`: Charge calculation method. Available: "gasteiger" (default), "mmff94", "qeq", "eqeq", "eem"

## Example
```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @add_partial_charges("gasteiger")
    @output_as("charged.sdf", "sdf")
    @execute
end
```
"""
macro add_partial_charges(expr, method="gasteiger")
    return :(_add_partial_charges($(esc(expr)); method=$method))
end

"""
    @canonicalize(expr)

Canonicalize the atom order in molecules.

## Example
```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @canonicalize()
    @output_as("canonical.sdf", "sdf")
    @execute
end
```
"""
macro canonicalize(expr)
    return :(_canonicalize($(esc(expr))))
end

"""
    @generate_conformers(expr)

Generate conformers for molecules.

## Example
```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @generate_conformers()
    @output_as("conformers.sdf", "sdf")
    @execute
end
```
"""
macro generate_conformers(expr)
    return :(_generate_conformers($(esc(expr))))
end
