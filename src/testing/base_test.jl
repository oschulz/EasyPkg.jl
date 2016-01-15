# This file is a part of EasyPkg, licensed under the MIT License (MIT).

macro using_BaseTestNext()
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
