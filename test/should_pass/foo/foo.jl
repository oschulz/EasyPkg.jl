# This file is a part of EasyPkg, licensed under the MIT License (MIT).

import EasyPkg
@EasyPkg.using_BaseTestNext

@testset "Some tests" begin
	@test sum([1,2,3]) == 6
	@test sum([1,2,3,4]) == 10
end
