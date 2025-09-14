using OpenBabel
using Test
using Aqua

@testset "Aqua Tests" begin
    Aqua.test_all(OpenBabel)
end
