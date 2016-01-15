# This file is a part of EasyPkg, licensed under the MIT License (MIT).

import EasyPkg

try
    EasyPkg.run_all_tests("should_fail")
    error("Some tests were expected to fail, but didn't")
catch
    info("Ok, some tests were expected to fail")
end

include(joinpath("should_pass", "runtests.jl"))
