# This file is a part of EasyPkg, licensed under the MIT License (MIT).

"""
`@using_BaseTest`

Use this macro to use the new Julia v0.5 `Base.Test`, independent of your
Julia version.

Expands to

```
using Base.Test
```

for Julia v0.5 and to

```
using BaseTestNext
const Test = BaseTestNext
```

for Julia v0.4.
"""

macro using_BaseTest()
    esc(
        quote
            if VERSION >= v"0.5-"
                using Base.Test
            else
                using BaseTestNext
                const Test = BaseTestNext
                nothing
            end
        end
    )
end
