include("../dyadic.jl")

using Random:
    AbstractRNG

using Test:
    @testset,
    @test

import JCheck:
    @quickcheck,
    @add_predicate,
    Quickcheck,
    generate,
    specialcases

import .DyadicRationals: DyadicRational

specialcases(::Type{DyadicRational}) = DyadicRational[
    DyadicRationals.ZERO,
# DyadicRationals.POSITIVE_INFINITY,
# DyadicRationals.NEGATIVE_INFINITY
]

function randomDyadic(rng::AbstractRNG)
    numerator = rand(rng, -1000000:1000000)
    denominator = 2^rand(rng, 0:10)
    DyadicRational(numerator, denominator)
end

function generate(rng::AbstractRNG, ::Type{DyadicRational}, n::Int)
    [randomDyadic(rng) for _ in 1:n]
end


@testset verbose = true "Dyadic Arithmetic" begin
    qc = Quickcheck("Dyadic Arithmetic")

    @add_predicate qc "Addition Commutes" (a::DyadicRational, b::DyadicRational) -> begin
        a + b == b + a
    end

    @add_predicate qc "Multiplication Commutes" (a::DyadicRational, b::DyadicRational) -> begin
        a * b == b * a
    end

    @add_predicate qc "Adding Inverse is same as subtraction" (a::DyadicRational, b::DyadicRational) -> begin
        a - b == a + -b
    end

    @add_predicate qc "Distributes" (a::DyadicRational, b::DyadicRational, c::DyadicRational) -> begin
        a * (b + c) == (a * b) + (a * c)
    end

    @quickcheck qc
end



@testset verbose = true "Hashcodes" begin
    @test hash(DyadicRational(1, 2)) == hash(DyadicRational(1, 2))
    @test hash(DyadicRational(2, 4)) == hash(DyadicRational(1, 2))
end