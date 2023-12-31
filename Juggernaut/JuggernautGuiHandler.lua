local client = game.Players.LocalPlayer

local dataFailedWarning = script.Parent:WaitForChild("DataFailedWarning")
dataFailedWarning.Enabled = false

client.ChildAdded:Connect(function(child)
	if child.Name == "FAILED TO LOAD DATA" then
		dataFailedWarning.Enabled = true
	end
end)


local rs = game.ReplicatedStorage:WaitForChild("JuggernautReplicatedStorage")
local config = require(rs:WaitForChild("Settings"))
local status = rs:WaitForChild("STATUS")

local mainGui = script.Parent:WaitForChild("JuggernautGui")
local healthBar = mainGui:WaitForChild("JuggernautHealthBar")
local statusLabel = mainGui:WaitForChild("StatusLabel")
healthBar.Visible, statusLabel.Visible = false, true


function updateStatusLabel()
	statusLabel.Text = status.Value
end
updateStatusLabel()
status:GetPropertyChangedSignal("Value"):Connect(updateStatusLabel)


function updateHealthBar(health)
	local maxHealth = config.JuggernautHumanoidProperties.MaxHealth
	local scale = health / maxHealth
	
	healthBar.Health.Text = health .. "/" .. maxHealth
	healthBar.Bar:TweenSize(UDim2.new(scale, 0, 1, 0), "InOut", "Linear", 0.2)
	
	healthBar.Visible = true
end

rs.ChildAdded:Connect(function(child)
	if child.Name == "JUGGERNAUT HEALTH" then
		
		updateHealthBar(child.Value)
		child:GetPropertyChangedSignal("Value"):Connect(function()
			updateHealthBar(child.Value)
		end)
		
		child.AncestryChanged:Connect(function()
			if child.Parent == nil then
				healthBar.Visible = false
			end
		end)
	end
end)