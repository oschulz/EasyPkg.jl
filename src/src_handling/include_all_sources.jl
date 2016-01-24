# This file is a part of EasyPkg, licensed under the MIT License (MIT).


export include_all_sources

"""
`include_all_sources([basedir])`

Recursively includes all sources in the specified directory and it's
subdirectories, by searching for and including all ".jl" files. Directories
are processed before files.

`basedir` defaults to the directory containing the current source file
(or `pwd()`, if run from the REPL), and is interpreted relative to it
if `basedir` is not an absolute path.

`include_all_sources()` reduces the average Julia project's "Project.jl" to

```julia
import EasyPkg
EasyPkg.include_all_sources()

function __init__()
    ...
end
```

For this to work, the structure of the sources files must not depend on
a specific inclusion order - so the source files should not contain any
initialization steps that depend on another source file. For precompiled
packages, this shouldn't be an issue, as all initialization steps will
reside in `__init()__` anyhow.
"""

function include_all_sources(basedir::AbstractString = include_base_path())
    const abs_basedir = isabspath(basedir) ? basedir : joinpath(include_base_path(), basedir)
    const sources = find_sources(abs_basedir)

    for fname in sources
        const absfname = joinpath(abs_basedir, fname)
        include(absfname)
    end
end
