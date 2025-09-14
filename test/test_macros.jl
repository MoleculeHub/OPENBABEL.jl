using OpenBabel
using Test
using Chain

@testset "OpenBabel Macro Tests" begin
    @testset "Core I/O Macros" begin
        @testset "@read_file macro" begin
            # Test macro expansion
            cmd = @read_file("test_files/smiles_file.smi", "smi")
            @test cmd == "-ismi test_files/smiles_file.smi"

            cmd = @read_file("test_files/smiles_file.smi", "sdf")
            @test cmd == "-isdf test_files/smiles_file.smi"

            cmd = @read_file("test_files/smiles_file.smi", "mol")
            @test cmd == "-imol test_files/smiles_file.smi"
        end

        @testset "@output_as macro" begin
            # Test macro chaining
            base_cmd = "-ismi test_files/smiles_file.smi"
            cmd = @output_as(base_cmd, "output.mol", "mol")
            @test cmd == "-ismi test_files/smiles_file.smi -omol -O output.mol"

            cmd = @output_as(base_cmd, "output.sdf", "sdf")
            @test cmd == "-ismi test_files/smiles_file.smi -osdf -O output.sdf"

            cmd = @output_as(base_cmd, "output.xyz", "xyz")
            @test cmd == "-ismi test_files/smiles_file.smi -oxyz -O output.xyz"
        end
    end

    @testset "Property and Coordinate Macros" begin
        @testset "@add_properties macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            # Single property
            cmd = @add_properties(base_cmd, ["MW"])
            @test cmd == "-ismi test_files/smiles_file.smi --append MW"

            # Multiple properties
            cmd = @add_properties(base_cmd, ["MW", "logP", "TPSA"])
            @test cmd == "-ismi test_files/smiles_file.smi --append MW logP TPSA"

            # Empty properties array
            cmd = @add_properties(base_cmd, String[])
            @test cmd == "-ismi test_files/smiles_file.smi --append "
        end

        @testset "@gen_3D_coords macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @gen_3D_coords(base_cmd, "fast")
            @test cmd == "-ismi test_files/smiles_file.smi --gen3d"

            cmd = @gen_3D_coords(base_cmd, "med")
            @test cmd == "-ismi test_files/smiles_file.smi --gen3d"

            cmd = @gen_3D_coords(base_cmd, "slow")
            @test cmd == "-ismi test_files/smiles_file.smi --gen3d"
        end

        @testset "@gen_2D_coords macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @gen_2D_coords(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --gen2d"
        end

        @testset "@add_filename macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @add_filename(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --addfilename"
        end

        @testset "@add_index macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @add_index(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --addinindex"
        end

        @testset "@add_title macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @add_title(base_cmd, "My Title")
            @test cmd == "-ismi test_files/smiles_file.smi --addtotitle My Title"

            cmd = @add_title(base_cmd, "Complex Title With Spaces")
            @test cmd ==
                "-ismi test_files/smiles_file.smi --addtotitle Complex Title With Spaces"
        end

        @testset "@write_multiple_files macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @write_multiple_files(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi -m"
        end
    end

    @testset "Filtering and Matching Macros" begin
        @testset "@match_smarts_string macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            # Benzene ring
            cmd = @match_smarts_string(base_cmd, "c1ccccc1")
            @test cmd == "-ismi test_files/smiles_file.smi -s c1ccccc1"

            # Alcohol group
            cmd = @match_smarts_string(base_cmd, "[OH]")
            @test cmd == "-ismi test_files/smiles_file.smi -s [OH]"

            # Carbonyl group
            cmd = @match_smarts_string(base_cmd, "[#6]=[#8]")
            @test cmd == "-ismi test_files/smiles_file.smi -s [#6]=[#8]"
        end

        @testset "@dont_match_smarts_string macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @dont_match_smarts_string(base_cmd, "c1ccccc1")
            @test cmd == "-ismi test_files/smiles_file.smi -v c1ccccc1"

            cmd = @dont_match_smarts_string(base_cmd, "[OH]")
            @test cmd == "-ismi test_files/smiles_file.smi -v [OH]"
        end

        @testset "@sort_by macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @sort_by(base_cmd, "MW")
            @test cmd == "-ismi test_files/smiles_file.smi --sort MW"

            cmd = @sort_by(base_cmd, "logP")
            @test cmd == "-ismi test_files/smiles_file.smi --sort logP"

            cmd = @sort_by(base_cmd, "TPSA")
            @test cmd == "-ismi test_files/smiles_file.smi --sort TPSA"
        end

        @testset "@sort_by_reverse macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @sort_by_reverse(base_cmd, "MW")
            @test cmd == "-ismi test_files/smiles_file.smi --sort ~MW"

            cmd = @sort_by_reverse(base_cmd, "logP")
            @test cmd == "-ismi test_files/smiles_file.smi --sort ~logP"
        end

        @testset "@remove_duplicate_mols macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @remove_duplicate_mols(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --unique"
        end

        @testset "@center_coords_at_zero macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @center_coords_at_zero(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi -c"
        end

        @testset "@convert_dative_bonds macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @convert_dative_bonds(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi -b"
        end

        @testset "@ignore_bad_molecules macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @ignore_bad_molecules(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi -e"
        end

        @testset "@remove_hydrogens macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @remove_hydrogens(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi -d"
        end

        @testset "@set_atom_order_canonical macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @set_atom_order_canonical(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --canonical"
        end

        @testset "@separate_fragments macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @separate_fragments(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --separate"
        end

        @testset "@start_with_index macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @start_with_index(base_cmd, 1)
            @test cmd == "-ismi test_files/smiles_file.smi -f 1"

            cmd = @start_with_index(base_cmd, 10)
            @test cmd == "-ismi test_files/smiles_file.smi -f 10"

            cmd = @start_with_index(base_cmd, 100)
            @test cmd == "-ismi test_files/smiles_file.smi -f 100"
        end
    end

    @testset "Complex Chain Tests" begin
        @testset "Multiple operations chain" begin
            result = @chain begin
                @read_file("test_files/smiles_file.smi", "smi")
                @add_properties(["MW", "logP"])
                @sort_by("MW")
                @output_as("output.sdf", "sdf")
            end

            expected = "-ismi test_files/smiles_file.smi --append MW logP --sort MW -osdf -O output.sdf"
            @test result == expected
        end

        @testset "Filtering and processing chain" begin
            result = @chain begin
                @read_file("test_files/smiles_file.smi", "smi")
                @match_smarts_string("c1ccccc1")
                @remove_duplicate_mols()
                @gen_3D_coords("fast")
                @add_properties(["MW", "TPSA", "HBD", "HBA"])
                @sort_by_reverse("logP")
                @output_as("filtered_3d.sdf", "sdf")
            end

            expected = "-ismi test_files/smiles_file.smi -s c1ccccc1 --unique --gen3d --append MW TPSA HBD HBA --sort ~logP -osdf -O filtered_3d.sdf"
            @test result == expected
        end

        @testset "Complex processing pipeline" begin
            result = @chain begin
                @read_file("test_files/smiles_file.smi", "mol")
                @ignore_bad_molecules()
                @remove_hydrogens()
                @set_atom_order_canonical()
                @center_coords_at_zero()
                @add_index()
                @add_filename()
                @write_multiple_files()
                @output_as("processed", "sdf")
            end

            expected = "-imol test_files/smiles_file.smi -e -d --canonical -c --addinindex --addfilename -m -osdf -O processed"
            @test result == expected
        end
    end

    @testset "Edge Cases and Special Characters" begin
        @testset "File paths with spaces" begin
            result = @chain begin
                @read_file("test_files/smiles_file.smi", "smi")
                @output_as("output file.mol", "mol")
            end
            @test result == "-ismi test_files/smiles_file.smi -omol -O output file.mol"
        end

        @testset "Complex SMARTS patterns" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            # Complex aromatic pattern
            cmd = @match_smarts_string(base_cmd, "[#6]1:[#6]:[#6]:[#6]:[#6]:[#6]:1")
            @test cmd ==
                "-ismi test_files/smiles_file.smi -s [#6]1:[#6]:[#6]:[#6]:[#6]:[#6]:1"

            # Functional group with brackets
            cmd = @match_smarts_string(base_cmd, "[CH3][CH2][OH]")
            @test cmd == "-ismi test_files/smiles_file.smi -s [CH3][CH2][OH]"
        end

        @testset "Property names with special characters" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @add_properties(base_cmd, ["MW", "logP", "TPSA", "HB-A", "HB-D"])
            @test cmd == "-ismi test_files/smiles_file.smi --append MW logP TPSA HB-A HB-D"
        end

        @testset "Large index values" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @start_with_index(base_cmd, 999999)
            @test cmd == "-ismi test_files/smiles_file.smi -f 999999"
        end
    end

    @testset "Energy and Advanced Calculation Macros" begin
        @testset "@calculate_energy macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            # Test default forcefield
            cmd = @calculate_energy(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --energy --ff MMFF94"

            # Test specific forcefields
            cmd = @calculate_energy(base_cmd, "UFF")
            @test cmd == "-ismi test_files/smiles_file.smi --energy --ff UFF"

            cmd = @calculate_energy(base_cmd, "MMFF94s")
            @test cmd == "-ismi test_files/smiles_file.smi --energy --ff MMFF94s"
        end

        @testset "@minimize_energy macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            # Test default forcefield
            cmd = @minimize_energy(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --minimize --ff MMFF94"

            # Test specific forcefields
            cmd = @minimize_energy(base_cmd, "UFF")
            @test cmd == "-ismi test_files/smiles_file.smi --minimize --ff UFF"

            cmd = @minimize_energy(base_cmd, "GAFF")
            @test cmd == "-ismi test_files/smiles_file.smi --minimize --ff GAFF"
        end

        @testset "@add_partial_charges macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            # Test default method
            cmd = @add_partial_charges(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --partialcharge gasteiger"

            # Test specific methods
            cmd = @add_partial_charges(base_cmd, "mmff94")
            @test cmd == "-ismi test_files/smiles_file.smi --partialcharge mmff94"

            cmd = @add_partial_charges(base_cmd, "qeq")
            @test cmd == "-ismi test_files/smiles_file.smi --partialcharge qeq"
        end

        @testset "@canonicalize macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @canonicalize(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --canonical"
        end

        @testset "@generate_conformers macro" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            cmd = @generate_conformers(base_cmd)
            @test cmd == "-ismi test_files/smiles_file.smi --conformer"
        end

        @testset "Energy workflow chaining" begin
            # Test realistic energy workflow
            result = @chain begin
                @read_file("test_files/smiles_file.smi", "smi")
                @gen_3D_coords("fast")
                @minimize_energy("MMFF94")
                @calculate_energy("MMFF94")
                @output_as("energy_output.sdf", "sdf")
            end

            expected = "-ismi test_files/smiles_file.smi --gen3d --minimize --ff MMFF94 --energy --ff MMFF94 -osdf -O energy_output.sdf"
            @test result == expected
        end
    end

    @testset "New Descriptor Properties" begin
        @testset "Available descriptors utility" begin
            descriptors = get_available_descriptors()
            @test isa(descriptors, Vector{String})
            @test length(descriptors) > 15  # Should have many descriptors
            @test "MW" in descriptors
            @test "atoms" in descriptors
            @test "bonds" in descriptors
            @test "InChI" in descriptors
            @test "formula" in descriptors
            @test "HBA1" in descriptors
            @test "rotors" in descriptors
        end

        @testset "Extended properties usage" begin
            base_cmd = "-ismi test_files/smiles_file.smi"

            # Test with new descriptors
            cmd = @add_properties(base_cmd, ["atoms", "bonds", "rotors"])
            @test cmd == "-ismi test_files/smiles_file.smi --append atoms bonds rotors"

            cmd = @add_properties(base_cmd, ["InChI", "formula", "HBA1"])
            @test cmd == "-ismi test_files/smiles_file.smi --append InChI formula HBA1"

            cmd = @add_properties(base_cmd, ["abonds", "sbonds", "dbonds", "tbonds"])
            @test cmd ==
                "-ismi test_files/smiles_file.smi --append abonds sbonds dbonds tbonds"
        end
    end
end
