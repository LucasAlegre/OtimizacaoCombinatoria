#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface
using Graphs

# modelo
m = Model(solver=GLPKSolverMIP())

cores = collect(1:10)
vertices = collect(1:10)

g = simple_graph(10, is_directed=false)
# Grafo de Petersen
add_edge!(g, 1, 2)
add_edge!(g, 1, 5)
add_edge!(g, 1, 7)
add_edge!(g, 2, 3)
add_edge!(g, 2, 8)
add_edge!(g, 3, 4)
add_edge!(g, 3, 9)
add_edge!(g, 4, 5)
add_edge!(g, 4, 10)
add_edge!(g, 5, 6)
add_edge!(g, 6, 8)
add_edge!(g, 6, 9)
add_edge!(g, 7, 10)
add_edge!(g, 7, 9)
add_edge!(g, 10, 8)

# variáveis
@variable(m, x[vertices, cores], Bin)
@variable(m, c[cores], Bin)

@objective(m, Min, sum(c[cor] for cor in cores))
@constraints(m, begin
            [v in vertices], sum(x[v,cor] for cor in cores) == 1
            [cor in cores, edge in edges(g)], x[source(edge,g),cor]+x[target(edge,g),cor] <= 1
            [cor in cores], length(vertices)*c[cor] >= sum(x[v,cor] for v in vertices)
            end)

# imprime & resolve
println(m)
print("Resolução...")
status = solve(m)
println("Ok.")

println("Foram usadas $(getobjectivevalue(m)) cores")
