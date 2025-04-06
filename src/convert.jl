export convert_molecule

function make_obabel_cmd(input::String,
        input_format::String,
        output_format::String)
    cmd = addenv(
        `$(obabel()) -i$input_format $input -o$output_format`,
        "BABEL_LIBDIR" => LIBDIR,
        "BABEL_DATADIR" => DATADIR
    )
    return cmd
end

function convert_molecule(input::String,
        input_format::String,
        output_format::String,
        io::IOBuffer = IOBuffer())
    cmd = input |>
          x -> make_obabel_cmd(x, input_format, output_format) |>
               x -> pipeline(x, stdout = io, stderr = devnull) |>
                    run
    out = take!(io) |> 
            String  |> 
            x -> split(x, r"\s+")
    return out 
end
