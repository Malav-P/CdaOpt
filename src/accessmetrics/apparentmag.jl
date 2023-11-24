"""
    getsuntrajectory(phase, tspan, params)
Generate a circular clockwise trajectory for the sun of radius 1 AU. Return the position states evaluated at `tspan`.
Sun's motion begins with initial phase `phase`.
"""
function getsuntrajectory(phase::Float64, tspan::Array{Float64, 1}, params::Base.ImmutableDict{String, Float64})

    ws = params["ws"]
    d = params["AU"];

    rsun = zeros(length(tspan), 4)

    rsun[:,1] = d .* cos.(ws*tspan .+ phase);
    rsun[:,2] = d .* sin.(ws*tspan .+ phase);
    rsun[:,4] = tspan
    
    return rsun
end

"""
    computeapparentmag(rO, rT, rS, params)
Compute the apparent magnitude of a target at position `rT`, given the position of the sun at `rS` and the position
of the observer at `rO`. Target's optical properties are captured in `params`
"""
function computeapparentmag(rO::Vector{Float64}, rT::Vector{Float64}, rS::Vector{Float64}, params::Base.ImmutableDict{String, Float64})

    #apparent magnitude of sun
    ms = params["ms"];
    # specular and diffuse reflection coefficients, taken from https://arxiv.org/pdf/2302.09732.pdf page 13
    aspec = params["aspec"];
    adiff = params["adiff"];
    #diameter of object 
    d = params["d"] ;

    #vector from observer to target
    rOT = rT - rO;

    #vector from sun to target
    rST = rT - rS;

    # distance from observer to target
    zeta = norm(rOT);

    # solar phase angle (angle between the two vectors)
    psi = atan(norm(cross(rOT,rST)),dot(rOT,rST));

    #calculate pdiff
    pdiff = (2/(3*pi))*(sin(psi) + (pi - psi)*cos(psi));

    # compute apparent magnitude
    return ms - 2.5 * log10( (d^2 / zeta^2) * (aspec/4 + adiff*pdiff));

end

function apparentmag(orbits::Array{Float64, 3}, targets::Matrix{Float64}, params::Base.ImmutableDict{String, Base.ImmutableDict{String, Float64}})

    J = size(orbits, 3) 
    T = size(orbits, 1)
    P = size(targets, 1)

    tspan = orbits[:, 4, 1]
    rsun = getsuntrajectory(0.0, tspan, params["apmag"])[:,1:3]
    access_measure = zeros(Float64, (T, J, P))

    rM = [1 - params["dynamics"]["mu"], 0, 0]
    beta = params["apmag"]["rmoon"]

    rE = [-params["dynamics"]["mu"], 0, 0]
    alpha = params["apmag"]["rearth"]

    for j = 1:J
        r_cr3bp = orbits[:,1:3,j]

        for i = 1:T
            rO = r_cr3bp[i, :]
            rS = rsun[i, :]

            ## DEADZONE CALCULATION FOR LUNAR OBSTRUCTION ----------------------------------

            rOM = rM - rO;

            # w1 normalized to unit length, w1 is normal to rOM
            w1 = [0, -rOM[3], rOM[2]] / norm([0, -rOM[3], rOM[2]]);
    
            # b1 offset
            b1 = dot(w1, rM);
    
            # w2 normalized to unit length
            w2 = cross(rOM, w1)/ norm(rOM);
    
            # b2 offset
            b2 = dot(w2, rM);
    
            # w3 normalized to unit length
            w3 = rOM/norm(rOM);
    
            # b3 offset
            b3 = dot(w3, rM);

            indeadzonehuhmoon = x -> (abs(dot(w1, x) - b1) <= beta) && (abs(dot(w2, x) - b2) <= beta) && (dot(w3, x) - b3 > 0);

            ## DEADZONE CALCULATION FOR LUNAR OBSTRUCTION ----------------------------------

            ## DEADZONE CALCULATION FOR EARTH OBSTRUCTION ----------------------------------

            # vector from observer to Earth
            rOE = rE - rO;
    
            # w1 normalized to unit length
            w1_ = [0, -rOE[3], rOE[2]] / norm([0, -rOE[3], rOE[2]]);
    
            # b1 offset
            b1_ = dot(w1_, rE);
    
            # w2 normalized to unit length
            w2_ = cross(rOE, w1_)/ norm(rOE);
    
            # b2 offset
            b2_ = dot(w2_, rE);
    
            # w3 normalized to unit length
            w3_ = rOE/norm(rOE);
    
            # b3 offset
            b3_ = dot(w3_, rE);
    
    
            indeadzonehuhearth = x -> (abs(dot(w1_, x) - b1_) <= alpha) && (abs(dot(w2_, x) - b2_) <= alpha) && (dot(w3_, x) - b3_ > 0);
    
            ## DEADZONE CALCULATION FOR EARTH OBSTRUCTION ----------------------------------

            for p = 1:P
                rT = targets[p,:]
    
                # if target is obstructed by moon or earth, set apparent magnitude to inf (impossible to view)
                if indeadzonehuhmoon(rT) || indeadzonehuhearth(rT)
                    access_measure[i, j, p] = typemax(Float64);
                else
                    access_measure[i, j, p] = computeapparentmag(rO, rT, rS, params["apmag"]);
                end
    
            end
    

        end

    end

    return access_measure
    
end


    