# Add parent::Int here to avoid overwritting same method in JuMP. Should be safe.
function JuMP.parseNLExpr_runtime(m::JuMP.Model, x::JuMP.Variable, tape, parent::Int, values)
    # @show m
    # @show parent
    # @show JuMP.getName(x)
    # @show x.col
    # @show tape
    # @show parent
    # @show values

    JuMP.__last_model[1] = x.m
    if x.m === m
        push!(tape, JuMP.NodeData(ReverseDiffSparse.VARIABLE, x.col, parent))
    else
        othermap = getStochastic(m).othermap
        if haskey(othermap, x)
            newx = othermap[x]
        else
            newx = JuMP.Variable(m,JuMP.getLower(x),JuMP.getUpper(x),:Cont, JuMP.getName(x))
            othermap[x] = newx  #parent -> dummy parent in the child node
            @show x.col, "-->",newx.col
        end
        push!(tape, JuMP.NodeData(ReverseDiffSparse.VARIABLE, newx.col, parent))
    end
    nothing
end

function JuMP.parseNLExpr_runtime(m::JuMP.Model, x::Vector{JuMP.Variable}, tape, parent::Int, values)
    # @show x, typeof(x)
    for xi in x
        # @show xi
        JuMP.parseNLExpr_runtime(m, xi, tape, parent, values)
    end
end