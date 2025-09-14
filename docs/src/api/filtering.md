# Filtering & Matching Macros

These macros filter, sort, and manipulate molecular datasets based on structural patterns and properties.

## Pattern Matching

```@docs
@match_smarts_string
@dont_match_smarts_string
```

## Sorting and Deduplication

```@docs
@sort_by
@sort_by_reverse
@remove_duplicate_mols
```

## Structural Modifications

```@docs
@convert_dative_bonds
@remove_hydrogens
@set_atom_order_canonical
@separate_fragments
```

## Data Processing

```@docs
@ignore_bad_molecules
@start_with_index
```

## Usage Examples

### SMARTS Pattern Filtering

Filter molecules containing benzene rings:

```julia
@chain begin
    @read_file("database.smi", "smi")
    @match_smarts_string("c1ccccc1")  # Aromatic benzene ring
    @output_as("benzene_compounds.smi", "smi")
    @execute
end
```

Exclude molecules with specific functional groups:

```julia
@chain begin
    @read_file("compounds.smi", "smi")
    @dont_match_smarts_string("[OH]")  # Remove alcohols
    @output_as("no_alcohols.smi", "smi")
    @execute
end
```

### Common SMARTS Patterns

| Pattern | Description |
|---------|-------------|
| `c1ccccc1` | Benzene ring |
| `[OH]` | Hydroxyl group |
| `[NH2]` | Primary amine |
| `C=O` | Carbonyl group |
| `[#6]=[#8]` | Carbon double bonded to oxygen |
| `[R]` | Any atom in a ring |

### Sorting by Properties

Sort molecules by molecular weight:

```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @add_properties(["MW"])
    @sort_by("MW")  # Ascending order
    @output_as("sorted_by_mw.sdf", "sdf")
    @execute
end
```

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

### Data Cleaning Workflow

Complete data cleaning and processing pipeline:

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

### Processing Large Datasets

Start processing from a specific molecule index:

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