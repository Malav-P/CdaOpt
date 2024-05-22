using Test

include("../CdaOpt/src/cdaopt.jl")
using .CdaOpt

x0 = [0.9519486347314083  0.0 0.0 0.0 -0.952445273435512 0.0 6.45;
      0.13603399956670137 0.0 0.0 0.0 3.202418276067991  0.0 6.45]
#---------------------------------------------------- ICs
target = [0. 0. 0.;
          0. 1. 0.]
#---------------------------------------------------- target points
tspan = collect(LinRange(0, 6.45, 50))
#---------------------------------------------------- time span
T = length(tspan)
P = size(target,1)
J = size(x0, 1)
#---------------------------------------------------- T, P, J
m = rand(UInt, T*P)
#---------------------------------------------------- coverage requirement
gravitymodel = R3BP.get_cr3bp_params(399, 301)
#---------------------------------------------------- CR3BP parameters
apmag_params = Base.ImmutableDict(
"ws" => - 0.9253018261815922,           # angular velocity of sun
"AU" => 1.496e8 / gravitymodel.lstar,   # 1AU in distance units
"ms" => -26.74,                         # apparent magnitude of sun
"aspec" => 0,                           # specular reflection coefficient
"adiff" => 0.2,                         # diffuse reflection coefficient
"d" => 0.001 / gravitymodel.lstar,      # diameter of target in distance units
"rmoon" => 1374.4 / gravitymodel.lstar, # radius of moon in DU
"rearth" => 6371 / gravitymodel.lstar   # radius of earth in DU
)
#---------------------------------------------------- illumination parameters
params = Base.ImmutableDict("dynamics" => R3BP.asdict(gravitymodel), "apmag" => apmag_params)
#---------------------------------------------------- aggregrated parameters
access_metric = AccessMetrics.apparentmag
#---------------------------------------------------- access metric

