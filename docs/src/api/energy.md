# Energy & Advanced Calculation Macros

These macros perform energy calculations, geometry optimizations, and advanced molecular computations.

## Calculate Energy

```@docs
@calculate_energy
```

### Usage Examples

Calculate energy using different force fields:

```julia
# MMFF94 forcefield (default)
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @calculate_energy("MMFF94")
    @output_as("energies.sdf", "sdf")
    @execute
end

# UFF forcefield
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("med")
    @calculate_energy("UFF")
    @output_as("uff_energies.sdf", "sdf")
    @execute
end
```

Energy ranking workflow:

```julia
@chain begin
    @read_file("conformers.sdf", "sdf")
    @calculate_energy("MMFF94")
    @sort_by("Energy")  # Sort by ascending energy (most stable first)
    @output_as("energy_ranked.sdf", "sdf")
    @execute
end
```

## Minimize Energy

```@docs
@minimize_energy
```

### Usage Examples

```julia
# MMFF94 forcefield (default)
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @minimize_energy("MMFF94")
    @output_as("optimized.sdf", "sdf")
    @execute
end

# UFF forcefield
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("med")
    @minimize_energy("UFF")
    @output_as("uff_optimized.sdf", "sdf")
    @execute
end
```

Complete energy minimization workflow:

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @minimize_energy("MMFF94")
    @calculate_energy("MMFF94")
    @output_as("optimized.sdf", "sdf")
    @execute
end
```

## Add Partial Charges

```@docs
@add_partial_charges
```

### Usage Examples

```julia
# Gasteiger charges (default)
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @add_partial_charges("gasteiger")
    @output_as("charged_molecules.sdf", "sdf")
    @execute
end

# MMFF94 charges
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("fast")
    @add_partial_charges("mmff94")
    @output_as("mmff_charges.sdf", "sdf")
    @execute
end
```

Available charge methods:

| Method | Description | Accuracy | Speed |
|--------|-------------|----------|-------|
| `gasteiger` | Gasteiger-Marsili | Medium | Fast |
| `mmff94` | MMFF94 charges | High | Medium |
| `qeq` | QEq charges | Medium | Fast |
| `eqeq` | EQEq charges | Medium | Fast |
| `eem` | Electronegativity Equalization | Medium | Medium |

## Canonicalize

```@docs
@canonicalize
```

### Usage Examples

Standardize molecular representation:

```julia
@chain begin
    @read_file("compounds.smi", "smi")
    @canonicalize()
    @output_as("canonical_structures.smi", "smi")
    @execute
end
```

## Generate Conformers

```@docs
@generate_conformers
```

### Usage Examples

Generate multiple conformations:

```julia
@chain begin
    @read_file("flexible_molecules.smi", "smi")
    @gen_3D_coords("med")
    @generate_conformers()
    @minimize_energy("MMFF94")
    @output_as("conformers.sdf", "sdf")
    @execute
end
```

## Available Forcefields

| Forcefield | Description | Best for |
|------------|-------------|----------|
| `MMFF94` | Merck Molecular Force Field | General organic molecules |
| `MMFF94s` | MMFF94 static | Static conformations |
| `UFF` | Universal Force Field | Broad chemical space |
| `GAFF` | General AMBER Force Field | Drug-like molecules |
| `Ghemical` | Ghemical Force Field | Quick calculations |

## Complete Workflows

### Comprehensive Energy Calculation Pipeline

```julia
@chain begin
    @read_file("compounds.smi", "smi")
    @gen_3D_coords("slow")           # High-quality 3D structures
    @canonicalize()                  # Standardize representation
    @minimize_energy("MMFF94")       # Optimize geometry
    @add_partial_charges("mmff94")   # Add partial charges
    @calculate_energy("MMFF94")      # Calculate final energy
    @add_properties(["MW", "logP"])  # Add additional properties
    @sort_by("Energy")               # Sort by energy
    @output_as("energy_ranked.sdf", "sdf")
    @execute
end
```

### Drug Discovery Pipeline

```julia
@chain begin
    @read_file("drug_candidates.smi", "smi")
    @ignore_bad_molecules()          # Skip invalid structures
    @gen_3D_coords("med")            # Generate 3D coordinates
    @minimize_energy("MMFF94")       # Energy minimization
    @add_partial_charges("gasteiger") # Add charges
    @add_properties(["MW", "logP", "TPSA", "HBD", "HBA", "rotors"])
    @match_smarts_string("[!Pb;!Hg;!As]")  # Remove toxic elements
    @sort_by_reverse("logP")         # Rank by lipophilicity
    @output_as("optimized_candidates.sdf", "sdf")
    @execute
end
```