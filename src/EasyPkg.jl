# This file is a part of EasyPkg, licensed under the MIT License (MIT).

__precompile__()

module EasyPkg

include("include_helpers.jl")

EasyPkg.include_sources(
    "src_handling",
)

EasyPkg.include_all_sources("testing")

end # module
