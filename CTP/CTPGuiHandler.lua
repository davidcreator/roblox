local rs = game.ReplicatedStorage:WaitForChild("CTPReplicatedStorage")
local config = require(rs:WaitForChild("CONFIGURATION"))
local status = rs:WaitForChild("STATUS")

local statusText = script.Parent:WaitForChild("StatusText")
local teamsFrame = script.Parent:WaitForChild("TeamsFrame")
teamsFrame.Visible = false
local captureBar = script.Parent:WaitForChild("CaptureProgressBar")
captureBar.Visible = false

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
		local team1Score = child:WaitForChild("TEAM 1 SCORE")
		local team2Score = child:WaitForChild("TEAM 2 SCORE")
		
		local plrTeam = client.Team
		teamsFrame.Team1Frame.BackgroundColor3 = plrTeam.TeamColor.Color
		
		if plrTeam == config.Team1 then
			teamsFrame.Team2Frame.BackgroundColor3 = config.Team2.TeamColor.Color
			
			teamsFrame.Team1Frame.Points.Text = team1Score.Value
			teamsFrame.Team2Frame.Points.Text = team2Score.Value
			
		elseif plrTeam == config.Team2 then
			teamsFrame.Team2Frame.BackgroundColor3 = config.Team1.TeamColor.Color
			
			teamsFrame.Team1Frame.Points.Text = team2Score.Value
			teamsFrame.Team2Frame.Points.Text = team1Score.Value
		end
		
		team1Score:GetPropertyChangedSignal("Value"):Connect(function()
			if plrTeam == config.Team1 then
				teamsFrame.Team1Frame.Points.Text = team1Score.Value
			else
				teamsFrame.Team2Frame.Points.Text = team1Score.Value
			end
		end)
		team2Score:GetPropertyChangedSignal("Value"):Connect(function()
			if plrTeam == config.Team2 then
				teamsFrame.Team1Frame.Points.Text = team2Score.Value
			else
				teamsFrame.Team2Frame.Points.Text = team2Score.Value
			end
		end)
		
		teamsFrame.Visible = true	
		
		
		local contestedValue = child:FindFirstChildOfClass("NumberValue")
		while not contestedValue do
			contestedValue = child:FindFirstChildOfClass("NumberValue")
		end
		
		contestedValue.Changed:Connect(function()
			local contestingTeam = config[contestedValue.Name]
			if contestingTeam then
				local timeContested = contestedValue.Value
				
				local barScale = timeContested / config.TimeToCapture
				if barScale <= 1 then
					captureBar.Bar.BackgroundColor3 = contestingTeam.TeamColor.Color
					captureBar.Bar.Size = UDim2.new(barScale, 0, captureBar.Bar.Size.Y.Scale, 0)
					captureBar.Visible = true
				else
					captureBar.Visible = false
				end
			else
				captureBar.Visible = false
			end
		end)
		
		
		child.Destroying:Connect(function()
			teamsFrame.Visible = false
			captureBar.Visible = false
		end)
	end
end)