#!/usr/bin/env julia

using JuMP
using GLPKMathProgInterface
using DataFrames

food=readtable("McDonalds-food.wsv",header=true,allowcomments=true)
nutr=readtable("McDonalds-nutr.wsv",header=true,allowcomments=true)
amnt=readtable("McDonalds-amnt.wsv",header=true,allowcomments=true)

NUTR=nutr[:NUTR]

FOOD=food[:FOOD];

cost=Dict(zip(FOOD,food[:cost]))

f_min=Dict(zip(FOOD, map(x->ismissing(x)?0:x,food[:f_min])))

f_max=Dict(zip(FOOD, map(x->ismissing(x)?typemax(Float64):x,food[:f_max])))

n_min=Dict(zip(NUTR, map(x->ismissing(x)?0:x, nutr[:n_min])))

n_max=Dict(zip(NUTR, map(x->ismissing(x)?typemax(Float64):x, nutr[:n_max])))

amt=Dict{Tuple{String,String},Float64}()
for i in 1:nrow(amnt), j in 2:ncol(amnt)
    amt[FOOD[i],NUTR[j-1]]=amnt[i,j]
end

# modelo normal
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x[f in FOOD], lowerbound=f_min[f], upperbound=f_max[f])

@objective(m, Min, sum(cost[f]*x[f] for f in FOOD))

@constraints(m, begin
             [n in NUTR], n_min[n] <= sum(amt[f,n]*x[f] for f in FOOD)
             [n in NUTR], sum(amt[f,n]*x[f] for f in FOOD) <= n_max[n]
             end)

# imprime & resolve
#println(m)
print("Resolução...")
solve(m)
println("Ok.")
println()

println("A dieta normal tem um custo total de R\$ $(getobjectivevalue(m))")
println("É composta de:")
for f in FOOD
    if getvalue(x[f]) > 0
        println("$(getvalue(x[f])) unidades do alimento $(f)")
    end
end

# modelo com dieta entre 2000kcal e 2100kcal
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x[f in FOOD], lowerbound=f_min[f], upperbound=f_max[f])

@objective(m, Min, sum(cost[f]*x[f] for f in FOOD))

@constraints(m, begin
             [n in NUTR], n_min[n] <= sum(amt[f,n]*x[f] for f in FOOD)
             [n in NUTR], sum(amt[f,n]*x[f] for f in FOOD) <= n_max[n]
             100 <= sum(amt[f,"Energia"]*x[f] for f in FOOD)
             sum(amt[f,"Energia"]*x[f] for f in FOOD) <= 105
             end)

# imprime & resolve
#println(m)
print("Resolução...")
solve(m)
println("Ok.")
println()

println("A dieta entre 2000kcal e 2100kcal tem um custo total de R\$ $(getobjectivevalue(m))")
println("É composta de:")
for f in FOOD
    if getvalue(x[f]) > 0
        println("$(getvalue(x[f])) unidades do alimento $(f)")
    end
end

# modelo vegetariano
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x[f in FOOD], lowerbound=f_min[f], upperbound=f_max[f])

@objective(m, Min, sum(cost[f]*x[f] for f in FOOD))

@constraints(m, begin
             [n in NUTR], n_min[n] <= sum(amt[f,n]*x[f] for f in FOOD)
             [n in NUTR], sum(amt[f,n]*x[f] for f in FOOD) <= n_max[n]
             [i in 1:nrow(food); food[i,:veg]==false], x[food[i,:FOOD]] == 0
             end)

# imprime & resolve
#println(m)
print("Resolução...")
solve(m)
println("Ok.")
println()

println("A dieta vegetariana tem um custo total de R\$ $(getobjectivevalue(m))")
println("É composta de:")
for f in FOOD
    if getvalue(x[f]) > 0
        println("$(getvalue(x[f])) unidades do alimento $(f)")
    end
end

# modelo cada alimenta uma única vez
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x[f in FOOD], lowerbound=f_min[f], upperbound=f_max[f])

@objective(m, Min, sum(cost[f]*x[f] for f in FOOD))

@constraints(m, begin
             [n in NUTR], n_min[n] <= sum(amt[f,n]*x[f] for f in FOOD)
             [n in NUTR], sum(amt[f,n]*x[f] for f in FOOD) <= n_max[n]
             [f in FOOD], x[f] <= 1
             end)

# imprime & resolve
#println(m)
print("Resolução...")
solve(m)
println("Ok.")
println()

println("A dieta onde cada alimento aparece no máximo uma vez tem um custo total de R\$ $(getobjectivevalue(m))")
println("É composta de:")
for f in FOOD
    if getvalue(x[f]) > 0
        println("$(getvalue(x[f])) unidades do alimento $(f)")
    end
end
