using Pkg

ENV["GUROBI_HOME"] = "/Library/gurobi1000/macos_universal2/"

# Specify the path to the project directory
project_dir = @__DIR__

# Activate the project environment
Pkg.activate(project_dir*"/CdaOpt")

# Instantiate the environment, installing all dependencies as specified in Project.toml and Manifest.toml
Pkg.instantiate()
