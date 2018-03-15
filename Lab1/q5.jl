#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# modelo
m = Model(solver=GLPKSolverLP())

month = collect(1:5)
need = [30000, 20000, 40000, 10000, 50000]
cost = [65, 100, 135, 160, 190]

# variáveis
@variable(m, x[month,month] >= 0)

@objective(m, Min, sum(x[i,j]*cost[j] for i in month, j in month))
@constraints(m, begin
             [i in month], need[i] <= sum(x[i,j] for j in month) + sum(x[ai,aj] for ai=1:i-1, aj=5:-1:i-ai+1)
             end)

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

println("Custo total = $(getobjectivevalue(m)) reais.")
for i in month, j in month
    if getvalue(x[i,j]) > 0
        println("No dia $(i) compra $(getvalue(x[i,j])) metros quadrados por $(j) dias.")
    end
end
