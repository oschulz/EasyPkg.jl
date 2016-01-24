# This file is a part of EasyPkg, licensed under the MIT License (MIT).


export find_sources

"""
`find_sources([basedir]; recursive = true, exclude_self = true)`

Finds all Julia source (".jl") files in the specified directory (`pwd()`, by
default).

Subdirectories are listed before files, directory and file names are
sorted alphabetically.
"""

function find_sources(
    basedir::AbstractString = pwd();
    recursive::Bool = true, exclude_self::Bool = true
)
    info("pwd = $(pwd())")
    info("basedir = $basedir")
    const current_src = current_src_file()

    function impl(subdir::AbstractString)
        const fullpath = joinpath(basedir, subdir)

        const result = Array(AbstractString, 0)

        const files = Array(AbstractString, 0)
        const dirs = Array(AbstractString, 0)
        for f in sort(readdir(fullpath))
            const fname = joinpath(fullpath, f)
            if isdir(fname)
                push!(dirs, f)
            elseif isfile(fname) && endswith(fname, ".jl")
                if (
                    !exclude_self || (
                        # Make double sure to exclude calling file:
                        ( fname != current_src ) &&
                        ( subdir != "" || f != basename(current_src) )
                    )
                )
                    push!(files, joinpath(subdir, f))
                end
            end
        end

        if (recursive)
            for d in dirs
                append!(result, impl(joinpath(subdir, d)))
            end
        end

        append!(result, files)

        result
    end

    impl("")
end
