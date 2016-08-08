# This file is a part of EasyPkg, licensed under the MIT License (MIT).

using Base.Test

@testset "Some tests" begin
	@test sum([1,2,3]) == 6
	@test sum([1,2,3,4]) == 10
end
