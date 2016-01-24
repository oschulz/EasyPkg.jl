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

`basedir` defaults to the directory containing the current source file
(or `pwd()`, if run from the REPL), and is interpreted relative to it
if `basedir` is not an absolute path.


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
    const abs_basedir = isabspath(basedir) ? basedir : joinpath(include_base_path(), basedir)
    const tests = find_sources(abs_basedir)

    const combined_tse = Base_TestSetException(0, 0, 0)

    for fname in tests
        const absfname = joinpath(abs_basedir, fname)
        info("Running tests in \"$fname\"")

        # Set fixed seed for default PRNG for repeatable test results:
        srand(345678)

        try
            testset = @testset "Tests in \"$fname\"" begin
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

    if (combined_tse.fail == 0) && (combined_tse.error == 0)
        info("All tests ($(combined_tse.pass) in total) passed.")
    else
        throw(combined_tse)
    end
end
