# OpenBabel.jl

A Julia library for reading, writing, and transforming chemical data, powered by [Open Babel](https://github.com/openbabel/openbabel).

## Installation

```julia
using Pkg
Pkg.add("OpenBabel")
```

## Quick Start

```julia
using OpenBabel
using Chain

# Write some random molecules to a file
open("./test_input.smi", "w") do io
    write(io, "CC(=O)NC1=CC=C(C=C1)O\n")
    write(io, "Cn1cnc2c1c(=O)n(c(=O)n2C)\n")
    write(io, "c1ccc(cc1)[N+](=O)[O-]\n")
end

# Convert and process molecules
@chain begin
    @read_file("./test_input.smi", "smi")
    @output_as("out.mol", "mol")
    @gen_3D_coords("fast")
    @sort_by("logP")
    @add_properties(["MW"])
    @execute
end
```

## Core Concepts

OpenBabel.jl provides a macro-based API that chains operations together, replicating Open Babel's command-line functionality:

```bash
obabel -iformat_1 file_1 -oformat_2 -O file_2 -arg_1 ... -arg_n
```

Each macro corresponds to a specific Open Babel operation and can be combined using Julia's `@chain` macro for readable, pipeline-style molecular data processing.
