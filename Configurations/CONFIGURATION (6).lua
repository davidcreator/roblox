local config = {}


config.MinimumPlayersNeeded = 2

config.IntermissionTime = 3
config.MapWaitTime = 3
config.PreparationTime = 6
config.RoundEndTime = 3

config.BombExplodeTimes = { --How long the tagged player has before they explode based on how many players are alive.
	[6] = 20,
	[5] = 15,
	[4] = 12,
	[3] = 10,
	[2] = 7
}

config.TagCooldown = 1

config.SurvivorSpeed = 16
config.TaggedSpeed = 20

config.SurviveReward = 100


return config