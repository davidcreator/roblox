local rs = game.ReplicatedStorage:WaitForChild("CTFReplicatedStorage")
local config = require(rs:WaitForChild("CONFIGURATION"))
local status = rs:WaitForChild("STATUS")

local statusText = script.Parent:WaitForChild("StatusText")
local teamsFrame = script.Parent:WaitForChild("TeamsFrame")
teamsFrame.Visible = false

local client = game.Players.LocalPlayer


function updateStatus()
	if not client:FindFirstChild("FAILED TO LOAD DATA") then
		statusText.Text = status.Value
	else
		statusText.Text = "Your data did not load successfully. Rejoin to fix this issue."
	end
end

updateStatus()
status:GetPropertyChangedSignal("Value"):Connect(updateStatus)


rs.ChildAdded:Connect(function(child)
	
	if child.Name == "SCORES" then
		local team1Flags = child:WaitForChild("TEAM 1 SCORE")
		local team2Flags = child:WaitForChild("TEAM 2 SCORE")
		
		local plrTeam = client.Team
		teamsFrame.Team1Frame.BackgroundColor3 = plrTeam.TeamColor.Color
		
		if plrTeam == config.Team1 then
			teamsFrame.Team2Frame.BackgroundColor3 = config.Team2.TeamColor.Color
			
			teamsFrame.Team1Frame.FlagsCaptured.Text = team1Flags.Value
			teamsFrame.Team2Frame.FlagsCaptured.Text = team2Flags.Value
			
		elseif plrTeam == config.Team2 then
			teamsFrame.Team2Frame.BackgroundColor3 = config.Team1.TeamColor.Color
			
			teamsFrame.Team1Frame.FlagsCaptured.Text = team2Flags.Value
			teamsFrame.Team2Frame.FlagsCaptured.Text = team1Flags.Value
		end
		
		team1Flags:GetPropertyChangedSignal("Value"):Connect(function()
			if plrTeam == config.Team1 then
				teamsFrame.Team1Frame.FlagsCaptured.Text = team1Flags.Value
			else
				teamsFrame.Team2Frame.FlagsCaptured.Text = team1Flags.Value
			end
		end)
		team2Flags:GetPropertyChangedSignal("Value"):Connect(function()
			if plrTeam == config.Team2 then
				teamsFrame.Team1Frame.FlagsCaptured.Text = team2Flags.Value
			else
				teamsFrame.Team2Frame.FlagsCaptured.Text = team2Flags.Value
			end
		end)
		
		teamsFrame.Visible = true	
		
		child.Destroying:Connect(function()
			teamsFrame.Visible = false
		end)
	end
end)