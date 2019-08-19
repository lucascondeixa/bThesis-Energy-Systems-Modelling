# creating function for optimizing

function tuukkasProblemsolver (hD, hPcS, hPcW, hPcC, hPcG, lenOfArray )
#solves all your problems and much more

# D A T A
#1: WIND
#2: SOLAR
#3: COAL
#4: GAS
#5: NUCLEAR

#investmentcosts:
InvestCosts = [2000, 3000 4000, 1500, 7000]  # dollars per kW


# WIND investments about 2milj pro MW thus 2000 pro kW - windustry how much does turbines const
# PV investment pro kW is 3000 noted by solar united: technologies vost analysis-solar-pv
# COAL schilissel coal-fired powerplant consttuction costs
# GAS /market realist.com natural gas fired power plantscheaper to build
# NUCLEAR wikipedia en - economics of nuclear plants. in america 7 grand

FixedRunningCosts = [WIND, SOLAR, COAL, GAS, NUCLEAR]

ScalingRunningCosts = [0, 0,COAL, GAS, NUCLEAR]

# M O D E L N A M E

    😂 = Model(with_optimizer(Gurobi.Optimizer, Presolve=0, OutputFlag=0))

# O B J E C T I V E F U N C T I O N

    @objective(😂, Min, sum{ inv[:], capex, run[:] }) # NOT READY
    #explain this function here

# D E C I S I O N  V A R I A B L E S

    #@defVar(😂, emissions <= cap_emissions ) #TBA
    @variable(😂, consupt <= production ) #TBA
    @variable(😂, consupt <= production ) #TBA
    @variable(😂, consupt <= production ) #TBA
    @variable(😂, consupt <= production ) #TBA

    for (k = 1: lenOfArray)
        @variable😂, hPcS[k] + hPcW[k] + hPcC[k] + hPcG[k] >= ConsumptionHourly[k] ) # PRODUCTION has to meet the DEMAND all time
    end

# C O N S T R A I N T S
    @constraint(😂, sum(list of different emissions(  )) <= cap_emissions  ) #limiting emissions. Summing up each production. Also could include investment emissions with a poistot -idea
    @constraint(😂, consumption <=  sum() ) # check that all consumption is below production
    @constraint(😂,  )
    @constraint(😂,  )
    @constraint(😂,  )
    @constraint(😂,  )


end # END OF THE SOLVER PART

##
