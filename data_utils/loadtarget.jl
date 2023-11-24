function loadtarget(fname::AbstractString; skiprows::Int = 16)
    delim = ' '
    type = Float64

    data = readdlm(fname, delim, type, skipstart=skiprows)

    tspan = data[:, 1]
    target = data[:, 2:4]
    tstep = tspan[2] - tspan[1]

    return tspan, target, tstep
end