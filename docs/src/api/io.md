# Core I/O Macros

These macros handle the fundamental input and output operations for molecular data files.

## File Input

```@docs
@read_file
```

## File Output

```@docs
@output_as
@write_multiple_files
```

## Pipeline Execution

```@docs
@execute
```

## Usage Examples

### Basic File Conversion

Convert SMILES to MOL format:

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @output_as("molecules.mol", "mol")
    @execute
end
```

### Multiple Output Files

Create separate files for each molecule:

```julia
@chain begin
    @read_file("database.sdf", "sdf")
    @write_multiple_files()
    @output_as("molecule", "mol")  # Creates molecule1.mol, molecule2.mol, etc.
    @execute
end
```

### Supported File Formats

The library supports all Open Babel file formats:

| Format | Extension | Description |
|--------|-----------|-------------|
| SMILES | `.smi` | Simplified molecular-input line-entry system |
| SDF | `.sdf` | Structure-data file |
| MOL | `.mol` | MDL Molfile |
| XYZ | `.xyz` | XYZ coordinate format |
| PDB | `.pdb` | Protein Data Bank format |

For a complete list, refer to the [Open Babel documentation](https://openbabel.org/docs/FileFormats/Overview.html).