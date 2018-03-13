#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# modelo
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x1 >= 0) # pães para baurus
@variable(m, x2 >= 0) # baurus

@objective(m, Max, 10*x1 + 20*x2)
@constraints(m, begin
             0.1*x1 + 0.1*x2 <= 200    
             0.125*x2 <= 800
             2*x1 + 3*x2 <= 5*40*60
             end)

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

println("Numero pães para baurus: $(getvalue(x1))")
println("Numero baurus: $(getvalue(x2))")
