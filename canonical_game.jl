include("nimbers.jl")
include("dyadic.jl")
import .DyadicRationals: DyadicRational

import Base: +, -, *, ==, inv, /, //, ceil, floor, hash, getproperty, length, iterate, zero

struct NumberUpStar
    n::DyadicRational
    u::Int
    s::Int
end

+(a::NumberUpStar, b::NumberUpStar) = NumberUpStar(a.n + b.n, a.u + b.u, a.s + b.s)

NumberUpStar(n::Integer, u::Int, s::Int) = NumberUpStar(DyadicRational(n // 1), u, s)
struct CanonicalGame
    L::Vector{CanonicalGame}
    R::Vector{CanonicalGame}
    birthday::Int
    nus::Union{NumberUpStar,Nothing}
end

CanonicalGame(L::Vector, R::Vector, birthday::Int) = CanonicalGame(L, R, birthday, nothing)

CanonicalGame([], [], 4)

ZERO = CanonicalGame([], [], 0)

# fromOptions
# function CanonicalGame(L::Vector{CanonicalGame}, R::Vector{CanonicalGame})
#     birthday = max(length(L) == 0 ? -1 : last(L).birthday, length(R) == 0 ? -1 : last(R).birthday) + 1
#     CanonicalGame(L, R, birthday)
# end

function CanonicalGame(L::Vector, R::Vector)
    @assert all(x -> typeof(x) == CanonicalGame, L)
    @assert all(x -> typeof(x) == CanonicalGame, R)
    birthday = max(length(L) == 0 ? -1 : last(L).birthday, length(R) == 0 ? -1 : last(R).birthday) + 1
    CanonicalGame(L, R, birthday)
end


# fromInteger
function CanonicalGame(number::Int)
    nus = NumberUpStar(number, 0, 0)
    if number == 0
        ZERO
    elseif number > 0
        CanonicalGame([CanonicalGame(number - 1)], [], number, nus)
    else
        CanonicalGame([], [CanonicalGame(number + 1)], -number, nus)
    end
end

iszero(g::CanonicalGame) = length(g.L) == 0 && length(g.R) == 0
zero(g::CanonicalGame) = ZERO

iszero(ZERO)

function show(io::IO, g::CanonicalGame)
    if iszero(g)
        print(io, "0")
    else
        print(io, "{$(join([repr(l) for l ∈ g.L], " ")) | $(join([repr(l) for l ∈ g.R], " "))}")
    end
end

CanonicalGame(number::DyadicRational) = CanonicalGame(number, 0, 0) # to-do, correct birthday

CanonicalGame(n::Int, upMultiple::Int, nimber::Int) = CanonicalGame(DyadicRational(n), upMultiple, nimber)

# fromNumberUpStar
function CanonicalGame(number::DyadicRational, upMultiple::Int, nimber::Int)
    nus = NumberUpStar(number, upMultiple, nimber)
    if upMultiple == 0 && nimber == 0
        # Just a number
        if number.denominator == 1
            return CanonicalGame(number.numerator)
        else
            l = CanonicalGame(DyadicRational(number.numerator - 1, number.denominator), 0, 0)
            r = CanonicalGame(DyadicRational(number.numerator + 1, number.denominator), 0, 0)
            birthday = max(l.birthday, r.birthday) + 1
            return CanonicalGame([l], [r], birthday, nus)
        end
    elseif upMultiple == 0
        # A number plus a nimber.  First get the next lower nimber.
        h = CanonicalGame(number, 0, nimber - 1)
        L = copy(h.L)
        R = L
        push!(L, h) = h
        birthday = h.birthday + 1
        return CanonicalGame(L, R, birthday, nus)
    elseif upMultiple == 1 && nimber == 1
        # ^* needs to be handled as a special case.
        n = CanonicalGame(number, 0, 0)
        n_star = CanonicalGame(number, 0, 1)
        L = [n, n_star]
        R = [n]
        birthday = n_star.birthday + 1
        return CanonicalGame(L, R, birthday, nus)
    elseif upMultiple == -1 && nimber == 1
        # Likewise with v*
        n = CanonicalGame(number, 0, 0)
        n_star = CanonicalGame(number, 0, 1)
        L = [n]
        R = [n, n_star]
        g.birthday = n_star.birthday + 1
        return CanonicalGame(L, R, birthday, nus)
    elseif upMultiple > 0
        L = [CanonicalGame(number, 0, 0)]
        R = [CanonicalGame(number, upMultiple - 1, nimber + 1)]
        birthday = R[1].birthday + 1
        return CanonicalGame(L, R, birthday, nus)
    end
end

function +(x::CanonicalGame, y::CanonicalGame)
    if !isnothing(x.nus) && !isnothing(y.nus)
        println("FAST +")
        nus_sum = x.nus + y.nus
        return CanonicalGame(nus_sum.n, nus_sum.u, nus_sum.s)
    end

    L1 = x.L .+ y
    L2 = y.L .+ x
    L = [L1; L2]
    R1 = x.R .+ y
    R2 = y.R .+ x
    R = [R1; R2]
    CanonicalGame(L, R)
end

length(g::CanonicalGame) = 1

iterate(g::CanonicalGame) = (g, nothing)
iterate(g::CanonicalGame, n::Nothing) = nothing

function ==(g::CanonicalGame, h::CanonicalGame)

end

show([CanonicalGame(DyadicRational(1 // n), 0, 0).birthday for n ∈ [2 4 8 16]])

CanonicalGame(n::Rational, u::Int, s::Int) = CanonicalGame(DyadicRational(n), u, s)

g = CanonicalGame(1, 0, 0)
g.L
g.R

println(g + g)


