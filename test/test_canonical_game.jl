include("../canonical_game.jl")
using Random: AbstractRNG

using Test:
    @testset,
    @test

import JCheck:
    @quickcheck,
    @add_predicate,
    Quickcheck,
    generate,
    specialcases