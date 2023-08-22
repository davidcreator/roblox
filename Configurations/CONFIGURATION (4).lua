local config = {}


config.IntermissionTime = 5
config.MapWaitTime = 3
config.RoundTime = 180
config.RoundFinishedTime = 3

config.StopOnceFlagsReached = true
config.FlagsRequiredToStop = 3

config.MinimumPlayersRequired = 2

config.WinReward = 100

config.Team1 = game:GetService("Teams"):WaitForChild("Red")
config.Team2 = game:GetService("Teams"):WaitForChild("Blue")


return config