#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# modelo
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, na >= 0)
@variable(m, nb >= 0)
@variable(m, nc >= 0)
@variable(m, xa)
@variable(m, xb)
@variable(m, xc)

@objective(m, Max, na + nb + nc)
@constraints(m, begin
             xa + xb + xc == 100
             na == (6 + (xa/10))/2
             nb == (7 + (2*xb/10))/2
             nc == (10 + (3*xc/10))/2
             na >= 5
             nb >= 5
             nc >= 5
             na <= 10
             nb <= 10
             nc <= 10
             end)

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

println("Na + Nb + Nc == $(getobjectivevalue(m))")
println("Nota A = $(getvalue(na)) Nota B = $(getvalue(nb)) Nota C = $(getvalue(nc))")
println("Horas de estudo disciplina A = $(getvalue(xa))")
println("Horas de estudo disciplina B = $(getvalue(xb))")
println("Horas de estudo disciplina C = $(getvalue(xc))")
