using OpenBabel
using Test

@testset "OpenBabel.jl Tests" begin
    include("test_simple.jl")
    include("test_aqua.jl")
    include("test_macros.jl")

    println("🧹 Cleaning up temporary files...")
    temp_files = ["test_output.sdf", "test_properties.txt", "test_filtered.smi"]

    cleaned_count = 0
    for file in temp_files
        if isfile(file)
            rm(file; force=true)
            cleaned_count += 1
        end
    end

    # Also clean any files that match test pattern in current directory
    for file in readdir(".")
        if startswith(file, "test_") && (
            endswith(file, ".sdf") ||
            endswith(file, ".txt") ||
            endswith(file, ".smi") ||
            endswith(file, ".mol")
        )
            try
                rm(file; force=true)
                cleaned_count += 1
            catch
                # Ignore errors if file doesn't exist or can't be deleted
            end
        end
    end

    if cleaned_count > 0
        println("✅ Cleaned up $cleaned_count temporary files")
    end
end
