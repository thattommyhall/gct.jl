include("nimbers.jl")
include("dyadic.jl")
import .DyadicRationals: DyadicRational

import Base: +, -, *, ==, inv, /, //, ceil, floor, hash, getproperty, length, iterate, zero

struct CanonicalGame
    L::Vector{CanonicalGame}
    R::Vector{CanonicalGame}
    birthday::Int
end

CanonicalGame([], [], 4)

ZERO = CanonicalGame([], [], 0)

# fromOptions
function CanonicalGame(L::Vector{CanonicalGame}, R::Vector{CanonicalGame})
    birthday = max(length(L) == 0 ? -1 : last(L).birthday, length(R) == 0 ? -1 : last(R).birthday) + 1
    CanonicalGame(L, R, birthday)
end

function CanonicalGame(L::Vector, R::Vector)
    birthday = max(length(L) == 0 ? -1 : last(L).birthday, length(R) == 0 ? -1 : last(R).birthday) + 1
    CanonicalGame(L, R, birthday)
end


# fromInteger
function CanonicalGame(number::Int)
    if number == 0
        ZERO
    elseif number > 0
        CanonicalGame([CanonicalGame(number - 1)], [], number)
    else
        CanonicalGame([], [CanonicalGame(number + 1)], -number)
    end
end

iszero(g::CanonicalGame) = length(g.L) == 0 && length(g.R) == 0
zero(g::CanonicalGame) = ZERO

iszero(ZERO)

function show(io::IO, a::CanonicalGame)
    if iszero(g)
        print(io, "0")
    else
        print(io, "{$(join([repr(l) for l ∈ a.L], " ")) | $(join([repr(l) for l ∈ a.R], " "))}")
    end
end


CanonicalGame(number::DyadicRational) = CanonicalGame(number, 0, 0) # to-do, correct birthday

# CanonicalGame(1, 1, 1) + CanonicalGame(1, 1, 1) = CanonicalGame(2, 2, 2)


CanonicalGame(n::Int, upMultiple::Int, nimber::Int) = CanonicalGame(DyadicRational(n), upMultiple, nimber)

# fromNumberUpStar
function CanonicalGame(number::DyadicRational, upMultiple::Int, nimber::Int)
    if upMultiple == 0 && nimber == 0
        # Just a number
        if number.denominator == 1
            return CanonicalGame(number.numerator)
        else
            l = CanonicalGame(DyadicRational(number.numerator - 1, number.denominator), 0, 0)
            r = CanonicalGame(DyadicRational(number.numerator + 1, number.denominator), 0, 0)
            birthday = max(l.birthday, r.birthday) + 1
            return CanonicalGame([l], [r], birthday)
        end
    elseif upMultiple == 0
        # A number plus a nimber.  First get the next lower nimber.
        h = CanonicalGame(number, 0, nimber - 1)
        L = copy(h.L)
        R = L
        push!(L, h) = h
        birthday = h.birthday + 1
        return CanonicalGame(L, R, birthday)
    elseif upMultiple == 1 && nimber == 1
        # ^* needs to be handled as a special case.
        n = CanonicalGame(number, 0, 0)
        n_star = CanonicalGame(number, 0, 1)
        L = [n, n_star]
        R = [n]
        birthday = n_star.birthday + 1
        return CanonicalGame(L, R, birthday)
    elseif upMultiple == -1 && nimber == 1
        # Likewise with v*
        n = CanonicalGame(number, 0, 0)
        n_star = CanonicalGame(number, 0, 1)
        L = [n]
        R = [n, n_star]
        g.birthday = n_star.birthday + 1
        return CanonicalGame(L, R, birthday)
    elseif upMultiple > 0
        L = [CanonicalGame(number, 0, 0)]
        R = [CanonicalGame(number, upMultiple - 1, nimber + 1)]
        birthday = R[1].birthday + 1
        return CanonicalGame(L, R, birthday)
    end
end

function +(x::CanonicalGame, y::CanonicalGame)
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

g = CanonicalGame(DyadicRational(1 // 2), 0, 0)
g.L
g.R

g + g

ZERO