@testset "constructing SdaProblem.problem instance" begin
    @test_throws MethodError SdaProblem.problem()

    @test_nowarn SdaProblem.problem(x0, target, tspan, params, m, access_metric, gravitymodel)


    @testset "changing x0" begin
        x0s_ = ("Foo", [0.0 0.0 0.0 0.0 0.0 0.0])
        messages = ("AssertionError(\"x0 must have type Matrix{Float64}\")",
                    "AssertionError(\"each row of x0 must be of the form [x, y, z, vx, vy, vz, period]\")")
        #----------------------------------------------------
        for (i, x0_) in enumerate(x0s_)
            try
                SdaProblem.problem(x0_, target, tspan, params, m, access_metric, gravitymodel) 
            catch err
                msg = string(err)

                @test cmp(msg, messages[i]) == 0
            end
        end 
    end

    @testset "changing target" begin
        targets_ = ([0.0, 0.0, 0.0], [0.0 0.0], rand(Float64, (P, 4)))
        messages = ("AssertionError(\"target must have type Matrix{Float64}\")",
                    "AssertionError(\"each row of target must be of the form [x, y, z]\")",
                    "AssertionError(\"each row of target must be of the form [x, y, z]\")")
        #----------------------------------------------------
        for (i, target_) in enumerate(targets_)
            try
                SdaProblem.problem(x0, target_, tspan, params, m, access_metric, gravitymodel) 
            catch err
                msg = string(err)

                @test cmp(msg, messages[i]) == 0
            end
        end
    end

    @testset "changing t_span" begin
        tspans_ = ([1.0], [-1.0, 0.0], [1.0, 2.4, 2.1])
        messages = ("AssertionError(\"tspan must have > 1 elements\")",
                    "AssertionError(\"tspan must start at time 0.0 or greater\")",
                    "AssertionError(\"tspan must have nondecreasing values\")")
        #----------------------------------------------------
        for (i, tspan_) in enumerate(tspans_)
            try
                SdaProblem.problem(x0, target, tspan_, params, m, access_metric, gravitymodel) 
            catch err
                msg = string(err)

                @test cmp(msg, messages[i]) == 0
            end
        end
    end

    @testset "changing params" begin
        params_ = ("Bar", "Foo")
        messages = ("AssertionError(\"type of params must be Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}}\")",
                    "AssertionError(\"type of params must be Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}}\")")
        #----------------------------------------------------
        for (i, param_) in enumerate(params_)
            try
                SdaProblem.problem(x0, target, tspan, param_, m, access_metric, gravitymodel) 
            catch err
                msg = string(err)

                @test cmp(msg, messages[i]) == 0
            end
        end

    end

    @testset "changing m" begin
        ms_ = (rand(Char, T*P), rand(UInt, T*P + 1))
        messages = ("AssertionError(\"m must have type AbstractVector{UInt}\")",
                    "AssertionError(\"length of m must be equal length(tspan) * size(x0, 2)\")")
        #----------------------------------------------------
        for (i, m_) in enumerate(ms_)
            try
                SdaProblem.problem(x0, target, tspan, params, m_, access_metric, gravitymodel) 
            catch err
                msg = string(err)

                @test cmp(msg, messages[i]) == 0
            end
        end
    end

    @testset "changing access_metric" begin
        f1 = function (r_cr3bp :: Matrix{String}, target :: Array{Float16, 2}, params :: Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}}) end
        f2 = function (r_cr3bp :: Matrix{Float32}, target :: Matrix{Float16}) end
        f3 = function (params :: Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}}, r_cr3bp :: Matrix{Float32}, target :: Matrix{Float32}) end

        access_metrics_ = (f1, f2, f3)
        messages = ("AssertionError(\"argument Matrix{String} should be of type Array{Float64, 3}\")",
                    "AssertionError(\"the passed function must take 3 arguments\")",
                    "AssertionError(\"argument Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}} should be of type Array{Float64, 3}\")")
        #----------------------------------------------------
        for (i, access_metric_) in enumerate(access_metrics_)
            try
                SdaProblem.problem(x0, target, tspan, params, m, access_metric_, gravitymodel) 
            catch err
                msg = string(err)

                @test cmp(msg, messages[i]) == 0
            end
        end
    end

    @testset "changing gravitymodel" begin
        gravitymodels_ = ("Chloelky", 32)
        messages = ("AssertionError(\"gravitymodel must be of type GravityModel = Union{CR3BP}\")",
                    "AssertionError(\"gravitymodel must be of type GravityModel = Union{CR3BP}\")")
        #----------------------------------------------------
        for (i, gravitymodel_) in enumerate(gravitymodels_)
            try
                SdaProblem.problem(x0, target, tspan, params, m, access_metric, gravitymodel_) 
            catch err
                msg = string(err)

                @test cmp(msg, messages[i]) == 0
            end
        end
    end

end

@testset "CR3BP module" begin
    Earth = 399
    Moon = 301

    p = R3BP.get_cr3bp_params(Earth, Moon)
    q = R3BP.get_cr3bp_params(Moon, Earth)


    @testset "checking p and q equal" begin
        @test p isa R3BP.CR3BP
        @test q isa R3BP.CR3BP

        @test p.mu ≈ q.mu
        @test p.lstar ≈ q.lstar
        @test p.tstar ≈ q.tstar
        @test p.mstar ≈ q.mstar
    end

    @test_throws KeyError R3BP.get_cr3bp_params(11, Earth)

end

@testset "precompute/phase/threshold/optimize pipeline" begin

    f = @test_nowarn SdaProblem.getcoveragerequirement(1, P, T)
    #---------------------------------------------------- coverage requirement
    p = SdaProblem.problem(x0, target, tspan, params, f, access_metric, gravitymodel)
    #---------------------------------------------------- Construct Problem
    access_measure, orbits = @test_nowarn CdaOpt.precompute(p)
    @test size(access_measure) == (T, J, P)
    #---------------------------------------------------- Precompute
    phased = @test_nowarn CdaOpt.phase(access_measure)
    @test size(phased) == (T*P, J*T)
    #---------------------------------------------------- Phase
    thresholded = @test_nowarn CdaOpt.threshold!(phased, 1.0)
    @test size(thresholded) == (T*P, J*T)
    #---------------------------------------------------- Threshold
    result = @test_nowarn CdaOpt.optimize(thresholded, f, silent=true)
    #---------------------------------------------------- Optimize

end
