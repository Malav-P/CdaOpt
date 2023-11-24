module CdaOpt

using JuMP, Gurobi

export SdaProblem, R3BP, AccessMetrics

# modules
include("./r3bp/r3bp.jl")
include("./sdaproblem/sdaproblem.jl")
include("./accessmetrics/accessmetrics.jl")

#  functions for optim framework
include("./preprocessing.jl")
include("./optimize.jl")
include("./postprocessing.jl")


end # module CdaOpt
