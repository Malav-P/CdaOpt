include("../src/cdaopt.jl")
include("../data_utils/data_utils.jl")
using .CdaOpt
using .DataUtils

x0 = DataUtils.loadicdir("./data/catalog", ordering=[4,3,1,2,5,6])
#-------------------------------------------------------------------- ICs
~, target, tstep = DataUtils.loadtarget("./data/targets/time_history1.txt")
#-------------------------------------------------------------------- target points
tspan = collect(0:tstep:6.45);
#-------------------------------------------------------------------- time span
T = length(tspan)
P = size(target,1)
J = size(x0, 1)
#-------------------------------------------------------------------- T, P, J
m = SdaProblem.getcoveragerequirement(1, P, T)
#-------------------------------------------------------------------- coverage requirement
gravitymodel = R3BP.CR3BP(1.215058560962404e-02,384400.0, 3.751902619517228e+05, 7.0 )
#-------------------------------------------------------------------- gravity model
apmag_params = Base.ImmutableDict(
"ws" => - 0.9253018261815922,#--------------- angular velocity of sun
"AU" => 1.496e8 / gravitymodel.lstar,#------- 1AU in distance units
"ms" => -26.74,#----------------------------- apparent magnitude of sun
"aspec" => 0,#------------------------------- specular reflection coefficient
"adiff" => 0.2,#----------------------------- diffuse reflection coefficient
"d" => 0.001 / gravitymodel.lstar,#---------- diameter of target in distance units
"rmoon" => 1737.4 / gravitymodel.lstar,#----- radius of moon in DU
"rearth" => 6371 / gravitymodel.lstar#------- radius of earth in DU
)
#-------------------------------------------------------------------- illumination parameters
params = Base.ImmutableDict(
    "dynamics" => R3BP.asdict(gravitymodel),
    "apmag"    => apmag_params
)
#-------------------------------------------------------------------- aggregrated params
access_metric = AccessMetrics.apparentmag
#-------------------------------------------------------------------- access metric


p = SdaProblem.problem(x0, target, tspan, params, m, access_metric, gravitymodel)
access_measure, orbits = CdaOpt.precompute(p)
phased = CdaOpt.phase(access_measure)
V = CdaOpt.threshold(phased, 17.0)
result = CdaOpt.optimize(V, m)
orbit_ids, orbit_shifts = CdaOpt.postprocessing(p, result)


println(orbit_ids)
println(orbit_shifts)
