using MKL
using BenchmarkTools
using Infiltrator
using Revise
using TestEnv

using Pkg
Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true

Infiltrator.toggle_async_check(false)

atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "error while importing OhMyREPL" e
    end
end


# usage: run_with_args("../src/subparcel_driver.jl", "examples/input_tracking.json")
function run_with_args(script, args...)
    empty!(ARGS)
    append!(ARGS, args)
    include(script)
end
