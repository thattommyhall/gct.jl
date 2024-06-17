import Base: show, +, *

struct Game{T}
    L::Set{T}
    R::Set{T}
end

function stringify(items)
    representations = [repr(i) for i in items]
    join(representations, " ")
end

function show(io::IO, g::Game)
    print(io, "{ $(stringify(g.L)) | $(stringify(g.R)) }")
end

Game(L::Vector{T}, R::Vector{T}) where {T} = Game(Set(L), Set(R))

function is_game_literal(any)
    false
end

function is_game_literal(exp::Expr)
    exp.head == :bracescat || exp.head == :braces
end

function transform_game_literal(exp)
    if exp.head == :braces
        # typeof(exp.args[1]) == Expr
        left = [exp.args[1].args[2]]
        right = [exp.args[1].args[3]]
    elseif exp.head == :bracescat
        left = []
        right = []
        current = left
        for el in exp.args[1].args
            if typeof(el) == Expr
                # el.args[1] == :|
                push!(current, el.args[2])
                current = right
                push!(current, el.args[3])
            else
                push!(current, el)
            end
        end
    end

    :(Game($left, $right))
end

function replace(any)
end

function +(g::Game, h::Game)
    42
end

function +(g::Game, n::Number)
    42
end

function *(g::Game, n::Number)
    42
end

function *(n::Number, g::Game)
    42
end

function replace(exp::Expr)
    if is_game_literal(exp)
        transform_game_literal(exp)
    else
        for (idx, arg) in enumerate(exp.args)
            if is_game_literal(arg)
                exp.args[idx] = transform_game_literal(arg)
            end
        end
        for arg in exp.args
            replace(arg)
        end
    end
end

macro cgt(exp)
    replace(exp)
    return exp
end


a = :({1 2 3|4 5 6} + 3 + 2 / 4 - 2 * {1 | 0})
Meta.show_sexpr(a)
replace(a)
a

@macroexpand @cgt {1 2 3|2 4} + {0 | 0}


@cgt {1 2 3|2 4} + {0 | 0}

@cgt {1 2 3|4 5 6} + 3 + 2 / 4 - 2 * {1 | 0}

