# Property & Coordinate Macros

These macros add molecular properties, generate coordinates, and modify molecular metadata.

## Property Calculation

```@docs
@add_properties
```

### Available Descriptors

The `get_available_descriptors()` function returns a list of all molecular descriptors that can be calculated. If this function is not yet implemented, refer to the Open Babel documentation for available descriptors.

## Coordinate Generation

```@docs
@gen_3D_coords
@gen_2D_coords
@center_coords_at_zero
```

## Metadata Addition

```@docs
@add_filename
@add_index
@add_title
```

## Usage Examples

### Adding Molecular Properties

Calculate common molecular descriptors:

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @add_properties(["MW", "logP", "TPSA", "HBD", "HBA"])
    @output_as("molecules_with_props.sdf", "sdf")
    @execute
end
```

### Available Properties

Get a list of all available descriptors:

```julia
descriptors = get_available_descriptors()
println(descriptors)
```

Common properties include:
- `MW` - Molecular weight
- `logP` - Partition coefficient
- `TPSA` - Topological polar surface area
- `HBD` - Hydrogen bond donors
- `HBA` - Hydrogen bond acceptors
- `rotors` - Number of rotatable bonds
- `atoms` - Number of atoms
- `bonds` - Number of bonds

### 3D Coordinate Generation

Generate 3D structures with different quality levels:

```julia
# Fast generation (good for large datasets)
@chain begin
    @read_file("input.smi", "smi")
    @gen_3D_coords("fast")
    @output_as("output_3d.mol", "mol")
    @execute
end

# Higher quality (slower)
@chain begin
    @read_file("input.smi", "smi")
    @gen_3D_coords("slow")
    @center_coords_at_zero()
    @output_as("centered_3d.mol", "mol")
    @execute
end
```

### Adding Metadata

Add indices and filenames to track molecule origins:

```julia
@chain begin
    @read_file("database.sdf", "sdf")
    @add_index()
    @add_filename()
    @add_title("Processed Database")
    @output_as("indexed_molecules.sdf", "sdf")
    @execute
end
```