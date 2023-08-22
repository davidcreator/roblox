--MINE ORE WHEN CLICKING
local re = game.ReplicatedStorage:WaitForChild("MiningRE")
local mouse = game.Players.LocalPlayer:GetMouse()
local animation = script:WaitForChild("PickaxeAnimation")
local cooldown = false

mouse.Button1Down:Connect(function()
	
	if script.Parent.Parent == game.Players.LocalPlayer.Character and not cooldown then
		cooldown = true
		
		game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(animation):Play()
		re:FireServer(mouse.Target, mouse.Hit, workspace.CurrentCamera.CFrame)
		
		wait(1)
		cooldown = false
	end
end)


--CREATE BOX OVER HOVERED ORES
local equipped = false
local currentBox = nil

script.Parent.Equipped:Connect(function()
	equipped = true
end)
script.Parent.Unequipped:Connect(function()
	equipped = false
end)

mouse.Move:Connect(function()
	
	if mouse.Target and mouse.Target.Parent == workspace.OreArea then
		
		if currentBox then currentBox:Destroy() end
		
		currentBox = Instance.new("SelectionBox")
		currentBox.Adornee = mouse.Target
		currentBox.Parent = mouse.Target
		
		
	elseif currentBox then
		currentBox:Destroy()
	end
end)


--CREATE GUI WHEN MINING
local plrGui = game.Players.LocalPlayer.PlayerGui

re.OnClientEvent:Connect(function(oreName, oreHealth)
	
	if plrGui:FindFirstChild("OreHealthGui") then
		plrGui.OreHealthGui:Destroy()
	end
	
	local newGui = script:WaitForChild("OreHealthGui"):Clone()
	newGui.HealthBarBG.OreName.Text = oreName
	
	local requiredHits = game.ReplicatedStorage.Ores[oreName].Health.Value
	local currentHits = requiredHits - oreHealth
	
	newGui.HealthBarBG.HealthBar.Size = UDim2.new(currentHits / requiredHits, 0, 1, 0)
	
	newGui.Parent = plrGui
	
	local destroyTime = 3
	if currentHits == requiredHits then
		destroyTime = 1
	end
	
	game:GetService("Debris"):AddItem(newGui, destroyTime)
end)