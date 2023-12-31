--RIGHT CLICK TO TRANSFORM

local transformRE = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("Transform")

local mouse = game.Players.LocalPlayer:GetMouse()

local cam = workspace.CurrentCamera


mouse.Button2Up:Connect(function()
	
	local target = mouse.Target
	
	if target then
		repeat target = target.Parent until target:IsA("Model") or target == workspace
		
		if target:FindFirstChild("PROP") then
			transformRE:FireServer(target)
		end
	end
end)


--STATUS GUI

local statusVal = game.ReplicatedStorage:WaitForChild("GAME STATUS")

function updateStatus()
	script.Parent:WaitForChild("StatusTextLabel").Text = statusVal.Value
end

updateStatus()
statusVal:GetPropertyChangedSignal("Value"):Connect(updateStatus)