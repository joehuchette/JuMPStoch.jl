using StructJuMP, JuMP

firststage = StructuredModel()
@variable(firststage, x[1:2])
@setNLObjective(firststage, Min, (x[1]+x[2])^2)
@addNLConstraint(firststage, x[1] * x[2] == 10)

for scen in 1:2
    bl = StructuredModel(parent=firststage)
    @variable(bl, y)
    @constraint(bl, x[2]^2 + x[1]*y ≤ 5)
    @setNLObjective(bl, Min, (x[1]+x[2])*y)
end

solve(firststage)
