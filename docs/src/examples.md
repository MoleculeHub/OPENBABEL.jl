# Examples

This page provides comprehensive examples of using OpenBabel.jl for common molecular data processing tasks.

## Basic File Conversion

### SMILES to SDF Conversion

```julia
using OpenBabel
using Chain

# Convert SMILES to SDF with 3D coordinates and properties
@chain begin
    @read_file("input.smi", "smi")
    @gen_3D_coords("fast")
    @add_properties(["MW", "logP", "TPSA"])
    @output_as("output.sdf", "sdf")
    @execute
end
```

### Batch File Processing

```julia
# Process multiple molecules into separate files
@chain begin
    @read_file("database.smi", "smi")
    @gen_2D_coords()
    @add_index()
    @write_multiple_files()
    @output_as("molecule", "mol")  # Creates molecule1.mol, molecule2.mol, etc.
    @execute
end
```

## Drug Discovery Workflows

### Lead Compound Filtering

```julia
# Filter compounds by Lipinski's Rule of Five
@chain begin
    @read_file("compound_library.sdf", "sdf")
    @add_properties(["MW", "logP", "HBD", "HBA"])
    @match_smarts_string("[!#1]")  # Must contain non-hydrogen atoms
    @sort_by("MW")
    @output_as("filtered_compounds.sdf", "sdf")
    @execute
end

# Additional filtering can be done in Julia
# Filter by Lipinski's Rule of Five criteria
```

### Virtual Screening Pipeline

```julia
# Prepare compounds for virtual screening
@chain begin
    @read_file("screening_library.smi", "smi")
    @ignore_bad_molecules()
    @remove_duplicate_mols()
    @gen_3D_coords("med")
    @minimize_energy("MMFF94")
    @add_partial_charges("gasteiger")
    @canonicalize()
    @add_properties(["MW", "logP", "TPSA", "rotors"])
    @sort_by_reverse("MW")
    @output_as("screening_ready.sdf", "sdf")
    @execute
end
```

## Chemical Database Processing

### Large Dataset Cleaning

```julia
# Clean and standardize a large chemical database
@chain begin
    @read_file("raw_database.sdf", "sdf")
    @ignore_bad_molecules()          # Skip invalid structures
    @remove_duplicate_mols()         # Remove duplicates
    @separate_fragments()            # Split salt complexes
    @remove_hydrogens()              # Use implicit hydrogens
    @set_atom_order_canonical()      # Standardize atom ordering
    @dont_match_smarts_string("[Na,K,Cl,Br]")  # Remove simple salts
    @add_properties(["MW", "atoms", "bonds"])
    @sort_by("MW")
    @output_as("clean_database.sdf", "sdf")
    @execute
end
```

### Property-Based Filtering

```julia
# Extract drug-like molecules based on molecular properties
@chain begin
    @read_file("compound_collection.sdf", "sdf")
    @add_properties(["MW", "logP", "TPSA", "HBD", "HBA", "rotors"])
    # Following steps would need additional Julia filtering
    @match_smarts_string("[#6,#7,#8,#16,#15,#9,#17,#35,#53]")  # Common drug atoms
    @dont_match_smarts_string("[Pb,Hg,As,Cd]")  # Exclude toxic metals
    @output_as("druglike_molecules.sdf", "sdf")
    @execute
end
```

## Structure-Activity Relationships

### Scaffold Analysis

```julia
# Generate molecular scaffolds for SAR analysis
@chain begin
    @read_file("active_compounds.sdf", "sdf")
    @remove_hydrogens()
    @set_atom_order_canonical()
    @add_properties(["MW", "rotors", "rings"])
    @sort_by("rings")
    @output_as("scaffolds.sdf", "sdf")
    @execute
end
```

### Conformer Generation for Flexibility Analysis

