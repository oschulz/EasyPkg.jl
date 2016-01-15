# This file is a part of EasyPkg, licensed under the MIT License (MIT).

using FactCheck

facts("Some facts") do
	@fact sum([1,2,3]) --> 6
	@fact sum([1,2,3,4]) --> 10
end
