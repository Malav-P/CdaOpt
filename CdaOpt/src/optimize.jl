"""
    optimize(A, b; <keyword arguments>)

Solves the binary integer linear program with linear constraints Ax >= b and objective minimize `sum(x)`.

Minimizes the number of `1` entries in the design vector while satisfying the linear system of constraints
given by Ax >= b.

# Arguments
- `A::Matrix{Int}`: Matrix of LHS of constraint equation Ax >= b
- `b::AbstractVector{Int}`: RHS of constraint equation Ax >= binary
- `silent::Bool`: suppress the solver's information
"""
function optimize(A::Matrix{Int}, b::AbstractVector{UInt}; silent::Bool = false)

    num_constraints , n = size(A)

    model = Model(Gurobi.Optimizer)

    if silent
        set_silent(model)
    end

    @variable(model, x[1:n], Bin)


    @constraint(model, [i=1:num_constraints], sum(A[i,j] * x[j] for j in 1:n) >= b[i])
    
    @objective(model, Min, sum(x[j] for j in 1:n))

    optimize!(model)


    return model
end