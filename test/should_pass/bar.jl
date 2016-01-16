# This file is a part of EasyPkg, licensed under the MIT License (MIT).

import EasyPkg
@EasyPkg.using_BaseTest

@testset "Some other tests" begin
	@test 40+2 == 42
	@test 2*5 == 10
end
