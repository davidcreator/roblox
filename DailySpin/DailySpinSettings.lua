local module = {}

local spinRewards = { --Repeated numbers = higher chance for that reward to be chosen
	100, 100, 100, 100, 
	200, 200, 200, 
	500, 500, 
	1000
}

local spinColours = { --Amount of cash = Colour on wheel
	[100] = Color3.fromRGB(156, 149, 138), 
	[200] = Color3.fromRGB(109, 199, 50), 
	[500] = Color3.fromRGB(240, 207, 18), 
	[1000] = Color3.fromRGB(249, 112, 21),
}

module.rewards = spinRewards
module.colours = spinColours

return module
