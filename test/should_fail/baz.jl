# This file is a part of EasyPkg, licensed under the MIT License (MIT).

import EasyPkg
@EasyPkg.using_BaseTest

@testset "This should fail" begin
	@test 1 == 1
	@test 2 == 0
    @test 3 == 3
    error("Some bogus error")
end
