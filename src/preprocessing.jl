"""
    precompute(p)

Propagate the observers' initial conditions from the problem `p` and determine the access measure from 
each target point to each observer's location
"""
function precompute(p::SdaProblem.problem)

    orbits = R3BP.propagate(p.x0[:, 1:6], p.tspan, p.gravity_model) 

    access_measure = p.access_metric(orbits[:, [1, 2, 3, 7], :], p.target, p.params)

    return access_measure, orbits
end

"""
    phase(V)
Circularly shift each column of each slice of `V`.

For each 2D slice of `V`, `V[:, :, i]`, take each column of the slice `V[:, j, i]` and circularly shift
it 0, 1, 2, 3, ..., `length(V[:, j, i])` times, storing each result in an expanded array
"""
function phase(V :: Array{Float64, 3})
    T, J, P = size(V)

    V_phased = zeros(T*P, T*J)


    for p in 1:P
        V_p = V_phased[1 + (p-1)*T: p*T, :]
        V_o = V[:, :, p]

        for j in 1:J
            offset = (j-1)*T;

            for shift in 0:(T-1)
                V_p[:, shift + offset + 1] = circshift(V_o[:,j], shift);
            end
        end

        V_phased[1 + (p-1)*T: p*T, :] = V_p;

    end

    return V_phased

end

"""
    threshold!(V, cutoff)

Apply an indicator function to `V`. 
    
All elements in `V` below `cutoff` are mapped to 1. All others are mapped to 0. In place version of 
`threshold(V, cutoff)`

See also [`threshold`](@ref)

"""
function threshold!(V::Matrix{Float64}, cutoff::Float64)

    V[findall(x -> x <  cutoff, V)] .= 1
    V[findall(x -> !(x==1), V)] .= 0
    
    return Int.(V) # This operation of converting floats to Int is O(numel(V)), perhaps more efficient way exists?

end

"""
    threshold(V, cutoff)

Apply an indicator function to `V`. 
    
All elements in `V` below `cutoff` are mapped to 1. All others are mapped to 0. 

See also [`threshold!`](@ref)
"""
function threshold(V::Matrix{Float64}, cutoff::Float64)

    V_ = zeros(Int, size(V))
    V_[findall(x -> x <= cutoff, V)] .= 1

    return V_

end