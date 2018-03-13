#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# conjuntos de óleos: 1,2=vegetais, 3,4,5: não-vegetais
v=collect(1:2)
n=collect(3:5)
o=vcat(v,n)

# custo e acidez
c = [ 110, 120, 130, 110, 115 ]
a = [ 8.8, 6.1, 2.0, 4.2, 5.0 ]

# modelo
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x[o] >= 0)
@variable(m, xo)

@objective(m, Max, 150*xo-sum{c[i]*x[i],i in o})
@constraints(m, begin
             sum{x[i],i in v}<=200
             sum{x[i],i in n}<=250
             3*xo <= sum{a[i]*x[i],i in o}
             sum{a[i]*x[i],i in o} <= 6*xo
             sum{x[i],i in o} == xo
             end)

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

println("Valor ótimo: $(getvalue(xo))")
println("Produção total: $(getvalue(xo))")
println("Óleos vegetais: $(map(i->getvalue(x[i]),v))")
println("Óleos não-vegetais: $(map(i->getvalue(x[i]),n))")
