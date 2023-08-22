local plr = game.Players.LocalPlayer

local char = plr.Character or plr.CharacterAdded:Wait()


local tool = script.Parent

local anim = script:WaitForChild("LiftAnimation")


local isLifting = false


local givePowerEvent = game.ReplicatedStorage:WaitForChild("OnClickGivePower")


tool.Activated:Connect(function()
		
	if isLifting == true then return end
		
	if not char:FindFirstChild("Humanoid") then return end
		
	isLifting = true
	
	
	local loadedAnim = char.Humanoid:LoadAnimation(anim)
	
	loadedAnim:Play()
	
	
	givePowerEvent:FireServer()
	
	
	wait(2)
	
	
	isLifting = false
	
end)