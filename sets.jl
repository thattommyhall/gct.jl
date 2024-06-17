function is_set_literal(any)
    false
end

function is_set_literal(exp::Expr)
    exp.head == :bracescat || exp.head == :braces
end

function replace(any)
end


function replace(exp::Expr)
    for (idx, arg) in enumerate(exp.args)
        if is_set_literal(arg)
            elements = elements_from_set_literal(arg)
            exp.args[idx] = :(Set($elements))
        end
    end
    for arg in exp.args
        replace(arg)
    end
end

function elements_from_set_literal(literal)
    literal.args[1].args
end

macro set_expression(exp)
    replace(exp)
    return eval(exp)
end

eg = :({1 2 3} ∪ {4 5 6})

replace(eg)

eg