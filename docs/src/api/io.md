# Core I/O Macros

These macros handle the fundamental input and output operations for molecular data files.

## Read File

```@docs
@read_file
```

### Usage Examples

Basic file reading with format specification:

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @output_as("molecules.mol", "mol")
    @execute
end
```

## Output As

```@docs
@output_as
```

### Usage Examples

Convert and save to different formats:

```julia
# SMILES to SDF conversion
@chain begin
    @read_file("compounds.smi", "smi")
    @gen_3D_coords("fast")
    @output_as("compounds.sdf", "sdf")
    @execute
end

# Multiple format outputs
@chain begin
    @read_file("molecules.sdf", "sdf")
    @output_as("molecules.mol", "mol")
    @execute
end
```

## Write Multiple Files

```@docs
@write_multiple_files
```

### Usage Examples

```julia
@chain begin
    @read_file("database.sdf", "sdf")
    @write_multiple_files()
    @output_as("molecule", "mol")  # Creates molecule1.mol, molecule2.mol, etc.
    @execute
end
```

## Execute

```@docs
@execute
```

### Usage Examples

Execute the processing pipeline:

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @add_properties(["MW", "logP"])
    @output_as("processed.sdf", "sdf")
    @execute  # This executes the entire pipeline
end
```

## Supported File Formats

The library supports all Open Babel file formats:

| Format | Extension | Description |
|--------|-----------|-------------|
| SMILES | `.smi` | Simplified molecular-input line-entry system |
| SDF | `.sdf` | Structure-data file |
| MOL | `.mol` | MDL Molfile |
| XYZ | `.xyz` | XYZ coordinate format |
| PDB | `.pdb` | Protein Data Bank format |

For a complete list, refer to the [Open Babel documentation](https://openbabel.org/docs/FileFormats/Overview.html).

## Complete Workflows

### Basic File Conversion

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @output_as("molecules.mol", "mol")
    @execute
end
```

### Batch Processing with Multiple Outputs

```julia
@chain begin
    @read_file("database.sdf", "sdf")
    @write_multiple_files()
    @output_as("molecule", "mol")
    @execute
end
```