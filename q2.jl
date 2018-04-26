#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# modelo
m = Model(solver=GLPKSolverMIP())

n = 8

investimentos = [1, 2, 3, 4, 5, 6, 7]
lucro = Dict(zip(investimentos, [17,10,15,19,7,13,9]))
custo = Dict(zip(investimentos, [43,28,34,48,17,32,23]))

# variáveis
@variable(m, x[i in investimentos] >= 0, Bin)

@objective(m, Max, sum(x[i]*lucro[i] for i in investimentos))
@constraints(m, begin
             sum(x[i]*custo[i] for i in investimentos) <= 100
             x[1] + x[2] <= 1
             x[3] + x[4] <= 1
             -x[4] + x[1] + x[2] >= 0
             -x[3] + x[1] + x[2] >= 0
             end)

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

println("Lucro total = $(getobjectivevalue(m)) MR")
for i in investimentos
    if getvalue(x[i]) > 0
        println("Investir no investimento $(i)")
    end
end

for i=1:7
    println("$(i)")
end

