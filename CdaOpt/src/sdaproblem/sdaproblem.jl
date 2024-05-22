
module SdaProblem
using ..R3BP

# TODO : EXPORT LIST ( ... )

include("./getcoveragerequirement.jl")


struct problem
    x0 :: Matrix{Float64}
    target :: Matrix{Float64}
    tspan :: Vector{Float64}
    params :: Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}}
    m :: Array{UInt, 1}

    access_metric :: Function
    gravity_model :: GravityModel

    problem(x0_, target_, tspan_, params_, m_, access_metric_, gravitymodel_) = begin

        check_x0(x0_)

        check_target(target_)

        check_tspan(tspan_)

        check_params(params_)

        check_access_metric(access_metric_)

        T = length(tspan_)
        P = size(target_, 1)

        check_m(m_, T*P)

        check_gravitymodel(gravitymodel_)


        return new(x0_, target_, tspan_, params_, m_, access_metric_, gravitymodel_)

    end
end


include("./sdaproblem_helpers.jl")
end