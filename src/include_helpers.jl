# This file is a part of EasyPkg, licensed under the MIT License (MIT).


called_from_repl() = isa(Base.source_path(), Void)

include_base_path() = called_from_repl() ? pwd() : dirname(Base.source_path())

current_src_file() = called_from_repl() ? "" : Base.source_path()


export include_sources

"""
`include_sources(name...)`

Includes all listed Julia sources. Source names are interpreted to be relative
to the path of the calling source file (or the current directory, when run
directly from the REPL).

Names may be ".jl" files or directories. For directories (e.g. "foo"),
`include_sources` will include the Julia source file with the same name inside
that directory (e.g. "foo/foo.jl").
"""

function include_sources(names::AbstractString...)
    base_path = include_base_path()

    for fname in names
        absfname = joinpath(base_path, fname)
        if isdir(absfname)
            subfname = joinpath(absfname, "$(basename(absfname)).jl")
            if isfile(subfname)
                include(subfname)
            else
                error("Error while including directory \"$absfname\", no source file \"$subfname\" found.")
            end
        elseif isfile(absfname) && endswith(absfname, ".jl")
            include(absfname)
        elseif endswith(absfname, ".jl")
            error("No such file: \"$absfname\"")
        else
            error("Don't know how to handle source name \"$absfname\"")
        end
    end
end
