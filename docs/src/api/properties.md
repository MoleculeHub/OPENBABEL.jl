# Property & Coordinate Macros

These macros add molecular properties, generate coordinates, and modify molecular metadata.

## Add Properties

```@docs
@add_properties
```

### Usage Examples

Calculate common molecular descriptors:

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @add_properties(["MW", "logP", "TPSA", "HBD", "HBA"])
    @output_as("molecules_with_props.sdf", "sdf")
    @execute
end
```

Available properties include:
- `MW` - Molecular weight
- `logP` - Partition coefficient
- `TPSA` - Topological polar surface area
- `HBD` - Hydrogen bond donors
- `HBA` - Hydrogen bond acceptors
- `rotors` - Number of rotatable bonds
- `atoms` - Number of atoms
- `bonds` - Number of bonds

### Available Descriptors

The `get_available_descriptors()` function returns a list of all molecular descriptors that can be calculated:

```julia
descriptors = get_available_descriptors()
println(descriptors)
```

## Generate 3D Coordinates

```@docs
@gen_3D_coords
```

### Usage Examples

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
    @output_as("high_quality_3d.mol", "mol")
    @execute
end
```

## Generate 2D Coordinates

```@docs
@gen_2D_coords
```

### Usage Examples

Generate 2D coordinates for visualization:

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_2D_coords()
    @output_as("molecules_2d.sdf", "sdf")
    @execute
end
```

## Center Coordinates at Zero

```@docs
@center_coords_at_zero
```

### Usage Examples

Center molecular coordinates at the origin:

```julia
@chain begin
    @read_file("input.smi", "smi")
    @gen_3D_coords("slow")
    @center_coords_at_zero()
    @output_as("centered_3d.mol", "mol")
    @execute
end
```

## Add Filename

```@docs
@add_filename
```

### Usage Examples

Add the source filename as metadata:

```julia
@chain begin
    @read_file("database.sdf", "sdf")
    @add_filename()
    @output_as("molecules_with_filename.sdf", "sdf")
    @execute
end
```

## Add Index

```@docs
@add_index
```

### Usage Examples

Add molecule indices for tracking:

```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @add_index()
    @output_as("indexed_molecules.sdf", "sdf")
    @execute
end
```

## Add Title

```@docs
@add_title
```

### Usage Examples

```julia
@chain begin
    @read_file("molecules.sdf", "sdf")
    @add_title("Processed Database")
    @output_as("titled_molecules.sdf", "sdf")
    @execute
end
```

## Complete Workflows

### Property Calculation Pipeline

```julia
@chain begin
    @read_file("molecules.smi", "smi")
    @gen_3D_coords("med")
    @add_properties(["MW", "logP", "TPSA", "HBD", "HBA"])
    @add_index()
    @add_filename()
    @output_as("full_analysis.sdf", "sdf")
    @execute
end
```

### Coordinate Generation with Metadata

```julia
@chain begin
    @read_file("database.sdf", "sdf")
    @gen_3D_coords("slow")
    @center_coords_at_zero()
    @add_index()
    @add_filename()
    @add_title("High Quality 3D Structures")
    @output_as("processed_3d.sdf", "sdf")
    @execute
end
```