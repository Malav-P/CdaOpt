"""
    postprocessing(p, model)

Compute the phasing of the satellites in each orbit given the optimal solution from `model`.

# Arguments
- `p::SdaProblem.problem`: and instance of the optimization problem.
- `model::Model`: an instance of a JuMP model.

"""
function postprocessing(p::SdaProblem.problem, model::Model)

    T = length(p.tspan)

    x = value.(model[:x])

    winners = findall(y -> y > 0.99, x)

    obj = length(winners)

    orbit_ids = zeros(Int, obj)
    orbit_shifts = zeros(Int, obj)

    for i = 1:obj
        winner_value = winners[i];
        orbit_ids[i] = ceil(Int, winner_value/T);

        # note that if this number = -1, we are circularly shifting the orbit backwards by
        # 1 or equivalently, forwards by T - 1
        orbit_shifts[i] = mod(winner_value, T) - 1;
    end

    return orbit_ids, orbit_shifts

end