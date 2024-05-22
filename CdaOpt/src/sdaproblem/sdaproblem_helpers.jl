function check_x0(x0)
    
    @assert typeof(x0) <: Matrix{Float64} "x0 must have type Matrix{Float64}"

    @assert size(x0, 2) == 7 "each row of x0 must be of the form [x, y, z, vx, vy, vz, period]"

end

function check_target(target)

    @assert typeof(target) <: Matrix{Float64} "target must have type Matrix{Float64}"

    @assert size(target, 2) == 3 "each row of target must be of the form [x, y, z]"

end

function check_tspan(tspan)

    @assert typeof(tspan) <: Vector{Float64} "tspan must have type Vector{Float64}"

    T = length(tspan)

    @assert T > 1 "tspan must have > 1 elements"

    @assert tspan[1] >= 0.0 "tspan must start at time 0.0 or greater"
    for i in range(1, T-1)
        @assert tspan[i] <= tspan[i+1] "tspan must have nondecreasing values"
    end

end

function check_params(params)
    @assert typeof(params) <: Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}} "type of params must be Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}}"

end

function check_m(m, len)

    @assert typeof(m) <: AbstractVector{UInt} "m must have type AbstractVector{UInt}"

    @assert length(m) == len "length of m must be equal length(tspan) * size(x0, 2)"

end

function check_access_metric(access_metric)
    method = first(methods(access_metric))

    arg_types = Tuple(method.sig.parameters[2:end])
    @assert length(arg_types) == 3 "the passed function must take 3 arguments"

    expected_types = (Array{Float64, 3}, Array{Float64, 2}, Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}})
    for (i, arg_type) in enumerate(arg_types)

        @assert arg_type <: expected_types[i] "argument $arg_type should be of type $(expected_types[i])"

    end
end


function check_gravitymodel(gravitymodel)
    @assert typeof(gravitymodel) <: GravityModel "gravitymodel must be of type GravityModel = Union{CR3BP}"
end