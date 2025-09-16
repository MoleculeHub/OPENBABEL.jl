# Filtering & Matching Macros

These macros filter, sort, and manipulate molecular datasets based on structural patterns and properties.

## Match SMARTS String

```@docs
@match_smarts_string
```

### Usage Examples

Filter molecules containing benzene rings:

```julia
@chain begin
    @read_file("database.smi", "smi")
    @match_smarts_string("c1ccccc1")  # Aromatic benzene ring
    @output_as("benzene_compounds.smi", "smi")
    @execute
end
```

Common SMARTS patterns:

| Pattern | Description |
|---------|-------------|
| `c1ccccc1` | Benzene ring |
| `[OH]` | Hydroxyl group |
| `[NH2]` | Primary amine |
| `C=O` | Carbonyl group |
| `[#6]=[#8]` | Carbon double bonded to oxygen |
| `[R]` | Any atom in a ring |

## Don't Match SMARTS String

```@docs
@dont_match_smarts_string
```

### Usage Examples

Exclude molecules with specific functional groups:

```julia
@chain begin
    @read_file("compounds.smi", "smi")
    @dont_match_smarts_string("[OH]")  # Remove alcohols
    @output_as("no_alcohols.smi", "smi")
    @execute
end
```

## Sort By

```@docs
@sort_by
```

### Usage Examples

```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @add_properties(["MW"])
    @sort_by("MW")  # Ascending order
    @output_as("sorted_by_mw.sdf", "sdf")
    @execute
end
```

## Sort By Reverse

```@docs
@sort_by_reverse
```

### Usage Examples

Sort by logP in descending order:

```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @add_properties(["logP"])
    @sort_by_reverse("logP")  # Descending order
    @output_as("high_logp_first.sdf", "sdf")
    @execute
end
```

## Remove Duplicate Molecules

```@docs
@remove_duplicate_mols
```

### Usage Examples

Remove duplicate structures:

```julia
@chain begin
    @read_file("raw_data.smi", "smi")
    @remove_duplicate_mols()
    @output_as("unique_molecules.smi", "smi")
    @execute
end
```

## Convert Dative Bonds

```@docs
@convert_dative_bonds
```

### Usage Examples

Convert dative bonds to standard representation:

```julia
@chain begin
    @read_file("complexes.sdf", "sdf")
    @convert_dative_bonds()
    @output_as("converted_bonds.sdf", "sdf")
    @execute
end
```

## Remove Hydrogens

```@docs
@remove_hydrogens
```

### Usage Examples

Remove explicit hydrogens:

```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @remove_hydrogens()
    @output_as("implicit_h.sdf", "sdf")
    @execute
end
```

## Set Atom Order Canonical

```@docs
@set_atom_order_canonical
```

### Usage Examples

Standardize atom ordering:

```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @set_atom_order_canonical()
    @output_as("canonical_order.sdf", "sdf")
    @execute
end
```

## Separate Fragments

```@docs
@separate_fragments
```

### Usage Examples

Split salts and complexes:

```julia
@chain begin
    @read_file("salts.sdf", "sdf")
    @separate_fragments()
    @output_as("fragments.sdf", "sdf")
    @execute
end
```

## Ignore Bad Molecules

```@docs
@ignore_bad_molecules
```

### Usage Examples

Skip invalid molecular structures:

```julia
@chain begin
    @read_file("raw_data.smi", "smi")
    @ignore_bad_molecules()
    @output_as("valid_molecules.smi", "smi")
    @execute
end
```

## Start With Index

```@docs
@start_with_index
```

### Usage Examples

```julia
@chain begin
    @read_file("huge_database.sdf", "sdf")
    @start_with_index(1000)  # Begin from molecule 1000
    @add_properties(["MW", "logP"])
    @sort_by("MW")
    @output_as("subset_processed.sdf", "sdf")
    @execute
end
```

## Complete Workflows

### Data Cleaning Pipeline

```julia
@chain begin
    @read_file("raw_data.smi", "smi")
    @ignore_bad_molecules()      # Skip invalid molecules
    @remove_duplicate_mols()     # Remove duplicates
    @remove_hydrogens()          # Implicit hydrogens
    @set_atom_order_canonical()  # Standardize atom order
    @separate_fragments()        # Split salts/complexes
    @match_smarts_string("[!#1]")  # Keep non-hydrogen containing
    @output_as("cleaned_data.smi", "smi")
    @execute
end
```

### Structure-Based Filtering

```julia
@chain begin
    @read_file("compounds.smi", "smi")
    @match_smarts_string("c1ccccc1")     # Keep aromatic compounds
    @dont_match_smarts_string("[OH]")    # Remove alcohols
    @add_properties(["MW", "logP"])
    @sort_by_reverse("logP")
    @output_as("filtered_aromatics.sdf", "sdf")
    @execute
end
```