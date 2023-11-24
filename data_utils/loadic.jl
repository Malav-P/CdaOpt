"""
    loadic(fname)

Load the initial condition from JSON file `fname`. The contents of the file `fname` must have keys `"x0"` and  `"period"`.
"""
function loadic(fname::AbstractString)

    jsondict =  open(fname, "r") do f
                    return JSON.parse(f)
                end

    x0 = jsondict["x0"]
    period = jsondict["period"]

    return convert(Matrix{Float64}, [x0' period])

end

"""
    loadicdir(dir, ordering)

Laod the initial conditions of all the JSON files in `dir`. All files in `dir` must have extension `.json`.
`ordering` specifies the order in which the files are read.
"""
function loadicdir(dir::AbstractString; ordering::Union{Vector{Int}, Nothing}=nothing)
    fnames = readdir(dir)

    if isnothing(ordering)
        ordering = 1:length(fnames)
    else
        @assert length(ordering) == length(fnames) "ordering must have same length as number of files in directory"
    end

    currdir = pwd()
    cd(dir)

    x0s = zeros(length(fnames), 7)

    for i = 1:length(fnames)
        x0s[i, :] = loadic(fnames[ordering[i]])
    end

    cd(currdir)
    return x0s

end