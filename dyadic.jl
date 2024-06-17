module DyadicRationals
import Base: +, -, *, ==, inv, /, //, ceil, floor, hash, getproperty

struct DyadicRational
    value::Rational

    function DyadicRational(numerator::Integer, denominator::Integer)
        if !ispow2(denominator)
            error("The denominator must be a power of 2.")
        end
        new(numerator // denominator)
    end

    function DyadicRational(value::Rational)
        if !ispow2(value.den)
            error("The denominator must be a power of 2.")
        end
        new(value)
    end

    function DyadicRational(n::Integer)
        new(n // 1)
    end
end

function Base.getproperty(d::DyadicRational, s::Symbol)
    if s == :num || s == :numerator
        return d.value.num
    elseif s == :den || s == :denominator
        return d.value.den
    else
        return getfield(d, s)
    end
end


ZERO = DyadicRational(0 // 1)
# POSITIVE_INFINITY = DyadicRational(1 // 0)
# NEGATIVE_INFINITY = DyadicRational(-1 // 0)

a::DyadicRational == b::DyadicRational = a.value == b.value
d::DyadicRational * a::DyadicRational = DyadicRational(d.value * a.value)
d::DyadicRational + a::DyadicRational = DyadicRational(d.value + a.value)
d::DyadicRational - a::DyadicRational = DyadicRational(d.value - a.value)

hash(a::DyadicRational) = hash(a.value)

isless(d::DyadicRational, a::DyadicRational) = d.value < a.value

isInteger(d::DyadicRational) = d.den == 1
isInfinite(d::DyadicRational) = d.den == 0

-(d::DyadicRational) = DyadicRational(-d.value)

end