local plr = game.Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local statusLabel = plrGui:WaitForChild("StatusGui"):WaitForChild("StatusLabel")

local rs = game.ReplicatedStorage:WaitForChild("MurderMysteryReplicatedStorage")
local re = rs:WaitForChild("RemoteEvent")
local config = require(rs:WaitForChild("CONFIGURATION"))
local status = rs:WaitForChild("STATUS")


function updateStatus()
	statusLabel.Text = status.Value
end
updateStatus()

local updateStatusConnection = status:GetPropertyChangedSignal("Value"):Connect(updateStatus)


re.OnClientEvent:Connect(function(instruction, value1, value2)
	
	if instruction == "DATA FAILED TO LOAD" then
		updateStatusConnection:Disconnect()
		
		statusLabel.Text = "Your data failed to load. Any progress from this session will be lost once you rejoin."
		statusLabel.TextColor3 = Color3.fromRGB(255, 199, 56)
		
	elseif instruction == "ROLE CHOSEN" then
		statusLabel.Text = "Your role is " .. value1
		
		
	elseif instruction == "DUMMY KNIFE" then
		
		local knifeClone = value1:Clone()
		knifeClone.Transparency = 0
		
		knifeClone.Velocity = value2

		knifeClone.Parent = workspace
		
		local knifeCFrame = CFrame.new(value1.Handle.Position, value2)
		knifeClone.CFrame = knifeCFrame

		local bav = Instance.new("BodyAngularVelocity")
		bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)

		bav.AngularVelocity = knifeCFrame:VectorToWorldSpace(Vector3.new(-config.MurdererWeaponRotationalVelocity, 0, 0))
		bav.Parent = knifeClone
		
		knifeClone.Touched:Connect(function(hit)
			if hit.Parent ~= value1.Parent and hit.Parent.Parent ~= value1.Parent then	

				knifeClone:Destroy()
			end
		end)
	end
end)