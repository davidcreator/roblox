local maxCash = 5000
local cashPerSecond = 500
local timeToRob = 30
local robbing = false
local cooldown = 30
local closed = false
local defaultVaultPosition = script.Parent.VaultDoor.Position

local playersRobbing = {}
local alreadyRobbed = {}
local guis = {}


function endRobbery()
	
	closed = true
	robbing = false
	
	wait(1)

	script.Parent.Door.CanCollide = true
	script.Parent.VaultDoor.Position = defaultVaultPosition

	
	for i, gui in pairs(guis) do
		gui:Destroy()
	end
	
	for p, x in pairs(playersRobbing) do
		p.Character.HumanoidRootPart.CFrame = script.Parent.FailedToRob.CFrame
	end


	playersRobbing = {}
	alreadyRobbed = {}

	script.Alarm:Stop()

	wait(cooldown)
	closed = false

	script.Parent.Door.CanCollide = false
end


function beginRobbery()
	
	for i = 1, timeToRob do
		
		wait(1)
		
		local region3 = Region3.new(script.Parent.VaultArea.Position - script.Parent.VaultArea.Size/2, script.Parent.VaultArea.Position + script.Parent.VaultArea.Size/2)
		local parts = workspace:FindPartsInRegion3(region3, script.Parent, math.huge)
		
		local playersGivenCashTo = {}
		
		for x, part in pairs(parts) do
			
			if playersRobbing[game.Players:GetPlayerFromCharacter(part.Parent)] and playersRobbing[game.Players:GetPlayerFromCharacter(part.Parent)] < maxCash and not playersGivenCashTo[game.Players:GetPlayerFromCharacter(part.Parent)] then
				
				playersGivenCashTo[game.Players:GetPlayerFromCharacter(part.Parent)] = true
				
				playersRobbing[game.Players:GetPlayerFromCharacter(part.Parent)] += cashPerSecond
				
				if not game.Players:GetPlayerFromCharacter(part.Parent).PlayerGui:FindFirstChild("RobberyGui") then
					script.RobberyGui:Clone().Parent = game.Players:GetPlayerFromCharacter(part.Parent).PlayerGui
					game.Players:GetPlayerFromCharacter(part.Parent).PlayerGui.RobberyGui.Background.RobbedAmount.Text = "$0"
					table.insert(guis, game.Players:GetPlayerFromCharacter(part.Parent).PlayerGui.RobberyGui)
				end
				
				game.Players:GetPlayerFromCharacter(part.Parent).PlayerGui.RobberyGui.Background.RobbedAmount.Text = "$" .. playersRobbing[game.Players:GetPlayerFromCharacter(part.Parent)]
			end
		end
	end
	
	endRobbery()
end


game.Players.PlayerAdded:Connect(function(p)
	
	local ls = Instance.new("Folder", p)
	ls.Name = "leaderstats"
	
	local cash = Instance.new("IntValue", ls)
	cash.Name = "Cash"
end)


local touchedCooldown = {}

script.Parent.Door.Touched:Connect(function(hit)
	
	if not closed and game.Players:GetPlayerFromCharacter(hit.Parent) and not touchedCooldown[game.Players:GetPlayerFromCharacter(hit.Parent)] and not playersRobbing[game.Players:GetPlayerFromCharacter(hit.Parent)] and not alreadyRobbed[game.Players:GetPlayerFromCharacter(hit.Parent)] then
		
		script.Alarm:Resume()
		
		touchedCooldown[game.Players:GetPlayerFromCharacter(hit.Parent)] = true

		playersRobbing[game.Players:GetPlayerFromCharacter(hit.Parent)] = 0
		
		spawn(function()
			wait(2)
			touchedCooldown[game.Players:GetPlayerFromCharacter(hit.Parent)] = nil
		end)
		
		if not robbing then
			beginRobbery()
		end
		robbing = true

		
	elseif not closed and game.Players:GetPlayerFromCharacter(hit.Parent) and not touchedCooldown[game.Players:GetPlayerFromCharacter(hit.Parent)] and playersRobbing[game.Players:GetPlayerFromCharacter(hit.Parent)] then
		
		game.Players:GetPlayerFromCharacter(hit.Parent).leaderstats.Cash.Value += playersRobbing[game.Players:GetPlayerFromCharacter(hit.Parent)]
		
		playersRobbing[game.Players:GetPlayerFromCharacter(hit.Parent)] = nil
		alreadyRobbed[game.Players:GetPlayerFromCharacter(hit.Parent)] = true
		
		
		local stillRobbing = false
		for p, x in pairs(playersRobbing) do
			if p[x] then stillRobbing = true end
		end
		
		if not stillRobbing then
			
			endRobbery()
		end
	end
end)


script.Parent.OpenVault.Touched:Connect(function(hit)

	if game.Players:GetPlayerFromCharacter(hit.Parent) then
		
		wait(3)
		
		game:GetService("TweenService"):Create(script.Parent.VaultDoor, TweenInfo.new(5), {Position = defaultVaultPosition + Vector3.new(0, script.Parent.Door.Size.Y, 0)}):Play()
	end
end)


for i, laser in pairs(script.Parent.Lasers:GetChildren()) do
	
	local touched = {}
	
	laser.Touched:Connect(function(hit)
		
		local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
		
		if plr and not touched[plr] then 
			
			touched[plr] = true
			
			hit.Parent.Humanoid:TakeDamage(20)
			
			wait(1)
			
			touched[plr] = nil
		end
	end)
end