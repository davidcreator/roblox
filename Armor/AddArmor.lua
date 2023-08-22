local armorpieces = game:GetService("ReplicatedStorage"):WaitForChild("ArmorPieces")


function addFunc(plr:Player, armor:Model) --Adding a new armor to a player's inventory
	
	local char = plr.Character
	
	if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
		
		local inv = plr:WaitForChild("ArmorInventory")
		
		if armor.Parent.Parent == armorpieces then
			armor:Clone().Parent = inv
		end
	end
end

return addFunc
