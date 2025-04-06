using Openbabel
using Test


@testset "Openbabel.jl" begin
    test_file = "./test/test_files/smiles_file.smi"

    valid_smiles_list = convert_molecule(test_file, "smi", "inchi")
    @test convert_molecule(test_file, "smi", "inchi") |> x -> isa(x, AbstractVector)
    @test convert_molecule(test_file, "smi", "inchi") |> x -> x[2] == "InChI=1S/C4H10/c1-3-4-2/h3-4H2,1-2H3"
end

test_file = "./test/test_files/smiles_file.smi"
a = convert_molecule(test_file, "smi", "mol")

