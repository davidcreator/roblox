local limitDoorModel = script.Parent

local door = limitDoorModel:WaitForChild("Door")

local teleportInsidePart = limitDoorModel:WaitForChild("TeleportInside")
local teleportOutsidePart = limitDoorModel:WaitForChild("TeleportOutside")

local surfaceGui = door:WaitForChild("PlayerAmountGui")
local textLabel = surfaceGui:WaitForChild("PlayerAmount")


local plrsInside = {}

local plrLimit = 2

local cooldownPerPlr = 0.5
local plrsOnCooldown = {}


door.Touched:Connect(function(touched)
	
	local char = touched.Parent
	local plr = game.Players:GetPlayerFromCharacter(char)
	
	if plrsOnCooldown[plr] then return end
	
	if plr and not plrsInside[plr] then
		
		local amountOfPlrs = textLabel.Text
		if tonumber(amountOfPlrs) >= plrLimit then return end
		
		textLabel.Text = tonumber(textLabel.Text) + 1
		
		plrsInside[plr] = true
		
		char.HumanoidRootPart.CFrame = teleportInsidePart.CFrame
		
		plrsOnCooldown[plr] = true
		wait(cooldownPerPlr)
		plrsOnCooldown[plr] = nil
		
	elseif plr and plrsInside[plr] then
		
		textLabel.Text = tonumber(textLabel.Text) - 1
		
		plrsInside[plr] = nil
		
		char.HumanoidRootPart.CFrame = teleportOutsidePart.CFrame
		
		plrsOnCooldown[plr] = true
		wait(cooldownPerPlr)
		plrsOnCooldown[plr] = nil
	end
end)