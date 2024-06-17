import Base: show, +, *, one

struct Nimber
    value::Int
end

show(io::IO, a::Nimber) = print(io, "⋆$(a.value)")

function ⋆(a::Int)
    Nimber(a)
end

function +(a::Nimber, b::Nimber)
    Nimber(a.value ⊻ b.value)
end