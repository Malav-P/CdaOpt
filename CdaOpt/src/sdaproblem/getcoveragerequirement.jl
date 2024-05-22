"""
    getcoveragerequirement(N, P, T; <keyword arguments>)

Generate the coverage requirement for `N` departure windows, `P` target points, and `T` timesteps.
`N` must be a power of 2
"""
function getcoveragerequirement(N::Int, P::Int, T::Int; randomize::Bool = false)

    @assert N > 0 && (N & (N - 1)) == 0 "N must be a positive integer power of 2"

    M = zeros(UInt,P,T)

    step = T
    power = 0
    indices = [1]

    while power < log2(N)
        step = floor(UInt, step/2)
        power += 1
        newindices = zeros(UInt, length(indices))
        for i in eachindex(indices)
            newindices[i] = indices[i] + step
        end

        indices = vcat(indices, newindices)
    end

    M[1, indices] .= 1


    if randomize
        M[1, :] = circshift(M[1, :], rand(1:T))
        for p = 2:P
            M[p, :] = circshift(M[p-1, :], rand(1:T))
        end
    else
        for p = 2:P
            M[p, :] = circshift(M[p-1, :], 1)
        end
    end

    return vec(M')

end