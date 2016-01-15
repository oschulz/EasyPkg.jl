# This file is a part of EasyPkg, licensed under the MIT License (MIT).

using FactCheck

facts("Some other facts") do
	@fact 40+2 --> 42
	@fact 2*5 --> 10
end
