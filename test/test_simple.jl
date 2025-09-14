using OpenBabel
using Test
using Chain

@testset "Simple Chain Execution Tests" begin
    @testset "Basic File Conversion" begin
        isfile("test_output.sdf") && rm("test_output.sdf")

        @chain begin
            @read_file("test_files/smiles_file.smi", "smi")
            @gen_3D_coords("fast")
            @output_as("test_output.sdf", "sdf")
            @execute
        end

        @test isfile("test_output.sdf")

        @test filesize("test_output.sdf") > 0

        rm("test_output.sdf"; force=true)
    end

    @testset "Properties Chain" begin
        isfile("test_properties.txt") && rm("test_properties.txt")

        # Run properties chain
        @chain begin
            @read_file("test_files/smiles_file.smi", "smi")
            @add_properties(["MW", "logP"])
            @output_as("test_properties.txt", "txt")
            @execute
        end

        # Verify output file was created
        @test isfile("test_properties.txt")

        # Verify file has content
        @test filesize("test_properties.txt") > 0

        # Read and verify content has property data
        content = read("test_properties.txt", String)
        @test !isempty(content)

        # Clean up
        rm("test_properties.txt"; force=true)
    end

    # Test filtering chain
    @testset "Filtering Chain" begin
        # Clean up any existing output
        isfile("test_filtered.smi") && rm("test_filtered.smi")

        # Run filtering chain (match anything with carbon)
        @chain begin
            @read_file("test_files/smiles_file.smi", "smi")
            @match_smarts_string("C")
            @output_as("test_filtered.smi", "smi")
            @execute
        end

        # Verify output file was created
        @test isfile("test_filtered.smi")

        # Clean up
        rm("test_filtered.smi"; force=true)
    end

    # Test utility functions work
    @testset "Utility Functions" begin
        # Test format support
        formats = get_supported_formats()
        @test isa(formats, Vector{String})
        @test "smi" in formats
        @test "sdf" in formats

        # Test descriptors
        descriptors = get_available_descriptors()
        @test isa(descriptors, Vector{String})
        @test "MW" in descriptors

        # Test molecule counting
        count = count_molecules("test_files/smiles_file.smi", "smi")
        @test count >= 0
    end
end
