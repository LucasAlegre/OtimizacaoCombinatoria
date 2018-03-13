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

f_min=Dict(zip(FOOD, map(x->isna(x)?0:x,food[:f_min])))

f_max=Dict(zip(FOOD, map(x->isna(x)?typemax(Float64):x,food[:f_max])))

n_min=Dict(zip(NUTR, map(x->isna(x)?0:x, nutr[:n_min])))

n_max=Dict(zip(NUTR, map(x->isna(x)?typemax(Float64):x, nutr[:n_max])))

amt=Dict{Tuple{String,String},Float64}()
for i in 1:nrow(amnt), j in 2:ncol(amnt)
    amt[FOOD[i],NUTR[j-1]]=amnt[i,j]
end

# modelo
m = Model(solver=GLPKSolverLP())

# variáveis
@variable(m, x[i=1:nrow(food)])

println(m)

