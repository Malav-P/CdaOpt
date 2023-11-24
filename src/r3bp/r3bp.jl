module R3BP

using DifferentialEquations

export GravityModel, CR3BP, get_cr3bp_params

include("./getgm.jl")
include("./getsemimajoraxis.jl")

include("./cr3bp.jl")

GravityModel = Union{CR3BP}

end