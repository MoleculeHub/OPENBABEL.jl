export check_if_empty

function check_if_empty(input_file::String)
    if stat(input_file).size == 0
        throw(ArgumentError("Passed file $input_file is empty."))
    end
end
