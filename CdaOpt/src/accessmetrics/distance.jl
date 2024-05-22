"""
    distance(orbits, targets, params)

Compute the distances between each target point in `targets` to each possible observer location
contained in `orbits`. Additional parameters are passed via the `params` argument.

# Arguments
- `orbits::Array{Float64, 3}`: An array containing position history of observers. At timestep `t` the position of observer `i`
                               is `orbits[t, 1:3, i]` and the timestamp is given by `orbits[t, 4, i]`.
- `targets::Matrix{Float64}`: A matrix containing the target points. Position of target point `p` is accessed with `targets[p, :]`.
- `params::Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}}`: Additional params (NOT USED)
"""
function distance(orbits::Array{Float64, 3}, targets::Matrix{Float64}, params::Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}})::Array{Float64, 3}

    J = size(orbits, 3) 
    T = size(orbits, 1)
    P = size(targets, 1)

    access_measure = zeros(Float64, (T, J, P))

    for j in 1:J
        orbit = orbits[:,1:3,j]

        for (p, target) in enumerate(eachrow(targets))

            access_measure[:, j, p] = [norm(target - i) for i in eachrow(orbit)]

        end

    end

    return access_measure
    
end