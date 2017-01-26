EasyPkg
-------

[![Build Status](https://travis-ci.org/oschulz/EasyPkg.jl.svg?branch=master)](https://travis-ci.org/oschulz/EasyPkg.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/gc84nlrar6l0a3d8/branch/master?svg=true)](https://ci.appveyor.com/project/oschulz/easypkg-jl/branch/master)

A Julia package to simplify package development. EasyPkg aims to reduce the
boilerplate code typically found in a Julia project's "src/<PrjName>.jl" and
"test/runtests.jl".


Package Source code
-------------------

EasyPkg can include all Julia source files in your package automatically,
or assist with manual source file handing.

### Automatic source file handling

Use `include_all_sources()` to reduce the average Julia project's
"src/<PrjName>.jl" to

```julia

__precompile__()

module <PrjName>

import EasyPkg
EasyPkg.include_all_sources()

function __init__()
    ...
end

end # module

```

For this to work, the structure of the sources files must not depend on
a specific inclusion order - so the source files should not contain any
initialization steps that depend on another source file. For precompiled
packages, this shouldn't be an issue, as all initialization steps will
reside in `__init()__` anyhow.


### Manual source file handling

If you need control over the order in which source files are included, you
can use `EasyPkg.include_sources(name...)` to shorten your source inclusion
code a little and handle subdirectories in a modular fashion.

Given a package structure like

* src
    * foo/foo.jl
    * foo/xyz.jl
    * bar.jl

use

```julia
EasyPkg.include_sources(
    "foo",
    "bar.jl",
)
```

to include "foo/foo.jl" and "bar.jl". Obviously, "foo/foo.jl" will be
responsible for including "foo/xyz.jl" and other files in the "foo"
subdirectory (e.g using `EasyPkg.include_sources` again).

Note: The source file structure of EasyPkg itself is not necessarily a good
template - it is a bit complicated and deeply nested on purpose, so that
EasyPkg can tests it's own functionality.


Package Tests
-------------

Use `EasyPkg.run_all_tests()` to reduce "test/runtests.jl" for a typical
Julia project to

```julia
import EasyPkg
EasyPkg.run_all_tests()
```

It will automatically find and include all your test source files (may
reside in nested directories). They should look like this:

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
