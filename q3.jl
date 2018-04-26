#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface

# modelo
m = Model(solver=GLPKSolverMIP())

sudoku = [[0 0 0 0 0 0 0 1 0]; [0 0 0 0 0 2 0 0 3]; [0 0 0 4 0 0 0 0 0]; [0 0 0 0 0 0 5 0 0 ]; [4 0 1 6 0 0 0 0 0]; [0 0 7 1 0 0 0 0 0 ]; [0 5 0 0 0 0 2 0 0]; [0 0 0 0 8 0 0 4 0]; [0 3 0 9 1 0 0 0 0 ]]


digitos = collect(1:9)
linhas = collect(1:9)
colunas = collect(1:9)

# variáveis
@variable(m, x[linhas,colunas,digitos], Bin)

@objective(m, Max, 0)
@constraints(m, begin
             [i in linhas, j in colunas] sum(x[i,j,d] for d in digitos) == 1
             [i in linhas, d in digitos] sum(x[i,j,d] for j in colunas) == 1
             [j in colunas, d in digitos] sum(x[i,j,d] for i in linhas) == 1
             [bi in 0:2, bj in 0:2, d in digitos] sum(x[i+3*bi,j+3*bj,d] for i in 1:3, j in 1:3) == 1             
         end)
for i in linhas, j in colunas
    if sudoku[i,j] != 0
        @constraint(m, x[i,j,sudoku[i,j]] == 1)
    end
end

# imprime & resolve
println(m)
print("Resolução...")
solve(m)
println("Ok.")

S = zeros(Int, 9, 9)
for i in linhas, j in colunas
    S[i,j] = Int(getvalue(x[i,j]))
end

S

