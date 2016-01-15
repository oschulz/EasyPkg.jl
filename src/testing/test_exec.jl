# This file is a part of EasyPkg, licensed under the MIT License (MIT).

export run_all_tests

"""
`run_all_tests([basedir])`

Recursively runs all tests in the specified directory (the current directory,
by default) and it's subdirectories, by recursively searching for and
including all ".jl" files.

`run_all_tests()` reduces the average Julia project's "runtests.jl" to

```julia
import EasyPkg
EasyPkg.run_all_tests()
```

Subdirectories are processed before files.

The default random number generator is re-initializes with a fixed seed before
including each test source file, to achieve repeatable results for tests that
use the RNG.
"""

function run_all_tests(basedir::AbstractString = pwd())
    const from_repl = isa(Base.source_path(), Void)
    callingfile = from_repl ? "" : Base.source_path()

    function impl(subdir::AbstractString)
        const fullpath = joinpath(basedir, subdir)

        const tests = Array(typeof(fullpath), 0)
        const dirs = Array(typeof(fullpath), 0)
        for f in readdir(fullpath)
            const fname = joinpath(fullpath, f)
            if isdir(fname)
                push!(dirs, f)
            elseif isfile(fname) && endswith(fname, ".jl")
                # Make double sure to exclude calling file to avoid endless
                # recursion:
                if (
                    ( fname != callingfile ) &&
                    ( subdir != "" || f != basename(callingfile) )
                )
                    push!(tests, f)
                end
            end
        end

        for d in dirs
            impl(joinpath(subdir, d))
        end

        for t in tests
            Base.info("Running tests in \"$(joinpath(subdir, t))\"")

            # Set fixed seed for default PRNG for repeatable test results
            srand(345678)

            include(joinpath(basedir, subdir, t))
        end
    end

    impl("")

    nothing
end
