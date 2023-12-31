local config = {}


config.BossRoom = workspace:WaitForChild("BossRoom")

config.BossStats = {
	health = 1000;
	
	spikeAttackDamage = 30;
	jumpAttackDamage = 80;
	laserAttackDamage = 12;
	
	damageCycle = {
		"SPIKES", 
		"WAIT 5", 
		"JUMP", 
		"WAIT 6", 
		"LASERS", 
		"WAIT 7"};
	
	minSpikes = 60;
	maxSpikes = 80;
	spikeRange = 130;
	spikeTime = 2;
	
	jumpPower = 80;
	jumpChargeTime = 1;
	jumpDamageRange = 20;
	
	laserDuration = 5;
	laserMaxSpread = 5;
}

config.IntroCutsceneComponents = config.BossRoom:WaitForChild("CutsceneComponents"):WaitForChild("Intro")

config.IntroCutsceneInstructions = {
	{"MOVE", config.IntroCutsceneComponents["1"].CFrame, 0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.In};
	{"PLAY ANIMATION", "Fall"};
	{"MOVE", config.IntroCutsceneComponents["2"].CFrame, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out};
	{"WAIT", 0.3};
	{"MOVE", config.IntroCutsceneComponents["3"].CFrame, 1.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.In};
	{"STOP ANIMATION", "Fall"};
	{"PLAY ANIMATION", "Land"};
	{"CAMERA SHAKE", 3, 1};
	{"PLAY SOUND", "GroundSmash"};
	{"WAIT", 2};
	{"MOVE", config.IntroCutsceneComponents["4"].CFrame, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In};
	{"PLAY ANIMATION", "Roar"};
	{"WAIT", 0.2};
	{"CAMERA SHAKE", 1.3, 2.7};
	{"PLAY SOUND", "Roar"};
	{"WAIT", 3};
}


return config