using OPENBABEL
using Test
using Aqua

@testset "Aqua Tests" begin
    Aqua.test_all(OPENBABEL)
end
