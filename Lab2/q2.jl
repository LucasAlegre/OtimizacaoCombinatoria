#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# modelo
m = Model(solver=GLPKSolverMIP())

n = 8

# variáveis
@variable(m, d[1:n, 1:n], Bin)

@objective(m, Max, 0)
@constraint(m, sum(d[i,j] for i in 1:n, j in 1:n) == n)
for i=1:n, j=1:n, i2=1:n, j2=1:n
    if i != i2 || j != j2
        if i-j == i2-j2 || i+j == i2+j2 || i == i2 || j == j2
            @constraint(m, d[i,j] + d[i2,j2] <= 1)
        end
    end
end

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

for i=1:n
    println("$(getvalue(d[i,:]))")
end
