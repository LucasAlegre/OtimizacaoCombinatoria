#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# modelo
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x1 >= 0)
@variable(m, x2 >= 0)

@objective(m, Max, 3*x1 + 5*x2)
@constraints(m, begin 
             x1 <= 4
             2*x2 <= 12
             3*x1 + 2*x2 <= 18
             end)

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

println("Numero de lotes do produto 1: $(getvalue(x1))")
println("Numero de lotes do produto 2: $(getvalue(x2))")
