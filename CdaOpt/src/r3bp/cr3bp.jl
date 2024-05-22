struct CR3BP
    mu :: AbstractFloat
    lstar :: AbstractFloat
    tstar :: AbstractFloat
    mstar :: AbstractFloat
end

"""
    astuple(p)
Convert the `CR3BP` struct's fields into a `Tuple`.
"""
function astuple(p::CR3BP)
    return (p.mu, p.lstar, p.tstar, p.mstar)
end

"""
    asdict(p)
Converts the `CR3BP` struct and its fields into a `Base.ImmutableDict` object.
"""
function asdict(p::CR3BP)
    return Base.ImmutableDict("mu"=>p.mu, "lstar"=>p.lstar, "tstar"=>p.tstar, "mstar"=>p.mstar)
end

"""
Get the circular restricted 3-body problem parameters of two specified bodies.

# Arguments
- `m1_id::Int`: Body 1 ID.
- `m2_id::Int`: Body 2 ID.

# Returns
- an instance of CR3BP

"""
function get_cr3bp_params(m1_id::Int, m2_id::Int)

    gm1, gm2 = getgm(m1_id, m2_id)

    if gm1 < gm2
        return get_cr3bp_params(m2_id, m1_id)
    end

    mu = gm2 / (gm1 + gm2)
    a2 = getsemimajoraxis(m2_id)[1]

    lstar = a2

    tstar = sqrt( (a2)^3 / (gm1 + gm2))

    mstar = gm1 + gm2

    return CR3BP(mu, lstar, tstar, mstar)
end

"""
    cr3bp(du, u, p, t)
The ODE function used to numerically integrate the CR3BP equations of motion.
"""
function cr3bp(du, u, p, t)
    # state vector
    x, y, z, vx, vy, vz = u[1:6]

    # mass parameter
    μ = p[1]

    # position to primary and secondary bodies
    r1 = sqrt( (x+μ)^2 + y^2 + z^2 )
    r2 = sqrt( (x-1+μ)^2 + y^2 + z^2 )

    # position derivatives
    du[1:3] = [vx, vy, vz]
    
    # velocity derivatives
    du[4] = 2*vy + x - ((1-μ)/r1^3)*(μ+x) + (μ/r2^3)*(1-μ-x)
    du[5] = -2*vx + y - ((1-μ)/r1^3)*y - (μ/r2^3)*y
    du[6] = -((1-μ)/r1^3)*z - (μ/r2^3)*z

end

"""
    propagate(x0s, tspan, params)
Propate the list of initial conditions in `x0s` in the CR3BP given CR3BP parameters contained in `params`.
Solution is saved at time steps defined in `tspan`.
"""
function propagate(x0s :: Array{Float64, 2}, tspan :: Vector{Float64}, params :: CR3BP)

    J = size(x0s, 1)
    T = length(tspan)

    tstart, tend = tspan[[1, end]]

    orbits = zeros(Float64, (T, 7, J))


    for row in 1:J
        x0 = x0s[row, :]

        prob = ODEProblem(cr3bp, x0, (tstart, tend), astuple(params))

        s = solve(prob, Vern7(), abstol = 1e-12, reltol=1e-12, saveat=tspan)

        orbits[:,1:6,row] = mapreduce(permutedims, vcat, s.u)
        orbits[:,7,row] = tspan

    end

    return orbits
    
end

"""
    to_csv(orbits, params, fname)

Writes the orbit history contained in `orbits` to the file `fname` as comma separated values.
"""
function to_csv(orbits :: Array{Float64, 3}, params :: CR3BP, fname :: String)

    io = open(fname, "w")

    num_orbits = size(orbits, 3)

    for i in 1:num_orbits
        orbit = orbits[:,:,i]
        writedlm(io, orbit,',')
    end

    close(io)

end
