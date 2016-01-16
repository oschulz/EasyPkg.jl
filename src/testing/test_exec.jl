# This file is a part of EasyPkg, licensed under the MIT License (MIT).

if VERSION >= v"0.5-"
    using Base.Test
    typealias Base_TestSetException Base.Test.TestSetException
else
    using BaseTestNext
    typealias Base_TestSetException BaseTestNext.TestSetException
    nothing
end


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

`run_all_tests()` uses `Base.Test` (for Julia >= v0.5), resp. `BaseTestNext`
(for backward compatibility).

The test source files themselves should look like this:

```julia
import EasyPkg
@EasyPkg.using_BaseTest

@testset "Some tests" begin
    @test ...
    @test ...
    ...
end

@testset "Some more tests" ...
```

The default random number generator is re-initializes with a fixed seed before
including each test source file, to achieve repeatable results for tests that
use the RNG.
"""

function run_all_tests(basedir::AbstractString = include_base_path())
    const from_repl = isa(Base.source_path(), Void)
    callingfile = from_repl ? "" : Base.source_path()

    const combined_tse = Base_TestSetException(0, 0, 0)

    function impl(subdir::AbstractString)
        const fullpath = joinpath(basedir, subdir)

        const tests = Array(AbstractString, 0)
        const dirs = Array(AbstractString, 0)
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
            const subfname = joinpath(subdir, t)
            const absfname = joinpath(basedir, subfname)
            info("Running tests in \"$subfname\"")

            # Set fixed seed for default PRNG for repeatable test results:
            srand(345678)

            try
                testset = @testset "Tests in \"$subfname\"" begin
                    include(absfname)
                end
                combined_tse.pass += length(testset.results[1].results)
            catch err
                if isa(err, Base_TestSetException)
                    combined_tse.pass += err.pass
                    combined_tse.fail += err.fail
                    combined_tse.error += err.error
                else
                    throw(err)
                end
            end
        end

    end

    impl("")

    if (combined_tse.fail == 0) && (combined_tse.error == 0)
        info("All tests ($(combined_tse.pass) in total) passed.")
    else
        throw(combined_tse)
    end
end