```julia
# Generate conformers to study molecular flexibility
@chain begin
    @read_file("flexible_molecules.smi", "smi")
    @gen_3D_coords("slow")
    @generate_conformers()
    @minimize_energy("MMFF94")
    @calculate_energy("MMFF94")
    @add_properties(["rotors", "MW"])
    @sort_by("Energy")
    @output_as("conformer_ensemble.sdf", "sdf")
    @execute
end
```

## Specialized Chemical Applications

### Natural Product Processing

```julia
# Process natural product structures
@chain begin
    @read_file("natural_products.sdf", "sdf")
    @ignore_bad_molecules()
    @gen_3D_coords("slow")  # High quality for complex structures
    @center_coords_at_zero()
    @add_properties(["MW", "logP", "TPSA", "rings", "stereocenters"])
    @dont_match_smarts_string("[Si,B,Al]")  # Remove unusual atoms
    @sort_by_reverse("rings")  # Complex ring systems first
    @output_as("processed_np.sdf", "sdf")
    @execute
end
```

### Fragment Library Generation

```julia
# Create fragment library from larger molecules
@chain begin
    @read_file("parent_compounds.smi", "smi")
    @separate_fragments()        # Split into fragments
    @remove_duplicate_mols()     # Remove duplicate fragments
    @match_smarts_string("[#6,#7,#8]")  # Keep C, N, O containing fragments
    @add_properties(["MW", "atoms", "HBA", "HBD"])
    @sort_by("MW")
    @output_as("fragment_library.sdf", "sdf")
    @execute
end
```

## Quality Control and Validation

### Structure Validation Pipeline

```julia
# Validate and clean chemical structures
@chain begin
    @read_file("unchecked_structures.sdf", "sdf")
    @ignore_bad_molecules()      # Skip unparseable structures
    @canonicalize()              # Standardize representation
    @convert_dative_bonds()      # Handle coordination bonds
    @add_properties(["formula", "MW", "atoms", "bonds"])
    @add_filename()              # Track original source
    @add_index()                 # Add unique identifiers
    @output_as("validated_structures.sdf", "sdf")
    @execute
end
```

### Duplicate Detection and Removal

```julia
# Advanced duplicate detection workflow
@chain begin
    @read_file("merged_database.sdf", "sdf")
    @canonicalize()              # Ensure consistent representation
    @remove_hydrogens()          # Compare without explicit H
    @set_atom_order_canonical()  # Standard atom ordering
    @remove_duplicate_mols()     # Remove exact duplicates
    @add_properties(["InChI"])   # Add InChI for further comparison
    @sort_by("MW")
    @output_as("deduplicated_database.sdf", "sdf")
    @execute
end
```

## Performance Optimization

### Processing Large Datasets Efficiently

```julia
# Efficient processing of large chemical databases
function process_large_database(input_file, output_file, start_idx=1, batch_size=10000)
    current_idx = start_idx
    batch_num = 1

    while true
        try
            @chain begin
                @read_file(input_file, "sdf")
                @start_with_index(current_idx)
                @ignore_bad_molecules()
                @add_properties(["MW", "logP"])
                @output_as("$(output_file)_batch_$(batch_num).sdf", "sdf")
                @execute
            end

            current_idx += batch_size
            batch_num += 1
        catch
            break  # End of file reached
        end
    end
end

# Usage
process_large_database("huge_database.sdf", "processed", 1, 5000)
```

### Memory-Efficient Processing

```julia
# Process files in chunks to manage memory usage
@chain begin
    @read_file("large_dataset.sdf", "sdf")
    @start_with_index(1)         # Start from beginning
    @ignore_bad_molecules()      # Skip problematic structures
    @gen_3D_coords("fast")       # Use fast method for efficiency
    @add_properties(["MW"])      # Minimal properties for speed
    @write_multiple_files()      # Separate files reduce memory
    @output_as("chunk", "sdf")   # Creates chunk1.sdf, chunk2.sdf, etc.
    @execute
end
```