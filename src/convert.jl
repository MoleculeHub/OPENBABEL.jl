export convert_molecule

function make_obabel_cmd(input_file::String,
        input_format::String,
        output_format::String)
    cmd = addenv(
        `$(obabel()) -i$input_format $input_file -o$output_format`,
        "BABEL_LIBDIR" => LIBDIR,
        "BABEL_DATADIR" => DATADIR
    )
    return cmd
end

function convert_molecule(input_file::String,
        input_format::String,
        output_format::String,
        io::IOBuffer = IOBuffer())
    
    if !ispath(input_file)
        throw(ArgumentError("Input file $input_file does not exist"))
    end
    
    @chain input_file begin 
        make_obabel_cmd(_, input_format, output_format)
        pipeline(_, stdout = io, stderr = devnull)
        run
    end

    out = @chain take!(io) begin
        String
        split(_, r"\s+")
    end

    return out[1:end-1]
end
