local dataFailedWarning = script.Parent:WaitForChild("DataFailedWarning")
dataFailedWarning.Enabled = false

local client = game.Players.LocalPlayer

client.ChildAdded:Connect(function(child)
	if child.Name == "FAILED TO LOAD DATA" then
		dataFailedWarning.Enabled = true
	end
end)


local rs = game.ReplicatedStorage:WaitForChild("BombTagReplicatedStorage")

local statusValue = rs:WaitForChild("STATUS")
local currentTagged = rs:WaitForChild("CURRENT TAGGED PLAYER")
local bombTimer = rs:WaitForChild("EXPLODE TIMER")


local mainGui = script.Parent:WaitForChild("BombTagGui")
local textFrame = mainGui:WaitForChild("TextContainer")
local statusLabel = textFrame:WaitForChild("Status")
statusLabel.Visible = true
local bombTimeLabel = textFrame:WaitForChild("BombExplodeTime")
bombTimeLabel.Visible = false


function updateStatus()
	statusLabel.Text = statusValue.Value
end
updateStatus()
statusValue:GetPropertyChangedSignal("Value"):Connect(updateStatus)


function updateTimer()
	
	if currentTagged.Value == client.Character then
		
		statusLabel.Text = "You are tagged"
		bombTimeLabel.Text = "You will explode in " .. bombTimer.Value .. " seconds!"
		
		bombTimeLabel.Visible = true
	else
		statusLabel.Text = statusValue.Value
		bombTimeLabel.Visible = false
	end
end

bombTimer:GetPropertyChangedSignal("Value"):Connect(updateTimer)