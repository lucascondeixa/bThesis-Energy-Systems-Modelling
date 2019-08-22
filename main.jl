# creating function for optimizing
using JuMP
using Gurobi

# D A T A
#1: WIND
#2: SOLAR
#3: COAL
#4: GAS
#5: NUCLEAR

const methods = ["WIND", "PV", "COAL", "GAS", "NUCLEAR"]
const M = length(methods)
const EmissionCap = 7000 #laita luku tähän
const EmissionCausePerMWh = [0, 0, 100, 60, 0]
const ramp = [[50 50 50 50 50];[50 50 50 50 50]] #ramp[m, (up tai down)] : 1up, 2down
const N = 5
const InvestCosts = [2, 3, 4, 1.5, 7]  # dollars per MW
const batteryInvestmentCost = 20

# WIND investments about 2milj pro MW thus 2000 pro kW - windustry how much does turbines const
# PV investment pro kW is 3000 noted by solar united: technologies vost analysis-solar-pv
# COAL schilissel coal-fired powerplant consttuction costs
# GAS /market realist.com natural gas fired power plantscheaper to build
# NUCLEAR wikipedia en - economics of nuclear plants. in america 7 grand

const FixedRunningCosts = [20, 20, 100, 140, 180]
const ScalingRunningCosts = [0, 0, 120, 150, 20]
const prodData = [[0 20 100 50 100];[50 50 100 50 100];[100 70 100 50 100];[30 30 100 50 100];[60 0 100 50 100]] #prodData[i,t] this for historical data in order to get the capacityFactor for each method.
const demand = [100 200 300 400 400]

#############


# M O D E L N A M E

    md = Model(with_optimizer(Gurobi.Optimizer))

# Some further explanation here TODO

# D E C I S I O N  V A R I A B L E S
# battery
# production describes the actual production of each method at each time
# capacityFactor describes with which factor should we multiply real-world data to have a clever capacity


    #@variable(multi, trans[1:numorig, 1:numdest, 1:numprod] >= 0)
    #@variable(md, 0 <= capacty[1:M] ) #capacity explained here, pro MW each
    @variable(md, 0 <= battery[t=1:N] <= BatCapacity)
    @variable(md, 0 <= production[i=1:M,t= 1:N] ) #TBA
    @variable(md, 0 <= capacityFactor[i=1:M] )
    @variable(md, 0 <= BatCapacity )
    #@variable(md, consupt <= production ) #TBA


# C O N S T R A I N T S
# consumption <= production, for all i, t
# battery  is updated
# battery shredding TODO
# emissions
# production <= capacityFactor*prodData
# ramping for production
#
#
#
#
    @constraint(md, [t=1:N],demand[t] <=  sum(production[i, t] for i in 1:M) ) # check that all consumption is below production
    @constraint(md, [t=2:N], battery[t] == battery[t-1] + sum(production[i, t] for i in 1:M) ) #for battery
    @constraint(md, sum(sum(EmissionCausePerMWh[i].*production[i, t] for i in 1:M ) for t in 1:N) <=EmissionCap  )
    @constraint(md, [t=1:N, i=1:M], production[i,t] <= capacityFactor[i] * prodData[i,t] )
for m in 1:M       #ramp stuff done here. Limitations marked on the matrix ramp
    @constraint(md,[t=2:N], production[m,t]-production[m, t-1] <= ramp[1, m]) #ramping up
    @constraint(md, [t=2:N], production[m,t]-production[m, t-1] >= ramp[2, m]) #ramping down
end


# O B J E C T I V E F U N C T I O N

# investment costs pro each factorthingi
# production minimized
#
#
#
#

    @objective(md, Min,
    sum(capacityFactor[i] * InvestCosts[i] for i in 1:M ) +
    sum( ScalingRunningCosts[i] * sum( production[i, t] for t in 1:N) for i in 1:M) +
    BatCapacity*batteryInvestmentCost
    ) # objectice ends

#end

optimize!(md)
